"use client";

import Link from 'next/link';
import { useState } from 'react';
import { useCMS } from '@/context/CMSContext';
import {
  DEFAULT_CONTACT_PHONE,
  DEFAULT_CONTACT_PHONE_SECONDARY,
  DEFAULT_INSTAGRAM_URL,
  DEFAULT_LOGO_PATH,
  DEFAULT_SITE_NAME,
  DEFAULT_SITE_TAGLINE,
  DEFAULT_SNAPCHAT_URL,
  DEFAULT_TIKTOK_URL,
  formatGhanaIntlTel,
  formatGhanaPhoneDisplay,
  getWhatsAppUrl,
} from '@/lib/site-defaults';

function FooterSection({ title, children }: { title: string, children: React.ReactNode }) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="border-b border-[#BE185D]/30 lg:border-none last:border-0">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="w-full flex items-center justify-between py-4 text-left lg:py-0 lg:cursor-default lg:mb-6"
      >
        <h4 className="font-bold text-lg text-white">{title}</h4>
        <i className={`ri-arrow-down-s-line text-[#FFCC00] text-xl transition-transform duration-300 lg:hidden ${isOpen ? 'rotate-180' : ''}`}></i>
      </button>
      <div className={`overflow-hidden transition-all duration-300 ${isOpen ? 'max-h-96 pb-6' : 'max-h-0 lg:max-h-full lg:overflow-visible'}`}>
        {children}
      </div>
    </div>
  );
}

export default function Footer() {
  const { getSetting } = useCMS();
  const rawSiteName = getSetting("site_name") || "";
  const siteName =
    rawSiteName || DEFAULT_SITE_NAME;
  const siteTagline =
    getSetting("site_tagline") ||
    DEFAULT_SITE_TAGLINE;
  const contactEmail = getSetting('contact_email') || '';
  const contactPhone = getSetting("contact_phone") || DEFAULT_CONTACT_PHONE;
  const whatsappLink = getWhatsAppUrl(contactPhone);
  const whatsappLink2 = getWhatsAppUrl(DEFAULT_CONTACT_PHONE_SECONDARY);

  return (
    <footer className="bg-[#0f172a] text-white rounded-t-[2.5rem] mt-8 lg:mt-0 overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 py-10 lg:py-12">
        <div className="grid lg:grid-cols-4 gap-8 lg:gap-10">

          {/* Brand Column */}
          <div className="lg:col-span-1 space-y-4">
            <Link href="/" className="inline-block">
              <img
                src={DEFAULT_LOGO_PATH}
                alt={siteName}
                className="h-16 w-auto object-contain"
              />
            </Link>
            <p className="text-white/85 leading-relaxed text-sm">
              {siteTagline.replace(/Less\.?$/i, "").trimEnd()}{" "}
              <Link href="/admin" className="text-inherit hover:text-inherit no-underline">Less.</Link>
            </p>

            <div className="flex flex-wrap gap-3 pt-2">
              <a
                href={whatsappLink}
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center text-[#FFCC00] hover:bg-[#FFCC00] hover:text-[#0f172a] transition-all hover:-translate-y-1"
                aria-label="WhatsApp (primary)"
              >
                <i className="ri-whatsapp-line"></i>
              </a>
              <a
                href={whatsappLink2}
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center text-[#FFCC00] hover:bg-[#FFCC00] hover:text-[#0f172a] transition-all hover:-translate-y-1"
                aria-label="WhatsApp (alternate)"
              >
                <i className="ri-whatsapp-line"></i>
              </a>
              <a
                href={DEFAULT_INSTAGRAM_URL}
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center text-[#FFCC00] hover:bg-[#FFCC00] hover:text-[#0f172a] transition-all hover:-translate-y-1"
                aria-label="Instagram"
              >
                <i className="ri-instagram-line"></i>
              </a>
              <a
                href={DEFAULT_TIKTOK_URL}
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center text-[#FFCC00] hover:bg-[#FFCC00] hover:text-[#0f172a] transition-all hover:-translate-y-1"
                aria-label="TikTok"
              >
                <i className="ri-tiktok-line"></i>
              </a>
              <a
                href={DEFAULT_SNAPCHAT_URL}
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center text-[#FFCC00] hover:bg-[#FFCC00] hover:text-[#0f172a] transition-all hover:-translate-y-1"
                aria-label="Snapchat"
              >
                <i className="ri-snapchat-line"></i>
              </a>
            </div>

            <div className="space-y-2 pt-3 border-t border-[#BE185D]/30">
              {contactPhone && (
                <div className="flex flex-col gap-2">
                  <a href={`tel:${formatGhanaIntlTel(contactPhone)}`} className="flex items-center gap-3 text-white/90 hover:text-white transition-colors text-sm">
                    <i className="ri-phone-line"></i> {formatGhanaPhoneDisplay(contactPhone)}
                  </a>
                  <a href={`tel:${formatGhanaIntlTel(DEFAULT_CONTACT_PHONE_SECONDARY)}`} className="flex items-center gap-3 text-white/90 hover:text-white transition-colors text-sm">
                    <i className="ri-phone-line"></i> {formatGhanaPhoneDisplay(DEFAULT_CONTACT_PHONE_SECONDARY)}
                  </a>
                </div>
              )}
              {contactEmail && (
                <a href={`mailto:${contactEmail}`} className="flex items-center gap-3 text-white/90 hover:text-white transition-colors text-sm">
                  <i className="ri-mail-line"></i> {contactEmail}
                </a>
              )}
            </div>
          </div>

          {/* Links Sections */}
          <div className="lg:col-span-3 grid lg:grid-cols-3 gap-6 lg:gap-8">

            <FooterSection title="Shop">
              <ul className="space-y-3 text-white/80">
                <li><Link href="/shop" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> All Products</Link></li>
                <li><Link href="/categories" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Categories</Link></li>
                <li><Link href="/shop?sort=newest" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> New Arrivals</Link></li>
                <li><Link href="/shop?sort=bestsellers" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Best Sellers</Link></li>
              </ul>
            </FooterSection>

            <FooterSection title="Customer Care">
              <ul className="space-y-3 text-white/80">
                <li><Link href="/contact" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Contact Us</Link></li>
                <li><Link href="/order-tracking" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Track My Order</Link></li>
                <li><Link href="/shipping" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Shipping Info</Link></li>
                <li><Link href="/returns" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Returns Policy</Link></li>
              </ul>
            </FooterSection>

            <FooterSection title="Company">
              <ul className="space-y-3 text-white/80">
                <li><Link href="/about" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Our Story</Link></li>
                <li><Link href="/blog" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Blog</Link></li>
                <li><Link href="/privacy" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Privacy Policy</Link></li>
                <li><Link href="/terms" className="hover:text-[#FFCC00] transition-colors flex items-center gap-2"><i className="ri-arrow-right-s-line opacity-50"></i> Terms of Service</Link></li>
              </ul>
            </FooterSection>

          </div>
        </div>

        <div className="border-t border-[#BE185D]/30 mt-8 pt-6 flex flex-col md:flex-row justify-between items-center gap-3 text-xs text-white/80">
          <p>&copy; {new Date().getFullYear()} {siteName}. All rights reserved.</p>
          <div className="flex gap-4 grayscale opacity-50">
            <i className="ri-visa-line text-2xl"></i>
            <i className="ri-mastercard-line text-2xl"></i>
            <i className="ri-paypal-line text-2xl"></i>
          </div>
        </div>
      </div>
    </footer>
  );
}
