
-- ============================================================================
-- 7. ENABLE ROW LEVEL SECURITY
-- ============================================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.store_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wishlist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.review_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.return_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.return_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cms_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.navigation_menus ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.navigation_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.store_modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_memory ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customer_insights ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_ticket_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_knowledge_base ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_canned_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_escalation_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_analytics_daily ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delivery_zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.riders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delivery_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delivery_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contact_submissions ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 8. ROW LEVEL SECURITY POLICIES
-- Matches live database exactly. Uses (select auth.uid()) for performance.
-- Every admin FOR ALL policy has WITH CHECK.
-- ============================================================================

-- â”€â”€ Profiles â”€â”€
CREATE POLICY "profiles_select" ON public.profiles FOR SELECT USING ((select auth.uid()) = id OR is_admin_or_staff());
CREATE POLICY "profiles_insert_own" ON public.profiles FOR INSERT WITH CHECK ((select auth.uid()) = id);
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE USING ((select auth.uid()) = id);
CREATE POLICY "profiles_admin_all" ON public.profiles FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Roles â”€â”€
CREATE POLICY "roles_select" ON public.roles FOR SELECT USING (true);
CREATE POLICY "roles_admin" ON public.roles FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Addresses â”€â”€
CREATE POLICY "addresses_select_own" ON public.addresses FOR SELECT USING ((select auth.uid()) = user_id);
CREATE POLICY "addresses_insert_own" ON public.addresses FOR INSERT WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "addresses_update_own" ON public.addresses FOR UPDATE USING ((select auth.uid()) = user_id);
CREATE POLICY "addresses_delete_own" ON public.addresses FOR DELETE USING ((select auth.uid()) = user_id);
CREATE POLICY "addresses_admin_all" ON public.addresses FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Store Settings â”€â”€
CREATE POLICY "store_settings_select" ON public.store_settings FOR SELECT USING (true);
CREATE POLICY "store_settings_admin" ON public.store_settings FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Site Settings â”€â”€
CREATE POLICY "site_settings_select" ON public.site_settings FOR SELECT USING (true);
CREATE POLICY "site_settings_admin" ON public.site_settings FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Audit Logs â”€â”€
CREATE POLICY "audit_logs_admin" ON public.audit_logs FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());
CREATE POLICY "audit_logs_insert" ON public.audit_logs FOR INSERT WITH CHECK (is_admin_or_staff());

-- â”€â”€ Categories â”€â”€
CREATE POLICY "categories_select" ON public.categories FOR SELECT USING (true);
CREATE POLICY "categories_admin" ON public.categories FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Products â”€â”€
CREATE POLICY "products_select_active" ON public.products FOR SELECT USING (status = 'active'::product_status OR is_admin_or_staff());
CREATE POLICY "products_admin" ON public.products FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Product Images â”€â”€
CREATE POLICY "product_images_select" ON public.product_images FOR SELECT USING (true);
CREATE POLICY "product_images_insert_admin" ON public.product_images FOR INSERT WITH CHECK (is_admin_or_staff());
CREATE POLICY "product_images_update_admin" ON public.product_images FOR UPDATE USING (is_admin_or_staff());
CREATE POLICY "product_images_delete_admin" ON public.product_images FOR DELETE USING (is_admin_or_staff());
CREATE POLICY "product_images_admin" ON public.product_images FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Product Variants â”€â”€
CREATE POLICY "product_variants_select" ON public.product_variants FOR SELECT USING (true);
CREATE POLICY "product_variants_admin" ON public.product_variants FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Coupons â”€â”€
CREATE POLICY "coupons_select_active" ON public.coupons FOR SELECT USING (true);
CREATE POLICY "coupons_admin" ON public.coupons FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Orders â”€â”€
CREATE POLICY "orders_select_own" ON public.orders FOR SELECT USING ((select auth.uid()) = user_id OR user_id IS NULL OR is_admin_or_staff());
CREATE POLICY "orders_insert" ON public.orders FOR INSERT WITH CHECK (((select auth.uid()) IS NOT NULL AND (select auth.uid()) = user_id) OR ((select auth.uid()) IS NULL AND user_id IS NULL));
CREATE POLICY "orders_update_admin" ON public.orders FOR UPDATE USING (is_admin_or_staff());
CREATE POLICY "orders_delete_admin" ON public.orders FOR DELETE USING (is_admin_or_staff());

