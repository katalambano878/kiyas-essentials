/** Valid http(s) image URL from CMS / DB, or null */
export function categoryImageUrl(raw: unknown): string | null {
  if (typeof raw !== 'string') return null;
  const t = raw.trim();
  if (!t || !/^https?:\/\//i.test(t)) return null;
  // Reject retired hosted-Supabase storage URLs
  if (/\.supabase\.co\//i.test(t)) return null;
  return t;
}

export type CategoryCoverStyle = {
  chip: string;
  icon: string;
  color: string;
  image: string;
  imagePosition: string;
};

/** Local SVG placeholders — no external Supabase storage dependency */
function svgCover(from: string, to: string, label: string): string {
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
    <defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="${from}"/><stop offset="100%" stop-color="${to}"/>
    </linearGradient></defs>
    <rect width="800" height="600" fill="url(#g)"/>
    <text x="400" y="310" text-anchor="middle" fill="rgba(255,255,255,0.85)"
      font-family="Georgia,serif" font-size="42">${label}</text>
  </svg>`;
  return `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}`;
}

export const DEFAULT_CATEGORY_STYLES: CategoryCoverStyle[] = [
  {
    chip: 'Beauty picks',
    icon: 'ri-heart-2-line',
    color: 'from-pink-200 to-[#BE185D]',
    image: svgCover('#FBCFE8', '#BE185D', 'Beauty'),
    imagePosition: '50% 40%',
  },
  {
    chip: 'Gadget picks',
    icon: 'ri-camera-lens-line',
    color: 'from-rose-100 to-[#BE185D]',
    image: svgCover('#FFE4E6', '#BE185D', 'Gadgets'),
    imagePosition: '50% 50%',
  },
  {
    chip: 'Lifestyle picks',
    icon: 'ri-home-heart-line',
    color: 'from-fuchsia-200 to-[#9D174D]',
    image: svgCover('#F5D0FE', '#9D174D', 'Lifestyle'),
    imagePosition: '50% 35%',
  },
  {
    chip: 'Style picks',
    icon: 'ri-handbag-line',
    color: 'from-[#9D174D] to-[#BE185D]',
    image: svgCover('#9D174D', '#BE185D', 'Style'),
    imagePosition: '50% 55%',
  },
];

export const CATEGORY_COVER_BY_SLUG: Record<
  string,
  { image: string; imagePosition: string }
> = {
  'beauty-personal-care': {
    image: DEFAULT_CATEGORY_STYLES[0].image,
    imagePosition: '50% 40%',
  },
  'electronics-gadgets': {
    image: DEFAULT_CATEGORY_STYLES[1].image,
    imagePosition: '50% 50%',
  },
  'home-lifestyle': {
    image: DEFAULT_CATEGORY_STYLES[2].image,
    imagePosition: '50% 35%',
  },
  'fashion-accessories': {
    image: DEFAULT_CATEGORY_STYLES[3].image,
    imagePosition: '50% 55%',
  },
};

/** Card / listing image: DB column, then slug cover, then rotating defaults. */
export function resolveCategoryImage(
  slug: string | null | undefined,
  imageUrl: string | null | undefined,
  index: number
): string {
  const fromDb = categoryImageUrl(imageUrl);
  if (fromDb) return fromDb;
  const key = String(slug || '').toLowerCase();
  const cover = key ? CATEGORY_COVER_BY_SLUG[key] : undefined;
  if (cover?.image) return cover.image;
  return DEFAULT_CATEGORY_STYLES[index % DEFAULT_CATEGORY_STYLES.length].image;
}

export function resolveCategoryImagePosition(
  slug: string | null | undefined,
  index: number,
  metaPosition?: unknown
): string {
  if (typeof metaPosition === 'string' && metaPosition.trim()) {
    return metaPosition.trim();
  }
  const key = String(slug || '').toLowerCase();
  const cover = key ? CATEGORY_COVER_BY_SLUG[key] : undefined;
  if (cover?.imagePosition) return cover.imagePosition;
  return DEFAULT_CATEGORY_STYLES[index % DEFAULT_CATEGORY_STYLES.length]
    .imagePosition;
}
