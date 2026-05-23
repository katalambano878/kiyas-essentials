'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useCart } from '@/context/CartContext';
import { useWishlist } from '@/context/WishlistContext';
import { useState, useEffect, useMemo } from 'react';
import { supabase } from '@/lib/supabase';

export default function MobileBottomNav() {
  const pathname = usePathname();
  const { cartCount } = useCart();
  const { wishlistCount } = useWishlist();
  const [user, setUser] = useState<{ id: string } | null>(null);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      const { data: { session } } = await supabase.auth.getSession();
      if (!cancelled) setUser(session?.user ?? null);
    })();
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_e, session) => {
      if (!cancelled) setUser(session?.user ?? null);
    });
    return () => {
      cancelled = true;
      subscription.unsubscribe();
    };
  }, []);

  const isActive = (path: string) => {
    if (path === '/') return pathname === '/';
    return pathname.startsWith(path);
  };

  const navItems = useMemo(
    () => [
      {
        href: '/',
        label: 'Home',
        iconActive: 'ri-home-5-fill',
        iconInactive: 'ri-home-5-line',
      },
      {
        href: '/shop',
        label: 'Shop',
        iconActive: 'ri-store-3-fill',
        iconInactive: 'ri-store-3-line',
      },
      {
        href: '/cart',
        label: 'Cart',
        iconActive: 'ri-shopping-cart-fill',
        iconInactive: 'ri-shopping-cart-line',
        badge: cartCount,
      },
      {
        href: '/wishlist',
        label: 'Wishlist',
        iconActive: 'ri-heart-3-fill',
        iconInactive: 'ri-heart-3-line',
        badge: wishlistCount,
      },
      {
        href: user ? '/account' : '/auth/login',
        label: 'Account',
        iconActive: user ? 'ri-user-smile-fill' : 'ri-user-3-fill',
        iconInactive: user ? 'ri-user-smile-line' : 'ri-user-3-line',
      },
    ],
    [cartCount, wishlistCount, user]
  );

  return (
    <nav
      className="lg:hidden fixed bottom-0 left-0 right-0 z-[100] pointer-events-none"
      aria-label="Mobile navigation"
    >
      <div className="relative pointer-events-auto">
        <div className="absolute -top-4 left-0 right-0 h-4 bg-gradient-to-t from-white/90 to-transparent pointer-events-none" />

        <div className="bg-white/95 backdrop-blur-xl border-t border-[#BE185D]/10 shadow-[0_-8px_32px_rgba(190,24,93,0.12)]">
          <div className="grid grid-cols-5 gap-0 px-0.5 pt-1 pb-[calc(0.35rem+env(safe-area-inset-bottom,0px))]">
            {navItems.map((item) => {
              const active = isActive(item.href);
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex flex-col items-center justify-center min-w-0 py-1.5 transition-all duration-200 relative group active:scale-95 ${
                    active ? 'text-[#BE185D]' : 'text-gray-400'
                  }`}
                  aria-label={item.label}
                  aria-current={active ? 'page' : undefined}
                >
                  {active && (
                    <div className="absolute top-0 left-1/2 -translate-x-1/2 w-7 h-0.5 rounded-full bg-[#BE185D]" />
                  )}

                  <div className="relative mt-1 flex h-7 w-7 shrink-0 items-center justify-center">
                    <i
                      className={`${active ? item.iconActive : item.iconInactive} text-[20px] transition-transform duration-200 ${
                        active ? 'scale-105' : 'group-hover:scale-105'
                      }`}
                    />

                    {item.badge !== undefined && item.badge > 0 && (
                      <span className="absolute -top-1 -right-1.5 min-w-[16px] h-4 px-0.5 bg-[#BE185D] text-white text-[9px] font-bold rounded-full flex items-center justify-center shadow-sm">
                        {item.badge > 99 ? '99+' : item.badge}
                      </span>
                    )}
                  </div>

                  <span
                    className={`mt-0.5 max-w-full truncate px-0.5 text-[9px] font-semibold leading-tight ${
                      active ? 'text-[#BE185D]' : 'text-gray-500'
                    }`}
                  >
                    {item.label}
                  </span>
                </Link>
              );
            })}
          </div>
        </div>
      </div>
    </nav>
  );
}
