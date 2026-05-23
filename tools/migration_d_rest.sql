
-- ============================================================================
-- 5. INDEXES
-- ============================================================================

-- Profiles
CREATE INDEX idx_profiles_email ON public.profiles USING btree (email);
CREATE INDEX idx_profiles_role ON public.profiles USING btree (role);

-- Addresses
CREATE INDEX idx_addresses_user_id ON public.addresses USING btree (user_id);

-- Audit Logs
CREATE INDEX idx_audit_logs_user ON public.audit_logs USING btree (user_id);
CREATE INDEX idx_audit_logs_created ON public.audit_logs USING btree (created_at);
CREATE INDEX idx_audit_logs_entity ON public.audit_logs USING btree (entity_type, entity_id);

-- Categories
CREATE INDEX idx_categories_parent ON public.categories USING btree (parent_id);
CREATE INDEX idx_categories_slug ON public.categories USING btree (slug);
CREATE INDEX idx_categories_status ON public.categories USING btree (status);

-- Products
CREATE INDEX idx_products_category ON public.products USING btree (category_id);
CREATE INDEX idx_products_featured ON public.products USING btree (featured);
CREATE INDEX idx_products_slug ON public.products USING btree (slug);
CREATE INDEX idx_products_status ON public.products USING btree (status);
CREATE INDEX idx_products_brand ON public.products USING btree (brand);
CREATE INDEX idx_products_name ON public.products USING btree (name);
CREATE INDEX idx_products_price ON public.products USING btree (price);
CREATE INDEX idx_products_created ON public.products USING btree (created_at);

-- Product Images
CREATE INDEX idx_product_images_product ON public.product_images USING btree (product_id);
CREATE INDEX idx_product_images_position ON public.product_images USING btree (position);

-- Product Variants
CREATE INDEX idx_product_variants_product ON public.product_variants USING btree (product_id);

-- Blog Posts
CREATE INDEX idx_blog_posts_slug ON public.blog_posts USING btree (slug);
CREATE INDEX idx_blog_posts_status ON public.blog_posts USING btree (status);
CREATE INDEX idx_blog_posts_author ON public.blog_posts USING btree (author_id);

-- Coupons
CREATE INDEX idx_coupons_code ON public.coupons USING btree (code);
CREATE INDEX idx_coupons_active ON public.coupons USING btree (is_active);

-- Orders
CREATE INDEX idx_orders_number ON public.orders USING btree (order_number);
CREATE INDEX idx_orders_status ON public.orders USING btree (status);
CREATE INDEX idx_orders_user ON public.orders USING btree (user_id);
CREATE INDEX idx_orders_email ON public.orders USING btree (email);
CREATE INDEX idx_orders_payment ON public.orders USING btree (payment_status);
CREATE INDEX idx_orders_created ON public.orders USING btree (created_at);

-- Order Items
CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);
CREATE INDEX idx_order_items_product ON public.order_items USING btree (product_id);
CREATE INDEX idx_order_items_variant ON public.order_items USING btree (variant_id);

-- Order Status History
CREATE INDEX idx_order_status_history_order ON public.order_status_history USING btree (order_id);
CREATE INDEX idx_order_status_history_created_by ON public.order_status_history USING btree (created_by);

-- Cart Items
CREATE INDEX idx_cart_items_user ON public.cart_items USING btree (user_id);
CREATE INDEX idx_cart_items_product ON public.cart_items USING btree (product_id);
CREATE INDEX idx_cart_items_variant ON public.cart_items USING btree (variant_id);

-- Wishlist Items
CREATE INDEX idx_wishlist_items_user ON public.wishlist_items USING btree (user_id);
CREATE INDEX idx_wishlist_items_product ON public.wishlist_items USING btree (product_id);

-- Notifications
CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);
CREATE INDEX idx_notifications_read ON public.notifications USING btree (user_id) WHERE read_at IS NULL;

-- Reviews
CREATE INDEX idx_reviews_product ON public.reviews USING btree (product_id);
CREATE INDEX idx_reviews_status ON public.reviews USING btree (status);
CREATE INDEX idx_reviews_user ON public.reviews USING btree (user_id);

-- Review Images
CREATE INDEX idx_review_images_review ON public.review_images USING btree (review_id);

