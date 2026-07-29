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

const VALID_TYPES = ['percentage', 'fixed_amount', 'free_shipping'] as const;

function normalizeCouponBody(body: Record<string, unknown>, partial = false) {
  const payload: Record<string, unknown> = {};

  if (!partial || body.code !== undefined) {
    const code = String(body.code || '').trim().toUpperCase();
    if (!code) throw new Error('Coupon code is required');
    payload.code = code;
  }

  if (!partial || body.type !== undefined) {
    const type = String(body.type || 'percentage');
    if (!VALID_TYPES.includes(type as typeof VALID_TYPES[number])) {
      throw new Error('Invalid coupon type');
    }
    payload.type = type;
  }

  if (!partial || body.value !== undefined) {
    const type = String(body.type || payload.type || 'percentage');
    const value = type === 'free_shipping' ? 0 : Number(body.value);
    if (type !== 'free_shipping' && (Number.isNaN(value) || value < 0)) {
      throw new Error('Invalid coupon value');
    }
    payload.value = value;
  }

  if (body.description !== undefined) payload.description = body.description || null;
  if (body.minimum_purchase !== undefined || body.minPurchase !== undefined) {
    payload.minimum_purchase = Number(body.minimum_purchase ?? body.minPurchase) || 0;
  }
  if (body.maximum_discount !== undefined || body.maxDiscount !== undefined) {
    const max = body.maximum_discount ?? body.maxDiscount;
    payload.maximum_discount = max === '' || max == null ? null : Number(max);
  }
  if (body.usage_limit !== undefined || body.usageLimit !== undefined) {
    const limit = body.usage_limit ?? body.usageLimit;
    payload.usage_limit = limit === '' || limit == null ? null : Number(limit);
  }
  if (body.per_user_limit !== undefined) {
    payload.per_user_limit = Number(body.per_user_limit) || 1;
  }
  if (body.start_date !== undefined || body.startDate !== undefined) {
    const start = body.start_date ?? body.startDate;
    payload.start_date = start ? new Date(String(start)).toISOString() : null;
  }
  if (body.end_date !== undefined || body.endDate !== undefined) {
    const end = body.end_date ?? body.endDate;
    payload.end_date = end ? new Date(String(end)).toISOString() : null;
  }
  if (body.is_active !== undefined || body.isActive !== undefined) {
    payload.is_active = body.is_active ?? body.isActive;
  }

  return payload;
}

export async function GET(request: Request) {
  const err = await requireAdmin(request);
  if (err) return err;

  try {
    const { data, error } = await supabaseAdmin
      .from('coupons')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    return NextResponse.json({ coupons: data || [] });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}

export async function POST(request: Request) {
  const err = await requireAdmin(request);
  if (err) return err;

  try {
    const body = await request.json();
    const payload = normalizeCouponBody(body);

    const { data, error } = await supabaseAdmin
      .from('coupons')
      .insert(payload)
      .select('*')
      .single();

    if (error) {
      if (error.message?.includes('duplicate') || error.message?.includes('unique')) {
        return NextResponse.json({ error: 'A coupon with this code already exists' }, { status: 409 });
      }
      throw error;
    }

    return NextResponse.json({ coupon: data }, { status: 201 });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 400 });
  }
}
