# FULL SYSTEM AUDIT — Kiyas Essentials

**Date:** 2026-07-29  
**Branch:** `staging/plain-postgres`  
**Production:** https://kiyasessentials.store  
**DB:** plain PostgreSQL `store_kiyas` via `fleet-postgres`  
**Architecture:** Shape A — Supabase-js API preserved via `lib/db/*` shims (`pg` Pool + `/rest` `/auth` `/storage`)

---

## 1. Baseline (before this audit pass)

| Check | Status |
|-------|--------|
| Git branch | `staging/plain-postgres` clean (only untracked product import scripts) |
| Runtime `@supabase/supabase-js` | Removed (cutover commit `5bad6ef`) |
| Live homepage / shop / cart / checkout | HTTP 200 |
| Storefront product/shop/categories APIs | HTTP 200 |
| Admin login + orders/products/staff APIs | HTTP 200 (after prior fixes) |
| Order detail nested embed | Previously 404 — fixed in `95cd0a2` |
| Hubtel / Paystack code | **Not present in repository** |
| Payment provider in use | **Moolre only** |
| SMS provider | **Moolre SMS only** |

### Known breakage at audit start

1. Staff create used missing `auth.admin.createUser` on PG shim  
2. ~16 API routes gated on `SUPABASE_SERVICE_ROLE_KEY` instead of `DATABASE_URL`  
3. Hardcoded `*.supabase.co` category cover URLs  
4. Callback secret mismatch was non-blocking (forgery risk when secret set)  
5. Failed callbacks could overwrite paid orders  
6. External payment/SMS fetches had no timeouts  
7. Delivery `NOT IN` UUID lists fragile without quote stripping  

---

## 2. Architecture summary

| Layer | Implementation |
|-------|----------------|
| Framework | Next.js 15 App Router, React 19 |
| DB access | `pg` Pool (`lib/db/pool.ts`) + PostgREST-shaped builder (`lib/db/supabase-compat.ts`) |
| Browser client | `lib/db/http-client.ts` → same-origin `/rest/v1`, `/auth/v1`, `/storage/v1` |
| Auth | Custom GoTrue shim (`lib/db/auth.ts`) — bcrypt + jose JWT against `auth.users` |
| Storage | Local disk (`STORAGE_ROOT`), served via `/storage/v1/object/...` |
| Payments | Moolre embed link + callback + status verify |
| SMS / email | Moolre SMS + Resend |
| Admin gate | `middleware.ts` JWT + `app_metadata.role` ∈ admin/staff |

---

## 3. Route inventory (condensed)

### Public storefront (~30 pages)
`/`, `/shop`, `/categories`, `/product/[slug]`, `/cart`, `/checkout`, `/pay/[orderId]`, `/order-success`, `/order-tracking`, `/wishlist`, `/about`, `/blog`, `/blog/[id]`, `/contact`, `/faqs`, `/help`, `/support/*`, `/returns*`, `/shipping`, `/terms`, `/privacy`, auth pages, account pages.

### Admin (~35 pages)
Dashboard, orders, POS, products, categories, customers, reviews, inventory, analytics, coupons, support, delivery, modules, staff, roles, notifications, test-sms, blog stub.

### Critical APIs
- Storefront: products, shop, categories, checkout, pay, modules  
- Admin: me, orders, products, coupons, staff, upload, POS, modules  
- Payment: `/api/payment/moolre`, `/callback`, `/verify`  
- Notifications: `/api/notifications`  
- Compat: `/rest/v1/*`, `/auth/v1/*`, `/storage/v1/*`  

Full path lists were generated during Phase 2 exploration (explore agents).

---

## 4. Fixes applied in this audit pass

| Area | Fix |
|------|-----|
| Env gates | `DATABASE_URL`/`POSTGRES_URL` replace `SUPABASE_SERVICE_ROLE_KEY` checks in 16 API routes + admin login message |
| Staff create | Implemented `auth.admin.createUser` in PG compat → `signUpWithPassword` |
| Category images | Removed hardcoded Supabase Storage URLs; local SVG placeholders |
| Callback security | Reject invalid `MOOLRE_CALLBACK_SECRET`; ignore delayed failure after paid |
| Delivery filters | Safer UUID `NOT IN` + quote stripping in compat layer |
| Timeouts | 15–20s AbortController on SMS, payment init, payment verify |
| Docs | This file + migration/payment/performance/changelog reports + `.env.example` |

---

## 5. Page audit status (live smoke, 2026-07-29)

| Area | Status |
|------|--------|
| Public pages (home, shop, categories, cart, checkout, contact, about, faqs, blog) | Working (200) |
| Storefront APIs | Working |
| Admin login + me/orders/products/coupons/staff/delivery stats | Working |
| Order detail | Working (post prior deploy) |
| Coupons CRUD UI | Working (API + modal) |
| Blog admin new/edit | Stub / not fully implemented — manual follow-up |
| Hubtel / Paystack journeys | N/A — not in codebase |
| Live payment end-to-end with real money | Manual — use sandbox/test only |

---

## 6. Remaining risks

1. Shape A leaves ~85 files on Supabase-shaped API — embed/`!inner` edge cases remain  
2. Browser `/rest/v1` is not RLS-scoped; authorization must stay in API routes + middleware  
3. `MOOLRE_CALLBACK_SECRET` must be set in Coolify for hard callback auth  
4. Product image storage volume not persistent across Coolify redeploys (must restore `/app/storage`)  
5. No automated test suite for callbacks yet  
6. Admin blog routes incomplete  

---

## 7. Final production readiness

**Ready after listed manual actions** (see `REPAIR_CHANGELOG.md` § Manual Actions).

Core storefront, admin orders/products, Moolre payment + SMS paths are operational on plain Postgres. Hubtel/Paystack are out of scope (not implemented). Full rewrite off the Shape A shim is optional future work, not required for stability.
