import { isPlainPostgres } from './db/mode';
import { createClient as createPgClient } from './db/supabase-compat';

/**
 * Server-side admin client (plain Postgres compat only).
 * ONLY use in API routes / server actions — never in client components.
 */

function createAdminClient() {
  if (!isPlainPostgres()) {
    throw new Error(
      'Plain Postgres mode required: set DATABASE_URL (or POSTGRES_URL) for server-side supabaseAdmin.'
    );
  }
  return createPgClient();
}

export const supabaseAdmin: ReturnType<typeof createPgClient> = createAdminClient();
