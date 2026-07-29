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

const GRADIENTS: Array<[string, string]> = [
  ['#FBCFE8', '#BE185D'],
  ['#FFE4E6', '#BE185D'],
  ['#F5D0FE', '#9D174D'],
  ['#9D174D', '#BE185D'],
  ['#FDA4AF', '#BE185D'],
  ['#FFCC00', '#BE185D'],
];

/** Local SVG placeholder labeled with the real category name */
export function svgCover(from: string, to: string, label: string): string {
  const safe = String(label || 'Shop')
    .replace(/[<>&"']/g, '')
    .slice(0, 28);
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
    <defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="${from}"/><stop offset="100%" stop-color="${to}"/>
    </linearGradient></defs>
    <rect width="800" height="600" fill="url(#g)"/>
    <text x="400" y="310" text-anchor="middle" fill="rgba(255,255,255,0.9)"
      font-family="Georgia,serif" font-size="40">${safe}</text>
  </svg>`;
  return `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}`;
}

function placeholderFor(label: string, index: number): string {
  const [from, to] = GRADIENTS[index % GRADIENTS.length];
  return svgCover(from, to, label);
}

export const DEFAULT_CATEGORY_STYLES: CategoryCoverStyle[] = [
  {
    chip: 'Beauty picks',
    icon: 'ri-heart-2-line',
    color: 'from-pink-200 to-[#BE185D]',
    image: placeholderFor('Beauty', 0),
    imagePosition: '50% 40%',
  },
  {
    chip: 'Gadget picks',
    icon: 'ri-camera-lens-line',
    color: 'from-rose-100 to-[#BE185D]',
    image: placeholderFor('Gadgets', 1),
    imagePosition: '50% 50%',
  },
  {
    chip: 'Lifestyle picks',
    icon: 'ri-home-heart-line',
    color: 'from-fuchsia-200 to-[#9D174D]',
    image: placeholderFor('Lifestyle', 2),
    imagePosition: '50% 35%',
  },
  {
    chip: 'Style picks',
    icon: 'ri-handbag-line',
    color: 'from-[#9D174D] to-[#BE185D]',
    image: placeholderFor('Style', 3),
    imagePosition: '50% 55%',
  },
];

export const CATEGORY_COVER_BY_SLUG: Record<
  string,
  { image: string; imagePosition: string }
> = {
  'beauty-personal-care': {
    image: placeholderFor('Beauty', 0),
    imagePosition: '50% 40%',
  },
  'electronics-gadgets': {
    image: placeholderFor('Gadgets', 1),
    imagePosition: '50% 50%',
  },
  'home-lifestyle': {
    image: placeholderFor('Lifestyle', 2),
    imagePosition: '50% 35%',
  },
  'fashion-accessories': {
    image: placeholderFor('Style', 3),
    imagePosition: '50% 55%',
  },
  stationary: {
    image: placeholderFor('Stationary', 4),
    imagePosition: '50% 50%',
  },
};

/** Card / listing image: DB column, then slug cover, then name-based placeholder. */
export function resolveCategoryImage(
  slug: string | null | undefined,
  imageUrl: string | null | undefined,
  index: number,
  name?: string | null
): string {
  const fromDb = categoryImageUrl(imageUrl);
  if (fromDb) return fromDb;
  const key = String(slug || '').toLowerCase();
  const cover = key ? CATEGORY_COVER_BY_SLUG[key] : undefined;
  if (cover?.image) return cover.image;
  const label =
    (name && String(name).trim()) ||
    (slug && String(slug).replace(/-/g, ' ')) ||
    'Shop';
  return placeholderFor(label, index);
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
