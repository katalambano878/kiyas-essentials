-- 6. TRIGGERS
-- ============================================================================

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_addresses_updated_at BEFORE UPDATE ON public.addresses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_product_variants_updated_at BEFORE UPDATE ON public.product_variants FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_coupons_updated_at BEFORE UPDATE ON public.coupons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_banners_updated_at BEFORE UPDATE ON public.banners FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_blog_posts_updated_at BEFORE UPDATE ON public.blog_posts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cms_content_updated_at BEFORE UPDATE ON public.cms_content FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON public.reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_return_requests_updated_at BEFORE UPDATE ON public.return_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_support_tickets_updated_at BEFORE UPDATE ON public.support_tickets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_chat_conversations_updated_at BEFORE UPDATE ON public.chat_conversations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_insights_updated_at BEFORE UPDATE ON public.customer_insights FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_navigation_items_updated_at BEFORE UPDATE ON public.navigation_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_navigation_menus_updated_at BEFORE UPDATE ON public.navigation_menus FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_riders_updated_at BEFORE UPDATE ON public.riders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_delivery_assignments_updated_at BEFORE UPDATE ON public.delivery_assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_delivery_zones_updated_at BEFORE UPDATE ON public.delivery_zones FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Review rating auto-update
CREATE TRIGGER on_review_change AFTER INSERT OR DELETE OR UPDATE ON public.reviews FOR EACH ROW EXECUTE FUNCTION update_product_rating();

-- Auth trigger: auto-create profile on signup
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

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

-- ── Profiles ──
CREATE POLICY "profiles_select" ON public.profiles FOR SELECT USING ((select auth.uid()) = id OR is_admin_or_staff());
CREATE POLICY "profiles_insert_own" ON public.profiles FOR INSERT WITH CHECK ((select auth.uid()) = id);
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE USING ((select auth.uid()) = id);
CREATE POLICY "profiles_admin_all" ON public.profiles FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Roles ──
CREATE POLICY "roles_select" ON public.roles FOR SELECT USING (true);
CREATE POLICY "roles_admin" ON public.roles FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Addresses ──
CREATE POLICY "addresses_select_own" ON public.addresses FOR SELECT USING ((select auth.uid()) = user_id);
CREATE POLICY "addresses_insert_own" ON public.addresses FOR INSERT WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "addresses_update_own" ON public.addresses FOR UPDATE USING ((select auth.uid()) = user_id);
CREATE POLICY "addresses_delete_own" ON public.addresses FOR DELETE USING ((select auth.uid()) = user_id);
CREATE POLICY "addresses_admin_all" ON public.addresses FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Store Settings ──
CREATE POLICY "store_settings_select" ON public.store_settings FOR SELECT USING (true);
CREATE POLICY "store_settings_admin" ON public.store_settings FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Site Settings ──
CREATE POLICY "site_settings_select" ON public.site_settings FOR SELECT USING (true);
CREATE POLICY "site_settings_admin" ON public.site_settings FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Audit Logs ──
CREATE POLICY "audit_logs_admin" ON public.audit_logs FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());
CREATE POLICY "audit_logs_insert" ON public.audit_logs FOR INSERT WITH CHECK (is_admin_or_staff());

-- ── Categories ──
CREATE POLICY "categories_select" ON public.categories FOR SELECT USING (true);
CREATE POLICY "categories_admin" ON public.categories FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Products ──
CREATE POLICY "products_select_active" ON public.products FOR SELECT USING (status = 'active'::product_status OR is_admin_or_staff());
CREATE POLICY "products_admin" ON public.products FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Product Images ──
CREATE POLICY "product_images_select" ON public.product_images FOR SELECT USING (true);
CREATE POLICY "product_images_insert_admin" ON public.product_images FOR INSERT WITH CHECK (is_admin_or_staff());
CREATE POLICY "product_images_update_admin" ON public.product_images FOR UPDATE USING (is_admin_or_staff());
CREATE POLICY "product_images_delete_admin" ON public.product_images FOR DELETE USING (is_admin_or_staff());
CREATE POLICY "product_images_admin" ON public.product_images FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Product Variants ──
CREATE POLICY "product_variants_select" ON public.product_variants FOR SELECT USING (true);
CREATE POLICY "product_variants_admin" ON public.product_variants FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Coupons ──
CREATE POLICY "coupons_select_active" ON public.coupons FOR SELECT USING (true);
CREATE POLICY "coupons_admin" ON public.coupons FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Orders ──
CREATE POLICY "orders_select_own" ON public.orders FOR SELECT USING ((select auth.uid()) = user_id OR user_id IS NULL OR is_admin_or_staff());
CREATE POLICY "orders_insert" ON public.orders FOR INSERT WITH CHECK (((select auth.uid()) IS NOT NULL AND (select auth.uid()) = user_id) OR ((select auth.uid()) IS NULL AND user_id IS NULL));
CREATE POLICY "orders_update_admin" ON public.orders FOR UPDATE USING (is_admin_or_staff());
CREATE POLICY "orders_delete_admin" ON public.orders FOR DELETE USING (is_admin_or_staff());

