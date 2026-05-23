/**
 * Kiyas Essentials — storefront defaults.
 * Override via NEXT_PUBLIC_APP_URL, CMS `site_settings`, and env where noted.
 */

export const DEFAULT_SITE_NAME = "Kiyas Essentials";
export const DEFAULT_SITE_TAGLINE =
  "Girly accessories, daily essentials, content creation tools, home decor, tripods & more.";
export const DEFAULT_SITE_URL = "https://example.com";
export const DEFAULT_LOGO_PATH = "/logo.png";
export const DEFAULT_CONTACT_EMAIL = "hello@example.com";
export const DEFAULT_ADMIN_EMAIL = "admin@example.com";
export const DEFAULT_NOREPLY_EMAIL = "noreply@example.com";

/** Ghana local numbers (WhatsApp) */
export const DEFAULT_CONTACT_PHONE_PRIMARY = "0504649472";
export const DEFAULT_CONTACT_PHONE_SECONDARY = "0543889627";
/** Primary line — used as default `contact_phone` fallback */
export const DEFAULT_CONTACT_PHONE = DEFAULT_CONTACT_PHONE_PRIMARY;

export const DEFAULT_INSTAGRAM_HANDLE = "kiyas.essentials";
/** TikTok profile URL (handle may differ from display name “Kiyas Essentials”) */
export const DEFAULT_TIKTOK_URL = "https://www.tiktok.com/@kiyas.essentials";
export const DEFAULT_SNAPCHAT_URL = "https://www.snapchat.com/add/Pretty_zaky";
export const DEFAULT_INSTAGRAM_URL = `https://www.instagram.com/${DEFAULT_INSTAGRAM_HANDLE}/`;

export const DEFAULT_CITY = "Accra";
export const DEFAULT_COUNTRY_CODE = "GH";
export const DEFAULT_CONTACT_ADDRESS = "Accra, Ghana";

/** Digits only for wa.me, e.g. 233504649472 */
export function formatGhanaWaPath(localPhone: string): string {
  const d = localPhone.replace(/\D/g, "");
  if (d.startsWith("233")) return d;
  if (d.startsWith("0")) return "233" + d.slice(1);
  return "233" + d;
}

export function getWhatsAppUrl(localPhone: string): string {
  return `https://wa.me/${formatGhanaWaPath(localPhone)}`;
}

/** E.164 for Ghana, e.g. +233501234567 */
export function formatGhanaIntlTel(localPhone: string): string {
  return `+${formatGhanaWaPath(localPhone)}`;
}

/** Spaced display: 050 464 9472 */
export function formatGhanaPhoneDisplay(localPhone: string): string {
  const d = localPhone.replace(/\D/g, "");
  const n = d.startsWith("0") ? d : `0${d}`;
  if (n.length >= 10) return `${n.slice(0, 3)} ${n.slice(3, 6)} ${n.slice(6, 10)}`;
  return localPhone;
}

export function getSiteUrl(): string {
  const fromEnv =
    process.env.NEXT_PUBLIC_APP_URL ||
    (process.env.VERCEL_URL ? `https://${process.env.VERCEL_URL}` : null);
  return (fromEnv || DEFAULT_SITE_URL).replace(/\/+$/, "");
}
