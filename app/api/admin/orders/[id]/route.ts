import { NextResponse } from 'next/server';
import { supabaseAdmin } from '@/lib/supabase-admin';

function getAccessToken(request: Request): string | null {
  const authHeader = request.headers.get('authorization');
  if (authHeader?.startsWith('Bearer ')) return authHeader.slice(7).trim();
  const cookieHeader = request.headers.get('cookie') || '';
  const match = cookieHeader.match(/\bsb-access-token=([^;]+)/);
  if (match) return decodeURIComponent(match[1].trim());
  const authCookie = cookieHeader
    .split(';')
    .map((c) => c.trim())
    .find((c) => c.startsWith('sb-') && (c.includes('-auth-token') || c.includes('auth')));
  if (!authCookie) return null;
  const value = authCookie.split('=').slice(1).join('=').trim();
  const decoded = decodeURIComponent(value);
  try {
    const parsed = JSON.parse(decoded);
    if (Array.isArray(parsed) && parsed[0]) return parsed[0];
    if (parsed?.access_token) return parsed.access_token;
    if (typeof parsed === 'string') return parsed;
  } catch {
    return decoded;
  }
  return null;
}

async function requireAdmin(request: Request): Promise<NextResponse | null> {
  if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
    return NextResponse.json({ error: 'Server misconfiguration' }, { status: 503 });
  }
  const token = getAccessToken(request);
  if (!token) return NextResponse.json({ error: 'Not authenticated' }, { status: 401 });
  const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(token);
  if (userError || !user) return NextResponse.json({ error: 'Invalid session' }, { status: 401 });
  const { data: profile } = await supabaseAdmin
    .from('profiles').select('role').eq('id', user.id).single();
  const role = profile?.role != null ? String(profile.role) : '';
  if (role !== 'admin' && role !== 'staff') {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
  }
  return null;
}

const ORDER_SELECT = `
  *,
  order_items (
    id,
    product_id,
    product_name,
    variant_name,
    sku,
    quantity,
    unit_price,
    total_price,
    metadata
  )
`;

async function attachProductImages(order: Record<string, unknown> & { order_items?: Array<{ product_id?: string | null }> }) {
  const items = order.order_items || [];
  const productIds = [...new Set(items.map((i) => i.product_id).filter(Boolean))] as string[];
  if (productIds.length === 0) return order;

  const { data: images } = await supabaseAdmin
    .from('product_images')
    .select('product_id, url')
    .in('product_id', productIds)
    .order('position', { ascending: true });

  const byProduct = new Map<string, { url: string }[]>();
  for (const img of images || []) {
    const list = byProduct.get(img.product_id) || [];
    list.push({ url: img.url });
    byProduct.set(img.product_id, list);
  }

  order.order_items = items.map((item) => ({
    ...item,
    products: item.product_id
      ? { product_images: byProduct.get(item.product_id) || [] }
      : null,
  }));
  return order;
}

export async function GET(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const err = await requireAdmin(request);
  if (err) return err;

  const { id } = await params;

  try {
    const isUUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id);
    let data: Record<string, unknown> | null = null;
    let queryError: { message?: string } | null = null;

    if (isUUID) {
      const { data: d, error } = await supabaseAdmin
        .from('orders').select(ORDER_SELECT).eq('id', id).single();
      if (error) queryError = error;
      else data = d;
    }

    if (!data) {
      const { data: d, error } = await supabaseAdmin
        .from('orders').select(ORDER_SELECT).eq('order_number', id).single();
      if (error) {
        if (queryError) {
          console.error('Admin order detail query error:', queryError.message, error.message);
          return NextResponse.json({ error: queryError.message || 'Failed to load order' }, { status: 500 });
        }
        return NextResponse.json({ error: 'Order not found' }, { status: 404 });
      }
      data = d;
    }

    const order = await attachProductImages(data);
    return NextResponse.json({ order });
  } catch (e: any) {
    console.error('Admin order detail error:', e);
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const err = await requireAdmin(request);
  if (err) return err;

  const { id } = await params;

  try {
    const body = await request.json();
    const { status, notes, metadata } = body;

    const { error } = await supabaseAdmin
      .from('orders')
      .update({ status, notes, metadata })
      .eq('id', id);

    if (error) throw error;
    return NextResponse.json({ success: true });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}
