import type { Metadata } from "next";
import Script from "next/script";
import { Montserrat } from "next/font/google";
import { CartProvider } from "@/context/CartContext";
import { WishlistProvider } from "@/context/WishlistContext";
import {
  DEFAULT_INSTAGRAM_URL,
  DEFAULT_LOGO_PATH,
  DEFAULT_SITE_NAME,
  DEFAULT_SITE_TAGLINE,
  DEFAULT_SNAPCHAT_URL,
  DEFAULT_TIKTOK_URL,
  DEFAULT_CONTACT_PHONE,
  formatGhanaIntlTel,
  getWhatsAppUrl,
  getSiteUrl,
} from "@/lib/site-defaults";
import "./globals.css";

const montserrat = Montserrat({
  weight: ["300", "400", "500", "600", "700"],
  style: ["normal", "italic"],
  subsets: ["latin"],
  variable: "--font-montserrat",
});

const siteUrl = getSiteUrl();
const telIntl = formatGhanaIntlTel(DEFAULT_CONTACT_PHONE);
const FAVICON_VERSION = "20260416d";
const sameAsSocial = [
  getWhatsAppUrl(DEFAULT_CONTACT_PHONE),
  DEFAULT_INSTAGRAM_URL,
  DEFAULT_TIKTOK_URL,
  DEFAULT_SNAPCHAT_URL,
];

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  applicationName: DEFAULT_SITE_NAME,
  category: "shopping",
  referrer: "origin-when-cross-origin",
  title: {
    default: `${DEFAULT_SITE_NAME} | Online Store`,
    template: `%s | ${DEFAULT_SITE_NAME}`,
  },
  description: DEFAULT_SITE_TAGLINE,
  keywords: [
    DEFAULT_SITE_NAME,
    "girly accessories",
    "daily essentials",
    "content creation",
    "home decor",
    "tripods",
    "Accra",
    "Ghana",
    "online store",
  ],
  authors: [{ name: DEFAULT_SITE_NAME }],
  creator: DEFAULT_SITE_NAME,
  publisher: DEFAULT_SITE_NAME,
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  icons: {
    shortcut: [
      { url: `/logo.png?v=${FAVICON_VERSION}`, type: 'image/png' },
    ],
    icon: [
      { url: `/logo.png?v=${FAVICON_VERSION}`, type: 'image/png' },
    ],
    apple: [
      { url: `/logo.png?v=${FAVICON_VERSION}`, type: 'image/png' },
    ],
  },
  manifest: '/manifest.json',
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: DEFAULT_SITE_NAME,
  },
  formatDetection: {
    telephone: true,
  },
  verification: {
    google: process.env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION || '',
  },
  openGraph: {
    type: "website",
    locale: "en_GH",
    url: siteUrl,
    title: `${DEFAULT_SITE_NAME} | Online Store`,
    description: DEFAULT_SITE_TAGLINE,
    siteName: DEFAULT_SITE_NAME,
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: `${DEFAULT_SITE_NAME} preview`,
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: `${DEFAULT_SITE_NAME} | Online Store`,
    description: DEFAULT_SITE_TAGLINE,
    images: ["/twitter-image.png"],
  },
  alternates: {
    canonical: siteUrl,
  },
};

// Google Analytics Measurement ID
const GA_MEASUREMENT_ID = process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID;
// Google reCAPTCHA v3 Site Key
const RECAPTCHA_SITE_KEY = process.env.NEXT_PUBLIC_RECAPTCHA_SITE_KEY;

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <head>
        {/* PWA Meta Tags */}
        <meta name="theme-color" content="#BE185D" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="apple-mobile-web-app-title" content={DEFAULT_SITE_NAME} />
        <meta name="mobile-web-app-capable" content="yes" />
        <meta name="msapplication-TileColor" content="#BE185D" />
        <meta name="msapplication-tap-highlight" content="no" />

        {/* Apple Touch Icon */}
        <link rel="apple-touch-icon" href={`/logo.png?v=${FAVICON_VERSION}`} />

        <link
          href="https://cdn.jsdelivr.net/npm/remixicon@4.1.0/fonts/remixicon.css"
          rel="stylesheet"
        />

        {/* Structured Data - Organization + Local Business */}
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@graph": [
                {
                  "@type": "Organization",
                  "@id": `${siteUrl}#organization`,
                  "name": DEFAULT_SITE_NAME,
                  "url": siteUrl,
                  "logo": `${siteUrl}${DEFAULT_LOGO_PATH}`,
                  "image": `${siteUrl}/og-image.png`,
                  "description": DEFAULT_SITE_TAGLINE,
                  "sameAs": sameAsSocial,
                  "contactPoint": {
                    "@type": "ContactPoint",
                    "contactType": "customer service",
                    "telephone": telIntl,
                    "availableLanguage": "English"
                  }
                },
                {
                  "@type": "Store",
                  "@id": `${siteUrl}#store`,
                  "name": DEFAULT_SITE_NAME,
                  "url": siteUrl,
                  "image": `${siteUrl}/og-image.png`,
                  "telephone": telIntl,
                  "priceRange": "$$",
                                   "address": {
                    "@type": "PostalAddress",
                    "addressLocality": "Accra",
                    "addressCountry": "GH"
                  },
                  "areaServed": "Ghana"
                }
              ]
            })
          }}
        />
      </head>

      {/* Google Analytics */}
      {GA_MEASUREMENT_ID && (
        <>
          <Script
            src={`https://www.googletagmanager.com/gtag/js?id=${GA_MEASUREMENT_ID}`}
            strategy="afterInteractive"
          />
          <Script id="google-analytics" strategy="afterInteractive">
            {`
              window.dataLayer = window.dataLayer || [];
              function gtag(){dataLayer.push(arguments);}
              gtag('js', new Date());
              gtag('config', '${GA_MEASUREMENT_ID}', {
                page_path: window.location.pathname,
              });
            `}
          </Script>
        </>
      )}

      {/* Google reCAPTCHA v3 */}
      {RECAPTCHA_SITE_KEY && (
        <Script
          src={`https://www.google.com/recaptcha/api.js?render=${RECAPTCHA_SITE_KEY}`}
          strategy="afterInteractive"
        />
      )}

      <body className={`antialiased overflow-x-hidden pwa-body ${montserrat.variable} font-sans`} style={{ fontFamily: "var(--font-montserrat), system-ui, sans-serif" }}>
        <a
          href="#main-content"
          className="sr-only focus:not-sr-only focus:absolute focus:top-4 focus:left-4 focus:z-[10000] focus:px-6 focus:py-3 focus:bg-gray-900 focus:text-white focus:rounded-lg focus:font-semibold focus:shadow-lg"
        >
          Skip to main content
        </a>
        <CartProvider>
          <WishlistProvider>
            <div id="main-content">
              {children}
            </div>
          </WishlistProvider>
        </CartProvider>
      </body>
    </html>
  );
}