-- ── Order Items ──
CREATE POLICY "order_items_select" ON public.order_items FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND (orders.user_id = (select auth.uid()) OR orders.user_id IS NULL)) OR is_admin_or_staff());
CREATE POLICY "order_items_insert" ON public.order_items FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND (orders.user_id = (select auth.uid()) OR orders.user_id IS NULL)));
CREATE POLICY "order_items_admin" ON public.order_items FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Order Status History ──
CREATE POLICY "order_status_history_select" ON public.order_status_history FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_status_history.order_id AND orders.user_id = (select auth.uid())) OR is_admin_or_staff());
CREATE POLICY "order_status_history_admin" ON public.order_status_history FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Cart Items ──
CREATE POLICY "cart_items_select_own" ON public.cart_items FOR SELECT USING ((select auth.uid()) = user_id);
CREATE POLICY "cart_items_insert_own" ON public.cart_items FOR INSERT WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "cart_items_update_own" ON public.cart_items FOR UPDATE USING ((select auth.uid()) = user_id);
CREATE POLICY "cart_items_delete_own" ON public.cart_items FOR DELETE USING ((select auth.uid()) = user_id);

-- ── Wishlist Items ──
CREATE POLICY "wishlist_items_select_own" ON public.wishlist_items FOR SELECT USING ((select auth.uid()) = user_id);
CREATE POLICY "wishlist_items_insert_own" ON public.wishlist_items FOR INSERT WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "wishlist_items_delete_own" ON public.wishlist_items FOR DELETE USING ((select auth.uid()) = user_id);

