'use client';
import { money } from '@/lib/format-money';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { supabase } from '@/lib/supabase';
import { useCMS } from '@/context/CMSContext';
import ProductCard, {
  type ColorVariant,
  getColorHex,
} from '@/components/ProductCard';
import AnimatedSection, { AnimatedGrid } from '@/components/AnimatedSection';
import { usePageTitle } from '@/hooks/usePageTitle';
import {
  DEFAULT_CONTACT_PHONE,
  DEFAULT_SITE_NAME,
  DEFAULT_SITE_TAGLINE,
} from '@/lib/site-defaults';
import {
  categoryImageUrl,
  CATEGORY_COVER_BY_SLUG,
  DEFAULT_CATEGORY_STYLES,
} from '@/lib/category-covers';

export default function Home() {
  usePageTitle('');
  const { getSetting, getActiveBanners } = useCMS();
  const [featuredProducts, setFeaturedProducts] = useState<any[]>([]);
  const [featuredCategories, setFeaturedCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const heroSlides = [
    { src: '/products/perfume-set.png', position: '50% 40%' },
    { src: '/products/makeup-brush-cleaner.png', position: '50% 35%' },
    { src: '/products/karaoke-set.png', position: '50% 45%' },
  ];
  const [currentHeroSlide, setCurrentHeroSlide] = useState(0);

  useEffect(() => {
    async function fetchData() {
      try {
        // Fetch independently so a category filter failure never blanks products
        const productsPromise = supabase
          .from('products')
          .select('*, product_variants(*), product_images(*)')
          .eq('status', 'active')
          .order('created_at', { ascending: false })
          .limit(12);

        const categoriesPromise = supabase
          .from('categories')
          .select('id, name, slug, parent_id, position, metadata, image_url')
          .eq('status', 'active')
          .is('parent_id', null)
          .order('position', { ascending: true })
          .limit(12);

        const [productsResult, categoriesResult] = await Promise.all([
          productsPromise,
          categoriesPromise,
        ]);

        if (productsResult.error) {
          console.error('Error fetching products:', productsResult.error);
        } else {
          setFeaturedProducts(productsResult.data || []);
        }

        if (categoriesResult.error) {
          console.error('Error fetching categories:', categoriesResult.error);
        } else {
          const rows = categoriesResult.data || [];
          const featured = rows.filter(
            (c: any) => c?.metadata?.featured === true || c?.metadata?.featured === 'true'
          );
          setFeaturedCategories((featured.length > 0 ? featured : rows).slice(0, 4));
        }
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoading(false);
      }
    }

    fetchData();
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentHeroSlide((prev) => (prev + 1) % heroSlides.length);
    }, 5000);

    return () => clearInterval(interval);
  }, [heroSlides.length]);

  const siteName = getSetting('site_name') || DEFAULT_SITE_NAME;
  const contactPhone = getSetting('contact_phone') || DEFAULT_CONTACT_PHONE;
  const phoneDisplay = `${contactPhone.slice(0, 3)} ${contactPhone.slice(3, 7)} ${contactPhone.slice(7)}`;

  const heroHeadline =
    getSetting('hero_headline') ||
    'Girly accessories, essentials & creator-ready finds';
  const heroSubheadline =
    getSetting('hero_subheadline') || DEFAULT_SITE_TAGLINE;
  const heroPrimaryText = getSetting('hero_primary_btn_text') || 'Shop Now';
  const heroPrimaryLink = getSetting('hero_primary_btn_link') || '/shop';
  const heroSecondaryText =
    getSetting('hero_secondary_btn_text') || 'Browse Collections';
  const heroSecondaryLink = getSetting('hero_secondary_btn_link') || '/shop';

  const activeBanners = getActiveBanners('top');

  const renderBanners = () => {
    if (activeBanners.length === 0) return null;
    return (
      <div className="bg-brand-brown text-white py-2 overflow-hidden relative">
        <div className="flex animate-marquee whitespace-nowrap">
          {activeBanners.concat(activeBanners).map((banner, index) => (
            <span
              key={index}
              className="mx-8 text-sm font-medium tracking-wide flex items-center"
            >
              {banner.title}
            </span>
          ))}
        </div>
      </div>
    );
  };

  const popularProducts = featuredProducts.slice(0, 6);
  const latestProducts = featuredProducts;
  const defaultCategoryStyles = DEFAULT_CATEGORY_STYLES;
  const categoryCoverBySlug = CATEGORY_COVER_BY_SLUG;
  const fallbackCategories = [
    { name: 'Beauty & Personal Care', slug: 'beauty-personal-care', metadata: {} },
    { name: 'Electronics & Gadgets', slug: 'electronics-gadgets', metadata: {} },
    {
      name: 'Home & Lifestyle',
      slug: 'home-lifestyle',
      metadata: {},
    },
    { name: 'Fashion & Accessories', slug: 'fashion-accessories', metadata: {} },
  ];
  const vibeCategories = (featuredCategories.length > 0
    ? featuredCategories
    : fallbackCategories
  )
    .slice(0, 4)
    .map((category, index) => {
      const style = defaultCategoryStyles[index % defaultCategoryStyles.length];
      const slugKey = String(category.slug || '').toLowerCase();
      const cover = slugKey ? categoryCoverBySlug[slugKey] : undefined;
      const metaImage =
        categoryImageUrl(category.image_url) ||
        categoryImageUrl(category.metadata?.image) ||
        categoryImageUrl(category.metadata?.cover_image);
      return {
        ...category,
        chip: category.metadata?.chip || style.chip,
        icon: category.metadata?.icon || style.icon,
        color: category.metadata?.color || style.color,
        image: metaImage || cover?.image || style.image,
        imagePosition:
          category.metadata?.image_position ||
          category.metadata?.imagePosition ||
          cover?.imagePosition ||
          style.imagePosition,
      };
    });

  return (
    <main className="flex-col items-center justify-between min-h-screen bg-white">
      {renderBanners()}

      <section className="relative w-full min-h-[85vh] lg:min-h-[95vh] flex flex-col justify-center overflow-hidden bg-[#0f172a]">
        {/* Background Slider with Ken Burns effect */}
        <div className="absolute inset-0">
          {heroSlides.map((slide, index) => (
            <div
              key={slide.src}
              className={`absolute inset-0 transition-all duration-[2000ms] ease-in-out ${
                index === currentHeroSlide ? 'opacity-100 scale-100' : 'opacity-0 scale-105'
              }`}
            >
              <Image
                src={slide.src}
                alt=""
                fill
                priority={index === 0}
                quality={100}
                unoptimized
                sizes="100vw"
                className="object-cover"
                style={{
                  objectPosition: slide.position,
                }}
              />
              {/* Advanced Gradient Overlay */}
              <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-black/20 to-[#0f172a]/90" />
              <div className="absolute inset-0 bg-gradient-to-r from-black/50 via-transparent to-black/50" />
            </div>
          ))}
        </div>

        {/* Main Content */}
        <div className="relative z-10 w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-32 flex flex-col items-center text-center lg:items-start lg:text-left">
          {/* Pill */}
          <div className="scroll-animate is-visible" style={{ transitionDelay: '100ms' }}>
            <span className="inline-flex items-center gap-2 rounded-full bg-white/10 backdrop-blur-md border border-white/20 px-4 py-2 text-xs font-bold uppercase tracking-[0.2em] text-white shadow-xl">
              <span className="w-2 h-2 rounded-full bg-[#BE185D] animate-pulse" />
              {siteName}
              <span className="hidden sm:inline"> · Exclusive</span>
            </span>
          </div>

          {/* Headline */}
          <h1 className="mt-6 text-3xl sm:text-4xl md:text-5xl lg:text-6xl font-extrabold leading-tight tracking-tight text-white drop-shadow-2xl max-w-3xl scroll-animate is-visible" style={{ transitionDelay: '200ms' }}>
            {heroHeadline}
          </h1>

          {/* Subheadline */}
          <p className="mt-4 text-sm sm:text-base md:text-lg text-gray-300 max-w-xl font-medium leading-relaxed scroll-animate is-visible" style={{ transitionDelay: '300ms' }}>
            {heroSubheadline}
          </p>

          {/* Buttons */}
          <div className="mt-8 flex flex-col sm:flex-row items-center gap-3 w-full sm:w-auto scroll-animate is-visible" style={{ transitionDelay: '400ms' }}>
            <Link
              href={heroPrimaryLink}
              className="group relative flex w-full sm:w-auto items-center justify-center gap-2.5 rounded-full bg-[#BE185D] px-7 py-3.5 text-sm sm:text-base font-bold text-white transition-all duration-300 hover:bg-[#9D174D] hover:shadow-[0_0_30px_rgba(190,24,93,0.4)] hover:-translate-y-1"
            >
              <span>{heroPrimaryText}</span>
              <i className="ri-arrow-right-up-line text-lg sm:text-xl transition-transform duration-300 group-hover:rotate-45 group-hover:scale-110" />
            </Link>
            <Link
              href={heroSecondaryLink}
              className="group w-full sm:w-auto inline-flex items-center justify-center rounded-full border border-white/30 bg-white/5 backdrop-blur-md px-7 py-3.5 text-sm sm:text-base font-bold text-white transition-all duration-300 hover:bg-white/20 hover:border-white/50"
            >
              {heroSecondaryText}
            </Link>
          </div>
        </div>

        {/* Floating Glass Bar at Bottom */}
        <div className="absolute bottom-0 left-0 right-0 z-20 w-full bg-gradient-to-t from-[#0f172a] to-transparent pt-12 pb-6 px-4">
          <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6">
            {/* Trust Badges — hidden on mobile */}
            <div className="hidden md:flex flex-wrap items-center justify-start gap-10">
              <div className="flex items-center gap-3 text-white/80 group">
                <div className="flex h-10 w-10 items-center justify-center rounded-full bg-white/10 backdrop-blur-md border border-white/10 transition-colors group-hover:bg-[#BE185D]/20 group-hover:border-[#BE185D]/50">
                  <i className="ri-shield-star-line text-lg text-[#BE185D]" />
                </div>
                <span className="text-sm font-semibold tracking-wide">Premium Quality</span>
              </div>
              <div className="flex items-center gap-3 text-white/80 group">
                <div className="flex h-10 w-10 items-center justify-center rounded-full bg-white/10 backdrop-blur-md border border-white/10 transition-colors group-hover:bg-[#BE185D]/20 group-hover:border-[#BE185D]/50">
                  <i className="ri-camera-lens-line text-lg text-[#BE185D]" />
                </div>
                <span className="text-sm font-semibold tracking-wide">Creator &amp; home picks</span>
              </div>
            </div>

            {/* Slider Controls */}
            <div className="flex items-center gap-3">
              {heroSlides.map((slide, index) => (
                <button
                  key={`dot-${slide.src}`}
                  onClick={() => setCurrentHeroSlide(index)}
                  className={`h-1.5 rounded-full transition-all duration-500 ${
                    index === currentHeroSlide ? 'w-8 bg-[#BE185D]' : 'w-2 bg-white/30 hover:bg-white/60'
                  }`}
                  aria-label={`Go to slide ${index + 1}`}
                />
              ))}
            </div>
          </div>
        </div>
      </section>

      <AnimatedSection className="bg-white py-12 sm:py-20 border-b border-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-6 mb-10 sm:mb-14">
            <div>
              <p className="text-xs font-bold tracking-[0.25em] text-[#BE185D] uppercase mb-2">
                Curated Collections
              </p>
              <h2 className="text-3xl sm:text-4xl font-black tracking-tight text-gray-900">
                Shop by category
              </h2>
            </div>
            <Link
              href="/shop"
              className="group inline-flex items-center gap-2 rounded-full bg-gray-50 px-5 py-2.5 text-sm font-bold text-gray-900 transition-all hover:bg-[#BE185D] hover:text-white hover:shadow-lg hover:shadow-[#BE185D]/20"
            >
              <span>Browse full catalogue</span>
              <i className="ri-arrow-right-line transition-transform group-hover:translate-x-1" />
            </Link>
          </div>

          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-5 lg:grid-cols-4">
            {vibeCategories.map((item) => (
              <Link
                key={item.slug}
                href={`/shop?category=${encodeURIComponent(item.slug)}`}
                className="group relative flex flex-col overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-sm transition-all duration-500 hover:-translate-y-0.5 hover:border-[#BE185D]/25 hover:shadow-[0_16px_36px_-12px_rgba(190,24,93,0.2)]"
              >
                <div
                  className={`pointer-events-none absolute -right-16 -top-16 h-48 w-48 rounded-full bg-gradient-to-br ${item.color} opacity-0 blur-3xl transition-all duration-700 group-hover:opacity-[0.18] group-hover:scale-125`}
                />

                <div className="relative aspect-[5/4] w-full overflow-hidden sm:aspect-[4/3]">
                  <Image
                    src={item.image}
                    alt={item.name}
                    fill
                    unoptimized
                    sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 25vw"
                    className="object-cover transition-transform duration-700 ease-out group-hover:scale-105"
                    style={{ objectPosition: item.imagePosition }}
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/55 via-black/10 to-transparent" />
                  <div className="absolute left-3 top-3 sm:left-3.5 sm:top-3.5">
                    <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-white/95 text-[#BE185D] shadow-md backdrop-blur-sm transition-transform duration-500 group-hover:scale-105 group-hover:-rotate-3">
                      <i className={`${item.icon} text-lg`} />
                    </span>
                  </div>
                  <div className="absolute bottom-3 left-3 right-3 sm:bottom-3.5 sm:left-3.5 sm:right-3.5">
                    <span className="inline-flex max-w-full items-center rounded-full bg-white/90 px-2.5 py-1 text-[9px] font-bold uppercase tracking-[0.12em] text-[#BE185D] shadow-sm backdrop-blur-sm sm:text-[10px]">
                      <span className="truncate">{item.chip}</span>
                    </span>
                  </div>
                </div>

                <div className="relative z-10 flex items-center justify-between gap-3 px-4 py-3.5 sm:px-4 sm:py-4">
                  <h3 className="min-w-0 flex-1 text-base font-bold leading-snug tracking-tight text-gray-900 transition-colors duration-300 group-hover:text-[#BE185D] sm:text-lg">
                    {item.name}
                  </h3>
                  <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-[#BE185D]/10 text-[#BE185D] transition-all duration-300 group-hover:bg-[#BE185D] group-hover:text-white group-hover:shadow-md">
                    <i className="ri-arrow-right-line text-lg" />
                  </span>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </AnimatedSection>

      <AnimatedSection className="bg-white py-10 sm:py-14">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-4 mb-8">
            <div>
              <p className="text-xs font-semibold tracking-[0.25em] text-brand-carton uppercase">
                Trending now
              </p>
              <h2 className="mt-1 text-2xl sm:text-3xl font-extrabold text-gray-900">
                Products customers love most
              </h2>
            </div>
            <Link
              href="/shop?sort=bestsellers"
              className="inline-flex items-center text-sm font-medium text-gray-800 hover:text-[#BE185D]"
            >
              View bestselling products
              <i className="ri-arrow-right-line ml-1" />
            </Link>
          </div>

          {loading ? (
            <div className="grid grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-6">
              {[...Array(3)].map((_, i) => (
                <div key={i} className="animate-pulse">
                  <div className="bg-gray-200 aspect-[4/5] rounded-2xl mb-4" />
                  <div className="h-4 bg-gray-200 rounded w-3/4 mb-2" />
                  <div className="h-4 bg-gray-200 rounded w-1/2" />
                </div>
              ))}
            </div>
          ) : (
            <AnimatedGrid className="grid grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-6">
              {popularProducts.map((product) => {
                const variants = product.product_variants || [];
                const hasVariants = variants.length > 0;
                const minVariantPrice = hasVariants
                  ? Math.min(
                      ...variants.map((v: any) => v.price || product.price)
                    )
                  : undefined;
                const totalVariantStock = hasVariants
                  ? variants.reduce(
                      (sum: number, v: any) => sum + (v.quantity || 0),
                      0
                    )
                  : 0;
                const effectiveStock = hasVariants
                  ? totalVariantStock
                  : product.quantity;

                const colorVariants: ColorVariant[] = [];
                const seenColors = new Set<string>();
                for (const v of variants) {
                  const colorName = (v as any).option2;
                  if (
                    colorName &&
                    !seenColors.has(colorName.toLowerCase().trim())
                  ) {
                    const hex = getColorHex(colorName);
                    if (hex) {
                      seenColors.add(colorName.toLowerCase().trim());
                      colorVariants.push({ name: colorName.trim(), hex });
                    }
                  }
                }

                return (
                  <ProductCard
                    key={product.id}
                    id={product.id}
                    slug={product.slug}
                    name={product.name}
                    price={product.price}
                    originalPrice={product.compare_at_price}
                    image={
                      product.product_images?.[0]?.url ||
                      'https://via.placeholder.com/400x500'
                    }
                    rating={product.rating_avg || 5}
                    reviewCount={product.review_count || 0}
                    badge={product.featured ? 'Featured' : 'Trending'}
                    inStock={effectiveStock > 0}
                    maxStock={effectiveStock || 50}
                    moq={product.moq || 1}
                    hasVariants={hasVariants}
                    minVariantPrice={minVariantPrice}
                    colorVariants={colorVariants}
                  />
                );
              })}
            </AnimatedGrid>
          )}
        </div>
      </AnimatedSection>

      <AnimatedSection className="bg-brand-cream/55 py-10 sm:py-14">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-4 mb-6">
            <div>
              <p className="text-xs font-semibold tracking-[0.25em] text-[#BE185D] uppercase">
                Just landed
              </p>
              <h2 className="mt-1 text-2xl sm:text-3xl font-extrabold text-[#BE185D]">
                Fresh arrivals & restocks
              </h2>
            </div>
            <p className="text-sm text-[#BE185D]/85 max-w-md">
              New drops across girly accessories, daily essentials, creator
              gear (including tripods), home decor, and more — picked with you
              in mind.
            </p>
          </div>

          <div className="just-landed-viewport relative overflow-hidden">
            <div className="flex gap-4 animate-just-landed-scroll pb-2 [--card-width:240px] hover:[animation-play-state:paused]">
              {[...(latestProducts.length ? latestProducts : popularProducts), ...(latestProducts.length ? latestProducts : popularProducts)].map(
                (product, index) => (
                  <div
                    key={`${product.id}-${index}`}
                    className="min-w-[180px] sm:min-w-[220px] max-w-[260px] w-[var(--card-width)] flex-shrink-0 rounded-xl sm:rounded-2xl bg-white shadow-sm hover:shadow-md transition-shadow"
                  >
                    <div className="relative aspect-[4/5] rounded-xl sm:rounded-2xl overflow-hidden bg-brand-carton/10">
                      <Image
                        src={
                          product.product_images?.[0]?.url ||
                          'https://via.placeholder.com/400x500'
                        }
                        alt={product.name}
                        fill
                        className="object-cover"
                      />
                    </div>
                    <div className="p-3">
                      <p className="text-xs uppercase tracking-wide text-brand-carton mb-1">
                        New drop
                      </p>
                      <p className="text-sm font-semibold text-gray-900 line-clamp-2">
                        {product.name}
                      </p>
                      <div className="mt-2 flex items-center justify-between">
                        <span className="text-sm font-bold text-gray-900">
                          {`GH₵${money(Number(product.price || 0))}`}
                        </span>
                        <Link
                          href={`/product/${product.slug}`}
                          className="inline-flex h-8 w-8 items-center justify-center rounded-full bg-[#BE185D] text-white hover:bg-[#9D174D] text-sm"
                        >
                          <i className="ri-arrow-right-line" />
                        </Link>
                      </div>
                    </div>
                  </div>
                )
              )}
            </div>
          </div>
        </div>
      </AnimatedSection>

      <AnimatedSection className="bg-white py-10 sm:py-14">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-2xl mx-auto mb-8 sm:mb-10">
              <p className="text-xs font-semibold tracking-[0.25em] text-[#BE185D] uppercase">
              Why customers stay with us
            </p>
            <h2 className="mt-2 text-2xl sm:text-3xl font-extrabold text-gray-900">
              Made for your routine, your space &amp; your content
            </h2>
            <p className="mt-3 text-sm sm:text-base text-gray-600">
              {siteName} brings together girly accessories, everyday essentials,
              content-creation tools, home decor, tripods, and more — so you can
              shop cute, practical pieces in one place, with support from our
              Accra-based team.
            </p>
          </div>

          <div className="grid gap-4 sm:gap-6 grid-cols-1 md:grid-cols-3">
            {[
              {
                icon: 'ri-shield-check-line',
                title: 'Quality you can trust',
                body: 'We focus on pieces you will actually use — from glam extras and daily essentials to decor and creator gear.',
              },
              {
                icon: 'ri-customer-service-2-line',
                title: 'Real people, real help',
                body: 'Message us on WhatsApp or Instagram for sizing, restocks, or help choosing tripods, decor, and accessories.',
              },
              {
                icon: 'ri-money-dollar-circle-line',
                title: 'Fair, clear pricing',
                body: 'Straightforward Ghana Cedi prices at checkout — no guesswork on what you are paying.',
              },
            ].map((item) => (
              <div
                key={item.title}
                className="relative overflow-hidden rounded-2xl border border-[#BE185D]/15 bg-brand-cream/40 p-6"
              >
                <div className="absolute -right-6 -top-6 h-20 w-20 rounded-full bg-[#BE185D]/20 blur-2xl pointer-events-none" />
                <div className="relative">
                  <div className="mb-4 inline-flex h-10 w-10 items-center justify-center rounded-xl bg-[#BE185D] text-white shadow-md">
                    <i className={`${item.icon} text-xl`} />
                  </div>
                  <h3 className="text-base font-semibold text-gray-900 mb-2">
                    {item.title}
                  </h3>
                  <p className="text-sm text-gray-600 leading-relaxed">
                    {item.body}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </AnimatedSection>

      <section className="pb-12 sm:pb-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="relative overflow-hidden rounded-2xl sm:rounded-3xl bg-[#BE185D] text-white border border-[#BE185D] shadow-[0_16px_45px_rgba(190,24,93,0.35)] flex flex-col md:flex-row items-center md:items-stretch">
            <div className="relative w-full md:w-3/5 px-5 sm:px-8 py-8 sm:py-10 flex flex-col justify-center space-y-3 text-center md:text-left">
              <span className="inline-flex items-center text-xs font-semibold tracking-[0.25em] uppercase text-[#F3F3F3]">
                Start shopping with {siteName}
              </span>
              <h3 className="text-xl sm:text-2xl md:text-3xl lg:text-4xl font-extrabold">
                Cute, useful &amp; creator-ready — without the fuss.
              </h3>
              <p className="text-sm sm:text-base text-[#F3F3F3]/80 max-w-md mx-auto md:mx-0">
                Shop girly accessories, daily essentials, content tools, home decor,
                tripods, and more. Based in Accra — delivery options shown at
                checkout.
              </p>
              <div className="pt-2 flex flex-wrap gap-3 justify-center md:justify-start">
                <Link
                  href="/shop"
                  className="inline-flex items-center rounded-full bg-white text-[#BE185D] px-8 py-3 text-sm font-semibold shadow-lg hover:bg-rose-50 transition-colors"
                >
                  Start shopping
                  <i className="ri-arrow-right-up-line ml-2" />
                </Link>
                <Link
                  href="/account"
                  className="inline-flex items-center rounded-full border border-white/30 bg-white/10 px-6 py-3 text-sm font-semibold text-white hover:bg-white/20 transition-colors"
                >
                  Create an account
                </Link>
              </div>
            </div>
            <div className="relative w-full md:w-2/5 py-4 sm:py-6 pr-4 pl-4 md:pl-0 flex justify-center">
              <div className="relative h-40 sm:h-52 md:h-64 lg:h-full min-h-[12rem] w-full max-w-sm md:max-w-none overflow-hidden rounded-2xl border border-white/25 p-5 shadow-[0_22px_45px_rgba(0,0,0,0.2)]">
                <Image
                  src="/products/petal-soap.png"
                  alt=""
                  fill
                  unoptimized
                  className="object-cover"
                  sizes="(max-width: 768px) 90vw, 40vw"
                />
                <div className="absolute inset-0 bg-[#9D174D]/20" />
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
  );
}
