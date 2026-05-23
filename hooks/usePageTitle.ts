'use client';

import { useEffect } from 'react';
import { DEFAULT_SITE_NAME } from '@/lib/site-defaults';

export function usePageTitle(title: string) {
  useEffect(() => {
    document.title = title
      ? `${title} | ${DEFAULT_SITE_NAME}`
      : `${DEFAULT_SITE_NAME} | Online Store`;
  }, [title]);
}
