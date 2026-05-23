/** Valid http(s) image URL from CMS / DB, or null */
export function categoryImageUrl(raw: unknown): string | null {
  if (typeof raw !== 'string') return null;
  const t = raw.trim();
  if (!t || !/^https?:\/\//i.test(t)) return null;
  return t;
}

export type CategoryCoverStyle = {
  chip: string;
  icon: string;
  color: string;
  image: string;
  imagePosition: string;
};

const SUPABASE_STORAGE = 'https://yiasvoohzmqowdqrwcjw.supabase.co/storage/v1/object/public';

export const DEFAULT_CATEGORY_STYLES: CategoryCoverStyle[] = [
  {
    chip: 'Beauty picks',
    icon: 'ri-heart-2-line',
    color: 'from-pink-200 to-[#BE185D]',
    image: `${SUPABASE_STORAGE}/category-images/f9d48530-6dc4-4e40-9c01-dfc1c5b879e8/perfume-set.png`,
    imagePosition: '50% 40%',
  },
  {
    chip: 'Gadget picks',
    icon: 'ri-camera-lens-line',
    color: 'from-rose-100 to-[#BE185D]',
    image: `${SUPABASE_STORAGE}/category-images/7d210b5a-b1cb-4aa8-b781-576afe197be4/karaoke-set.png`,
    imagePosition: '50% 50%',
  },
  {
    chip: 'Lifestyle picks',
    icon: 'ri-home-heart-line',
    color: 'from-fuchsia-200 to-[#9D174D]',
    image: `${SUPABASE_STORAGE}/category-images/fa9b98a0-49bb-453e-bd1a-bb86e8ef0e8d/petal-soap.png`,
    imagePosition: '50% 35%',
  },
  {
    chip: 'Style picks',
    icon: 'ri-handbag-line',
    color: 'from-[#9D174D] to-[#BE185D]',
    image: `${SUPABASE_STORAGE}/category-images/2221463b-952e-445f-a63d-a9e59357f7cc/makeup-brush-cleaner.png`,
    imagePosition: '50% 55%',
  },
];

export const CATEGORY_COVER_BY_SLUG: Record<
  string,
  { image: string; imagePosition: string }
> = {
  'beauty-personal-care': {
    image: `${SUPABASE_STORAGE}/category-images/f9d48530-6dc4-4e40-9c01-dfc1c5b879e8/perfume-set.png`,
    imagePosition: '50% 40%',
  },
  'electronics-gadgets': {
    image: `${SUPABASE_STORAGE}/category-images/7d210b5a-b1cb-4aa8-b781-576afe197be4/karaoke-set.png`,
    imagePosition: '50% 50%',
  },
  'home-lifestyle': {
    image: `${SUPABASE_STORAGE}/category-images/fa9b98a0-49bb-453e-bd1a-bb86e8ef0e8d/petal-soap.png`,
    imagePosition: '50% 35%',
  },
  'fashion-accessories': {
    image: `${SUPABASE_STORAGE}/category-images/2221463b-952e-445f-a63d-a9e59357f7cc/makeup-brush-cleaner.png`,
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
