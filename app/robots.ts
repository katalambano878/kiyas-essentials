import { MetadataRoute } from 'next';
import { getSiteUrl } from '@/lib/site-defaults';

export default function robots(): MetadataRoute.Robots {
  const baseUrl = getSiteUrl();
  
  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
        disallow: [
          '/admin/',
          '/api/',
          '/checkout',
          '/cart',
          '/account/',
        ],
      },
    ],
    host: baseUrl,
    sitemap: `${baseUrl}/sitemap.xml`,
  };
}
