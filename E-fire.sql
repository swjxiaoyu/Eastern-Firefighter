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

-- 更多表结构请参考完整的 E-fire.sql 文件
-- 这是一个简化的示例，实际项目包含完整的数据库结构

SET FOREIGN_KEY_CHECKS = 1;