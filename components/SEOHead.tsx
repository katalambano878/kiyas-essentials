import { Metadata } from 'next';
import {
   DEFAULT_CONTACT_ADDRESS,
  DEFAULT_CONTACT_EMAIL,
  DEFAULT_COUNTRY_CODE,
  DEFAULT_INSTAGRAM_URL,
  DEFAULT_LOGO_PATH,
  DEFAULT_SITE_NAME,
  DEFAULT_CONTACT_PHONE,
  DEFAULT_SNAPCHAT_URL,
  DEFAULT_TIKTOK_URL,
  formatGhanaIntlTel,
  getWhatsAppUrl,
  getSiteUrl,
} from '@/lib/site-defaults';

interface SEOProps {
  title?: string;
  description?: string;
  keywords?: string[];
  ogImage?: string;
  ogType?: 'website' | 'product' | 'article';
  price?: number;
  currency?: string;
  availability?: string;
  category?: string;
  publishedTime?: string;
  author?: string;
  noindex?: boolean;
}

export function generateMetadata({
  title = "Online Store",
  description = "Shop products online. Delivery and payment options are shown at checkout.",
  keywords = [],
  ogImage,
  ogType = "website",
  price,
  currency = "GHS",
  availability,
  category,
  publishedTime,
  author,
  noindex = false
}: SEOProps): Metadata {
  const siteName = DEFAULT_SITE_NAME;
  const siteUrl = getSiteUrl();
  const defaultOg = `${siteUrl}/og-image.png`;
  const resolvedOg = ogImage || defaultOg;
  const fullTitle = title.includes(siteName) ? title : `${title} | ${siteName}`;

  const defaultKeywords = [
    "online store",
    "shopping",
    "e-commerce",
  ];

  const allKeywords = [...new Set([...keywords, ...defaultKeywords])];

  const metadata: Metadata = {
    title: fullTitle,
    description,
    keywords: allKeywords.join(', '),
    authors: author ? [{ name: author }] : undefined,
    openGraph: {
      title: fullTitle,
      description,
      images: [{ url: resolvedOg, width: 1200, height: 630, alt: title }],
      type: ogType as any,
      siteName,
      locale: "en_GH",
    },
    twitter: {
      card: "summary_large_image",
      title: fullTitle,
      description,
      images: [resolvedOg]
    },
    robots: noindex ? {
      index: false,
      follow: false
    } : {
      index: true,
      follow: true,
      googleBot: {
        index: true,
        follow: true,
        "max-image-preview": "large",
        "max-snippet": -1,
      },
    },
    alternates: {
      canonical: siteUrl,
    },
  };

  if (ogType === 'article' && publishedTime) {
    metadata.openGraph = {
      ...metadata.openGraph,
      type: "article",
      publishedTime,
    };
  }

  return metadata;
}

export function generateProductSchema(product: {
  name: string;
  description: string;
  image: string;
  price: number;
  currency?: string;
  sku: string;
  rating?: number;
  reviewCount?: number;
  availability?: string;
  brand?: string;
  category?: string;
}) {
  const schema = {
    "@context": "https://schema.org",
    "@type": "Product",
    name: product.name,
    description: product.description,
    image: product.image,
    sku: product.sku,
    brand: {
      "@type": "Brand",
      name: product.brand || DEFAULT_SITE_NAME,
    },
    offers: {
      "@type": "Offer",
      price: product.price,
      priceCurrency: product.currency || "GHS",
      availability:
        product.availability === "in_stock"
          ? "https://schema.org/InStock"
          : "https://schema.org/OutOfStock",
      url: typeof window !== "undefined" ? window.location.href : "",
      priceValidUntil: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
        .toISOString()
        .split("T")[0],
    },
  };

  if (product.rating && product.reviewCount) {
    (schema as any).aggregateRating = {
      "@type": "AggregateRating",
      ratingValue: product.rating,
      reviewCount: product.reviewCount,
      bestRating: 5,
      worstRating: 1
    };
  }

  if (product.category) {
    (schema as any).category = product.category;
  }

  return schema;
}

export function generateBreadcrumbSchema(items: { name: string; url: string }[]) {
  return {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: items.map((item, index) => ({
      "@type": "ListItem",
      position: index + 1,
      name: item.name,
      item: item.url,
    })),
  };
}

export function generateOrganizationSchema() {
  const siteUrl = getSiteUrl();
  const tel = formatGhanaIntlTel(DEFAULT_CONTACT_PHONE);
  const [city] = DEFAULT_CONTACT_ADDRESS.split(",").map((s) => s.trim());
  return {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: DEFAULT_SITE_NAME,
    url: siteUrl,
    logo: `${siteUrl}${DEFAULT_LOGO_PATH}`,
    email: DEFAULT_CONTACT_EMAIL,
    address: {
      "@type": "PostalAddress",
      addressLocality: city || "Accra",
      addressCountry: DEFAULT_COUNTRY_CODE,
    },
    contactPoint: {
      "@type": "ContactPoint",
      telephone: tel,
      contactType: "Customer Service",
      areaServed: DEFAULT_COUNTRY_CODE,
      availableLanguage: ["English"],
    },
    sameAs: [
      getWhatsAppUrl(DEFAULT_CONTACT_PHONE),
      DEFAULT_INSTAGRAM_URL,
      DEFAULT_TIKTOK_URL,
      DEFAULT_SNAPCHAT_URL,
    ],
  };
}

export function generateWebsiteSchema() {
  const siteUrl = getSiteUrl();
  return {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: DEFAULT_SITE_NAME,
    url: siteUrl,
    potentialAction: {
      "@type": "SearchAction",
      target: {
        "@type": "EntryPoint",
        urlTemplate: `${siteUrl}/shop?search={search_term_string}`,
      },
      "query-input": "required name=search_term_string",
    },
  };
}

export function StructuredData({ data }: { data: any }) {
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(data) }}
    />
  );
}
