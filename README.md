# Storefront application

Next.js e-commerce storefront with admin tools, payments, and optional AI chat. This template is ownership-neutral: configure branding, domains, and contact details via environment variables and the CMS.

## Setup

1. Install dependencies: `npm install`
2. Copy environment variables from your hosting provider (Supabase, payment keys, `NEXT_PUBLIC_APP_URL`, etc.) into `.env.local`.
3. Add your logo at `public/logo.png` (referenced as `/logo.png` in the app).
4. Run the dev server: `npm run dev` (default port is set in `package.json`).

## Customize

- **Site name and defaults:** `lib/site-defaults.ts` — neutral placeholders (`Your Store`, `example.com`, `hello@example.com`, etc.).
- **Runtime branding:** CMS settings in the database override many storefront strings.
- **Admin user:** `npm run create-admin` (see `scripts/create-admin.mjs` for env keys).

## Scripts

| Command | Description |
|--------|-------------|
| `npm run dev` | Development server |
| `npm run build` | Production build |
| `npm run lint` | ESLint |
| `npm run create-admin` | Create admin user in Supabase |