-- â”€â”€ Order Items â”€â”€
CREATE POLICY "order_items_select" ON public.order_items FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND (orders.user_id = (select auth.uid()) OR orders.user_id IS NULL)) OR is_admin_or_staff());
CREATE POLICY "order_items_insert" ON public.order_items FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND (orders.user_id = (select auth.uid()) OR orders.user_id IS NULL)));
CREATE POLICY "order_items_admin" ON public.order_items FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Order Status History â”€â”€
CREATE POLICY "order_status_history_select" ON public.order_status_history FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_status_history.order_id AND orders.user_id = (select auth.uid())) OR is_admin_or_staff());
CREATE POLICY "order_status_history_admin" ON public.order_status_history FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Cart Items â”€â”€
CREATE POLICY "cart_items_select_own" ON public.cart_items FOR SELECT USING ((select auth.uid()) = user_id);
CREATE POLICY "cart_items_insert_own" ON public.cart_items FOR INSERT WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "cart_items_update_own" ON public.cart_items FOR UPDATE USING ((select auth.uid()) = user_id);
CREATE POLICY "cart_items_delete_own" ON public.cart_items FOR DELETE USING ((select auth.uid()) = user_id);

-- â”€â”€ Wishlist Items â”€â”€
CREATE POLICY "wishlist_items_select_own" ON public.wishlist_items FOR SELECT USING ((select auth.uid()) = user_id);
CREATE POLICY "wishlist_items_insert_own" ON public.wishlist_items FOR INSERT WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "wishlist_items_delete_own" ON public.wishlist_items FOR DELETE USING ((select auth.uid()) = user_id);

