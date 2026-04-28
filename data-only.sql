-- Data only - no schema, no CREATE statements
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET row_security = off;

-- Category
INSERT INTO public."Category" (id, name, description, slug, "order", "createdAt", status) VALUES
('69e6657d-4952-45e0-967a-8aed1e9ea429', 'Thảo Luận Chung', 'Nơi giao lưu, làm quen và tán gẫu.', 'thao-luan-chung', 1, '2026-03-13 02:56:40.513', 'ACTIVE'),
('bd0ae490-26e9-44c1-8fc7-6bd0e6267c5a', 'Kiếm Tiền Online (MMO)', 'Chia sẻ các kèo hot, task ngon và kinh nghiệm kiếm tiền.', 'kiem-tien-online', 2, '2026-03-13 02:56:40.53', 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

-- Board
INSERT INTO public."Board" (id, name, description, slug, "order", "createdAt", "categoryId", status) VALUES
('ea8708a3-22f7-4924-ad73-5310d5693c7d', 'Ra mắt thành viên', 'Bạn mới gia nhập? Hãy giới thiệu bản thân tại đây!', 'ra-mat-thanh-vien', 1, '2026-03-13 02:56:40.521', '69e6657d-4952-45e0-967a-8aed1e9ea429', 'ACTIVE'),
('a1b8ede3-aa71-4b06-a37a-c4f653840aea', 'Mẹo Share & Earn', 'Cách tối ưu hóa thu nhập từ hệ thống Share Task của Picpee.', 'share-earn-tips', 1, '2026-03-13 02:56:40.534', 'bd0ae490-26e9-44c1-8fc7-6bd0e6267c5a', 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

-- Tag
INSERT INTO public."Tag" (id, name, slug, "createdAt") VALUES
('7559eab2-64ad-4459-9b2a-7a390877318d', 'Kiếm Tiền', 'kiem-tien', '2026-03-13 03:19:24.125'),
('e7cabf8c-8a81-464c-ba4f-40ab17325431', 'Chia Sẻ', 'chia-se', '2026-03-13 03:19:24.136'),
('34a6ceb4-c0b6-42bc-beb9-9066805e7e99', 'Hướng Dẫn', 'huong-dan', '2026-03-13 03:19:24.141'),
('47ed9039-53dd-4cb3-b64b-6a4d6a180ea2', 'Tán Gẫu', 'tan-gau', '2026-03-13 03:19:24.146')
ON CONFLICT (id) DO NOTHING;

-- User
INSERT INTO public."User" (id, email, "emailVerified", "verificationToken", username, "avatarUrl", signature, role, reputation, "createdAt", "updatedAt", password, "phoneNumber", "bankName", "bankAccountNumber", "bankAccountName", status) VALUES
('d24b8a9e-3caf-4370-a716-e9f63009f604', 'hoang_tuan@example.com', false, NULL, 'HoangTuan_Dev', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Hoang', 'Code is life | Fullstack Developer', 'USER', 150, '2026-03-13 02:56:40.496', '2026-03-13 02:56:40.496', '$2b$10$aeBVZpRFROQK3LKdnuRFAezBDviZxo6r3cc9kITFiLAxkhzqfvRDS', NULL, NULL, NULL, NULL, 'ACTIVE'),
('afcfc997-af60-4bbc-bdcf-807f56866992', 'linh_marketing@example.com', false, NULL, 'LinhMKT', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Linh', 'Sẻ chia có hội - Cùng nhau kiếm tiền 🌿', 'USER', 85, '2026-03-13 02:56:40.509', '2026-03-13 02:56:40.509', '$2b$10$aeBVZpRFROQK3LKdnuRFAezBDviZxo6r3cc9kITFiLAxkhzqfvRDS', NULL, NULL, NULL, NULL, 'ACTIVE'),
('78bf245a-e21a-4f98-98cd-26aec81b01a6', 'admin.pp.forum@gmail.com', false, NULL, 'AdminPP', 'https://api.dicebear.com/7.x/avataaars/svg?seed=AdminPP', 'Picpee Senior Admin', 'ADMIN', 999, '2026-03-13 04:58:19.18', '2026-03-13 04:58:19.18', '$2b$10$siCRSXl69K07pLoEVeQYSe2cXl8VyQnTeUlS3sOc2Dr/RQY6Talym', NULL, NULL, NULL, NULL, 'ACTIVE'),
('cfcac9f3-76cf-464f-bc1a-775296128ef5', 'user17733780791101@example.com', false, NULL, 'Member_1_929', 'https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_1_929', NULL, 'USER', 10, '2026-03-13 05:01:19.111', '2026-03-13 05:01:19.111', '$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma', NULL, NULL, NULL, NULL, 'ACTIVE'),
('49f7d4de-5e27-4297-be62-f7b7ebf18c3c', 'user17733780791162@example.com', false, NULL, 'Member_2_717', 'https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_2_717', NULL, 'USER', 10, '2026-03-13 05:01:19.117', '2026-03-13 05:01:19.117', '$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma', NULL, NULL, NULL, NULL, 'ACTIVE'),
('80f84e07-aeb2-40ef-94a6-dd132048acc7', 'user17733780791193@example.com', false, NULL, 'Member_3_71', 'https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_3_71', NULL, 'USER', 10, '2026-03-13 05:01:19.121', '2026-03-13 05:01:19.121', '$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma', NULL, NULL, NULL, NULL, 'ACTIVE'),
('23266cbf-f0a3-4826-954b-79d6fe886a12', 'user17733780791224@example.com', false, NULL, 'Member_4_655', 'https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_4_655', NULL, 'USER', 10, '2026-03-13 05:01:19.123', '2026-03-13 05:01:19.123', '$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma', NULL, NULL, NULL, NULL, 'ACTIVE'),
('d35b0a3b-12f1-43e3-8639-5a47c23ff369', 'user17733780791255@example.com', false, NULL, 'Member_5_55', 'https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_5_55', NULL, 'USER', 10, '2026-03-13 05:01:19.126', '2026-03-13 05:01:19.126', '$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma', NULL, NULL, NULL, NULL, 'ACTIVE'),
('76641def-ec09-4870-8f0d-39ae10c1b258', 'minhnzz1202@gmail.com', false, NULL, 'MinhNzz', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Minh', 'Picpee Lead Developer', 'USER', 1014, '2026-03-13 02:58:17.027', '2026-03-13 08:01:16.48', '$2b$10$XOcUDD4Pwb7tLkTGi5JPC.c9bjYBwHhtx34JSfTlMC1VY4rpmcKr6', NULL, NULL, NULL, NULL, 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

-- Wallet
INSERT INTO public."Wallet" (id, balance, "pendingBalance", "updatedAt", "userId") VALUES
('8d6b3813-c192-402f-ad1f-a9672df8d13b', 1500000.00, 200000.00, '2026-03-13 02:56:40.564', 'd24b8a9e-3caf-4370-a716-e9f63009f604'),
('df24a486-cd3b-47ae-b370-67d8d31b1643', 50000.00, 15000.00, '2026-03-13 02:56:40.575', 'afcfc997-af60-4bbc-bdcf-807f56866992'),
('308a196f-3efc-46ff-b8be-39c236547a69', 0.00, 0.00, '2026-03-13 05:00:14.714', '78bf245a-e21a-4f98-98cd-26aec81b01a6'),
('26073c28-29fd-449e-b6be-4e7f391320db', 5.00, 0.00, '2026-03-13 06:18:00.26', '76641def-ec09-4870-8f0d-39ae10c1b258')
ON CONFLICT (id) DO NOTHING;

-- Thread
INSERT INTO public."Thread" (id, title, content, slug, views, "isPinned", "isLocked", "isFeatured", "createdAt", "updatedAt", "boardId", "authorId") VALUES
('f86a0872-4aa8-43e5-9c35-8224d8bb5c2a', 'Top các nền tảng MMO uy tín 2026', 'Bài viết tổng hợp các network và nền tảng tốt nhất để anh em cày cuốc trong năm nay.', 'top-cac-nen-tang-mmo-uy-tin-2026', 892, false, false, false, '2026-03-13 03:19:24.165', '2026-03-13 06:47:37.395', 'a1b8ede3-aa71-4b06-a37a-c4f653840aea', '76641def-ec09-4870-8f0d-39ae10c1b258'),
('479ebdc7-7817-422d-a306-58e88948beda', 'Review các công cụ hỗ trợ làm việc từ xa tốt nhất', 'Chào mọi người, mình là Member_4_655. Đây là nội dung bài viết thứ 4 về chủ đề "Review các công cụ hỗ trợ làm việc từ xa tốt nhất". Hy vọng nhận được nhiều chia sẻ từ anh em!', 'bai-viet-mau-1773378079160-3', 17, false, false, false, '2026-03-13 05:01:19.161', '2026-03-13 05:01:19.161', 'ea8708a3-22f7-4924-ad73-5310d5693c7d', '23266cbf-f0a3-4826-954b-79d6fe886a12'),
('a6f671c8-a1ef-4988-942d-64fbf2d78931', 'Hướng dẫn kiếm 500k mỗi ngày từ Picpee Share Task', E'Chào anh em, mình đã tham gia Picpee được 1 tháng và rút được hơn 10 triệu. Bí quyết nằm ở việc chọn lọc thread có Share Task cao và chia sẻ lên đúng các group Facebook có tệp user phù hợp.\n      \n      Bước 1: Tìm bài viết có nút "Share & Earn".\n      Bước 2: Copy link giới thiệu cá nhân.\n      Bước 3: Viết caption thu hút và đăng lên MXH.\n      \n      Chúc anh em thành công!', 'huong-dan-kiem-500k-moi-ngay-tu-picpee', 1253, false, false, true, '2026-03-13 02:56:40.54', '2026-03-13 07:10:27.678', 'a1b8ede3-aa71-4b06-a37a-c4f653840aea', 'd24b8a9e-3caf-4370-a716-e9f63009f604'),
('707c7121-b56a-4848-a38c-370ea4e754ac', 'Kể về lần đầu tiên bạn kiếm được tiền trên mạng', 'Chào mọi người, mình là Member_5_55. Đây là nội dung bài viết thứ 5 về chủ đề "Kể về lần đầu tiên bạn kiếm được tiền trên mạng". Hy vọng nhận được nhiều chia sẻ từ anh em!', 'bai-viet-mau-1773378079170-4', 17, false, false, false, '2026-03-13 05:01:19.172', '2026-03-13 08:26:54.818', 'ea8708a3-22f7-4924-ad73-5310d5693c7d', 'd35b0a3b-12f1-43e3-8639-5a47c23ff369'),
('bd97094a-f95b-47d3-89dd-c65ab0cac84d', 'Xin chào, mình là thành viên mới đến từ Hà Nội', 'Rất vui được làm quen với mọi người. Mình hy vọng sẽ học hỏi được nhiều kinh nghiệm MMO tại đây.', 'xin-chao-minh-la-thanh-vien-moi', 54, false, false, false, '2026-03-13 02:56:40.549', '2026-03-13 03:31:48.307', 'ea8708a3-22f7-4924-ad73-5310d5693c7d', 'afcfc997-af60-4bbc-bdcf-807f56866992'),
('fce88b3f-41f1-4b9f-a15d-d3dba311d773', 'Chia sẻ kinh nghiệm kiếm tiền từ Affiliate Marketing', 'Chào mọi người, mình là Member_2_717. Đây là nội dung bài viết thứ 2 về chủ đề "Chia sẻ kinh nghiệm kiếm tiền từ Affiliate Marketing". Hy vọng nhận được nhiều chia sẻ từ anh em!', 'bai-viet-mau-1773378079140-1', 99, false, false, false, '2026-03-13 05:01:19.141', '2026-03-13 05:01:19.141', 'ea8708a3-22f7-4924-ad73-5310d5693c7d', '49f7d4de-5e27-4297-be62-f7b7ebf18c3c'),
('9c55616e-afb6-440c-a864-4def81fe6041', 'Tìm đồng đội làm dự án khởi nghiệp công nghệ', 'Chào mọi người, mình là Member_3_71. Đây là nội dung bài viết thứ 3 về chủ đề "Tìm đồng đội làm dự án khởi nghiệp công nghệ". Hy vọng nhận được nhiều chia sẻ từ anh em!', 'bai-viet-mau-1773378079152-2', 33, false, false, false, '2026-03-13 05:01:19.153', '2026-03-13 05:01:19.153', 'ea8708a3-22f7-4924-ad73-5310d5693c7d', '80f84e07-aeb2-40ef-94a6-dd132048acc7'),
('21dda81a-868f-414d-849f-0cc6c7fe743d', 'xzzxczxcz', '<p>zxvzx</p><p></p>', 'xzzxczxcz-ghjee', 6, false, false, false, '2026-03-13 08:01:16.471', '2026-03-13 08:40:05.214', 'ea8708a3-22f7-4924-ad73-5310d5693c7d', '76641def-ec09-4870-8f0d-39ae10c1b258'),
('cca89eae-e11c-46d9-af38-326d875b7ddd', 'Làm thế nào để bắt đầu với Freelance năm 2024?', 'Chào mọi người, mình là Member_1_929. Đây là nội dung bài viết thứ 1 về chủ đề "Làm thế nào để bắt đầu với Freelance năm 2024?". Hy vọng nhận được nhiều chia sẻ từ anh em!', 'bai-viet-mau-1773378079128-0', 45, false, false, false, '2026-03-13 05:01:19.13', '2026-03-13 09:46:15.231', 'ea8708a3-22f7-4924-ad73-5310d5693c7d', 'cfcac9f3-76cf-464f-bc1a-775296128ef5')
ON CONFLICT (id) DO NOTHING;

-- _ThreadTags
INSERT INTO public."_ThreadTags" ("A", "B") VALUES
('7559eab2-64ad-4459-9b2a-7a390877318d', 'f86a0872-4aa8-43e5-9c35-8224d8bb5c2a'),
('e7cabf8c-8a81-464c-ba4f-40ab17325431', 'f86a0872-4aa8-43e5-9c35-8224d8bb5c2a')
ON CONFLICT DO NOTHING;

-- Post
INSERT INTO public."Post" (id, content, "parentId", "createdAt", "updatedAt", "threadId", "authorId") VALUES
('3adc548b-ff67-4441-81bb-fd0087841106', 'Bài viết hữu ích quá bạn ơi, mình vừa thử và đã có Task đầu tiên được duyệt!', NULL, '2026-03-13 02:56:40.556', '2026-03-13 02:56:40.556', 'a6f671c8-a1ef-4988-942d-64fbf2d78931', 'afcfc997-af60-4bbc-bdcf-807f56866992'),
('331bd2f9-a294-4747-83af-ddfa6bfaecd7', 'Bài viết hữu ích quá bạn ơi, mình vừa thử và đã có Task đầu tiên được duyệt!', NULL, '2026-03-13 02:58:17.061', '2026-03-13 02:58:17.061', 'a6f671c8-a1ef-4988-942d-64fbf2d78931', 'afcfc997-af60-4bbc-bdcf-807f56866992'),
('c141e72a-de1c-4682-a88c-2e0011e1d0f2', 'Bài viết hữu ích quá bạn ơi, mình vừa thử và đã có Task đầu tiên được duyệt!', NULL, '2026-03-13 03:19:24.178', '2026-03-13 03:19:24.178', 'a6f671c8-a1ef-4988-942d-64fbf2d78931', 'afcfc997-af60-4bbc-bdcf-807f56866992'),
('bf9e25cd-4433-4104-9b34-981c63256a0b', 'Bình luận thứ 1 từ Member_1_929. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.135', '2026-03-13 05:01:19.135', 'cca89eae-e11c-46d9-af38-326d875b7ddd', 'cfcac9f3-76cf-464f-bc1a-775296128ef5'),
('32c29e6f-b6a9-4462-8492-38a299e45e72', 'Bình luận thứ 1 từ Member_1_929. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.144', '2026-03-13 05:01:19.144', 'fce88b3f-41f1-4b9f-a15d-d3dba311d773', 'cfcac9f3-76cf-464f-bc1a-775296128ef5'),
('55da1c52-8e45-4a28-aaac-12c44b875e33', 'Bình luận thứ 2 từ Member_4_655. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.147', '2026-03-13 05:01:19.147', 'fce88b3f-41f1-4b9f-a15d-d3dba311d773', '23266cbf-f0a3-4826-954b-79d6fe886a12'),
('200d27ca-44f3-4455-b32b-2a82d80b8b92', 'Bình luận thứ 3 từ Member_3_71. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.15', '2026-03-13 05:01:19.15', 'fce88b3f-41f1-4b9f-a15d-d3dba311d773', '80f84e07-aeb2-40ef-94a6-dd132048acc7'),
('cada5329-f0ec-4061-a73e-4d3eddbbc61d', 'Bình luận thứ 1 từ Member_4_655. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.157', '2026-03-13 05:01:19.157', '9c55616e-afb6-440c-a864-4def81fe6041', '23266cbf-f0a3-4826-954b-79d6fe886a12'),
('93e231af-6f43-4cf0-a836-6ba3167884ce', 'Bình luận thứ 1 từ Member_2_717. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.166', '2026-03-13 05:01:19.166', '479ebdc7-7817-422d-a306-58e88948beda', '49f7d4de-5e27-4297-be62-f7b7ebf18c3c'),
('c3eadb18-702e-4ca2-8e34-d3685eedf0a7', 'Bình luận thứ 2 từ Member_2_717. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.169', '2026-03-13 05:01:19.169', '479ebdc7-7817-422d-a306-58e88948beda', '49f7d4de-5e27-4297-be62-f7b7ebf18c3c'),
('bb698425-c726-4444-a350-ef42deeba02c', 'Bình luận thứ 1 từ Member_2_717. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.175', '2026-03-13 05:01:19.175', '707c7121-b56a-4848-a38c-370ea4e754ac', '49f7d4de-5e27-4297-be62-f7b7ebf18c3c'),
('74e15f1d-bec9-49f2-a2db-1d0cca20a5fa', 'Bình luận thứ 2 từ Member_5_55. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.177', '2026-03-13 05:01:19.177', '707c7121-b56a-4848-a38c-370ea4e754ac', 'd35b0a3b-12f1-43e3-8639-5a47c23ff369'),
('68bbd5dc-9fff-4d34-8c0a-65dd429bd4bd', 'Bình luận thứ 3 từ Member_4_655. Bài viết rất hữu ích!', NULL, '2026-03-13 05:01:19.179', '2026-03-13 05:01:19.179', '707c7121-b56a-4848-a38c-370ea4e754ac', '23266cbf-f0a3-4826-954b-79d6fe886a12')
ON CONFLICT (id) DO NOTHING;

-- Notification
INSERT INTO public."Notification" (id, "receiverId", "senderId", type, content, link, metadata, "isRead", "createdAt") VALUES
('98de9217-304e-4fe4-b49a-8cb140757aae', '76641def-ec09-4870-8f0d-39ae10c1b258', 'd24b8a9e-3caf-4370-a716-e9f63009f604', 'LIKE', 'đã thích bài viết của bạn: Hướng dẫn kiếm 500k mỗi ngày từ Picpee Share Task', '/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee', NULL, false, '2026-03-13 02:58:17.077'),
('7021dca4-d2dd-4f95-bcce-ff19a577ce89', '76641def-ec09-4870-8f0d-39ae10c1b258', 'afcfc997-af60-4bbc-bdcf-807f56866992', 'REPLY', 'đã trả lời một thảo luận bạn đang theo dõi', '/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee', NULL, false, '2026-03-13 02:58:17.077'),
('d496a6a1-34b3-4fb4-b3de-9935dcf4d38f', '76641def-ec09-4870-8f0d-39ae10c1b258', NULL, 'SYSTEM', 'Ví của bạn vừa được cộng 50.000đ từ sự kiện chào mừng!', '/wallet', NULL, false, '2026-03-13 02:58:17.077'),
('a61eff2f-d4db-4635-a7f1-e41609bf6496', '76641def-ec09-4870-8f0d-39ae10c1b258', 'd24b8a9e-3caf-4370-a716-e9f63009f604', 'MENTION', 'đã nhắc đến bạn trong một bình luận', '/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee', NULL, false, '2026-03-13 02:58:17.077'),
('92e306a5-d4ac-4bc1-84c8-5e999cb5fd89', '76641def-ec09-4870-8f0d-39ae10c1b258', 'd24b8a9e-3caf-4370-a716-e9f63009f604', 'LIKE', 'đã thích bài viết của bạn: Hướng dẫn kiếm 500k mỗi ngày từ Picpee Share Task', '/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee', NULL, false, '2026-03-13 03:19:24.22'),
('3e834178-d9cc-45c7-af3f-75dd557c45b4', '76641def-ec09-4870-8f0d-39ae10c1b258', 'afcfc997-af60-4bbc-bdcf-807f56866992', 'REPLY', 'đã trả lời một thảo luận bạn đang theo dõi', '/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee', NULL, false, '2026-03-13 03:19:24.22'),
('a22e2d36-0059-4894-85d7-14ebd4acdb4f', '76641def-ec09-4870-8f0d-39ae10c1b258', 'd24b8a9e-3caf-4370-a716-e9f63009f604', 'MENTION', 'đã nhắc đến bạn trong một bình luận', '/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee', NULL, true, '2026-03-13 03:19:24.22'),
('1ead6768-d109-4147-832f-0816777425c7', '76641def-ec09-4870-8f0d-39ae10c1b258', NULL, 'SYSTEM', 'Ví của bạn vừa được cộng 50.000đ từ sự kiện chào mừng!', '/wallet', NULL, true, '2026-03-13 03:19:24.22')
ON CONFLICT (id) DO NOTHING;

-- ShareTask
INSERT INTO public."ShareTask" (id, "sharedUrl", status, "proofNote", "rewardAmount", "approvedAt", "paymentDueAt", "createdAt", "updatedAt", "userId", "threadId") VALUES
('706fafd3-6dbc-48c3-8f49-a5011596125d', 'https://kenphotos.com/services/virtual-renovation', 'PAID', 'zfsasfasasf', 5.00, '2026-03-13 06:17:54.633', '2026-03-20 06:17:54.633', '2026-03-13 06:16:40.232', '2026-03-13 06:18:00.271', '76641def-ec09-4870-8f0d-39ae10c1b258', '707c7121-b56a-4848-a38c-370ea4e754ac')
ON CONFLICT (id) DO NOTHING;

-- Transaction
INSERT INTO public."Transaction" (id, amount, type, status, description, "createdAt", "walletId") VALUES
('0e25c04b-0bd3-4dfd-b01b-f469e514d622', 5.00, 'REWARD', 'COMPLETED', 'Thanh toán nhiệm vụ: Kể về lần đầu tiên bạn kiếm được tiền trên mạng', '2026-03-13 06:18:00.266', '26073c28-29fd-449e-b6be-4e7f391320db')
ON CONFLICT (id) DO NOTHING;
