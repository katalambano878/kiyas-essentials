/**
 * Site Knowledge Base — curated facts used by the AI chat assistant.
 */

import {
  DEFAULT_CONTACT_EMAIL,
  DEFAULT_CONTACT_PHONE,
  DEFAULT_INSTAGRAM_HANDLE,
  DEFAULT_SITE_NAME,
  DEFAULT_SITE_TAGLINE,
} from "@/lib/site-defaults";

export interface SiteKnowledgeEntry {
  id: string;
  title: string;
  path: string;
  category: string;
  content: string;
  keywords: string[];
}

export const SITE_KNOWLEDGE: SiteKnowledgeEntry[] = [
  {
    id: "business-overview",
    title: `About ${DEFAULT_SITE_NAME}`,
    path: "/about",
    category: "company",
    content: `${DEFAULT_SITE_NAME} is an online shop based in Accra, Ghana. ${DEFAULT_SITE_TAGLINE}

We focus on girly accessories, daily essentials, content creation tools (including tripods), home decor, and related lifestyle products — with clear photos, sizes where relevant, and checkout in Ghana Cedis (GHS).

Vision: A friendly place to shop cute, useful pieces for everyday life and creating content.
Mission: Help you find the right accessories, essentials, and gear with straightforward service and delivery options shown at checkout.

Delivery: Greater Accra and nationwide options (timing and fees) appear at checkout.`,
    keywords: [
      "store",
      "shopping",
      "products",
      "about",
      "accessories",
      "essentials",
      "tripods",
      "home decor",
      "content creation",
      "Accra",
      "Ghana",
      "delivery",
    ],
  },
  {
    id: "contact-info",
    title: "Contact Information",
    path: "/contact",
    category: "contact",
    content: `Contact ${DEFAULT_SITE_NAME}:

Phone/WhatsApp: ${DEFAULT_CONTACT_PHONE}
Email: ${DEFAULT_CONTACT_EMAIL}
Instagram: @${DEFAULT_INSTAGRAM_HANDLE}
Support Hours: Configure in store settings`,
    keywords: [
      "contact",
      "phone",
      "whatsapp",
      "email",
      "address",
      "support",
      "instagram",
    ],
  },
  {
    id: "shipping-policy",
    title: "Shipping & Delivery Policy",
    path: "/shipping",
    category: "shipping",
    content: `${DEFAULT_SITE_NAME} shipping options and timelines depend on destination and are shown at checkout.

Customers receive order updates and can track orders using order number and email.`,
    keywords: ["shipping", "delivery", "worldwide", "international", "timeline", "tracking"],
  },
  {
    id: "returns-policy",
    title: "Returns & Refunds Policy",
    path: "/returns",
    category: "returns",
    content: `Returns are accepted for eligible unused items in original condition within 30 days of delivery.

Custom or altered items may not be returnable unless there is a quality issue.

Refunds are processed after item inspection.`,
    keywords: ["returns", "refund", "exchange", "worn", "condition", "30 days"],
  },
  {
    id: "payment-methods",
    title: "Payment Methods",
    path: "/checkout",
    category: "payment",
    content: `Secure payment options are available at checkout.

Mobile Money is supported for eligible local orders where configured.
All prices are shown in Ghana Cedis (GHS) unless otherwise stated.`,
    keywords: ["payment", "momo", "checkout", "secure", "ngn", "naira", "nigeria"],
  },
  {
    id: "order-tracking-guide",
    title: "How to Track Your Order",
    path: "/order-tracking",
    category: "orders",
    content: `To track an order, go to /order-tracking and provide your order number and email address.

Typical status flow:
Order Placed -> Payment -> Processing -> Packaged -> Dispatched -> Delivered.`,
    keywords: ["track", "order", "status", "order number", "email", "dispatched"],
  },
  {
    id: "faq-summary",
    title: "Frequently Asked Questions",
    path: "/faqs",
    category: "faq",
    content: `FAQs cover orders, shipping, returns, payment, and account support.

Customers can contact support via WhatsApp, email, or support ticket for unresolved issues.`,
    keywords: ["faq", "questions", "support", "orders", "shipping", "returns"],
  },
  {
    id: "legal-summary",
    title: "Privacy & Terms",
    path: "/privacy",
    category: "legal",
    content: `Privacy Policy and Terms explain data handling, order conditions, returns, and user responsibilities.

For legal questions, contact ${DEFAULT_CONTACT_EMAIL}.`,
    keywords: ["privacy", "terms", "legal", "data", "policy"],
  },
  {
    id: "checkout-guide",
    title: "Checkout Process",
    path: "/checkout",
    category: "shopping",
    content: `Checkout steps:
1. Add products to cart
2. Enter shipping details
3. Choose delivery method
4. Complete payment
5. Receive confirmation and tracking updates`,
    keywords: ["checkout", "cart", "payment", "delivery", "order"],
  },
];

/**
 * Search the site knowledge base for relevant entries
 */
export function searchSiteKnowledge(query: string, maxResults = 3): SiteKnowledgeEntry[] {
  const lower = query.toLowerCase();
  const words = lower.split(/\s+/).filter(w => w.length > 2);

  const scored = SITE_KNOWLEDGE.map(entry => {
    let score = 0;

    // Exact keyword matches (highest priority)
    for (const kw of entry.keywords) {
      if (lower.includes(kw)) score += 10;
      for (const word of words) {
        if (kw.includes(word) || word.includes(kw)) score += 3;
      }
    }

    // Title match
    if (entry.title.toLowerCase().includes(lower)) score += 15;
    for (const word of words) {
      if (entry.title.toLowerCase().includes(word)) score += 5;
    }

    // Content match
    const contentLower = entry.content.toLowerCase();
    for (const word of words) {
      if (contentLower.includes(word)) score += 2;
    }

    // Boost FAQ entries slightly (they cover common questions)
    if (entry.category === 'faq') score += 1;

    return { entry, score };
  });

  return scored
    .filter(s => s.score > 0)
    .sort((a, b) => b.score - a.score)
    .slice(0, maxResults)
    .map(s => s.entry);
}

/**
 * Get all knowledge entries for a specific category
 */
export function getKnowledgeByCategory(category: string): SiteKnowledgeEntry[] {
  return SITE_KNOWLEDGE.filter(e => e.category === category);
}

/**
 * Build a condensed site map for the system prompt
 */
export function getSiteMapSummary(): string {
  return `WEBSITE PAGES (you can reference these to help customers navigate):
- / — Homepage with featured products, categories, and store info
- /shop — Browse all products with filters (category, price, rating, sort)
- /categories — Shop by category
- /product/[slug] — Individual product pages with details, reviews, variants
- /cart — Shopping cart with coupon support
- /checkout — Checkout flow (shipping → delivery → payment)
- /order-tracking — Track orders by order number + email
- /returns — Start a return request (30-day policy)
- /account — Profile, order history, addresses, security settings
- /wishlist — Saved products
- /about — Store story and mission
- /contact — Phone numbers, email, WhatsApp, visit info
- /faqs — Frequently asked questions
- /help — Help center with articles
- /blog — Tips and product guides
- /shipping — Detailed shipping & delivery policy
- /privacy — Privacy policy
- /terms — Terms & conditions
- /support/ticket — Create a support ticket
- /support/tickets — View your tickets
- /auth/login — Sign in
- /auth/signup — Create account
- /auth/forgot-password — Reset password`;
}
