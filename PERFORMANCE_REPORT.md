# Performance Report — Kiyas

**Date:** 2026-07-29  

---

## Baseline observations

| Surface | Observation |
|---------|-------------|
| Homepage / shop HTML | HTTP 200, server-rendered |
| Storefront product APIs | Respond with product JSON; nested selects previously caused 404s on detail |
| Admin orders list | OK; detail was failing on nested `products(product_images)` embed |
| External Moolre calls | Previously unbounded — could freeze request workers |
| Connection pool | `pg` singleton, `PG_POOL_MAX` default 10 |

---

## Freezing / slowness causes found

1. **Nested PostgREST embeds failing** → UI showed permanent error / empty (orders detail)  
2. **External payment/SMS fetch without timeout** → hung API routes under provider latency  
3. **Admin pages loading large tables without virtualization** — acceptable at current catalog size  
4. **Shape A double hop** for browser client (browser → `/rest` → PG) adds latency vs direct server components  
5. **Coolify cold start / redeploy** can briefly interrupt traffic  

---

## Fixes applied

| Fix | Impact |
|-----|--------|
| Order detail: flat select + separate image attach | Removes failing nested join |
| AbortController timeouts on Moolre payment/SMS/verify | Caps hang time at 15–20s |
| `DATABASE_URL` gates | Avoid false 503s that looked like “broken site” |
| Images: `images.unoptimized: true` (prior) | Avoids Next image optimizer dependency on remote Supabase |

---

## Recommendations (not all implemented)

1. Persist `/app/storage` as a Coolify volume  
2. Paginate admin orders/customers (limit + cursor)  
3. Prefer server components + `supabaseAdmin` for storefront lists (skip HTTP shim)  
4. Add indexes if EXPLAIN shows seq scans on `orders(order_number)`, `orders(payment_status, created_at)`, `order_items(order_id)` — verify on live before adding  
5. Cache public category/product lists with short revalidation  

---

## Measurements

Automated Lighthouse / query EXPLAIN not run in this pass (no local DB credentials in workspace). Live smoke: storefront + admin APIs return 200 within ~1–3s from VPS egress.