-- ── Reviews ──
CREATE POLICY "reviews_select" ON public.reviews FOR SELECT USING (status = 'approved'::review_status OR (select auth.uid()) = user_id OR is_admin_or_staff());
CREATE POLICY "reviews_insert_auth" ON public.reviews FOR INSERT WITH CHECK ((select auth.uid()) IS NOT NULL);
CREATE POLICY "reviews_update_own" ON public.reviews FOR UPDATE USING ((select auth.uid()) = user_id OR is_admin_or_staff());
CREATE POLICY "reviews_admin" ON public.reviews FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Review Images ──
CREATE POLICY "review_images_select" ON public.review_images FOR SELECT USING (true);
CREATE POLICY "review_images_insert" ON public.review_images FOR INSERT WITH CHECK ((select auth.uid()) IS NOT NULL);
CREATE POLICY "review_images_admin" ON public.review_images FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Blog Posts ──
CREATE POLICY "blog_posts_select_published" ON public.blog_posts FOR SELECT USING (status = 'published'::blog_status OR is_admin_or_staff());
CREATE POLICY "blog_posts_admin" ON public.blog_posts FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Return Requests ──
CREATE POLICY "return_requests_select_own" ON public.return_requests FOR SELECT USING ((select auth.uid()) = user_id OR is_admin_or_staff());
CREATE POLICY "return_requests_insert_own" ON public.return_requests FOR INSERT WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "return_requests_admin" ON public.return_requests FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Return Items ──
CREATE POLICY "return_items_select" ON public.return_items FOR SELECT USING (EXISTS (SELECT 1 FROM return_requests WHERE return_requests.id = return_items.return_request_id AND return_requests.user_id = (select auth.uid())) OR is_admin_or_staff());
CREATE POLICY "return_items_insert" ON public.return_items FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM return_requests WHERE return_requests.id = return_items.return_request_id AND return_requests.user_id = (select auth.uid())));
CREATE POLICY "return_items_admin" ON public.return_items FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Notifications ──
CREATE POLICY "notifications_select_own" ON public.notifications FOR SELECT USING ((select auth.uid()) = user_id OR is_admin_or_staff());
CREATE POLICY "notifications_update_own" ON public.notifications FOR UPDATE USING ((select auth.uid()) = user_id);
CREATE POLICY "notifications_admin" ON public.notifications FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Pages ──
CREATE POLICY "pages_select" ON public.pages FOR SELECT USING (true);
CREATE POLICY "pages_admin" ON public.pages FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── CMS Content ──
CREATE POLICY "cms_content_select" ON public.cms_content FOR SELECT USING (is_active = true);
CREATE POLICY "cms_content_admin" ON public.cms_content FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Banners ──
CREATE POLICY "banners_select" ON public.banners FOR SELECT USING (is_active = true);
CREATE POLICY "banners_admin" ON public.banners FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Navigation Menus ──
CREATE POLICY "navigation_menus_select" ON public.navigation_menus FOR SELECT USING (true);
CREATE POLICY "navigation_menus_admin" ON public.navigation_menus FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Navigation Items ──
CREATE POLICY "navigation_items_select" ON public.navigation_items FOR SELECT USING (is_active = true);
CREATE POLICY "navigation_items_admin" ON public.navigation_items FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Store Modules ──
CREATE POLICY "store_modules_select" ON public.store_modules FOR SELECT USING (true);
CREATE POLICY "store_modules_admin" ON public.store_modules FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Customers ──
CREATE POLICY "customers_select_own" ON public.customers FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "customers_insert" ON public.customers FOR INSERT WITH CHECK (is_admin_or_staff());
CREATE POLICY "customers_update" ON public.customers FOR UPDATE USING (is_admin_or_staff());
CREATE POLICY "customers_admin" ON public.customers FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Chat Conversations ──
CREATE POLICY "chat_conversations_select_own" ON public.chat_conversations FOR SELECT USING ((select auth.uid()) = user_id OR is_admin_or_staff() OR true);
CREATE POLICY "chat_conversations_insert" ON public.chat_conversations FOR INSERT WITH CHECK (true);
CREATE POLICY "chat_conversations_update" ON public.chat_conversations FOR UPDATE USING ((select auth.uid()) = user_id OR user_id IS NULL OR is_admin_or_staff());
CREATE POLICY "chat_conversations_admin" ON public.chat_conversations FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── AI Memory ──
CREATE POLICY "ai_memory_select" ON public.ai_memory FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "ai_memory_insert" ON public.ai_memory FOR INSERT WITH CHECK (is_admin_or_staff());
CREATE POLICY "ai_memory_admin" ON public.ai_memory FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Customer Insights ──
CREATE POLICY "customer_insights_select" ON public.customer_insights FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "customer_insights_admin" ON public.customer_insights FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Support Tickets ──
CREATE POLICY "support_tickets_select" ON public.support_tickets FOR SELECT USING (true);
CREATE POLICY "support_tickets_insert" ON public.support_tickets FOR INSERT WITH CHECK (true);
CREATE POLICY "support_tickets_admin" ON public.support_tickets FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Support Ticket Messages ──
CREATE POLICY "support_ticket_messages_select" ON public.support_ticket_messages FOR SELECT USING (true);
CREATE POLICY "support_ticket_messages_insert" ON public.support_ticket_messages FOR INSERT WITH CHECK (true);
CREATE POLICY "support_ticket_messages_admin" ON public.support_ticket_messages FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Support Feedback ──
CREATE POLICY "support_feedback_insert" ON public.support_feedback FOR INSERT WITH CHECK (true);
CREATE POLICY "support_feedback_admin" ON public.support_feedback FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Support Knowledge Base ──
CREATE POLICY "support_kb_select" ON public.support_knowledge_base FOR SELECT USING (is_published = true);
CREATE POLICY "support_kb_admin" ON public.support_knowledge_base FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Support Canned Responses ──
CREATE POLICY "support_canned_select" ON public.support_canned_responses FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "support_canned_admin" ON public.support_canned_responses FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Support Escalation Rules ──
CREATE POLICY "support_escalation_select" ON public.support_escalation_rules FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "support_escalation_admin" ON public.support_escalation_rules FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Support Analytics ──
CREATE POLICY "support_analytics_select" ON public.support_analytics_daily FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "support_analytics_admin" ON public.support_analytics_daily FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Delivery Zones ──
CREATE POLICY "delivery_zones_select" ON public.delivery_zones FOR SELECT USING (is_active = true);
CREATE POLICY "delivery_zones_admin" ON public.delivery_zones FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Riders ──
CREATE POLICY "riders_select" ON public.riders FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "riders_admin" ON public.riders FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Delivery Assignments ──
CREATE POLICY "delivery_assignments_select" ON public.delivery_assignments FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "delivery_assignments_admin" ON public.delivery_assignments FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ── Delivery Status History ──
CREATE POLICY "delivery_status_history_select" ON public.delivery_status_history FOR SELECT USING (is_admin_or_staff());
CREATE POLICY "delivery_status_history_admin" ON public.delivery_status_history FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- Contact Submissions
CREATE POLICY "contact_submissions_insert" ON public.contact_submissions FOR INSERT WITH CHECK (true);
CREATE POLICY "contact_submissions_admin" ON public.contact_submissions FOR ALL USING (is_admin_or_staff()) WITH CHECK (is_admin_or_staff());

-- ============================================================================
