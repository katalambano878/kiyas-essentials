'use client';

import Image from 'next/image';
import Link from 'next/link';
import { useCMS } from '@/context/CMSContext';
import { usePageTitle } from '@/hooks/usePageTitle';
import AnimatedSection, { AnimatedGrid } from '@/components/AnimatedSection';
import { DEFAULT_SITE_NAME, DEFAULT_SITE_TAGLINE } from '@/lib/site-defaults';

type ValueCard = {
  icon: string;
  title: string;
  body: string;
};

type JourneyStep = {
  label: string;
  title: string;
  body: string;
};

export default function AboutPage() {
  usePageTitle('Our Story');
  const { getSetting } = useCMS();

  const siteName = getSetting('site_name') || DEFAULT_SITE_NAME;

  const valueCards: ValueCard[] = [
    {
      icon: 'ri-eye-line',
      title: 'Transparency first',
      body: "Honest pricing in Ghana Cedis, clear product photos, and no mystery fees at checkout — you always know what you're buying.",
    },
    {
      icon: 'ri-shield-check-line',
      title: 'Thoughtful picks',
      body: 'We focus on girly accessories, daily essentials, creator tools, home decor, tripods, and pieces that fit real routines.',
    },
    {
      icon: 'ri-hand-heart-line',
      title: 'Here when you need us',
      body: 'Reach out on WhatsApp or Instagram for help with orders, restocks, or choosing the right tripod or decor piece.',
    },
  ];

  const journeySteps: JourneyStep[] = [
    {
      label: '01',
      title: 'Browse & discover',
      body: 'Explore collections — from cute accessories and everyday essentials to content gear and home decor.',
    },
    {
      label: '02',
      title: 'Order with confidence',
      body: 'Add to cart, choose delivery in Ghana, and pay the way that works for you (options shown at checkout).',
    },
    {
      label: '03',
      title: 'Enjoy & create',
      body: 'Unbox pieces for your vanity, your space, or your setup — and tag us when you share your content.',
    },
  ];

  return (
    <div className="min-h-screen bg-white text-gray-900">
      <section className="border-b border-brand-carton/15 bg-[#FDF2F8]">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-14 sm:py-16 lg:py-20">
          <div className="grid gap-10 lg:grid-cols-12 lg:items-center">
            <AnimatedSection className="lg:col-span-6" animation="fade-up">
              <p className="text-xs font-semibold tracking-[0.25em] uppercase text-[#BE185D]">
                About {siteName}
              </p>
              <h1 className="mt-3 text-3xl sm:text-4xl lg:text-5xl font-extrabold leading-tight text-gray-900">
                Cute finds for everyday life, your home &amp; your content.
              </h1>
              <p className="mt-5 text-base sm:text-lg text-gray-700 max-w-xl">
                {DEFAULT_SITE_TAGLINE} {siteName} is based in Accra and built
                for shoppers who want girly accessories, practical essentials,
                creator tools like tripods, and decor that makes a space feel
                like theirs — without the overwhelm.
              </p>

              <div className="mt-7 flex flex-wrap gap-3">
                <span className="inline-flex items-center rounded-full bg-white px-4 py-2 text-sm font-medium text-[#BE185D] border border-[#BE185D]/25">
                  <i className="ri-map-pin-line mr-2" /> Based in Accra, Ghana
                </span>
                <span className="inline-flex items-center rounded-full bg-white px-4 py-2 text-sm font-medium text-[#BE185D] border border-[#BE185D]/25">
                  <i className="ri-store-2-line mr-2" /> Accessories · decor · creator gear
                </span>
              </div>

              <div className="mt-8 flex flex-wrap gap-3">
                <Link
                  href="/shop"
                  className="inline-flex items-center rounded-full bg-[#BE185D] px-7 py-3 text-sm font-semibold text-white hover:bg-[#9D174D] transition-colors"
                >
                  Browse products
                  <i className="ri-arrow-right-up-line ml-2" />
                </Link>
                <Link
                  href="/contact"
                  className="inline-flex items-center rounded-full border border-[#BE185D]/35 bg-white px-7 py-3 text-sm font-semibold text-[#BE185D] hover:bg-rose-50 transition-colors"
                >
                  Contact our team
                </Link>
              </div>
            </AnimatedSection>

            <AnimatedSection className="lg:col-span-6" animation="fade-left">
              <div className="grid grid-cols-2 gap-3 sm:gap-4">
                <div className="relative overflow-hidden rounded-2xl aspect-[4/5] border border-brand-carton/15 bg-brand-carton/10">
                  <Image
                    src="/products/perfume-set.png"
                    alt={`${siteName} products`}
                    fill
                    className="object-cover"
                    sizes="(max-width: 1024px) 50vw, 33vw"
                  />
                </div>
                <div className="relative overflow-hidden rounded-2xl aspect-[4/5] border border-brand-carton/15 bg-brand-carton/10 mt-8">
                  <Image
                    src="/products/extra-long-tripod.png"
                    alt={`${siteName} home and lifestyle`}
                    fill
                    className="object-cover"
                    sizes="(max-width: 1024px) 50vw, 33vw"
                  />
                </div>
              </div>
            </AnimatedSection>
          </div>
        </div>
      </section>

      <AnimatedSection className="py-14 sm:py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="max-w-2xl">
            <p className="text-xs font-semibold tracking-[0.25em] uppercase text-[#BE185D]">
              Our core values
            </p>
            <h2 className="mt-2 text-2xl sm:text-3xl font-extrabold text-gray-900">
              Built on trust, styled with heart.
            </h2>
          </div>

          <AnimatedGrid className="mt-8 grid gap-4 md:grid-cols-3" staggerDelay={120}>
            {valueCards.map((item) => (
              <div
                key={item.title}
                className="rounded-2xl border border-brand-carton/15 bg-white p-6 shadow-sm"
              >
                <div className="mb-4 inline-flex h-11 w-11 items-center justify-center rounded-xl bg-[#BE185D] text-white">
                  <i className={`${item.icon} text-xl`} />
                </div>
                <h3 className="text-lg font-semibold text-gray-900">{item.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-gray-600">{item.body}</p>
              </div>
            ))}
          </AnimatedGrid>
        </div>
      </AnimatedSection>

      <section className="bg-white py-14 sm:py-16 border-b border-brand-carton/10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid gap-6 md:grid-cols-2">
            <div className="rounded-2xl border border-brand-carton/15 bg-brand-cream/40 p-6 sm:p-8">
              <div className="mb-4 inline-flex h-11 w-11 items-center justify-center rounded-xl bg-[#BE185D] text-white">
                <i className="ri-lightbulb-line text-xl" />
              </div>
              <p className="text-xs font-semibold tracking-[0.25em] uppercase text-[#BE185D] mb-2">Our Vision</p>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">
                Style that fits real life
              </h3>
              <p className="text-sm leading-relaxed text-gray-600">
                To make girly accessories, everyday essentials, and home touches
                easy to find — so you can feel put-together at home and on camera.
              </p>
            </div>
            <div className="rounded-2xl border border-brand-carton/15 bg-brand-cream/40 p-6 sm:p-8">
              <div className="mb-4 inline-flex h-11 w-11 items-center justify-center rounded-xl bg-[#BE185D] text-white">
                <i className="ri-compass-3-line text-xl" />
              </div>
              <p className="text-xs font-semibold tracking-[0.25em] uppercase text-[#BE185D] mb-2">Our Mission</p>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">
                Your go-to lifestyle shop
              </h3>
              <p className="text-sm leading-relaxed text-gray-600">
                To be the Accra-based shop you trust for accessories, essentials,
                decor, and creator tools — with friendly support and clear
                checkout every time.
              </p>
            </div>
          </div>
        </div>
      </section>

      <section className="bg-[#BE185D]/[0.06] py-14 sm:py-16 border-y border-[#BE185D]/15">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="max-w-2xl">
            <p className="text-xs font-semibold tracking-[0.25em] uppercase text-[#BE185D]">
              How it works
            </p>
            <h2 className="mt-2 text-2xl sm:text-3xl font-extrabold text-gray-900">
              From our shop to your door.
            </h2>
          </div>

          <div className="mt-8 grid gap-4 lg:grid-cols-3">
            {journeySteps.map((step) => (
              <div
                key={step.label}
                className="rounded-2xl border border-[#BE185D]/20 bg-white p-6 shadow-sm"
              >
                <span className="inline-flex rounded-full bg-[#BE185D]/12 px-3 py-1 text-xs font-bold tracking-[0.22em] uppercase text-[#BE185D]">
                  Step {step.label}
                </span>
                <h3 className="mt-3 text-lg font-semibold text-gray-900">{step.title}</h3>
                <p className="mt-2 text-sm text-gray-600 leading-relaxed">{step.body}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="py-14 sm:py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="rounded-3xl bg-[#BE185D] border border-[#9D174D] px-6 py-10 sm:px-10 sm:py-12 text-white text-center shadow-[0_16px_45px_rgba(190,24,93,0.35)]">
            <p className="text-xs font-semibold tracking-[0.25em] uppercase text-white/90">
              Shop with {siteName}
            </p>
            <h2 className="mt-3 text-2xl sm:text-3xl font-extrabold text-white">
              Glam, essentials, decor &amp; gear — in one place.
            </h2>
            <p className="mt-3 text-white/85 max-w-2xl mx-auto">
              Browse girly accessories, daily essentials, content creation tools,
              home decor, tripods, and more. Delivery options for Ghana are shown
              at checkout.
            </p>
            <div className="mt-7 flex flex-wrap items-center justify-center gap-3">
              <Link
                href="/shop"
                className="inline-flex items-center rounded-full bg-white text-[#BE185D] px-7 py-3 text-sm font-semibold shadow-md hover:bg-rose-50 transition-colors"
              >
                Shop now
              </Link>
              <Link
                href="/contact"
                className="inline-flex items-center rounded-full border-2 border-white/70 bg-transparent px-7 py-3 text-sm font-semibold text-white hover:bg-white/15 transition-colors"
              >
                Talk to us
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
