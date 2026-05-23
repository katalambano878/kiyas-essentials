-- 9. GRANTS
-- ============================================================================

-- Storefront (anon + authenticated) read access
GRANT SELECT ON public.products TO anon, authenticated;
GRANT SELECT ON public.categories TO anon, authenticated;
GRANT SELECT ON public.product_images TO anon, authenticated;
GRANT SELECT ON public.product_variants TO anon, authenticated;
GRANT SELECT ON public.store_modules TO anon, authenticated;
GRANT SELECT ON public.banners TO anon, authenticated;
GRANT SELECT ON public.cms_content TO anon, authenticated;
GRANT SELECT ON public.site_settings TO anon, authenticated;
GRANT SELECT ON public.store_settings TO anon, authenticated;
GRANT SELECT ON public.profiles TO anon, authenticated;
GRANT SELECT ON public.roles TO anon, authenticated;
GRANT SELECT ON public.coupons TO anon, authenticated;
GRANT SELECT ON public.pages TO anon, authenticated;
GRANT SELECT ON public.blog_posts TO anon, authenticated;
GRANT SELECT ON public.navigation_menus TO anon, authenticated;
GRANT SELECT ON public.navigation_items TO anon, authenticated;
GRANT SELECT ON public.reviews TO anon, authenticated;
GRANT SELECT ON public.review_images TO anon, authenticated;
GRANT SELECT ON public.delivery_zones TO anon, authenticated;
GRANT SELECT ON public.support_knowledge_base TO anon, authenticated;

-- Guest checkout (anon can insert orders, order items, support, chat)
GRANT SELECT, INSERT ON public.orders TO anon;
GRANT SELECT, INSERT ON public.order_items TO anon;
GRANT SELECT, INSERT ON public.reviews TO anon;
GRANT SELECT, INSERT ON public.support_tickets TO anon;
GRANT SELECT, INSERT ON public.support_ticket_messages TO anon;
GRANT SELECT, INSERT ON public.chat_conversations TO anon;
GRANT INSERT ON public.support_feedback TO anon;

-- Authenticated: full CRUD on all tables (RLS enforces row-level restrictions)
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.roles TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.addresses TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.store_settings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.site_settings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.audit_logs TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.categories TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.products TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.product_images TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.product_variants TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.coupons TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.orders TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.order_items TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.order_status_history TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cart_items TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.wishlist_items TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.reviews TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.review_images TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.blog_posts TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.return_requests TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.return_items TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.notifications TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.pages TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cms_content TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.banners TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.navigation_menus TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.navigation_items TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.store_modules TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.customers TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.chat_conversations TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.ai_memory TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.customer_insights TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_tickets TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_ticket_messages TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_feedback TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_knowledge_base TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_canned_responses TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_escalation_rules TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_analytics_daily TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.delivery_zones TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.riders TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.delivery_assignments TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.delivery_status_history TO authenticated;

-- Service role full access
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;

-- ============================================================================
-- 10. FUNCTION GRANTS
-- ============================================================================

-- Public storefront functions (safe for anon)
GRANT EXECUTE ON FUNCTION public.is_admin_or_staff() TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_storefront_products(text, text, text, integer, integer, numeric, numeric) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.search_products(text, uuid, numeric, numeric, text, text, integer, integer) TO anon, authenticated;

