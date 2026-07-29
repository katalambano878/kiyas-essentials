# Payment & Callback Audit — Kiyas

**Date:** 2026-07-29  
**Gateways in codebase:** Moolre only  
**Not present:** Hubtel, Paystack (no routes, env, or SDKs)

---

## Moolre flow

1. Checkout / POS creates order (server totals)  
2. `POST /api/payment/moolre` loads order from DB, ignores client amount  
3. Unique `externalref` = `{order_number}-R{timestamp}` stored in metadata  
4. Customer redirected to Moolre `authorization_url`  
5. Moolre POSTs `POST /api/payment/moolre/callback`  
6. Server validates secret (when set), amount, status → `mark_order_paid` RPC  
7. Browser lands on `/order-success` → optional `POST /api/payment/moolre/verify` against Moolre status API  

### Routes

| Route | Method | Auth | Status |
|-------|--------|------|--------|
| `/api/payment/moolre` | POST | Rate-limited public | Working; 20s timeout |
| `/api/payment/moolre/callback` | POST | Secret + amount | Hardened this pass |
| `/api/payment/moolre/callback` | GET | Public health | Working |
| `/api/payment/moolre/verify` | POST | Rate-limited | Working; 15s timeout |
| `/api/storefront/pay/[orderId]` | GET | Public order view | Working |

### Security controls

| Control | Status |
|---------|--------|
| Server-side amount | Yes — from `orders.total` |
| Callback secret | Rejects mismatch when `MOOLRE_CALLBACK_SECRET` set |
| Amount match (±0.01) | Yes |
| Idempotent paid | Yes — skip if already `paid` |
| Delayed failure after paid | Ignored (fixed this pass) |
| Redirect alone marks paid | No — verify/callback only |
| Duplicate SMS on double callback | Mitigated by paid idempotency before notify |

### Env

`MOOLRE_API_USER`, `MOOLRE_API_PUBKEY`, `MOOLRE_ACCOUNT_NUMBER`, `MOOLRE_MERCHANT_EMAIL`, `MOOLRE_CALLBACK_SECRET`

---

## Hubtel

**Not implemented.** No initiation, callback, or verify routes.  
**Final status:** N/A — do not configure Hubtel for this store unless a new integration is built.

---

## Paystack

**Not implemented.** No initiation, webhook, or verify routes.  
**Final status:** N/A — same as Hubtel.

---

## SMS (Moolre)

| Item | Detail |
|------|--------|
| Endpoint | `https://api.moolre.com/open/sms/send` |
| Entry | `lib/notifications.ts` → `sendSMS` |
| Triggers | Order confirm, status update, payment link, welcome, admin test, campaigns |
| Timeout | 15s AbortController (this pass) |
| Duplicate protection | Relies on order paid idempotency; no SMS attempt table yet |
| Credentials | `MOOLRE_SMS_API_KEY` or `MOOLRE_API_KEY`, `SMS_SENDER_ID` |

---

## Manual test checklist (staging)

- [ ] Initiate MoMo link for unpaid order  
- [ ] Complete payment → callback marks paid once  
- [ ] Replay callback → still paid, no double SMS preferred  
- [ ] Wrong secret → 401 when secret configured  
- [ ] Wrong amount → 400  
- [ ] Verify endpoint after redirect confirms via Moolre status API  
