'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { supabase } from '@/lib/supabase';
import {
  DEFAULT_CONTACT_EMAIL,
  DEFAULT_CONTACT_PHONE,
  DEFAULT_INSTAGRAM_HANDLE,
  DEFAULT_LOGO_PATH,
  DEFAULT_SITE_NAME,
  DEFAULT_SITE_TAGLINE,
  DEFAULT_CONTACT_ADDRESS,
} from '@/lib/site-defaults';

interface SiteSettings {
    site_name: string;
    site_tagline: string;
    site_logo: string;
    contact_email: string;
    contact_phone: string;
    contact_address: string;
    social_facebook: string;
    social_instagram: string;
    social_twitter: string;
    primary_color: string;
    secondary_color: string;
    currency: string;
    currency_symbol: string;
    [key: string]: string;
}

interface CMSContent {
    id: string;
    section: string;
    block_key: string;
    title: string | null;
    subtitle: string | null;
    content: string | null;
    image_url: string | null;
    button_text: string | null;
    button_url: string | null;
    metadata: Record<string, any>;
    is_active: boolean;
}

interface Banner {
    id: string;
    name: string;
    type: string;
    title: string | null;
    subtitle: string | null;
    image_url: string | null;
    background_color: string;
    text_color: string;
    button_text: string | null;
    button_url: string | null;
    is_active: boolean;
    position: string;
    start_date: string | null;
    end_date: string | null;
}

interface CMSContextType {
    settings: SiteSettings;
    content: CMSContent[];
    banners: Banner[];
    loading: boolean;
    getContent: (section: string, blockKey: string) => CMSContent | undefined;
    getSetting: (key: string) => string;
    getActiveBanners: (position?: string) => Banner[];
    refreshCMS: () => Promise<void>;
}

const defaultSettings: SiteSettings = {
    site_name: DEFAULT_SITE_NAME,
    site_tagline: DEFAULT_SITE_TAGLINE,
    site_logo: DEFAULT_LOGO_PATH,
    contact_email: DEFAULT_CONTACT_EMAIL,
    contact_phone: DEFAULT_CONTACT_PHONE,
    contact_address: DEFAULT_CONTACT_ADDRESS,
    social_facebook: '',
    social_instagram: DEFAULT_INSTAGRAM_HANDLE,
    social_twitter: '',
    primary_color: '#2C1D00',
    secondary_color: '#AB9462',
    currency: 'GHS',
    currency_symbol: 'GH₵',
};

const CMSContext = createContext<CMSContextType>({
    settings: defaultSettings,
    content: [],
    banners: [],
    loading: true,
    getContent: () => undefined,
    getSetting: () => '',
    getActiveBanners: () => [],
    refreshCMS: async () => { },
});

export function CMSProvider({ children }: { children: ReactNode }) {
    const [settings, setSettings] = useState<SiteSettings>({
        site_name: DEFAULT_SITE_NAME,
        site_tagline: DEFAULT_SITE_TAGLINE,
        site_logo: DEFAULT_LOGO_PATH,
        contact_email: DEFAULT_CONTACT_EMAIL,
        contact_phone: DEFAULT_CONTACT_PHONE,
        contact_address: DEFAULT_CONTACT_ADDRESS,
        social_facebook: '',
        social_instagram: DEFAULT_INSTAGRAM_HANDLE,
        social_twitter: '',
        primary_color: '#FBF6F2',
        secondary_color: '#A14F57',
        currency: 'GHS',
        currency_symbol: 'GH₵',
    });
    const [content, setContent] = useState<CMSContent[]>([]);
    const [banners, setBanners] = useState<Banner[]>([]);
    const [loading, setLoading] = useState(false);

    // CMS Fetching Logic Removed - Content is now managed in code.
    const fetchCMSData = async () => { };

    // Initial load handled by state defaults
    useEffect(() => {
    }, []);

    const getContent = (section: string, blockKey: string): CMSContent | undefined => {
        return content.find(c => c.section === section && c.block_key === blockKey);
    };

    const getSetting = (key: string): string => {
        return settings[key] || defaultSettings[key] || '';
    };

    const getActiveBanners = (position?: string): Banner[] => {
        const now = new Date();
        return banners.filter(b => {
            if (position && b.position !== position) return false;
            if (b.start_date && new Date(b.start_date) > now) return false;
            if (b.end_date && new Date(b.end_date) < now) return false;
            return b.is_active;
        });
    };

    return (
        <CMSContext.Provider
            value={{
                settings,
                content,
                banners,
                loading,
                getContent,
                getSetting,
                getActiveBanners,
                refreshCMS: fetchCMSData,
            }}
        >
            {children}
        </CMSContext.Provider>
    );
}

export function useCMS() {
    const context = useContext(CMSContext);
    if (!context) {
        throw new Error('useCMS must be used within a CMSProvider');
    }
    return context;
}

export default CMSContext;