-- Authenticated-only functions
GRANT EXECUTE ON FUNCTION public.mark_order_paid(uuid, text, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.adjust_inventory(uuid, uuid, integer) TO authenticated;
GRANT EXECUTE ON FUNCTION public.generate_order_number() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_dashboard_stats() TO authenticated;

-- Revoke sensitive functions from anon
REVOKE EXECUTE ON FUNCTION public.mark_order_paid(uuid, text, text) FROM anon;
REVOKE EXECUTE ON FUNCTION public.adjust_inventory(uuid, uuid, integer) FROM anon;
REVOKE EXECUTE ON FUNCTION public.get_dashboard_stats() FROM anon;

-- New RPC function grants
GRANT EXECUTE ON FUNCTION public.upsert_customer_from_order(text, text, text, text, text, uuid, jsonb) TO authenticated;
REVOKE EXECUTE ON FUNCTION public.upsert_customer_from_order(text, text, text, text, text, uuid, jsonb) FROM anon;
GRANT EXECUTE ON FUNCTION public.update_customer_stats(text, numeric) TO authenticated;
REVOKE EXECUTE ON FUNCTION public.update_customer_stats(text, numeric) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_order_for_tracking(text, text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.upsert_chat_conversation(text, uuid, jsonb, jsonb) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_chat_conversation(text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.generate_ticket_number() TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_ai_memories(text, uuid) TO authenticated;
REVOKE EXECUTE ON FUNCTION public.get_ai_memories(text, uuid) FROM anon;
GRANT EXECUTE ON FUNCTION public.upsert_customer_insight(uuid, text, text) TO authenticated;
REVOKE EXECUTE ON FUNCTION public.upsert_customer_insight(uuid, text, text) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_support_dashboard_stats() TO authenticated;
REVOKE EXECUTE ON FUNCTION public.get_support_dashboard_stats() FROM anon;
GRANT EXECUTE ON FUNCTION public.search_chat_conversations(text, text, text, integer, integer) TO authenticated;
REVOKE EXECUTE ON FUNCTION public.search_chat_conversations(text, text, text, integer, integer) FROM anon;
GRANT EXECUTE ON FUNCTION public.mark_order_paid(text, text) TO authenticated;
REVOKE EXECUTE ON FUNCTION public.mark_order_paid(text, text) FROM anon;

-- Contact submissions
GRANT INSERT ON public.contact_submissions TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.contact_submissions TO authenticated;
GRANT ALL ON public.contact_submissions TO service_role;

-- ============================================================================
-- 11. STORAGE BUCKETS
-- ============================================================================
INSERT INTO storage.buckets (id, name, public) VALUES ('product-images', 'product-images', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('category-images', 'category-images', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('blog-images', 'blog-images', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('blog-covers', 'blog-covers', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('review-images', 'review-images', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('cms-images', 'cms-images', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('banners', 'banners', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('site-media', 'site-media', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('receipts', 'receipts', false) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 12. STORAGE POLICIES (consolidated, matches live database)
-- ============================================================================

-- Public read for all public buckets
CREATE POLICY "storage_public_read" ON storage.objects FOR SELECT
  USING (bucket_id = ANY (ARRAY['product-images', 'category-images', 'avatars', 'blog-images', 'blog-covers', 'review-images', 'cms-images', 'banners', 'site-media']));

-- Admin insert/update/delete for all managed buckets
CREATE POLICY "storage_admin_insert" ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = ANY (ARRAY['product-images', 'category-images', 'avatars', 'blog-images', 'blog-covers', 'review-images', 'cms-images', 'banners', 'site-media'])
  AND EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('admin', 'staff')));

CREATE POLICY "storage_admin_update" ON storage.objects FOR UPDATE
  USING (bucket_id = ANY (ARRAY['product-images', 'category-images', 'avatars', 'blog-images', 'blog-covers', 'review-images', 'cms-images', 'banners', 'site-media'])
  AND EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('admin', 'staff')));

CREATE POLICY "storage_admin_delete" ON storage.objects FOR DELETE
  USING (bucket_id = ANY (ARRAY['product-images', 'category-images', 'avatars', 'blog-images', 'blog-covers', 'review-images', 'cms-images', 'banners', 'site-media'])
  AND EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('admin', 'staff')));

-- User avatar upload
CREATE POLICY "storage_avatar_insert" ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'avatars' AND auth.uid() IS NOT NULL);

-- Authenticated review image upload
CREATE POLICY "storage_review_images_insert" ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'review-images' AND auth.uid() IS NOT NULL);

-- ============================================================================
-- 13. SEED DATA
-- ============================================================================

-- Default roles
INSERT INTO public.roles (id, name, description, enabled, is_system, permissions) VALUES
  ('admin', 'Administrator', 'Full system access', true, true, '{"dashboard":true,"orders":true,"products":true,"categories":true,"customers":true,"reviews":true,"inventory":true,"analytics":true,"coupons":true,"support":true,"customer_insights":true,"notifications":true,"sms_debugger":true,"blog":true,"delivery":true,"modules":true,"staff":true,"roles":true,"pos":true}'),
  ('staff', 'Staff', 'Limited system access based on permissions', true, true, '{"dashboard":true,"orders":true,"products":true,"categories":true,"customers":true,"reviews":true,"inventory":true,"pos":true}'),
  ('customer', 'Customer', 'Customer access', true, true, '{}')
ON CONFLICT (id) DO NOTHING;

-- Default store modules
INSERT INTO public.store_modules (id, enabled) VALUES
  ('blog', false),
  ('customer-insights', true),
  ('notifications', true)
ON CONFLICT (id) DO NOTHING;

-- Default delivery zones (fees set to 0)
INSERT INTO public.delivery_zones (name, description, regions, base_fee, express_fee, estimated_days, is_active) VALUES
  ('Greater Accra', 'Accra and surrounding areas', ARRAY['Accra', 'Tema', 'Madina', 'Haatso', 'East Legon', 'Spintex', 'Kasoa', 'Ashaiman'], 0, 0, '1-2 days', true),
  ('Kumasi', 'Kumasi and surrounding areas', ARRAY['Kumasi', 'Adum', 'Kejetia', 'Bantama'], 0, 0, '2-4 days', true),
  ('Other Regions', 'All other regions in Ghana', ARRAY['Takoradi', 'Cape Coast', 'Tamale', 'Sunyani', 'Ho', 'Koforidua'], 0, 0, '3-5 days', true),
  ('International', 'Worldwide delivery', ARRAY['International'], 0, 0, '7-14 days', true);

