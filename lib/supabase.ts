import { createHttpClient } from './db/http-client';
import type { LegacySupabaseClient } from './legacy-supabase-type';

export const supabase = createHttpClient() as LegacySupabaseClient;
