# Kiyas Essentials — Supabase → plain Postgres cutover

**Shape:** A — shimmed `@supabase/supabase-js` → app `/rest/v1`, `/auth/v1`, `/storage/v1` + `DATABASE_URL`  
**Repo:** `katalambano878/kiyas-essentials`  
**Local folder:** `websites/kiyas`  
**Branch:** `staging/plain-postgres`  
**Coolify:** `kiyas-app` (`jtwjvhhndehujicj3h54zqec`) — production  
**Production:** https://kiyasessentials.store (also www + sslip fallback)  


See also: store hardening playbook in the big-vps workspace (`STORE_HARDENING_PLAYBOOK.md`).

## Env cutover trio (set together in Coolify)

| Variable | Notes |
|----------|--------|
| `DATABASE_URL` | `postgresql://…@fleet-postgres:5432/<db>` |
| `NEXT_PUBLIC_USE_PLAIN_PG` | `true` |
| `NEXT_PUBLIC_SUPABASE_URL` | **App origin** (sslip or custom domain), not `*.supabase.co` |

Also required: `AUTH_JWT_SECRET` / `JWT_SECRET`, `NEXT_PUBLIC_APP_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` (compat), `STORAGE_ROOT` / `STORAGE_PUBLIC_URL`, Resend + payment keys.

## Hardening notes (Jul 2026)

- [x] Shape A scaffold: `lib/db/*`, `/rest` `/auth` `/storage`, plain-PG middleware + `supabase-admin`
- [x] Phase A: `public/service-worker.js` `sw-v2.5-kiyas`, `lib/format-money.ts`, `app/error.tsx`, `app/admin/error.tsx`
- [x] `images.unoptimized: true`; drop `*.supabase.co` / `via.placeholder.com` remotePatterns
- [x] Phase B: money sweep, payment-reminders → `supabaseAdmin`, OrderHistory Track/Reorder/Invoice/Help
- [x] UUID `id` defaults migration: `supabase/migrations/20260726170000_uuid_id_defaults.sql` (run as DB owner after restore — see playbook §1a)
- [x] Coolify prod app + `store_kiyas` + deploy
- [x] Custom domain cutover (Jul 2026): FQDN + Traefik labels + env → `kiyasessentials.store`
- [x] UUID `id` defaults present on orders/order_items/customers/products
- [ ] Place test order on production

## Verify

```bash
BASE=https://kiyasessentials.store
curl -s -o /dev/null -w "%{http_code}\n" "$BASE/"
curl -s -o /dev/null -w "%{http_code}\n" "$BASE/shop"
curl -s "$BASE/service-worker.js" | head -n 3
# expect CACHE_VERSION = sw-v2.5-kiyas
```
