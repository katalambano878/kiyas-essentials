import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

function extractToken(request: NextRequest): string | undefined {
    let token = request.cookies.get('sb-access-token')?.value;
    if (token) return token;

    const projectRef = supabaseUrl?.split('//')[1]?.split('.')[0];
    token = request.cookies.get(`sb-${projectRef}-auth-token`)?.value;
    if (token) return token;

    for (const [name, cookie] of request.cookies) {
        if (name.startsWith('sb-') && (name.endsWith('-auth-token') || name.includes('auth'))) {
            try {
                const parsed = JSON.parse(cookie.value);
                if (Array.isArray(parsed) && parsed[0]) return parsed[0];
                if (typeof parsed === 'object' && parsed.access_token) return parsed.access_token;
                if (typeof parsed === 'string') return parsed;
            } catch {
                return cookie.value;
            }
        }
    }
    return undefined;
}

export async function middleware(request: NextRequest) {
    const { pathname } = request.nextUrl;
    const response = NextResponse.next();

    response.headers.set('X-Content-Type-Options', 'nosniff');
    response.headers.set('X-Frame-Options', 'DENY');
    response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');

    if (pathname.startsWith('/admin')) {
        response.headers.set('X-Robots-Tag', 'noindex, nofollow');
        response.headers.set('Cache-Control', 'no-store, no-cache, must-revalidate');

        if (pathname === '/admin/login') {
            return response;
        }

        const token = extractToken(request);

        if (!token) {
            const loginUrl = new URL('/admin/login', request.url);
            loginUrl.searchParams.set('redirect', pathname);
            return NextResponse.redirect(loginUrl);
        }

        if (supabaseServiceKey) {
            try {
                const supabase = createClient(supabaseUrl, supabaseServiceKey, {
                    auth: { autoRefreshToken: false, persistSession: false },
                });

                const { data: { user }, error } = await supabase.auth.getUser(token);

                if (error || !user) {
                    const loginUrl = new URL('/admin/login', request.url);
                    loginUrl.searchParams.set('redirect', pathname);
                    loginUrl.searchParams.set('error', 'session_expired');
                    return NextResponse.redirect(loginUrl);
                }

                response.headers.set('x-user-id', user.id);
            } catch (err) {
                console.error('[Middleware] Auth check error:', err);
            }
        }
    }

    if (pathname.startsWith('/api/')) {
        response.headers.set('X-Content-Type-Options', 'nosniff');
        response.headers.set('Cache-Control', 'no-store');
    }

    return response;
}

export const config = {
    matcher: [
        '/admin/:path*',
        '/api/:path*',
    ],
};
