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

-- â”€â”€ Wishlist Items â”€â”€;