# Repair Changelog — Kiyas (2026-07-29 audit)

## Commits in this effort (series)

Prior (same branch): order detail + coupons CRUD (`95cd0a2`), admin products/POS/delivery (`8189104`), variants/images fixes.

### This pass

- Replace `SUPABASE_SERVICE_ROLE_KEY` misconfig gates with `DATABASE_URL` / `POSTGRES_URL` (16 API routes + admin login copy)
- Implement `auth.admin.createUser` on Postgres compat client
- Remove hardcoded Supabase category cover URLs (`lib/category-covers.ts`)
- Harden Moolre callback: reject bad secret; ignore failure after paid
- SMS / payment init / verify timeouts
- Delivery UUID `NOT IN` quote handling + compat strip
- Documentation set + `.env.example`

## Files changed (this pass — primary)

- `app/api/admin/**` (env gates)
- `app/api/storefront/**` (env gates)
- `app/admin/login/page.tsx`
- `app/api/payment/moolre/route.ts`
- `app/api/payment/moolre/callback/route.ts`
- `app/api/payment/moolre/verify/route.ts`
- `app/api/delivery/route.ts`
- `lib/db/supabase-compat.ts`
- `lib/category-covers.ts`
- `lib/notifications.ts`
- `FULL_SYSTEM_AUDIT.md`, `SUPABASE_TO_POSTGRES_MIGRATION_REPORT.md`, `PAYMENT_AND_CALLBACK_AUDIT.md`, `PERFORMANCE_REPORT.md`, `REPAIR_CHANGELOG.md`, `.env.example`

## Database migrations

No new destructive migrations in this pass. Existing:

- `supabase/migrations/20260209000000_complete_schema.sql`
- `supabase/migrations/20260726170000_uuid_id_defaults.sql`
- Live fix previously applied: `mark_order_paid` text status CASE

## Packages

None added/removed.

## Manual actions required

1. Confirm Coolify env: `DATABASE_URL`, `AUTH_JWT_SECRET`, `MOOLRE_*`, `MOOLRE_CALLBACK_SECRET`, `MOOLRE_SMS_API_KEY`, `RESEND_API_KEY`, `STORAGE_ROOT`  
2. Set `MOOLRE_CALLBACK_SECRET` to match Moolre dashboard (callbacks now **reject** mismatch)  
3. After each redeploy, restore product images into container storage if volume not mounted  
4. Place a real/test MoMo order and confirm callback → paid → SMS  
5. Retarget `scripts/create-admin.mjs` before using it (still old SDK)  
6. Hubtel/Paystack: not in product — do not register unused callback URLs  

## Tests

| Check | Result |
|-------|--------|
| Live public pages | 200 |
| Live storefront APIs | 200 |
| Live admin APIs (auth) | 200 |
| Lint / unit / e2e suite | Not fully run (repo has minimal test harness) |
| Production build | Relies on Coolify nixpacks deploy |
