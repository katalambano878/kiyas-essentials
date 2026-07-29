# Supabase → Postgres Migration Report — Kiyas

**Shape:** A (compat shim)  
**Branch:** `staging/plain-postgres`  
**Production DB:** `store_kiyas` on fleet-postgres  

---

## Feature matrix

| Supabase feature | Replacement | Status |
|------------------|-------------|--------|
| PostgREST `/rest/v1` | `app/rest/v1` + `lib/db/supabase-compat.ts` | Complete |
| GoTrue `/auth/v1` | `app/auth/v1` + `lib/db/auth.ts` (bcrypt + jose) | Complete |
| Storage | Local disk `lib/db/storage.ts` + `/storage/v1` | Complete |
| `@supabase/supabase-js` runtime | Removed from `package.json` | Complete |
| Client `supabase.from()` | HTTP client → same-origin REST | Complete (intentional Shape A) |
| Server `supabaseAdmin` | Direct PG compat client | Complete |
| RLS policies in SQL | Present in schema; **not enforced** for service role / pool user — app-layer auth required | Partial by design |
| Realtime | Not used in app | N/A |
| Edge Functions | Next.js API routes | Complete |
| RPC (`mark_order_paid`, etc.) | Postgres functions via `.rpc()` | Complete (text status fix applied) |
| Auth Admin `createUser` | Added to compat → `signUpWithPassword` | Fixed this pass |
| Hosted Storage URLs | Category covers no longer use `*.supabase.co` | Fixed this pass |
| Env `SUPABASE_*` names | Kept for compat; values are local | Documented |

---

## Remaining Supabase references

| Kind | Count / notes |
|------|----------------|
| Runtime `@/lib/supabase*` imports | ~85 files (shim, not hosted SDK) |
| Direct `@supabase/supabase-js` | Scripts only (`create-admin.mjs`, `apply-rls.mjs`) — retarget when used |
| `*.supabase.co` in runtime | Removed from `lib/category-covers.ts` |
| Docs / SQL comments | Historical references remain |

---

## Schema notes

- Source: `supabase/migrations/20260209000000_complete_schema.sql` + UUID defaults migration  
- `orders.status` on live DB may be **TEXT** (not enum) — `mark_order_paid` uses text CASE  
- Nested embeds work via `fk-map.ts`; deep/`!inner` joins are best-effort  
- Auth schema: `auth.users` + `profiles.role`  

---

## Auth / RLS replacement

- Middleware verifies JWT for `/admin/*`  
- API routes call `requireAdmin` / `getAuthenticatedAdmin` with Bearer or cookie  
- Customer ownership checks live in specific APIs (order by email/id)  
- `/rest/v1` must not be treated as a public unauthenticated data plane for sensitive tables  

---

## Storage

- Uploads → `STORAGE_ROOT` (e.g. `/app/storage`)  
- Public URLs → `/storage/v1/object/public/...`  
- Coolify: restore product images after redeploy if volume not mounted  

See also: `docs/SUPABASE_TO_POSTGRES_MIGRATION_GUIDE.md`.
