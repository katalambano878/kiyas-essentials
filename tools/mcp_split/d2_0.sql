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