-- Return Requests
CREATE INDEX idx_return_requests_order ON public.return_requests USING btree (order_id);
CREATE INDEX idx_return_requests_user ON public.return_requests USING btree (user_id);

-- Return Items
CREATE INDEX idx_return_items_return_request ON public.return_items USING btree (return_request_id);
CREATE INDEX idx_return_items_order_item ON public.return_items USING btree (order_item_id);

-- Pages
CREATE INDEX idx_pages_slug ON public.pages USING btree (slug);

-- CMS Content
CREATE INDEX idx_cms_content_section ON public.cms_content USING btree (section);

-- Banners
CREATE INDEX idx_banners_active ON public.banners USING btree (is_active);

-- Navigation Items
CREATE INDEX idx_navigation_items_menu ON public.navigation_items USING btree (menu_id);
CREATE INDEX idx_navigation_items_parent ON public.navigation_items USING btree (parent_id);

-- Store Settings
CREATE INDEX idx_store_settings_updated_by ON public.store_settings USING btree (updated_by);

-- Customers
CREATE INDEX idx_customers_email ON public.customers USING btree (email);
CREATE INDEX idx_customers_user_id ON public.customers USING btree (user_id);
CREATE INDEX idx_customers_phone ON public.customers USING btree (phone);

-- Chat Conversations
CREATE INDEX idx_chat_conversations_session ON public.chat_conversations USING btree (session_id);
CREATE INDEX idx_chat_conversations_user ON public.chat_conversations USING btree (user_id) WHERE user_id IS NOT NULL;
CREATE INDEX idx_chat_conversations_created ON public.chat_conversations USING btree (created_at);
CREATE INDEX idx_chat_conversations_category ON public.chat_conversations USING btree (category);
CREATE INDEX idx_chat_conversations_sentiment ON public.chat_conversations USING btree (sentiment);

-- AI Memory
CREATE INDEX idx_ai_memory_customer_email ON public.ai_memory USING btree (customer_email);
CREATE INDEX idx_ai_memory_type ON public.ai_memory USING btree (memory_type);
CREATE INDEX idx_ai_memory_source_conversation ON public.ai_memory USING btree (source_conversation_id);

-- Customer Insights
CREATE INDEX idx_customer_insights_email ON public.customer_insights USING btree (customer_email);

-- Support Tickets
CREATE INDEX idx_support_tickets_status ON public.support_tickets USING btree (status);
CREATE INDEX idx_support_tickets_conversation ON public.support_tickets USING btree (conversation_id);
CREATE INDEX idx_support_tickets_number ON public.support_tickets USING btree (ticket_number);

-- Support Ticket Messages
CREATE INDEX idx_support_ticket_messages_ticket ON public.support_ticket_messages USING btree (ticket_id);

-- Support Feedback
CREATE INDEX idx_support_feedback_conversation ON public.support_feedback USING btree (conversation_id);
CREATE INDEX idx_support_feedback_ticket ON public.support_feedback USING btree (ticket_id);

-- Support Knowledge Base
CREATE INDEX idx_support_kb_source_ticket ON public.support_knowledge_base USING btree (source_ticket_id);

-- Riders
CREATE INDEX idx_riders_status ON public.riders USING btree (status);
CREATE INDEX idx_riders_zone ON public.riders USING btree (zone_id);

-- Delivery Assignments
CREATE INDEX idx_delivery_assignments_order ON public.delivery_assignments USING btree (order_id);
CREATE INDEX idx_delivery_assignments_rider ON public.delivery_assignments USING btree (rider_id);
CREATE INDEX idx_delivery_assignments_status ON public.delivery_assignments USING btree (status);
CREATE INDEX idx_delivery_assignments_zone ON public.delivery_assignments USING btree (zone_id);
CREATE INDEX idx_delivery_assignments_assigned_by ON public.delivery_assignments USING btree (assigned_by);

-- Delivery Status History
CREATE INDEX idx_delivery_status_history_assignment ON public.delivery_status_history USING btree (assignment_id);
CREATE INDEX idx_delivery_status_history_changed_by ON public.delivery_status_history USING btree (changed_by);

-- ============================================================================
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