-- â”€â”€ Reviews â”€â”€
CREATE POLICY "reviews_select" ON public.reviews FOR SELECT USING (status = 'approved'::review_status OR (select auth.uid()) = user_id OR is_admin_or_staff());
CREATE POLICY "reviews_insert_auth" ON public.reviews FOR INSERT WITH CHECK ((select auth.uid()) IS NOT NULL);
CREATE POLICY "reviews_update_own" ON public.reviews FOR UPDATE USING ((select auth.uid()) = user_id OR is_admin_or_staff());
CREATE POLICY "reviews_admin" ON public.reviews FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Review Images â”€â”€
CREATE POLICY "review_images_select" ON public.review_images FOR SELECT USING (true);
CREATE POLICY "review_images_insert" ON public.review_images FOR INSERT WITH CHECK ((select auth.uid()) IS NOT NULL);
CREATE POLICY "review_images_admin" ON public.review_images FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Blog Posts â”€â”€
CREATE POLICY "blog_posts_select_published" ON public.blog_posts FOR SELECT USING (status = 'published'::blog_status OR is_admin_or_staff());
CREATE POLICY "blog_posts_admin" ON public.blog_posts FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Return Requests â”€â”€
CREATE POLICY "return_requests_select_own" ON public.return_requests FOR SELECT USING ((select auth.uid()) = user_id OR is_admin_or_staff());
CREATE POLICY "return_requests_insert_own" ON public.return_requests FOR INSERT WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "return_requests_admin" ON public.return_requests FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Return Items â”€â”€
CREATE POLICY "return_items_select" ON public.return_items FOR SELECT USING (EXISTS (SELECT 1 FROM return_requests WHERE return_requests.id = return_items.return_request_id AND return_requests.user_id = (select auth.uid())) OR is_admin_or_staff());
CREATE POLICY "return_items_insert" ON public.return_items FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM return_requests WHERE return_requests.id = return_items.return_request_id AND return_requests.user_id = (select auth.uid())));
CREATE POLICY "return_items_admin" ON public.return_items FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Notifications â”€â”€
CREATE POLICY "notifications_select_own" ON public.notifications FOR SELECT USING ((select auth.uid()) = user_id OR is_admin_or_staff());
CREATE POLICY "notifications_update_own" ON public.notifications FOR UPDATE USING ((select auth.uid()) = user_id);
CREATE POLICY "notifications_admin" ON public.notifications FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Pages â”€â”€
CREATE POLICY "pages_select" ON public.pages FOR SELECT USING (true);
CREATE POLICY "pages_admin" ON public.pages FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ CMS Content â”€â”€
CREATE POLICY "cms_content_select" ON public.cms_content FOR SELECT USING (is_active = true);
CREATE POLICY "cms_content_admin" ON public.cms_content FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Banners â”€â”€
CREATE POLICY "banners_select" ON public.banners FOR SELECT USING (is_active = true);
CREATE POLICY "banners_admin" ON public.banners FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Navigation Menus â”€â”€
CREATE POLICY "navigation_menus_select" ON public.navigation_menus FOR SELECT USING (true);
CREATE POLICY "navigation_menus_admin" ON public.navigation_menus FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Navigation Items â”€â”€
CREATE POLICY "navigation_items_select" ON public.navigation_items FOR SELECT USING (is_active = true);
CREATE POLICY "navigation_items_admin" ON public.navigation_items FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Store Modules â”€â”€
CREATE POLICY "store_modules_select" ON public.store_modules FOR SELECT USING (true);
CREATE POLICY "store_modules_admin" ON public.store_modules FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Customers â”€â”€
CREATE POLICY "customers_select_own" ON public.customers FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "customers_insert" ON public.customers FOR INSERT WITH CHECK (is_admin_or_staff());
CREATE POLICY "customers_update" ON public.customers FOR UPDATE USING (is_admin_or_staff());
CREATE POLICY "customers_admin" ON public.customers FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Chat Conversations â”€â”€
CREATE POLICY "chat_conversations_select_own" ON public.chat_conversations FOR SELECT USING ((select auth.uid()) = user_id OR is_admin_or_staff() OR true);
CREATE POLICY "chat_conversations_insert" ON public.chat_conversations FOR INSERT WITH CHECK (true);
CREATE POLICY "chat_conversations_update" ON public.chat_conversations FOR UPDATE USING ((select auth.uid()) = user_id OR user_id IS NULL OR is_admin_or_staff());
CREATE POLICY "chat_conversations_admin" ON public.chat_conversations FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ AI Memory â”€â”€
CREATE POLICY "ai_memory_select" ON public.ai_memory FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "ai_memory_insert" ON public.ai_memory FOR INSERT WITH CHECK (is_admin_or_staff());
CREATE POLICY "ai_memory_admin" ON public.ai_memory FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Customer Insights â”€â”€
CREATE POLICY "customer_insights_select" ON public.customer_insights FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "customer_insights_admin" ON public.customer_insights FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Support Tickets â”€â”€
CREATE POLICY "support_tickets_select" ON public.support_tickets FOR SELECT USING (true);
CREATE POLICY "support_tickets_insert" ON public.support_tickets FOR INSERT WITH CHECK (true);
CREATE POLICY "support_tickets_admin" ON public.support_tickets FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Support Ticket Messages â”€â”€
CREATE POLICY "support_ticket_messages_select" ON public.support_ticket_messages FOR SELECT USING (true);
CREATE POLICY "support_ticket_messages_insert" ON public.support_ticket_messages FOR INSERT WITH CHECK (true);
CREATE POLICY "support_ticket_messages_admin" ON public.support_ticket_messages FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Support Feedback â”€â”€
CREATE POLICY "support_feedback_insert" ON public.support_feedback FOR INSERT WITH CHECK (true);
CREATE POLICY "support_feedback_admin" ON public.support_feedback FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Support Knowledge Base â”€â”€
CREATE POLICY "support_kb_select" ON public.support_knowledge_base FOR SELECT USING (is_published = true);
CREATE POLICY "support_kb_admin" ON public.support_knowledge_base FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Support Canned Responses â”€â”€
CREATE POLICY "support_canned_select" ON public.support_canned_responses FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "support_canned_admin" ON public.support_canned_responses FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Support Escalation Rules â”€â”€
CREATE POLICY "support_escalation_select" ON public.support_escalation_rules FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "support_escalation_admin" ON public.support_escalation_rules FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Support Analytics â”€â”€
CREATE POLICY "support_analytics_select" ON public.support_analytics_daily FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "support_analytics_admin" ON public.support_analytics_daily FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Delivery Zones â”€â”€
CREATE POLICY "delivery_zones_select" ON public.delivery_zones FOR SELECT USING (is_active = true);
CREATE POLICY "delivery_zones_admin" ON public.delivery_zones FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Riders â”€â”€
CREATE POLICY "riders_select" ON public.riders FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "riders_admin" ON public.riders FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Delivery Assignments â”€â”€
CREATE POLICY "delivery_assignments_select" ON public.delivery_assignments FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "delivery_assignments_admin" ON public.delivery_assignments FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- â”€â”€ Delivery Status History â”€â”€
CREATE POLICY "delivery_status_history_select" ON public.delivery_status_history FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "delivery_status_history_admin" ON public.delivery_status_history FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- Contact Submissions
CREATE POLICY "contact_submissions_insert" ON public.contact_submissions FOR INSERT WITH CHECK (true);
CREATE POLICY "contact_submissions_admin" ON public.contact_submissions FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ============================================================================
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
