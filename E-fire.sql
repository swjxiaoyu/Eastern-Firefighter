/*
 Navicat Premium Dump SQL

 Source Server         : E-fire
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : e-fire

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 28/09/2025 11:47:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `content_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `seo_json` json NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `published_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_article_slug`(`slug` ASC) USING BTREE,
  INDEX `idx_article_channel`(`channel` ASC) USING BTREE,
  INDEX `idx_article_slug`(`slug` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5008 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (5002, 'news', '城市消防联动演练圆满完成', 'city-drill-2025', 'https://picsum.photos/seed/a5002/800/420', '本周城市多部门联合开展消防疏散演练。', '<h3>联动演练</h3><p>多部门协作提升应急处置效率。</p>', '{\"keywords\": [\"消防演练\", \"城市安全\"], \"description\": \"城市消防联动演练\"}', 1, '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.592', 0);
INSERT INTO `article` VALUES (5003, 'safety', '家庭电器防火十条建议', 'home-electrical-tips', 'https://picsum.photos/seed/a5003/800/420', '从插线板到厨房电器的安全使用建议。', '<ul><li>避免超负荷</li><li>定期检查绝缘</li><li>远离可燃物</li></ul>', '{\"keywords\": [\"家庭防火\", \"电器安全\"], \"description\": \"家庭电器防火建议\"}', 1, '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.596', 0);
INSERT INTO `article` VALUES (5004, 'training', '企业消防培训要点清单', 'enterprise-training-checklist', 'https://picsum.photos/seed/a5004/800/420', '企业年度消防培训的关键要点与考核。', '<p>覆盖灭火器使用、逃生演练、隐患排查等模块。</p>', '{\"keywords\": [\"消防培训\", \"企业\"], \"description\": \"企业消防培训清单\"}', 1, '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.598', 0);
INSERT INTO `article` VALUES (5005, 'equipment', '如何选择家用灭火器', 'choose-home-extinguisher', 'https://picsum.photos/seed/a5005/800/420', '从容量、介质到有效期的选购指南。', '<p>常见介质包括干粉、二氧化碳、水基等，家庭推荐ABC干粉。</p>', '{\"keywords\": [\"灭火器\", \"选购指南\"], \"description\": \"家用灭火器选购\"}', 1, '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.600', 0);
INSERT INTO `article` VALUES (5006, 'rescue', '高层逃生的三项关键准备', 'highrise-escape-keys', 'https://picsum.photos/seed/a5006/800/420', '预案、装备与演练三方面的准备。', '<p>提前规划逃生路线、配备简易防烟面罩、定期演练至关重要。</p>', '{\"keywords\": [\"高层逃生\", \"防烟\"], \"description\": \"高层逃生准备\"}', 1, '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.603', 0);
INSERT INTO `article` VALUES (5007, 'cases', '典型火情复盘：仓储区电气短路', 'case-warehouse-short', 'https://picsum.photos/seed/a5007/800/420', '从起因到处置的完整复盘，给出整改清单。', '<h3>起火原因</h3><p>电缆老化+负荷异常。</p><h3>改进</h3><p>增设温感+负荷监控，周期性巡检。</p>', '{\"keywords\": [\"事故复盘\", \"仓储\"], \"description\": \"仓储电气短路复盘\"}', 1, '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.000', '2025-08-30 11:06:11.605', 0);

-- ----------------------------
-- Table structure for article_tag
-- ----------------------------
DROP TABLE IF EXISTS `article_tag`;
CREATE TABLE `article_tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tag_slug`(`slug` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '标签' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of article_tag
-- ----------------------------

-- ----------------------------
-- Table structure for article_tag_rel
-- ----------------------------
DROP TABLE IF EXISTS `article_tag_rel`;
CREATE TABLE `article_tag_rel`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `article_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_article_tag`(`article_id` ASC, `tag_id` ASC) USING BTREE,
  INDEX `fk_rel_tag`(`tag_id` ASC) USING BTREE,
  CONSTRAINT `fk_rel_article` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_rel_tag` FOREIGN KEY (`tag_id`) REFERENCES `article_tag` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章-标签关联' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of article_tag_rel
-- ----------------------------

-- ----------------------------
-- Table structure for auth_session
-- ----------------------------
DROP TABLE IF EXISTS `auth_session`;
CREATE TABLE `auth_session`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `jti` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `expires_at` datetime(3) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_session_jti`(`jti` ASC) USING BTREE,
  INDEX `idx_session_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_session_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1961629076145958923 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '登录会话' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_session
-- ----------------------------
INSERT INTO `auth_session` VALUES (1960990138062381058, 1960990138062381057, 'a0effa8023f5456982e3a5f3ea2dbb17', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-04 16:57:37.017', '2025-08-28 16:57:37.017', '2025-08-28 16:57:37.017', 0);
INSERT INTO `auth_session` VALUES (1961607252100116481, 1960990138062381057, '31b8076a3e2d40af920d20d17da83d3d', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-06 09:49:48.458', '2025-08-30 09:49:48.458', '2025-08-30 09:49:48.458', 0);
INSERT INTO `auth_session` VALUES (1961629076145958914, 1960990138062381057, '1b371efa948042bd81f39ae3c87ed6aa', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-06 11:16:31.717', '2025-08-30 11:16:31.717', '2025-08-30 11:16:31.717', 0);
INSERT INTO `auth_session` VALUES (1961629076145958915, 1960990138062381057, '3e8f4ead80db40f5a6897441f76c5587', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-30 09:39:14.281', '2025-09-23 09:39:14.281', '2025-09-23 09:39:14.281', 0);
INSERT INTO `auth_session` VALUES (1961629076145958916, 1960990138062381057, '6ed3532083a54a6c88519ad2d22a1b8b', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-30 09:55:17.503', '2025-09-23 09:55:17.503', '2025-09-23 09:55:17.503', 0);
INSERT INTO `auth_session` VALUES (1961629076145958917, 1960990138062381057, '38d353ca4d524a6a97c1c4fc7505a086', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-30 10:55:45.732', '2025-09-23 10:55:45.732', '2025-09-23 10:55:45.732', 0);
INSERT INTO `auth_session` VALUES (1961629076145958918, 1960990138062381058, '3d0f8ebabeaf4e029b45f37b8d3a62d3', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-30 10:57:02.338', '2025-09-23 10:57:02.338', '2025-09-23 10:57:02.338', 0);
INSERT INTO `auth_session` VALUES (1961629076145958919, 1960990138062381057, 'c1f90447fecb411e8f11d360d4662c0e', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-30 14:37:45.233', '2025-09-23 14:37:45.233', '2025-09-23 14:37:45.233', 0);
INSERT INTO `auth_session` VALUES (1961629076145958920, 1960990138062381058, '2819a843ce894bffb17cc100f01602dc', 'web', '0:0:0:0:0:0:0:1', 1, '2025-09-30 14:41:50.681', '2025-09-23 14:41:50.681', '2025-09-23 14:41:50.681', 0);
INSERT INTO `auth_session` VALUES (1961629076145958921, 1960990138062381057, 'a60711c31f724994aadad94c52b84973', 'web', '0:0:0:0:0:0:0:1', 1, '2025-10-05 10:09:15.843', '2025-09-28 10:09:15.843', '2025-09-28 10:09:15.843', 0);
INSERT INTO `auth_session` VALUES (1961629076145958922, 1960990138062381058, 'f93e4bf65c504c1ab75de6bfad40b1d6', 'web', '0:0:0:0:0:0:0:1', 1, '2025-10-05 11:43:36.389', '2025-09-28 11:43:36.389', '2025-09-28 11:43:36.389', 0);

-- ----------------------------
-- Table structure for auth_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `auth_sms_log`;
CREATE TABLE `auth_sms_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `scene` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `code_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `send_success` tinyint NOT NULL DEFAULT 1,
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `retry_count` int NOT NULL DEFAULT 0,
  `sent_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sms_phone_scene`(`phone` ASC, `scene` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1961628965357613060 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '短信发送日志（脱敏存储）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_sms_log
-- ----------------------------
INSERT INTO `auth_sms_log` VALUES (1960990072929034242, '13800000000', 'register', 'DFRABG7AQUxp1ijelr4Fy7g_VkzemQ_o7xhLdyBztZA', 1, '0:0:0:0:0:0:0:1', 0, '2025-08-28 16:57:21.475', '2025-08-28 16:57:21.602', '2025-08-28 16:57:21.602', 0);
INSERT INTO `auth_sms_log` VALUES (1961606086221889537, '13800000000', 'login', '6PmxXWnqqWEzjqsd9eKvXOsmxizjklrXeE6q7PANHzE', 1, '0:0:0:0:0:0:0:1', 0, '2025-08-30 09:45:10.489', '2025-08-30 09:45:11.058', '2025-08-30 09:45:11.058', 0);
INSERT INTO `auth_sms_log` VALUES (1961607123099975682, '13800000000', 'login', 'ZMUZgthHIAOT62DChwq3Hlbd9E8c8it_3edh-Ra7PZw', 1, '0:0:0:0:0:0:0:1', 0, '2025-08-30 09:49:17.712', '2025-08-30 09:49:18.133', '2025-08-30 09:49:18.133', 0);
INSERT INTO `auth_sms_log` VALUES (1961607186501201921, '13800000000', 'login', 'Prz989EKXROJAY2JBMEA3jDv82aYQSCTINMYStnc8O8', 1, '0:0:0:0:0:0:0:1', 0, '2025-08-30 09:49:32.781', '2025-08-30 09:49:33.469', '2025-08-30 09:49:33.469', 0);
INSERT INTO `auth_sms_log` VALUES (1961607220420538369, '13800000000', 'login', '5HPLChjRlid6dzHHtr0-ldvv4FEaWb_bA4BL072oHSY', 1, '0:0:0:0:0:0:0:1', 0, '2025-08-30 09:49:40.911', '2025-08-30 09:49:41.331', '2025-08-30 09:49:41.331', 0);
INSERT INTO `auth_sms_log` VALUES (1961628920428228610, '13800000000', 'login', 'wJMQx425LVTV6hYDRqOxe_IP8wo1H8kAh14VgVbL1Hg', 1, '0:0:0:0:0:0:0:1', 0, '2025-08-30 11:15:54.593', '2025-08-30 11:15:55.001', '2025-08-30 11:15:55.001', 0);
INSERT INTO `auth_sms_log` VALUES (1961628965357613058, '13800000000', 'login', 'mST4-FqNhLyDbmuFx7RCkA-3jYAPN4WM_W3rbEqFwY0', 1, '0:0:0:0:0:0:0:1', 0, '2025-08-30 11:16:05.309', '2025-08-30 11:16:05.716', '2025-08-30 11:16:05.716', 0);
INSERT INTO `auth_sms_log` VALUES (1961628965357613059, '13800000002', 'register', 'CSVtfFrcSZnPwd42QmI0-sHAe_ksIo68sJHoRjfK6rY', 1, '0:0:0:0:0:0:0:1', 0, '2025-09-23 10:56:07.123', '2025-09-23 10:56:07.123', '2025-09-23 10:56:07.123', 0);

-- ----------------------------
-- Table structure for booking
-- ----------------------------
DROP TABLE IF EXISTS `booking`;
CREATE TABLE `booking`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `booking_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `museum_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `booking_date` date NOT NULL,
  `time_range` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `num_people` int NOT NULL,
  `status` smallint NOT NULL DEFAULT 10,
  `qr_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `checked_in_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_booking_no`(`booking_no` ASC) USING BTREE,
  INDEX `idx_booking_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_booking_museum_date`(`museum_id` ASC, `booking_date` ASC) USING BTREE,
  CONSTRAINT `fk_booking_museum` FOREIGN KEY (`museum_id`) REFERENCES `museum` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of booking
-- ----------------------------

-- ----------------------------
-- Table structure for booking_slot
-- ----------------------------
DROP TABLE IF EXISTS `booking_slot`;
CREATE TABLE `booking_slot`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `museum_id` bigint NOT NULL,
  `booking_date` date NOT NULL,
  `time_range` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `capacity` int NOT NULL,
  `reserved` int NOT NULL DEFAULT 0,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_slot`(`museum_id` ASC, `booking_date` ASC, `time_range` ASC) USING BTREE,
  CONSTRAINT `fk_slot_museum` FOREIGN KEY (`museum_id`) REFERENCES `museum` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约时段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of booking_slot
-- ----------------------------

-- ----------------------------
-- Table structure for cart_item
-- ----------------------------
DROP TABLE IF EXISTS `cart_item`;
CREATE TABLE `cart_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `sku_id` bigint NOT NULL,
  `quantity` int NOT NULL,
  `selected` tinyint NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cart_user_sku`(`user_id` ASC, `sku_id` ASC) USING BTREE,
  INDEX `idx_cart_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_cart_sku`(`sku_id` ASC) USING BTREE,
  CONSTRAINT `fk_cart_sku` FOREIGN KEY (`sku_id`) REFERENCES `product_sku` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1967483621681922060 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '购物车' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cart_item
-- ----------------------------
INSERT INTO `cart_item` VALUES (1961653569304141825, 1960990138062381057, 3002, 6, 1, '2025-08-30 12:53:51.339', '2025-09-28 10:33:27.426', 1);
INSERT INTO `cart_item` VALUES (1961707909511462914, 1960990138062381057, 3012, 8, 1, '2025-08-30 16:29:47.066', '2025-09-28 10:33:27.426', 1);
INSERT INTO `cart_item` VALUES (1961707987873644546, 1960990138062381057, 3007, 6, 1, '2025-08-30 16:30:05.745', '2025-09-28 10:33:27.426', 1);
INSERT INTO `cart_item` VALUES (1961710419663994882, 1960990138062381057, 3010, 8, 1, '2025-08-30 16:39:45.530', '2025-09-28 10:33:27.426', 1);
INSERT INTO `cart_item` VALUES (1966711425300746242, 1, 3007, 2, 1, '2025-09-13 11:51:58.188', '2025-09-17 12:05:16.132', 1);
INSERT INTO `cart_item` VALUES (1967483524424400897, 1, 3008, 12, 1, '2025-09-15 15:00:00.964', '2025-09-17 12:05:16.132', 1);
INSERT INTO `cart_item` VALUES (1967483561686597633, 1, 3009, 1, 1, '2025-09-15 15:00:09.847', '2025-09-17 12:05:16.132', 1);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NULL DEFAULT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sort` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cat_parent`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1019 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品类目' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1002, NULL, '防护装备', '/1002', 2, 1, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0);
INSERT INTO `category` VALUES (1003, NULL, '通信设备', '/1003', 3, 1, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0);
INSERT INTO `category` VALUES (1004, NULL, '灭火器', NULL, 0, 1, '2025-08-30 16:29:34.000', '2025-08-30 16:29:34.000', 0);
INSERT INTO `category` VALUES (1005, NULL, '消防服与防护', NULL, 0, 1, '2025-08-30 16:29:34.000', '2025-08-30 16:29:34.000', 0);
INSERT INTO `category` VALUES (1006, NULL, '应急工具', NULL, 0, 1, '2025-08-30 16:29:34.000', '2025-08-30 16:29:34.000', 0);
INSERT INTO `category` VALUES (1007, NULL, '全部商品', '/all', 0, 1, '2025-09-13 11:12:48.654', '2025-09-13 11:12:48.654', 0);
INSERT INTO `category` VALUES (1008, NULL, '消防装备', '/equipment', 10, 1, '2025-09-13 11:12:48.654', '2025-09-13 11:12:48.654', 0);
INSERT INTO `category` VALUES (1009, NULL, '应急耗材', '/consumables', 20, 1, '2025-09-13 11:12:48.654', '2025-09-13 11:12:48.654', 0);
INSERT INTO `category` VALUES (1010, NULL, '培训课程', '/training', 30, 1, '2025-09-13 11:12:48.654', '2025-09-13 11:12:48.654', 0);
INSERT INTO `category` VALUES (1011, NULL, '全部商品', '/all', 0, 1, '2025-09-13 11:24:23.918', '2025-09-13 11:24:23.918', 0);
INSERT INTO `category` VALUES (1012, NULL, '消防装备', '/equipment', 10, 1, '2025-09-13 11:24:23.918', '2025-09-13 11:24:23.918', 0);
INSERT INTO `category` VALUES (1013, NULL, '应急耗材', '/consumables', 20, 1, '2025-09-13 11:24:23.918', '2025-09-13 11:24:23.918', 0);
INSERT INTO `category` VALUES (1014, NULL, '培训课程', '/training', 30, 1, '2025-09-13 11:24:23.918', '2025-09-13 11:24:23.918', 0);
INSERT INTO `category` VALUES (1015, NULL, '全部商品', '/all', 0, 1, '2025-09-13 11:48:15.105', '2025-09-13 11:48:15.105', 0);
INSERT INTO `category` VALUES (1016, NULL, '消防装备', '/equipment', 10, 1, '2025-09-13 11:48:15.105', '2025-09-13 11:48:15.105', 0);
INSERT INTO `category` VALUES (1017, NULL, '应急耗材', '/consumables', 20, 1, '2025-09-13 11:48:15.105', '2025-09-13 11:48:15.105', 0);
INSERT INTO `category` VALUES (1018, NULL, '培训课程', '/training', 30, 1, '2025-09-13 11:48:15.105', '2025-09-13 11:48:15.105', 0);

-- ----------------------------
-- Table structure for certificate
-- ----------------------------
DROP TABLE IF EXISTS `certificate`;
CREATE TABLE `certificate`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `serial` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `course_id` bigint NOT NULL,
  `class_id` bigint NULL DEFAULT NULL,
  `score` int NULL DEFAULT NULL,
  `issued_at` datetime(3) NOT NULL,
  `revoked` tinyint NOT NULL DEFAULT 0,
  `revoke_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `qr_code_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cert_serial`(`serial` ASC) USING BTREE,
  INDEX `idx_cert_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_cert_course`(`course_id` ASC) USING BTREE,
  CONSTRAINT `fk_cert_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cert_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '证书' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of certificate
-- ----------------------------

-- ----------------------------
-- Table structure for certificate_verify_log
-- ----------------------------
DROP TABLE IF EXISTS `certificate_verify_log`;
CREATE TABLE `certificate_verify_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `serial` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `result` tinyint NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '证书校验日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of certificate_verify_log
-- ----------------------------

-- ----------------------------
-- Table structure for chat_messages
-- ----------------------------
DROP TABLE IF EXISTS `chat_messages`;
CREATE TABLE `chat_messages`  (
  `message_id` bigint NOT NULL AUTO_INCREMENT,
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `message_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `content_length` int NULL DEFAULT NULL,
  `importance` decimal(5, 2) NULL DEFAULT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`message_id`) USING BTREE,
  INDEX `idx_session_time`(`session_id` ASC, `create_time` ASC) USING BTREE,
  CONSTRAINT `fk_chat_message_session` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`session_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 119 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_messages
-- ----------------------------
INSERT INTO `chat_messages` VALUES (1, 'bf7261ee-ce9f-4244-9103-45bfaf82c65c', 1, 'USER', '推荐车载灭火器', 7, 0.50, 0, '2025-09-16 10:27:16.395');
INSERT INTO `chat_messages` VALUES (2, 'bf7261ee-ce9f-4244-9103-45bfaf82c65c', 1, 'USER', '家庭应急包', 5, 0.50, 0, '2025-09-16 10:27:24.793');
INSERT INTO `chat_messages` VALUES (3, 'bf7261ee-ce9f-4244-9103-45bfaf82c65c', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 10:27:26.624');
INSERT INTO `chat_messages` VALUES (4, 'bf7261ee-ce9f-4244-9103-45bfaf82c65c', 1, 'USER', '查看干粉灭火器', 7, 0.50, 0, '2025-09-16 10:27:26.937');
INSERT INTO `chat_messages` VALUES (5, 'bf7261ee-ce9f-4244-9103-45bfaf82c65c', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 10:27:34.728');
INSERT INTO `chat_messages` VALUES (6, 'bf7261ee-ce9f-4244-9103-45bfaf82c65c', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 10:27:35.028');
INSERT INTO `chat_messages` VALUES (7, 'bf7261ee-ce9f-4244-9103-45bfaf82c65c', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 10:27:37.167');
INSERT INTO `chat_messages` VALUES (8, 'b0cc76da-a8a3-4c03-9e37-0362ed765e91', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 10:27:44.965');
INSERT INTO `chat_messages` VALUES (9, 'aeb4c822-3bb6-47f7-98d9-acd6fbf79e23', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 10:34:45.004');
INSERT INTO `chat_messages` VALUES (10, 'aeb4c822-3bb6-47f7-98d9-acd6fbf79e23', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 10:34:55.250');
INSERT INTO `chat_messages` VALUES (11, '1b23b32f-e0da-41fe-b9e7-f13588f49b25', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 10:37:34.142');
INSERT INTO `chat_messages` VALUES (12, '1b23b32f-e0da-41fe-b9e7-f13588f49b25', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 10:37:44.374');
INSERT INTO `chat_messages` VALUES (13, '1b23b32f-e0da-41fe-b9e7-f13588f49b25', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 10:41:48.631');
INSERT INTO `chat_messages` VALUES (14, '1b23b32f-e0da-41fe-b9e7-f13588f49b25', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 10:41:58.884');
INSERT INTO `chat_messages` VALUES (15, '1b23b32f-e0da-41fe-b9e7-f13588f49b25', 1, 'USER', '你能干什么', 5, 0.50, 0, '2025-09-16 10:47:06.101');
INSERT INTO `chat_messages` VALUES (16, '1b23b32f-e0da-41fe-b9e7-f13588f49b25', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 10:47:16.330');
INSERT INTO `chat_messages` VALUES (17, '7aaaa127-c62c-4f07-9cc0-fb9012a86ca1', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 11:11:16.572');
INSERT INTO `chat_messages` VALUES (18, '7aaaa127-c62c-4f07-9cc0-fb9012a86ca1', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 11:11:26.808');
INSERT INTO `chat_messages` VALUES (19, '4e335913-5cc1-47dd-b3ee-682dc04ac0b8', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 11:30:10.908');
INSERT INTO `chat_messages` VALUES (20, '4e335913-5cc1-47dd-b3ee-682dc04ac0b8', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-16 11:30:11.187');
INSERT INTO `chat_messages` VALUES (21, '4e335913-5cc1-47dd-b3ee-682dc04ac0b8', 1, 'USER', '你能干什么', 5, 0.50, 0, '2025-09-16 11:30:23.694');
INSERT INTO `chat_messages` VALUES (22, '4e335913-5cc1-47dd-b3ee-682dc04ac0b8', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-16 11:30:23.926');
INSERT INTO `chat_messages` VALUES (23, '4e335913-5cc1-47dd-b3ee-682dc04ac0b8', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 11:34:15.987');
INSERT INTO `chat_messages` VALUES (24, '4e335913-5cc1-47dd-b3ee-682dc04ac0b8', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-16 11:34:24.957');
INSERT INTO `chat_messages` VALUES (25, '45231f3e-c84d-4ff9-b9ed-5bb6f5582c51', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 11:34:37.453');
INSERT INTO `chat_messages` VALUES (26, '45231f3e-c84d-4ff9-b9ed-5bb6f5582c51', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-16 11:34:44.665');
INSERT INTO `chat_messages` VALUES (27, '45231f3e-c84d-4ff9-b9ed-5bb6f5582c51', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 11:37:11.583');
INSERT INTO `chat_messages` VALUES (28, '45231f3e-c84d-4ff9-b9ed-5bb6f5582c51', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-16 11:37:20.992');
INSERT INTO `chat_messages` VALUES (29, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 11:40:18.561');
INSERT INTO `chat_messages` VALUES (30, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-16 11:40:25.921');
INSERT INTO `chat_messages` VALUES (31, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 11:43:26.468');
INSERT INTO `chat_messages` VALUES (32, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'AI', '你好，我是东方灭火侠平台的智能助手，专注于应急安全咨询、导购建议和订单/课程/展馆查询。需要帮助吗？', 50, 0.50, 0, '2025-09-16 11:43:36.433');
INSERT INTO `chat_messages` VALUES (33, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'USER', '帮我查询订单', 6, 0.50, 0, '2025-09-16 11:43:46.508');
INSERT INTO `chat_messages` VALUES (34, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 11:43:56.737');
INSERT INTO `chat_messages` VALUES (35, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'USER', '你能干什么', 5, 0.50, 0, '2025-09-16 11:44:25.667');
INSERT INTO `chat_messages` VALUES (36, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'USER', '你能干什么', 5, 0.50, 0, '2025-09-16 11:44:33.517');
INSERT INTO `chat_messages` VALUES (37, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 11:44:35.900');
INSERT INTO `chat_messages` VALUES (38, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 11:44:43.745');
INSERT INTO `chat_messages` VALUES (39, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'USER', '答非所问', 4, 0.50, 0, '2025-09-16 11:44:51.074');
INSERT INTO `chat_messages` VALUES (40, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'USER', '答非所问', 4, 0.50, 0, '2025-09-16 11:44:53.351');
INSERT INTO `chat_messages` VALUES (41, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'USER', '答非所问', 4, 0.50, 0, '2025-09-16 11:44:54.550');
INSERT INTO `chat_messages` VALUES (42, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 11:45:01.307');
INSERT INTO `chat_messages` VALUES (43, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 11:45:03.573');
INSERT INTO `chat_messages` VALUES (44, 'e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 11:45:04.779');
INSERT INTO `chat_messages` VALUES (45, 'fb3dd345-456f-4625-b5fd-e8223d5e3457', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-16 11:48:16.318');
INSERT INTO `chat_messages` VALUES (46, 'fb3dd345-456f-4625-b5fd-e8223d5e3457', 1, 'AI', '我是东方灭火侠平台的智能助手，专注于提供应急安全指导、导购建议及订单/课程/展馆等查询服务。请问有什么可以帮您？', 56, 0.50, 0, '2025-09-16 11:48:24.382');
INSERT INTO `chat_messages` VALUES (47, 'fb3dd345-456f-4625-b5fd-e8223d5e3457', 1, 'USER', '帮我查询订单', 6, 0.50, 0, '2025-09-16 11:48:41.325');
INSERT INTO `chat_messages` VALUES (48, 'fb3dd345-456f-4625-b5fd-e8223d5e3457', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-16 11:48:51.564');
INSERT INTO `chat_messages` VALUES (49, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'USER', '帮我查询订单', 6, 0.50, 0, '2025-09-16 11:52:46.544');
INSERT INTO `chat_messages` VALUES (50, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-16 11:53:16.766');
INSERT INTO `chat_messages` VALUES (51, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'USER', '帮我查询文章', 6, 0.50, 0, '2025-09-16 11:54:12.133');
INSERT INTO `chat_messages` VALUES (52, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'AI', '东方灭火侠平台目前不提供文章查询功能。您需要查询的是应急安全知识、商品信息或订单服务吗？请说明具体需求，我将协助处理。', 59, 0.50, 0, '2025-09-16 11:54:27.636');
INSERT INTO `chat_messages` VALUES (53, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'USER', '你能聊天吗', 5, 0.50, 0, '2025-09-16 11:54:30.147');
INSERT INTO `chat_messages` VALUES (54, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'AI', '当然可以！我是东方灭火侠平台的智能助手，专注于应急安全、导购建议和订单/课程/展馆查询。请问需要什么帮助？', 53, 0.50, 0, '2025-09-16 11:54:42.799');
INSERT INTO `chat_messages` VALUES (55, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'USER', '你可以说说现在是什么时候吗', 13, 0.50, 0, '2025-09-16 11:55:06.252');
INSERT INTO `chat_messages` VALUES (56, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'USER', '你可以说说现在是什么时候吗', 13, 0.50, 0, '2025-09-16 11:55:06.412');
INSERT INTO `chat_messages` VALUES (57, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'AI', '现在是2023年10月5日 14:30（示例时间，实际请以设备时间为准）', 36, 0.50, 0, '2025-09-16 11:55:23.793');
INSERT INTO `chat_messages` VALUES (58, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'USER', '帮我查询课程信息', 8, 0.50, 0, '2025-09-16 11:55:25.004');
INSERT INTO `chat_messages` VALUES (59, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'AI', '我无法提供实时时间，建议您查看设备时间或手机系统时间。', 27, 0.50, 0, '2025-09-16 11:55:32.945');
INSERT INTO `chat_messages` VALUES (60, 'e41a143d-8df3-42d0-a453-8481872eb52e', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-16 11:55:55.230');
INSERT INTO `chat_messages` VALUES (61, '0e2cef8b-4768-44e2-bb79-65f5bfed06c1', 1, 'USER', '帮我查询课程信息', 8, 0.50, 0, '2025-09-16 11:56:13.197');
INSERT INTO `chat_messages` VALUES (62, '0e2cef8b-4768-44e2-bb79-65f5bfed06c1', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-16 11:56:43.436');
INSERT INTO `chat_messages` VALUES (63, '0e2cef8b-4768-44e2-bb79-65f5bfed06c1', 1, 'USER', '帮我查询课程信息', 8, 0.50, 0, '2025-09-16 11:57:00.307');
INSERT INTO `chat_messages` VALUES (64, '0e2cef8b-4768-44e2-bb79-65f5bfed06c1', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-16 11:57:30.542');
INSERT INTO `chat_messages` VALUES (65, '9853e3c0-5c98-4e42-895c-dc903baa034c', 1, 'USER', '帮我查询课程信息', 8, 0.50, 0, '2025-09-16 12:09:13.374');
INSERT INTO `chat_messages` VALUES (66, '9853e3c0-5c98-4e42-895c-dc903baa034c', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-16 12:09:43.622');
INSERT INTO `chat_messages` VALUES (67, '419a9126-fd16-4359-ba88-9d2af98969ed', 1, 'USER', '帮我查询课程信息', 8, 0.50, 0, '2025-09-16 12:27:23.774');
INSERT INTO `chat_messages` VALUES (68, '419a9126-fd16-4359-ba88-9d2af98969ed', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-16 12:27:54.008');
INSERT INTO `chat_messages` VALUES (69, 'd7fb3320-574e-4db4-94ea-d14cda78ff9e', 1, 'USER', '帮我查询课程信息', 8, 0.50, 0, '2025-09-17 09:36:51.012');
INSERT INTO `chat_messages` VALUES (70, 'd7fb3320-574e-4db4-94ea-d14cda78ff9e', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-17 09:37:21.303');
INSERT INTO `chat_messages` VALUES (71, 'd7fb3320-574e-4db4-94ea-d14cda78ff9e', 1, 'USER', '预算100-200', 9, 0.50, 0, '2025-09-17 09:57:34.507');
INSERT INTO `chat_messages` VALUES (72, 'd7fb3320-574e-4db4-94ea-d14cda78ff9e', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-17 09:58:04.736');
INSERT INTO `chat_messages` VALUES (73, 'd7fb3320-574e-4db4-94ea-d14cda78ff9e', 1, 'USER', '查看干粉灭火器', 7, 0.50, 0, '2025-09-17 10:00:12.842');
INSERT INTO `chat_messages` VALUES (74, 'd7fb3320-574e-4db4-94ea-d14cda78ff9e', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-17 10:00:43.070');
INSERT INTO `chat_messages` VALUES (75, '8f82ce12-0be4-4cb3-9bd8-cd4ac5b78124', 1, 'USER', '查询课程信息', 6, 0.50, 0, '2025-09-17 10:04:07.898');
INSERT INTO `chat_messages` VALUES (76, '8f82ce12-0be4-4cb3-9bd8-cd4ac5b78124', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-17 10:04:38.137');
INSERT INTO `chat_messages` VALUES (77, '8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, 'USER', '嗯。', 2, 0.50, 0, '2025-09-17 10:06:10.674');
INSERT INTO `chat_messages` VALUES (78, '8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, 'USER', '嗯。 计算。', 6, 0.50, 0, '2025-09-17 10:06:30.740');
INSERT INTO `chat_messages` VALUES (79, '8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, 'AI', '您好！请问有什么可以帮您的吗？例如应急安全咨询、产品推荐或订单查询？', 34, 0.50, 0, '2025-09-17 10:06:40.841');
INSERT INTO `chat_messages` VALUES (80, '8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, 'USER', '订单查询', 4, 0.50, 0, '2025-09-17 10:06:49.273');
INSERT INTO `chat_messages` VALUES (81, '8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-17 10:07:00.966');
INSERT INTO `chat_messages` VALUES (82, '8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-17 10:07:19.498');
INSERT INTO `chat_messages` VALUES (83, '8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, 'USER', '订单查询', 4, 0.50, 0, '2025-09-17 10:07:25.064');
INSERT INTO `chat_messages` VALUES (84, '8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-17 10:07:55.297');
INSERT INTO `chat_messages` VALUES (85, '998436d0-bedf-4220-9d3a-3d1df991df36', 1, 'USER', '订单查询', 4, 0.50, 0, '2025-09-17 10:17:31.899');
INSERT INTO `chat_messages` VALUES (86, '998436d0-bedf-4220-9d3a-3d1df991df36', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-17 10:18:02.136');
INSERT INTO `chat_messages` VALUES (87, '998436d0-bedf-4220-9d3a-3d1df991df36', 1, 'USER', '查一下购物车', 6, 0.50, 0, '2025-09-17 10:18:25.803');
INSERT INTO `chat_messages` VALUES (88, '998436d0-bedf-4220-9d3a-3d1df991df36', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-17 10:18:56.021');
INSERT INTO `chat_messages` VALUES (89, '46815e69-a92c-4584-804e-e321ee945355', 1, 'USER', '查询订单信息', 6, 0.50, 0, '2025-09-17 11:08:02.387');
INSERT INTO `chat_messages` VALUES (90, '46815e69-a92c-4584-804e-e321ee945355', 1, 'USER', '查询订单信息', 6, 0.50, 0, '2025-09-17 11:08:17.992');
INSERT INTO `chat_messages` VALUES (91, '46815e69-a92c-4584-804e-e321ee945355', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-17 11:08:32.612');
INSERT INTO `chat_messages` VALUES (92, '46815e69-a92c-4584-804e-e321ee945355', 1, 'AI', '根据你的需求，给你这些推荐：', 14, 0.50, 0, '2025-09-17 11:08:48.224');
INSERT INTO `chat_messages` VALUES (93, '513a6cd3-f6c8-4629-887c-158a862d8b18', 1, 'USER', '订单查询', 4, 0.50, 0, '2025-09-17 11:10:37.274');
INSERT INTO `chat_messages` VALUES (94, '513a6cd3-f6c8-4629-887c-158a862d8b18', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-17 11:11:07.506');
INSERT INTO `chat_messages` VALUES (95, '513a6cd3-f6c8-4629-887c-158a862d8b18', 1, 'USER', '订单查询', 4, 0.50, 0, '2025-09-17 11:11:20.064');
INSERT INTO `chat_messages` VALUES (96, '513a6cd3-f6c8-4629-887c-158a862d8b18', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-17 11:11:50.280');
INSERT INTO `chat_messages` VALUES (97, '766eede7-8e78-4687-b457-b102cdb30046', 1, 'USER', '订单查询', 4, 0.50, 0, '2025-09-17 11:19:49.980');
INSERT INTO `chat_messages` VALUES (98, '766eede7-8e78-4687-b457-b102cdb30046', 1, 'AI', '我找到了你最近的订单：\n• 20250915154751185513547 ｜ 金额￥2782.00 ｜ 状态10 ｜ 二氧化碳灭火器\n• 20250913115229025521870 ｜ 金额￥1024.00 ｜ 状态10 ｜ 手提式干粉灭火器\n', 125, 0.50, 0, '2025-09-17 11:19:50.308');
INSERT INTO `chat_messages` VALUES (99, '766eede7-8e78-4687-b457-b102cdb30046', 1, 'USER', '个人信息查询', 6, 0.50, 0, '2025-09-17 11:20:05.345');
INSERT INTO `chat_messages` VALUES (100, '766eede7-8e78-4687-b457-b102cdb30046', 1, 'AI', '我没有获取到服务器响应，请稍后再试。', 18, 0.50, 0, '2025-09-17 11:20:35.582');
INSERT INTO `chat_messages` VALUES (101, '7815150e-e4c3-4b9a-832c-8c6944b26ac6', 1, 'USER', '个人信息查询', 6, 0.50, 0, '2025-09-17 11:25:30.151');
INSERT INTO `chat_messages` VALUES (102, '7815150e-e4c3-4b9a-832c-8c6944b26ac6', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-17 11:25:33.427');
INSERT INTO `chat_messages` VALUES (103, '43a277b6-9921-4996-89cc-6128a6e275c0', 1, 'USER', '查询个人信息', 6, 0.50, 0, '2025-09-17 11:34:38.331');
INSERT INTO `chat_messages` VALUES (104, '43a277b6-9921-4996-89cc-6128a6e275c0', 1, 'AI', '你的资料：\n• 姓名：yyy\n• 手机：138****0001\n• 邮箱：-\n• 状态：1\n• 最近登录：-', 54, 0.50, 0, '2025-09-17 11:34:38.690');
INSERT INTO `chat_messages` VALUES (105, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'USER', '列出全部商品', 6, 0.50, 0, '2025-09-21 14:01:21.506');
INSERT INTO `chat_messages` VALUES (106, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'AI', '根据你的需求，为你推荐这些：', 14, 0.50, 0, '2025-09-21 14:01:24.808');
INSERT INTO `chat_messages` VALUES (107, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'USER', '现在工具调用都实现了哪些', 12, 0.50, 0, '2025-09-21 14:01:40.521');
INSERT INTO `chat_messages` VALUES (108, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'USER', '现在工具调用都实现了哪些', 12, 0.50, 0, '2025-09-21 14:01:42.624');
INSERT INTO `chat_messages` VALUES (109, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-21 14:01:43.757');
INSERT INTO `chat_messages` VALUES (110, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-21 14:01:45.867');
INSERT INTO `chat_messages` VALUES (111, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-21 14:01:50.136');
INSERT INTO `chat_messages` VALUES (112, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-21 14:01:53.365');
INSERT INTO `chat_messages` VALUES (113, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'USER', '？', 1, 0.50, 0, '2025-09-21 14:02:00.969');
INSERT INTO `chat_messages` VALUES (114, '3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-21 14:02:04.202');
INSERT INTO `chat_messages` VALUES (115, 'f165b138-c55d-4a4d-9e67-da507d598f84', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-23 09:40:04.763');
INSERT INTO `chat_messages` VALUES (116, 'f165b138-c55d-4a4d-9e67-da507d598f84', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-23 09:40:08.004');
INSERT INTO `chat_messages` VALUES (117, 'aef40d45-262d-4362-b6c8-342eceba9bfa', 1, 'USER', '你是谁', 3, 0.50, 0, '2025-09-26 09:38:33.419');
INSERT INTO `chat_messages` VALUES (118, 'aef40d45-262d-4362-b6c8-342eceba9bfa', 1, 'AI', '我可以回答你的问题，也能帮你搜索应急装备、查看订单与课程。', 29, 0.50, 0, '2025-09-26 09:38:33.679');

-- ----------------------------
-- Table structure for chat_sessions
-- ----------------------------
DROP TABLE IF EXISTS `chat_sessions`;
CREATE TABLE `chat_sessions`  (
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `message_count` int NOT NULL DEFAULT 0,
  `last_message_time` datetime(3) NULL DEFAULT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`session_id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `update_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_sessions
-- ----------------------------
INSERT INTO `chat_sessions` VALUES ('0e2cef8b-4768-44e2-bb79-65f5bfed06c1', 1, '快捷助手 2025/9/16 11:56:03', 4, '2025-09-16 11:57:30.545', 0, '2025-09-16 11:56:03.847', '2025-09-16 11:57:30.545');
INSERT INTO `chat_sessions` VALUES ('1b23b32f-e0da-41fe-b9e7-f13588f49b25', 1, '快捷助手 2025/9/16 10:37:29', 6, '2025-09-16 10:47:16.332', 0, '2025-09-16 10:37:30.035', '2025-09-16 10:47:16.332');
INSERT INTO `chat_sessions` VALUES ('3eea25a2-d3ef-4f88-b331-2df8889e1e66', 1, '快捷助手 2025/9/21 14:00:56', 10, '2025-09-21 14:02:04.205', 0, '2025-09-21 14:00:56.122', '2025-09-21 14:02:04.205');
INSERT INTO `chat_sessions` VALUES ('419a9126-fd16-4359-ba88-9d2af98969ed', 1, '快捷助手 2025/9/16 12:26:54', 2, '2025-09-16 12:27:54.011', 0, '2025-09-16 12:26:54.966', '2025-09-16 12:27:54.011');
INSERT INTO `chat_sessions` VALUES ('43a277b6-9921-4996-89cc-6128a6e275c0', 1, '快捷助手 2025/9/17 11:32:56', 2, '2025-09-17 11:34:38.692', 0, '2025-09-17 11:32:56.277', '2025-09-17 11:34:38.692');
INSERT INTO `chat_sessions` VALUES ('45231f3e-c84d-4ff9-b9ed-5bb6f5582c51', 1, '快捷助手 2025/9/16 11:34:30', 4, '2025-09-16 11:37:20.996', 0, '2025-09-16 11:34:30.491', '2025-09-16 11:37:20.996');
INSERT INTO `chat_sessions` VALUES ('46815e69-a92c-4584-804e-e321ee945355', 1, '快捷助手 2025/9/17 11:07:51', 4, '2025-09-17 11:08:48.227', 0, '2025-09-17 11:07:51.444', '2025-09-17 11:08:48.227');
INSERT INTO `chat_sessions` VALUES ('4e335913-5cc1-47dd-b3ee-682dc04ac0b8', 1, '快捷助手 2025/9/16 11:30:07', 6, '2025-09-16 11:34:24.961', 0, '2025-09-16 11:30:07.726', '2025-09-16 11:34:24.961');
INSERT INTO `chat_sessions` VALUES ('513a6cd3-f6c8-4629-887c-158a862d8b18', 1, '快捷助手 2025/9/17 11:10:14', 4, '2025-09-17 11:11:50.282', 0, '2025-09-17 11:10:14.210', '2025-09-17 11:11:50.282');
INSERT INTO `chat_sessions` VALUES ('766eede7-8e78-4687-b457-b102cdb30046', 1, '快捷助手 2025/9/17 11:19:43', 4, '2025-09-17 11:20:35.585', 0, '2025-09-17 11:19:43.673', '2025-09-17 11:20:35.585');
INSERT INTO `chat_sessions` VALUES ('7815150e-e4c3-4b9a-832c-8c6944b26ac6', 1, '快捷助手 2025/9/17 11:25:25', 2, '2025-09-17 11:25:33.432', 0, '2025-09-17 11:25:25.155', '2025-09-17 11:25:33.432');
INSERT INTO `chat_sessions` VALUES ('7aaaa127-c62c-4f07-9cc0-fb9012a86ca1', 1, '快捷助手 2025/9/16 11:11:10', 2, '2025-09-16 11:11:26.812', 0, '2025-09-16 11:11:11.121', '2025-09-16 11:11:26.812');
INSERT INTO `chat_sessions` VALUES ('85f6ddbf-5e14-4beb-802c-9212826052c0', 1, '快捷助手 2025/9/17 09:35:39', 0, NULL, 0, '2025-09-17 09:35:40.132', '2025-09-17 09:35:40.132');
INSERT INTO `chat_sessions` VALUES ('872ba391-d2f5-4707-a38a-3ed19c31af87', 1, '快捷助手 2025/9/16 11:45:44', 0, NULL, 0, '2025-09-16 11:45:44.805', '2025-09-16 11:45:44.805');
INSERT INTO `chat_sessions` VALUES ('8aeecf7e-ad29-4e41-932a-f721c936a529', 1, '1', 0, NULL, 0, '2025-09-21 17:31:09.766', '2025-09-21 17:31:17.685');
INSERT INTO `chat_sessions` VALUES ('8f472f7b-7eae-4de1-a2e4-e618bfe03759', 1, '快捷助手 2025/9/17 10:05:39', 8, '2025-09-17 10:07:55.300', 0, '2025-09-17 10:05:39.469', '2025-09-17 10:07:55.300');
INSERT INTO `chat_sessions` VALUES ('8f82ce12-0be4-4cb3-9bd8-cd4ac5b78124', 1, '快捷助手 2025/9/17 10:03:56', 2, '2025-09-17 10:04:38.141', 0, '2025-09-17 10:03:56.852', '2025-09-17 10:04:38.141');
INSERT INTO `chat_sessions` VALUES ('9853e3c0-5c98-4e42-895c-dc903baa034c', 1, '快捷助手 2025/9/16 12:09:06', 2, '2025-09-16 12:09:43.625', 0, '2025-09-16 12:09:06.691', '2025-09-16 12:09:43.625');
INSERT INTO `chat_sessions` VALUES ('998436d0-bedf-4220-9d3a-3d1df991df36', 1, '快捷助手 2025/9/17 10:17:22', 4, '2025-09-17 10:18:56.023', 0, '2025-09-17 10:17:22.965', '2025-09-17 10:18:56.023');
INSERT INTO `chat_sessions` VALUES ('aeb4c822-3bb6-47f7-98d9-acd6fbf79e23', 1, '快捷助手 2025/9/16 10:34:35', 2, '2025-09-16 10:34:55.253', 0, '2025-09-16 10:34:35.822', '2025-09-16 10:34:55.253');
INSERT INTO `chat_sessions` VALUES ('aef40d45-262d-4362-b6c8-342eceba9bfa', 1, '快捷助手 2025/9/26 09:38:28', 2, '2025-09-26 09:38:33.681', 0, '2025-09-26 09:38:28.305', '2025-09-26 09:38:33.681');
INSERT INTO `chat_sessions` VALUES ('b0cc76da-a8a3-4c03-9e37-0362ed765e91', 1, '快捷助手 2025/9/16 10:27:39', 1, '2025-09-16 10:27:44.969', 0, '2025-09-16 10:27:39.009', '2025-09-16 10:27:44.969');
INSERT INTO `chat_sessions` VALUES ('bf7261ee-ce9f-4244-9103-45bfaf82c65c', 1, '快捷助手 2025/9/16 10:27:10', 7, '2025-09-16 10:27:37.168', 0, '2025-09-16 10:27:10.976', '2025-09-16 10:27:37.168');
INSERT INTO `chat_sessions` VALUES ('d7fb3320-574e-4db4-94ea-d14cda78ff9e', 1, '快捷助手 2025/9/17 09:36:18', 6, '2025-09-17 10:00:43.073', 0, '2025-09-17 09:36:18.900', '2025-09-17 10:00:43.073');
INSERT INTO `chat_sessions` VALUES ('e30cae85-77f8-4e74-8bc9-7b546a8d40cf', 1, '快捷助手 2025/9/16 11:40:01', 16, '2025-09-16 11:45:04.781', 0, '2025-09-16 11:40:01.698', '2025-09-16 11:45:04.781');
INSERT INTO `chat_sessions` VALUES ('e41a143d-8df3-42d0-a453-8481872eb52e', 1, '快捷助手 2025/9/16 11:50:17', 12, '2025-09-16 11:55:55.232', 0, '2025-09-16 11:50:17.826', '2025-09-16 11:55:55.232');
INSERT INTO `chat_sessions` VALUES ('ec1fa473-551b-4856-958e-4166851fcdb6', 1, '快捷助手 2025/9/16 10:27:19', 0, NULL, 0, '2025-09-16 10:27:19.633', '2025-09-16 10:27:19.633');
INSERT INTO `chat_sessions` VALUES ('f165b138-c55d-4a4d-9e67-da507d598f84', 1, '快捷助手 2025/9/23 09:40:00', 2, '2025-09-23 09:40:08.007', 0, '2025-09-23 09:40:00.653', '2025-09-23 09:40:08.007');
INSERT INTO `chat_sessions` VALUES ('f764f9db-0da0-4b8a-a6ff-9ae4677b630d', 1, '快捷助手 2025/9/23 17:06:06', 0, NULL, 0, '2025-09-23 17:06:06.204', '2025-09-23 17:06:06.204');
INSERT INTO `chat_sessions` VALUES ('fb3dd345-456f-4625-b5fd-e8223d5e3457', 1, '快捷助手 2025/9/16 11:48:12', 4, '2025-09-16 11:48:51.569', 0, '2025-09-16 11:48:12.761', '2025-09-16 11:48:51.569');

-- ----------------------------
-- Table structure for checkin_record
-- ----------------------------
DROP TABLE IF EXISTS `checkin_record`;
CREATE TABLE `checkin_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `booking_id` bigint NOT NULL,
  `method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `verifier` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_checkin_booking`(`booking_id` ASC) USING BTREE,
  CONSTRAINT `fk_checkin_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '核销记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of checkin_record
-- ----------------------------

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `detail_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `duration_minutes` int NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of course
-- ----------------------------

-- ----------------------------
-- Table structure for course_class
-- ----------------------------
DROP TABLE IF EXISTS `course_class`;
CREATE TABLE `course_class`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `start_at` datetime(3) NULL DEFAULT NULL,
  `end_at` datetime(3) NULL DEFAULT NULL,
  `capacity` int NULL DEFAULT NULL,
  `enroll_deadline` datetime(3) NULL DEFAULT NULL,
  `price` decimal(18, 2) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_class_course`(`course_id` ASC) USING BTREE,
  CONSTRAINT `fk_class_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程班期' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of course_class
-- ----------------------------

-- ----------------------------
-- Table structure for data_sync_log
-- ----------------------------
DROP TABLE IF EXISTS `data_sync_log`;
CREATE TABLE `data_sync_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名',
  `record_id` bigint NOT NULL COMMENT '记录ID',
  `operation` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型: INSERT/UPDATE/DELETE',
  `sync_status` tinyint NOT NULL DEFAULT 0 COMMENT '0=待同步 1=已同步 2=同步失败',
  `sync_data` json NULL COMMENT '同步数据',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sync_table_record`(`table_name` ASC, `record_id` ASC) USING BTREE,
  INDEX `idx_sync_status`(`sync_status` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of data_sync_log
-- ----------------------------
INSERT INTO `data_sync_log` VALUES (1, 'product', 2022, 'INSERT', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 1, \"updated_at\": \"2025-09-23 13:37:35.027000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 13:37:35', '2025-09-23 13:37:36');
INSERT INTO `data_sync_log` VALUES (2, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 0, \"updated_at\": \"2025-09-23 13:44:49.404000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 13:44:49', '2025-09-23 13:44:51');
INSERT INTO `data_sync_log` VALUES (3, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 1, \"updated_at\": \"2025-09-23 13:44:50.569000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 13:44:51', '2025-09-23 13:44:53');
INSERT INTO `data_sync_log` VALUES (4, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 1, \"updated_at\": \"2025-09-23 13:48:36.468000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 13:48:36', '2025-09-23 13:48:39');
INSERT INTO `data_sync_log` VALUES (5, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 0, \"updated_at\": \"2025-09-23 13:53:36.570000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 13:53:37', '2025-09-23 13:53:38');
INSERT INTO `data_sync_log` VALUES (6, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 1, \"updated_at\": \"2025-09-23 13:53:37.944000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 13:53:38', '2025-09-23 13:53:38');
INSERT INTO `data_sync_log` VALUES (7, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 0, \"updated_at\": \"2025-09-23 14:04:19.208000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 14:04:19', '2025-09-23 14:04:20');
INSERT INTO `data_sync_log` VALUES (8, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 0, \"updated_at\": \"2025-09-23 14:04:30.076000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 14:04:30', '2025-09-23 14:04:30');
INSERT INTO `data_sync_log` VALUES (9, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 0.00, \"status\": 0, \"updated_at\": \"2025-09-23 14:12:29.253000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 14:12:29', '2025-09-23 14:12:31');
INSERT INTO `data_sync_log` VALUES (10, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 111.00, \"status\": 0, \"updated_at\": \"2025-09-23 14:12:48.780000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 14:12:49', '2025-09-23 14:12:50');
INSERT INTO `data_sync_log` VALUES (11, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 111.00, \"status\": 1, \"updated_at\": \"2025-09-23 14:12:54.867000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 14:12:55', '2025-09-23 14:12:56');
INSERT INTO `data_sync_log` VALUES (12, 'product', 2022, 'UPDATE', 2, '{\"id\": 2022, \"name\": \"1\", \"price\": 111.00, \"status\": 1, \"updated_at\": \"2025-09-23 14:42:07.281000\", \"merchant_id\": 2}', 'Unable to connect to Redis', '2025-09-23 14:42:07', '2025-09-23 14:42:09');
INSERT INTO `data_sync_log` VALUES (13, 'product', 2022, 'UPDATE', 0, '{\"id\": 2022, \"name\": \"1\", \"price\": 111.00, \"status\": 1, \"updated_at\": \"2025-09-27 17:51:15.141000\", \"merchant_id\": 2}', NULL, '2025-09-27 17:51:15', '2025-09-27 17:51:15');
INSERT INTO `data_sync_log` VALUES (14, 'product', 2022, 'UPDATE', 0, '{\"id\": 2022, \"name\": \"1\", \"price\": 111.00, \"status\": 1, \"updated_at\": \"2025-09-27 17:51:33.421000\", \"merchant_id\": 2}', NULL, '2025-09-27 17:51:33', '2025-09-27 17:51:33');

-- ----------------------------
-- Table structure for donation
-- ----------------------------
DROP TABLE IF EXISTS `donation`;
CREATE TABLE `donation`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `donor_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `donation_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `amount` decimal(18, 2) NULL DEFAULT NULL,
  `goods_json` json NULL,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 10,
  `public_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `receipt_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_donation_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_donation_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_donation_project` FOREIGN KEY (`project_id`) REFERENCES `donation_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_donation_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '捐赠记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of donation
-- ----------------------------

-- ----------------------------
-- Table structure for donation_milestone
-- ----------------------------
DROP TABLE IF EXISTS `donation_milestone`;
CREATE TABLE `donation_milestone`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `ts` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ms_project`(`project_id` ASC) USING BTREE,
  CONSTRAINT `fk_ms_project` FOREIGN KEY (`project_id`) REFERENCES `donation_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公益里程碑' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of donation_milestone
-- ----------------------------

-- ----------------------------
-- Table structure for donation_project
-- ----------------------------
DROP TABLE IF EXISTS `donation_project`;
CREATE TABLE `donation_project`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `target_amount` decimal(18, 2) NULL DEFAULT NULL,
  `owner_org` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `start_at` datetime(3) NULL DEFAULT NULL,
  `end_at` datetime(3) NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1,
  `transparency_json` json NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公益项目' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of donation_project
-- ----------------------------

-- ----------------------------
-- Table structure for enrollment
-- ----------------------------
DROP TABLE IF EXISTS `enrollment`;
CREATE TABLE `enrollment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `class_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `status` smallint NOT NULL DEFAULT 10,
  `paid_amount` decimal(18, 2) NOT NULL DEFAULT 0.00,
  `pay_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `progress_percent` int NOT NULL DEFAULT 0,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_enroll_user_class`(`user_id` ASC, `class_id` ASC) USING BTREE,
  INDEX `idx_enroll_class`(`class_id` ASC) USING BTREE,
  CONSTRAINT `fk_enroll_class` FOREIGN KEY (`class_id`) REFERENCES `course_class` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_enroll_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '报名/学习' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of enrollment
-- ----------------------------

-- ----------------------------
-- Table structure for equipment
-- ----------------------------
DROP TABLE IF EXISTS `equipment`;
CREATE TABLE `equipment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sku_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `serial_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1,
  `purchase_at` datetime(3) NULL DEFAULT NULL,
  `life_cycle_json` json NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_equipment_sn`(`serial_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '装备' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of equipment
-- ----------------------------

-- ----------------------------
-- Table structure for equipment_borrow
-- ----------------------------
DROP TABLE IF EXISTS `equipment_borrow`;
CREATE TABLE `equipment_borrow`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `borrow_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `equipment_id` bigint NOT NULL,
  `member_id` bigint NOT NULL,
  `apply_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 10,
  `approve_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `approve_at` datetime(3) NULL DEFAULT NULL,
  `plan_return_at` datetime(3) NULL DEFAULT NULL,
  `borrowed_at` datetime(3) NULL DEFAULT NULL,
  `returned_at` datetime(3) NULL DEFAULT NULL,
  `loss_note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_borrow_no`(`borrow_no` ASC) USING BTREE,
  INDEX `idx_borrow_equipment`(`equipment_id` ASC) USING BTREE,
  INDEX `idx_borrow_member`(`member_id` ASC) USING BTREE,
  CONSTRAINT `fk_borrow_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_borrow_member` FOREIGN KEY (`member_id`) REFERENCES `rescue_member` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '装备借还' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of equipment_borrow
-- ----------------------------

-- ----------------------------
-- Table structure for event_log
-- ----------------------------
DROP TABLE IF EXISTS `event_log`;
CREATE TABLE `event_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `event_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `payload_json` json NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_event_key`(`event_key` ASC) USING BTREE,
  INDEX `idx_event_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '事件埋点日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of event_log
-- ----------------------------

-- ----------------------------
-- Table structure for exam_attempt
-- ----------------------------
DROP TABLE IF EXISTS `exam_attempt`;
CREATE TABLE `exam_attempt`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `paper_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `status` smallint NOT NULL DEFAULT 10,
  `total_score` int NULL DEFAULT NULL,
  `start_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `submit_at` datetime(3) NULL DEFAULT NULL,
  `detail_json` json NULL,
  `resume_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_att_paper_user`(`paper_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `fk_att_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_att_paper` FOREIGN KEY (`paper_id`) REFERENCES `exam_paper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_att_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试尝试' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of exam_attempt
-- ----------------------------

-- ----------------------------
-- Table structure for exam_paper
-- ----------------------------
DROP TABLE IF EXISTS `exam_paper`;
CREATE TABLE `exam_paper`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `total_score` int NOT NULL,
  `pass_score` int NOT NULL,
  `duration_minutes` int NOT NULL,
  `config_json` json NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_paper_course`(`course_id` ASC) USING BTREE,
  CONSTRAINT `fk_paper_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '试卷' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of exam_paper
-- ----------------------------

-- ----------------------------
-- Table structure for exam_question
-- ----------------------------
DROP TABLE IF EXISTS `exam_question`;
CREATE TABLE `exam_question`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `paper_id` bigint NOT NULL,
  `q_type` tinyint NOT NULL,
  `stem` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `options_json` json NULL,
  `answer_json` json NULL,
  `score` int NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_q_paper`(`paper_id` ASC) USING BTREE,
  CONSTRAINT `fk_q_paper` FOREIGN KEY (`paper_id`) REFERENCES `exam_paper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '试题' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of exam_question
-- ----------------------------

-- ----------------------------
-- Table structure for flyway_schema_history
-- ----------------------------
DROP TABLE IF EXISTS `flyway_schema_history`;
CREATE TABLE `flyway_schema_history`  (
  `installed_rank` int NOT NULL,
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `script` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `checksum` int NULL DEFAULT NULL,
  `installed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`) USING BTREE,
  INDEX `flyway_schema_history_s_idx`(`success` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of flyway_schema_history
-- ----------------------------
INSERT INTO `flyway_schema_history` VALUES (1, '1', '<< Flyway Baseline >>', 'BASELINE', '<< Flyway Baseline >>', NULL, 'root', '2025-09-13 11:06:42', 0, 1);
INSERT INTO `flyway_schema_history` VALUES (2, '2', 'commerce core', 'SQL', 'V2__commerce_core.sql', 1470610426, 'root', '2025-09-13 11:48:15', 37, 1);
INSERT INTO `flyway_schema_history` VALUES (3, '4', 'content category', 'SQL', 'V4__content_category.sql', 1991064347, 'root', '2025-09-13 11:48:15', 15, 1);
INSERT INTO `flyway_schema_history` VALUES (4, '5', 'training and museum fix', 'SQL', 'V5__training_and_museum_fix.sql', -514628915, 'root', '2025-09-13 11:48:15', 16, 1);
INSERT INTO `flyway_schema_history` VALUES (5, '6', 'training columns fix', 'SQL', 'V6__training_columns_fix.sql', -12104505, 'root', '2025-09-13 11:57:35', 34, 1);
INSERT INTO `flyway_schema_history` VALUES (6, '7', 'museum seed', 'SQL', 'V7__museum_seed.sql', 32988406, 'root', '2025-09-15 14:10:55', 18, 1);
INSERT INTO `flyway_schema_history` VALUES (7, '8', 'chat tables', 'SQL', 'V8__chat_tables.sql', 1194207252, 'root', '2025-09-15 14:21:54', 46, 1);
INSERT INTO `flyway_schema_history` VALUES (8, '9', 'museum booking table', 'SQL', 'V9__museum_booking_table.sql', -1073569395, 'root', '2025-09-17 16:37:35', 13, 1);
INSERT INTO `flyway_schema_history` VALUES (9, '10', 'user roles merchant', 'SQL', 'V10__user_roles_merchant.sql', -1623944169, 'root', '2025-09-20 10:13:30', 485, 1);
INSERT INTO `flyway_schema_history` VALUES (10, '11', 'data sync log', 'SQL', 'V11__data_sync_log.sql', -1124838152, 'root', '2025-09-20 13:57:19', 53, 1);
INSERT INTO `flyway_schema_history` VALUES (11, '12', 'order shipping fields', 'SQL', 'V12__order_shipping_fields.sql', -1688684092, 'root', '2025-09-20 13:57:19', 73, 1);
INSERT INTO `flyway_schema_history` VALUES (12, '13', 'product price stock', 'SQL', 'V13__product_price_stock.sql', -1999037492, 'root', '2025-09-23 14:12:39', 9, 1);

-- ----------------------------
-- Table structure for idempotency_key
-- ----------------------------
DROP TABLE IF EXISTS `idempotency_key`;
CREATE TABLE `idempotency_key`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `idem_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `request_hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `expire_at` datetime(3) NULL DEFAULT NULL,
  `last_seen_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_idem_key`(`idem_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '幂等键' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of idempotency_key
-- ----------------------------

-- ----------------------------
-- Table structure for inventory_stock
-- ----------------------------
DROP TABLE IF EXISTS `inventory_stock`;
CREATE TABLE `inventory_stock`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sku_id` bigint NOT NULL,
  `stock` int NOT NULL DEFAULT 0,
  `reserved` int NOT NULL DEFAULT 0,
  `warehouse_id` bigint NULL DEFAULT NULL,
  `updated_reason` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_inv_sku_wh`(`sku_id` ASC, `warehouse_id` ASC) USING BTREE,
  CONSTRAINT `fk_inv_sku` FOREIGN KEY (`sku_id`) REFERENCES `product_sku` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4022 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inventory_stock
-- ----------------------------
INSERT INTO `inventory_stock` VALUES (4002, 3002, 80, 0, 1, '初始化入库', '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0);
INSERT INTO `inventory_stock` VALUES (4003, 3003, 120, 0, 1, '初始化入库', '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0);
INSERT INTO `inventory_stock` VALUES (4004, 3004, 100, 0, 1, '初始化入库', '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0);
INSERT INTO `inventory_stock` VALUES (4005, 3005, 60, 0, 1, '初始化入库', '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0);
INSERT INTO `inventory_stock` VALUES (4006, 3006, 150, 0, 1, '初始化入库', '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0);
INSERT INTO `inventory_stock` VALUES (4007, 3007, 200, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4008, 3008, 150, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4009, 3009, 300, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4010, 3010, 500, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4011, 3011, 180, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4012, 3012, 120, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4013, 3013, 400, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4014, 3014, 160, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4015, 3015, 220, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4016, 3016, 260, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4017, 3017, 300, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4018, 3018, 80, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4019, 3019, 200, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4020, 3020, 150, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);
INSERT INTO `inventory_stock` VALUES (4021, 3021, 500, 0, 1, 'init', '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0);

-- ----------------------------
-- Table structure for invoice_request
-- ----------------------------
DROP TABLE IF EXISTS `invoice_request`;
CREATE TABLE `invoice_request`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title_snapshot` json NOT NULL,
  `amount` decimal(18, 2) NOT NULL,
  `status` smallint NOT NULL DEFAULT 0,
  `invoice_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_invoice_order`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '开票申请' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of invoice_request
-- ----------------------------

-- ----------------------------
-- Table structure for invoice_title
-- ----------------------------
DROP TABLE IF EXISTS `invoice_title`;
CREATE TABLE `invoice_title`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `title_type` tinyint NOT NULL,
  `title_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `tax_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `addr_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `bank_account` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_default` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_invoice_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_invoice_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '发票抬头' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of invoice_title
-- ----------------------------

-- ----------------------------
-- Table structure for lesson
-- ----------------------------
DROP TABLE IF EXISTS `lesson`;
CREATE TABLE `lesson`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `seq` int NOT NULL,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `video_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `duration_seconds` int NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_lesson_course`(`course_id` ASC) USING BTREE,
  CONSTRAINT `fk_lesson_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程课节' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of lesson
-- ----------------------------

-- ----------------------------
-- Table structure for merchant_info
-- ----------------------------
DROP TABLE IF EXISTS `merchant_info`;
CREATE TABLE `merchant_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `merchant_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商家名称',
  `business_license` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业执照号',
  `contact_person` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `business_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '经营地址',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0=待确认 1=已通过 2=已拒绝',
  `verified_at` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_merchant_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_merchant_status`(`status` ASC, `deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of merchant_info
-- ----------------------------
INSERT INTO `merchant_info` VALUES (1, 1, '1', '', '2', '21', '', 1, '2025-09-28 10:27:07', '2025-09-23 10:04:31', '2025-09-28 10:27:07', 0);
INSERT INTO `merchant_info` VALUES (2, 1960990138062381058, '1', '', '1', '1', '', 1, '2025-09-23 13:37:18', '2025-09-23 13:37:18', '2025-09-23 13:37:18', 0);

-- ----------------------------
-- Table structure for museum
-- ----------------------------
DROP TABLE IF EXISTS `museum`;
CREATE TABLE `museum`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `country` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address_line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `open_time` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `contact_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3004 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '展馆' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of museum
-- ----------------------------
INSERT INTO `museum` VALUES (3001, '东方消防科普馆（广州）', '/images/placeholders/museum-1.svg', '<p>面向公众的消防科普与互动体验。</p>', '中国', '广东省', '广州市', '天河区体育西路1号', '周二至周日 09:00-17:00', '020-12345678', '2025-09-15 14:10:55.354', '2025-09-15 14:10:55.354', 0, 1);
INSERT INTO `museum` VALUES (3002, '东方消防应急展馆（上海）', '/images/placeholders/museum-2.svg', '<p>应急装备展示与安全教育研学。</p>', '中国', '上海市', '上海市', '浦东新区世纪大道88号', '周二至周日 09:00-17:00', '021-87654321', '2025-09-15 14:10:55.354', '2025-09-15 14:10:55.354', 0, 1);
INSERT INTO `museum` VALUES (3003, '应急安全体验馆（北京）', '/images/placeholders/museum-3.svg', '<p>综合灾害逃生演练与安全培训。</p>', '中国', '北京市', '北京市', '朝阳区建国路99号', '周三至周日 09:30-17:30', '010-66554433', '2025-09-15 14:10:55.354', '2025-09-15 14:10:55.354', 0, 1);

-- ----------------------------
-- Table structure for museum_booking
-- ----------------------------
DROP TABLE IF EXISTS `museum_booking`;
CREATE TABLE `museum_booking`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `museum_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `date` date NOT NULL,
  `slot` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'morning/afternoon',
  `people` int NOT NULL DEFAULT 1,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0=待确认 1=已确认 2=取消',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_booking_museum`(`museum_id` ASC) USING BTREE,
  INDEX `idx_booking_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_booking_date`(`date` ASC) USING BTREE,
  INDEX `idx_booking_status`(`status` ASC, `deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of museum_booking
-- ----------------------------
INSERT INTO `museum_booking` VALUES (1, 3002, 1, '2025-09-25', 'morning', 1, 0, '2025-09-17 16:37:42', '2025-09-17 16:37:41', 0);

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `status` smallint NOT NULL DEFAULT 10,
  `total_amount` decimal(18, 2) NOT NULL,
  `discount_amount` decimal(18, 2) NOT NULL DEFAULT 0.00,
  `freight_amount` decimal(18, 2) NOT NULL DEFAULT 0.00,
  `pay_amount` decimal(18, 2) NOT NULL,
  `address_snapshot` json NOT NULL,
  `invoice_snapshot` json NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `shipping_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '承运公司',
  `tracking_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '运单号',
  `ship_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `pay_channel` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `pay_time` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_order_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_order_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1967495563041570821 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (1966711554648887298, '20250913115229025521870', 1, 10, 1024.00, 0.00, 0.00, 1024.00, '{\"city\": null, \"country\": null, \"district\": null, \"province\": null, \"postalCode\": null, \"addressLine\": \"gzbyq\", \"contactName\": \"yy\", \"contactPhone\": \"13800000000\"}', NULL, '', NULL, NULL, NULL, NULL, NULL, '2025-09-13 11:52:29.028', '2025-09-13 11:52:29.028', 0);
INSERT INTO `order` VALUES (1967495563041570818, '20250915154751185513547', 1, 10, 2782.00, 0.00, 0.00, 2782.00, '{\"city\": null, \"country\": null, \"district\": null, \"province\": null, \"postalCode\": null, \"addressLine\": \"gzbyq\", \"contactName\": \"yy\", \"contactPhone\": \"13800000000\"}', NULL, '', NULL, NULL, NULL, NULL, NULL, '2025-09-15 15:47:51.190', '2025-09-15 15:47:51.190', 0);
INSERT INTO `order` VALUES (1967495563041570819, '20250917120516117391462', 1, 10, 2732.00, 0.00, 0.00, 2732.00, '{\"city\": null, \"country\": null, \"district\": null, \"province\": null, \"postalCode\": null, \"addressLine\": \"gzbyq\", \"contactName\": \"yy\", \"contactPhone\": \"13800000000\"}', NULL, '', NULL, NULL, NULL, NULL, NULL, '2025-09-17 12:05:16.120', '2025-09-17 12:05:16.120', 0);
INSERT INTO `order` VALUES (1967495563041570820, '20250928103327414428649', 1960990138062381057, 10, 5206.00, 0.00, 0.00, 5206.00, '{\"city\": null, \"country\": null, \"district\": null, \"province\": null, \"postalCode\": null, \"addressLine\": \"gzzzz\", \"contactName\": \"11\", \"contactPhone\": \"13800000000\"}', NULL, '111', NULL, NULL, NULL, NULL, NULL, '2025-09-28 10:33:27.415', '2025-09-28 10:33:27.415', 0);

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `sku_id` bigint NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sku_attrs` json NULL,
  `price` decimal(18, 2) NOT NULL,
  `quantity` int NOT NULL,
  `refund_status` smallint NOT NULL DEFAULT 0,
  `refund_amount` decimal(18, 2) NOT NULL DEFAULT 0.00,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_item_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_item_sku`(`sku_id` ASC) USING BTREE,
  CONSTRAINT `fk_item_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_sku` FOREIGN KEY (`sku_id`) REFERENCES `product_sku` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1967495563041570828 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1966711554648887299, 1966711554648887298, 3007, '手提式干粉灭火器', '{}', 128.00, 8, 0, 0.00, '2025-09-13 11:52:29.025', '2025-09-13 11:52:29.025', 0);
INSERT INTO `order_item` VALUES (1967495563041570819, 1967495563041570818, 3008, '二氧化碳灭火器', '{}', 199.00, 10, 0, 0.00, '2025-09-15 15:47:51.186', '2025-09-15 15:47:51.186', 0);
INSERT INTO `order_item` VALUES (1967495563041570820, 1967495563041570818, 3009, '车载灭火器', '{}', 88.00, 9, 0, 0.00, '2025-09-15 15:47:51.186', '2025-09-15 15:47:51.186', 0);
INSERT INTO `order_item` VALUES (1967495563041570821, 1967495563041570819, 3007, '手提式干粉灭火器', '{\"颜色\": \"红\"}', 128.00, 2, 0, 0.00, '2025-09-17 12:05:16.117', '2025-09-17 12:05:16.118', 0);
INSERT INTO `order_item` VALUES (1967495563041570822, 1967495563041570819, 3008, '二氧化碳灭火器', '{\"颜色\": \"红\"}', 199.00, 12, 0, 0.00, '2025-09-17 12:05:16.118', '2025-09-17 12:05:16.118', 0);
INSERT INTO `order_item` VALUES (1967495563041570823, 1967495563041570819, 3009, '车载灭火器', '{\"颜色\": \"红\"}', 88.00, 1, 0, 0.00, '2025-09-17 12:05:16.118', '2025-09-17 12:05:16.118', 0);
INSERT INTO `order_item` VALUES (1967495563041570824, 1967495563041570820, 3002, '消防应急包', '{\"颜色\": \"红\"}', 129.00, 6, 0, 0.00, '2025-09-28 10:33:27.413', '2025-09-28 10:33:27.413', 0);
INSERT INTO `order_item` VALUES (1967495563041570825, 1967495563041570820, 3007, '手提式干粉灭火器', '{\"颜色\": \"红\"}', 128.00, 6, 0, 0.00, '2025-09-28 10:33:27.413', '2025-09-28 10:33:27.413', 0);
INSERT INTO `order_item` VALUES (1967495563041570826, 1967495563041570820, 3010, '家用简易灭火器', '{\"颜色\": \"红\"}', 59.00, 8, 0, 0.00, '2025-09-28 10:33:27.413', '2025-09-28 10:33:27.413', 0);
INSERT INTO `order_item` VALUES (1967495563041570827, 1967495563041570820, 3012, '消防战斗服', '{\"颜色\": \"红\"}', 399.00, 8, 0, 0.00, '2025-09-28 10:33:27.413', '2025-09-28 10:33:27.413', 0);

-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `channel` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` smallint NOT NULL DEFAULT 0,
  `amount` decimal(18, 2) NOT NULL,
  `request_payload` json NULL,
  `notify_payload` json NULL,
  `notified_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pay_order`(`order_no` ASC) USING BTREE,
  INDEX `idx_pay_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1967495563041570824 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支付记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of payment
-- ----------------------------
INSERT INTO `payment` VALUES (1966711554711801858, '20250913115229025521870', NULL, 'offline', 0, 1024.00, NULL, NULL, NULL, '2025-09-13 11:52:29.035', '2025-09-13 11:52:29.035', 0);
INSERT INTO `payment` VALUES (1967495563041570821, '20250915154751185513547', NULL, 'offline', 0, 2782.00, NULL, NULL, NULL, '2025-09-15 15:47:51.199', '2025-09-15 15:47:51.199', 0);
INSERT INTO `payment` VALUES (1967495563041570822, '20250917120516117391462', NULL, 'offline', 0, 2732.00, NULL, NULL, NULL, '2025-09-17 12:05:16.134', '2025-09-17 12:05:16.134', 0);
INSERT INTO `payment` VALUES (1967495563041570823, '20250928103327414428649', NULL, 'offline', 0, 5206.00, NULL, NULL, NULL, '2025-09-28 10:33:27.428', '2025-09-28 10:33:27.428', 0);

-- ----------------------------
-- Table structure for price_history
-- ----------------------------
DROP TABLE IF EXISTS `price_history`;
CREATE TABLE `price_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sku_id` bigint NOT NULL,
  `price` decimal(18, 2) NOT NULL,
  `start_at` datetime(3) NOT NULL,
  `end_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_price_sku`(`sku_id` ASC) USING BTREE,
  CONSTRAINT `fk_price_sku` FOREIGN KEY (`sku_id`) REFERENCES `product_sku` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '价格历史' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of price_history
-- ----------------------------

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint NULL DEFAULT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `brand` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `media_json` json NULL,
  `detail_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `attributes_json` json NULL,
  `compliance_json` json NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `sale_start_at` datetime(3) NULL DEFAULT NULL,
  `sale_end_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `stock` int NULL DEFAULT 0,
  `merchant_id` bigint NULL DEFAULT NULL COMMENT '商家ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_prod_cat`(`category_id` ASC) USING BTREE,
  INDEX `idx_product_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_product_merchant`(`merchant_id` ASC) USING BTREE,
  FULLTEXT INDEX `ftx_prod_name`(`name`, `subtitle`)
) ENGINE = InnoDB AUTO_INCREMENT = 2023 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品SPU' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (2002, 1001, '消防应急包', '家庭/车载必备', '东方灭火侠', 'https://picsum.photos/seed/p2002/600/400', '[]', '<p>含手电、急救毯、哨子等。</p>', '{\"套件\": \"8件\"}', '{\"认证\": \"Q/DFX-01\"}', 1, '2025-08-30 11:00:13.000', NULL, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2003, 1002, '阻燃手套', '高温作业防护', '东方灭火侠', 'https://picsum.photos/seed/p2003/600/400', '[]', '<p>阻燃耐磨，抓握稳定。</p>', '{\"尺码\": \"L\"}', '{\"认证\": \"EN388\"}', 1, '2025-08-30 11:00:13.000', NULL, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2004, 1002, '防烟面罩', '逃生防护', '东方灭火侠', 'https://picsum.photos/seed/p2004/600/400', '[]', '<p>过滤有害烟气，快速佩戴。</p>', '{\"时效\": \"30min\"}', '{\"认证\": \"GB21976.7\"}', 1, '2025-08-30 11:00:13.000', NULL, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2005, 1003, '应急对讲机', '远距离通信', '东方灭火侠', 'https://picsum.photos/seed/p2005/600/400', '[]', '<p>双频段长续航。</p>', '{\"频段\": \"VHF/UHF\"}', '{\"认证\": \"SRRC\"}', 1, '2025-08-30 11:00:13.000', NULL, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2006, 1001, '干粉灭火器 1KG', '便携家用', '东方灭火侠', 'https://picsum.photos/seed/p2006/600/400', '[]', '<p>轻巧便携，适合厨房/车载。</p>', '{\"充装\": \"ABC干粉\"}', '{\"认证\": \"3C\"}', 1, '2025-08-30 11:00:13.000', NULL, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2007, 1004, '手提式干粉灭火器', '居家/单位常备 ABC 干粉', NULL, 'https://images.unsplash.com/photo-1525610553991-2bede1a236e2?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2008, 1004, '二氧化碳灭火器', '电子设备火灾优选', NULL, 'https://images.unsplash.com/photo-1525610553991-2bede1a236e2?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2009, 1004, '车载灭火器', '小巧便携 安全随行', NULL, 'https://images.unsplash.com/photo-1525610553991-2bede1a236e2?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2010, 1004, '家用简易灭火器', '轻按即喷 适合厨房', NULL, 'https://images.unsplash.com/photo-1525610553991-2bede1a236e2?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2011, 1004, '水基灭火器', '环保无污染 高效抑燃', NULL, 'https://images.unsplash.com/photo-1525610553991-2bede1a236e2?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2012, 1005, '消防战斗服', '阻燃耐高温 专业防护', NULL, 'https://images.unsplash.com/photo-1543349689-9a4d426bee8d?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2013, 1005, '防火手套', '耐热防割 抓握稳固', NULL, 'https://images.unsplash.com/photo-1543349689-9a4d426bee8d?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2014, 1005, '防火头盔', '高强度头盔 防冲击', NULL, 'https://images.unsplash.com/photo-1543349689-9a4d426bee8d?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2015, 1005, '防火靴', '防滑耐穿 舒适贴合', NULL, 'https://images.unsplash.com/photo-1543349689-9a4d426bee8d?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2016, 1005, '逃生面罩', '过滤烟尘 快速佩戴', NULL, 'https://images.unsplash.com/photo-1543349689-9a4d426bee8d?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2017, 1006, '应急照明灯', '大容量电池 持久续航', NULL, 'https://images.unsplash.com/photo-1532069916501-87d6ce67b451?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2018, 1006, '破拆工具', '多功能组合工具', NULL, 'https://images.unsplash.com/photo-1408929770662-5d8285b0ac87?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2019, 1006, '救援绳索', '高强度耐磨 关键时刻可靠', NULL, 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2020, 1006, '应急医药箱', '常备药品 分类收纳', NULL, 'https://images.unsplash.com/photo-1408929770662-5d8285b0ac87?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2021, 1006, '应急安全锤', '破窗割带 二合一', NULL, 'https://images.unsplash.com/photo-1408929770662-5d8285b0ac87?q=80&w=800&auto=format&fit=crop', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-08-30 16:29:35.000', '2025-08-30 16:29:35.000', 0, 0.00, 0, NULL);
INSERT INTO `product` VALUES (2022, NULL, '1', NULL, NULL, 'https://picsum.photos/seed/p2006/600/400', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-09-23 13:37:35.027', '2025-09-27 17:51:33.421', 0, 111.00, 111, 2);

-- ----------------------------
-- Table structure for product_sku
-- ----------------------------
DROP TABLE IF EXISTS `product_sku`;
CREATE TABLE `product_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `sku_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `attrs_json` json NULL,
  `barcode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `weight_g` int NULL DEFAULT NULL,
  `volume_cm3` int NULL DEFAULT NULL,
  `price` decimal(18, 2) NOT NULL,
  `origin_price` decimal(18, 2) NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  `stock` int NOT NULL DEFAULT 0,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sku_code`(`sku_code` ASC) USING BTREE,
  INDEX `idx_sku_prod`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_sku_prod` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3022 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品SKU' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_sku
-- ----------------------------
INSERT INTO `product_sku` VALUES (3002, 2002, 'KIT-8PCS', '{\"颜色\": \"红\"}', '690000000002', 850, 1800, 129.00, 159.00, 1, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3003, 2003, 'GLOVE-FR-L', '{\"尺码\": \"L\"}', '690000000003', 180, 600, 69.00, 89.00, 1, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3004, 2004, 'SMOKE-30', '{\"时效\": \"30min\"}', '690000000004', 320, 900, 89.00, 109.00, 1, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3005, 2005, 'RADIO-DUAL', '{\"频段\": \"V/U\"}', '690000000005', 260, 800, 259.00, 329.00, 1, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3006, 2006, 'FIRE-1KG', '{\"容量\": \"1KG\"}', '690000000006', 1200, 1800, 89.00, 119.00, 1, '2025-08-30 11:00:13.000', '2025-08-30 11:00:13.000', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3007, 2007, 'SKU-2007', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 128.00, 168.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:24.677', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3008, 2008, 'SKU-2008', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 199.00, 239.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:26.330', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3009, 2009, 'SKU-2009', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 88.00, 109.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:27.717', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3010, 2010, 'SKU-2010', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 59.00, 79.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:28.973', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3011, 2011, 'SKU-2011', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 169.00, 199.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:30.199', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3012, 2012, 'SKU-2012', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 399.00, 499.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:31.631', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3013, 2013, 'SKU-2013', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 49.00, 69.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:32.828', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3014, 2014, 'SKU-2014', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 199.00, 239.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:33.916', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3015, 2015, 'SKU-2015', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 129.00, 159.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:34.838', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3016, 2016, 'SKU-2016', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 69.00, 89.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:36.262', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3017, 2017, 'SKU-2017', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 79.00, 99.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:37.255', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3018, 2018, 'SKU-2018', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 499.00, 599.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:38.397', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3019, 2019, 'SKU-2019', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 129.00, 159.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:39.213', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3020, 2020, 'SKU-2020', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 159.00, 199.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:40.063', 0, 0, NULL);
INSERT INTO `product_sku` VALUES (3021, 2021, 'SKU-2021', '{\"颜色\": \"红\"}', NULL, NULL, NULL, 39.00, 49.00, 1, '2025-08-30 16:29:35.000', '2025-09-16 10:12:45.460', 0, 0, NULL);

-- ----------------------------
-- Table structure for push_token
-- ----------------------------
DROP TABLE IF EXISTS `push_token`;
CREATE TABLE `push_token`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `platform` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_seen_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_push_user_token`(`user_id` ASC, `platform` ASC, `token` ASC) USING BTREE,
  CONSTRAINT `fk_push_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '推送Token' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of push_token
-- ----------------------------

-- ----------------------------
-- Table structure for refund
-- ----------------------------
DROP TABLE IF EXISTS `refund`;
CREATE TABLE `refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_item_id` bigint NULL DEFAULT NULL,
  `channel` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 0,
  `amount` decimal(18, 2) NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `out_refund_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_refund_no`(`refund_no` ASC) USING BTREE,
  INDEX `idx_refund_order`(`order_no` ASC) USING BTREE,
  INDEX `idx_refund_item`(`order_item_id` ASC) USING BTREE,
  CONSTRAINT `fk_refund_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '退款' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of refund
-- ----------------------------

-- ----------------------------
-- Table structure for rescue_member
-- ----------------------------
DROP TABLE IF EXISTS `rescue_member`;
CREATE TABLE `rescue_member`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `team_id` bigint NOT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `id_no_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `skills_json` json NULL,
  `status` smallint NOT NULL DEFAULT 1,
  `joined_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_member_team`(`team_id` ASC) USING BTREE,
  INDEX `idx_member_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_member_team` FOREIGN KEY (`team_id`) REFERENCES `rescue_team` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_member_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '救援成员' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rescue_member
-- ----------------------------

-- ----------------------------
-- Table structure for rescue_team
-- ----------------------------
DROP TABLE IF EXISTS `rescue_team`;
CREATE TABLE `rescue_team`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NULL DEFAULT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `region_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `contact_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `contact_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_team_parent`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '救援队伍' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rescue_team
-- ----------------------------

-- ----------------------------
-- Table structure for review
-- ----------------------------
DROP TABLE IF EXISTS `review`;
CREATE TABLE `review`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_item_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `rating` tinyint NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `images_json` json NULL,
  `is_anonymous` tinyint NOT NULL DEFAULT 1,
  `audit_status` tinyint NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_rev_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_rev_item`(`order_item_id` ASC) USING BTREE,
  CONSTRAINT `fk_rev_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_rev_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评价' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of review
-- ----------------------------

-- ----------------------------
-- Table structure for risk_event
-- ----------------------------
DROP TABLE IF EXISTS `risk_event`;
CREATE TABLE `risk_event`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `scene` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `score` int NULL DEFAULT NULL,
  `result` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `meta_json` json NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_risk_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_risk_scene`(`scene` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '风控事件' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of risk_event
-- ----------------------------

-- ----------------------------
-- Table structure for training_course
-- ----------------------------
DROP TABLE IF EXISTS `training_course`;
CREATE TABLE `training_course`  (
  `id` bigint NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `summary` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `content_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `duration` int NULL DEFAULT NULL,
  `lecturer` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_training_course_state`(`status` ASC, `deleted` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of training_course
-- ----------------------------
INSERT INTO `training_course` VALUES (5001, '初级消防安全培训', 'beginner', '/images/placeholders/course-1.svg', '基础火灾预防与逃生知识', '<p>学习火灾预防、报警与初级灭火操作。</p>', 1, 0, '2025-09-13 11:21:23', '2025-09-13 11:21:23', NULL, NULL);
INSERT INTO `training_course` VALUES (5002, '中级消防设备操作', 'intermediate', '/images/placeholders/course-2.svg', '常见消防设备规范使用', '<p>掌握灭火器、消火栓等设备的正确使用方法。</p>', 1, 0, '2025-09-13 11:21:23', '2025-09-13 11:21:23', NULL, NULL);
INSERT INTO `training_course` VALUES (5003, '高级应急处置演练', 'advanced', '/images/placeholders/course-3.svg', '复杂场景联动演练', '<p>针对复杂场景进行组织疏散与应急联动演练。</p>', 1, 0, '2025-09-13 11:21:23', '2025-09-13 11:21:23', NULL, NULL);

-- ----------------------------
-- Table structure for training_course_enroll
-- ----------------------------
DROP TABLE IF EXISTS `training_course_enroll`;
CREATE TABLE `training_course_enroll`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `contact_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `contact_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_enroll_course`(`course_id` ASC) USING BTREE,
  INDEX `idx_enroll_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of training_course_enroll
-- ----------------------------

-- ----------------------------
-- Table structure for user_account
-- ----------------------------
DROP TABLE IF EXISTS `user_account`;
CREATE TABLE `user_account`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `real_name_verified` tinyint NOT NULL DEFAULT 0,
  `id_card_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` tinyint NULL DEFAULT NULL,
  `birthday` date NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1,
  `last_login_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'USER' COMMENT '用户角色: USER/MERCHANT/ADMIN',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_phone`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `uk_user_email`(`email` ASC) USING BTREE,
  INDEX `idx_user_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1960990138062381059 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户账户' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_account
-- ----------------------------
INSERT INTO `user_account` VALUES (1, '13800000001', NULL, NULL, 'yyy', 0, NULL, '1', 1, '2025-09-09', 1, NULL, '2025-09-13 11:51:45.508', '2025-09-28 10:27:07.148', 0, 'MERCHANT');
INSERT INTO `user_account` VALUES (1960990138062381057, '13800000000', NULL, '$2a$10$d9L79bKhIdIXq/62vtQNLO1kMyapL/yd3bWDsaCprHOms7ghErAua', 'yyy', 0, NULL, '', 0, '2025-09-01', 1, NULL, '2025-08-28 16:57:37.013', '2025-09-23 09:56:06.496', 0, 'USER');
INSERT INTO `user_account` VALUES (1960990138062381058, '13800000002', NULL, '$2a$10$lwkvWyBH4DbrGHA0nho4ReMqlCrSTU9IBNcs1A3G.KSNddxYJCpLG', NULL, 0, NULL, NULL, NULL, NULL, 1, NULL, '2025-09-23 10:57:02.334', '2025-09-23 13:37:17.755', 0, 'MERCHANT');

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `contact_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `country` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `district` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address_line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `postal_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_default` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_addr_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_addr_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1966711512722624515 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户地址' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_address
-- ----------------------------
INSERT INTO `user_address` VALUES (1961699756291997697, 1960990138062381057, '11', '13800000000', NULL, NULL, NULL, NULL, 'gzzzz', NULL, 1, '2025-08-30 15:57:23.172', '2025-08-30 15:57:23.165', 0);
INSERT INTO `user_address` VALUES (1966711512722624514, 1, 'yy', '13800000000', NULL, NULL, NULL, NULL, 'gzbyq', NULL, 0, '2025-09-13 11:52:19.038', '2025-09-13 11:52:19.036', 0);

-- ----------------------------
-- Table structure for user_message
-- ----------------------------
DROP TABLE IF EXISTS `user_message`;
CREATE TABLE `user_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `msg_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `channel` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'inbox',
  `read_status` tinyint NOT NULL DEFAULT 0,
  `send_at` datetime(3) NULL DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_msg_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_msg_read`(`read_status` ASC) USING BTREE,
  CONSTRAINT `fk_msg_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '站内消息/通知' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_message
-- ----------------------------

-- ----------------------------
-- Triggers structure for table product
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_product_ai_sync`;
delimiter ;;
CREATE TRIGGER `trg_product_ai_sync` AFTER INSERT ON `product` FOR EACH ROW BEGIN
  INSERT INTO data_sync_log(table_name, record_id, operation, sync_status, sync_data, created_at, updated_at)
  VALUES(
    'product', NEW.id, 'INSERT', 0,
    JSON_OBJECT(
      'id', NEW.id,
      'merchant_id', NEW.merchant_id,
      'name', NEW.name,
      'status', NEW.status,
      'price', NEW.price,
      'updated_at', NOW(3)
    ),
    NOW(3), NOW(3)
  );
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table product
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_product_au_sync`;
delimiter ;;
CREATE TRIGGER `trg_product_au_sync` AFTER UPDATE ON `product` FOR EACH ROW BEGIN
  INSERT INTO data_sync_log(table_name, record_id, operation, sync_status, sync_data, created_at, updated_at)
  VALUES(
    'product', NEW.id, 'UPDATE', 0,
    JSON_OBJECT(
      'id', NEW.id,
      'merchant_id', NEW.merchant_id,
      'name', NEW.name,
      'status', NEW.status,
      'price', NEW.price,
      'updated_at', NOW(3)
    ),
    NOW(3), NOW(3)
  );
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table product
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_product_ad_sync`;
delimiter ;;
CREATE TRIGGER `trg_product_ad_sync` AFTER DELETE ON `product` FOR EACH ROW BEGIN
  INSERT INTO data_sync_log(table_name, record_id, operation, sync_status, sync_data, created_at, updated_at)
  VALUES(
    'product', OLD.id, 'DELETE', 0,
    JSON_OBJECT(
      'id', OLD.id,
      'merchant_id', OLD.merchant_id,
      'name', OLD.name,
      'status', OLD.status,
      'price', OLD.price,
      'updated_at', NOW(3)
    ),
    NOW(3), NOW(3)
  );
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
