/*
 Navicat Premium Data Transfer

 Source Server         : 系统
 Source Server Type    : MySQL
 Source Server Version : 50717
 Source Host           : localhost:3306
 Source Schema         : syshotelappoint

 Target Server Type    : MySQL
 Target Server Version : 50717
 File Encoding         : 65001

 Date: 28/07/2025 09:54:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for appoint
-- ----------------------------
DROP TABLE IF EXISTS `appoint`;
CREATE TABLE `appoint`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '预约记录主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `ToUserId` int(11) NULL DEFAULT NULL COMMENT '下单账号',
  `TotalPeopleNum` int(11) NULL DEFAULT NULL COMMENT '总人数',
  `CommentScore` double(20, 8) NULL DEFAULT NULL COMMENT '评分',
  `Comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '评价',
  `No` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '编号',
  `Qty` int(11) NULL DEFAULT NULL COMMENT '数量',
  `BeginAppointTime` datetime(0) NULL DEFAULT NULL COMMENT '起始预约时间',
  `PayType` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付方式',
  `EndAppointTime` datetime(0) NULL DEFAULT NULL COMMENT '截至预约时间',
  `AppointStatus` int(11) NULL DEFAULT NULL COMMENT '预约状态枚举(1:待入住,2:已入住,3:用户取消,4:酒店取消,5:完成,6:待确定,7:申请取消,8:完成退房)',
  `RoomId` int(11) NULL DEFAULT NULL COMMENT '房间',
  `ReturnMoney` double(20, 8) NULL DEFAULT NULL COMMENT '退款金额',
  `PayTime` datetime(0) NULL DEFAULT NULL COMMENT '支付时间',
  `TotalMoney` double(20, 8) NULL DEFAULT NULL COMMENT '总金额',
  `CheckInTime` datetime(0) NULL DEFAULT NULL COMMENT '实际入住时间',
  `CheckOutTime` datetime(0) NULL DEFAULT NULL COMMENT '实际退房时间',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `RoomId`(`RoomId`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  INDEX `ToUserId`(`ToUserId`) USING BTREE,
  CONSTRAINT `appoint_ibfk_1` FOREIGN KEY (`RoomId`) REFERENCES `room` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `appoint_ibfk_3` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `appoint_ibfk_4` FOREIGN KEY (`ToUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '预约记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of appoint
-- ----------------------------
INSERT INTO `appoint` VALUES (1, '2025-07-22 13:02:36', 2, 3, 1, NULL, NULL, 'D20250722130235830987', 1, '2025-07-22 12:00:00', '1', '2025-07-23 12:00:00', 10, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `appoint` VALUES (2, '2025-07-22 13:28:53', 2, 3, 2, NULL, NULL, 'D20250722132853512587', 1, '2025-07-22 12:00:00', NULL, '2025-07-23 12:00:00', 10, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `appoint` VALUES (3, '2025-07-22 13:30:56', 2, 3, 2, NULL, NULL, 'D20250722133055474218', 1, '2025-07-22 12:00:00', NULL, '2025-07-23 12:00:00', 3, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `appoint` VALUES (4, '2025-07-22 13:37:43', 2, 3, 1, NULL, NULL, 'D20250722133742700841', 1, '2025-07-22 12:00:00', '银行卡', '2025-07-23 12:00:00', 3, 1, 6.00000000, '2025-07-22 13:39:29', 6.00000000, NULL, NULL);
INSERT INTO `appoint` VALUES (5, '2025-07-22 16:32:48', 2, 3, 2, 3.00000000, '这次入住贵酒店真的让我感到非常满意，从入住到离店，每一个细节都体现了酒店的用心和专业。\n\n首先，酒店的环境非常优雅，大堂宽敞明亮，房间干净整洁，床品柔软舒适，让我一夜好眠。房间内的设施一应俱全，尤其是高速Wi-Fi和智能电视，让我的休闲时光更加便利。浴室的设计也很人性化，热水充足，洗浴用品品质上乘，使用感极佳。\n\n其次，酒店的服务堪称一流。前台工作人员热情周到，办理入住迅速高效，还贴心升级了房型。客房服务响应及时，打扫得非常细致。餐厅的早餐种类丰富，食材新鲜，尤其是现做的特色美食，让我每天早晨都充满期待。\n\n最后，酒店的地理位置非常便利，周边交通便捷，购物和餐饮选择多样，无论是商务出行还是旅游度假都非常适合。\n\n总之，这次入住体验远超预期，下次一定会再次选择这里，也会推荐给朋友和家人！强烈推荐！', 'D20250722163248636627', 2, '2025-07-30 00:00:00', '支付宝', '2025-08-02 00:00:00', 5, 1, NULL, '2025-07-22 16:32:52', 36.00000000, NULL, NULL);
INSERT INTO `appoint` VALUES (6, '2025-07-22 21:57:34', 2, 3, 1, NULL, NULL, 'D20250722215733889357', 1, '2025-07-22 12:00:00', '银行卡', '2025-07-23 12:00:00', 1, 1, NULL, '2025-07-22 21:57:38', 6.00000000, NULL, NULL);
INSERT INTO `appoint` VALUES (7, '2025-07-23 17:06:40', 2, 3, 2, NULL, NULL, 'D20250723170640830426', 2, '2025-07-23 12:00:00', NULL, '2025-07-24 12:00:00', 3, 1, NULL, NULL, 0.00000000, NULL, NULL);
INSERT INTO `appoint` VALUES (8, '2025-07-23 17:07:58', 2, 3, 1, NULL, NULL, 'D20250723170758239506', 1, '2025-07-23 12:00:00', NULL, '2025-07-24 12:00:00', 3, 1, NULL, NULL, 0.00000000, NULL, NULL);
INSERT INTO `appoint` VALUES (9, '2025-07-23 20:18:33', 2, 3, 1, NULL, NULL, 'D20250723201833980274', 1, '2025-07-23 12:00:00', '微信支付', '2025-07-24 12:00:00', 1, 1, NULL, '2025-07-23 20:18:36', 6.00000000, NULL, NULL);
INSERT INTO `appoint` VALUES (10, '2025-07-26 11:53:43', 4, 3, 2, 4.50000000, '这次入住体验非常满意！酒店位置优越，交通便利，周边餐饮购物都很方便。前台服务热情周到，办理入住高效，还贴心升级了房型。房间宽敞整洁，床品舒适柔软，隔音效果很好，一夜安眠无打扰。浴室干湿分离，备品齐全，热水充足稳定。早餐品种丰富，中西式搭配合理，味道也很棒。特别点赞客房服务，响应迅速且态度亲切。酒店设施维护得很新，健身房和泳池都体验了，环境干净专业。退房时还赠送了小礼物，细节满分！性价比超高，下次出差或旅行一定会再次选择这里，也会推荐给朋友！', 'D20250726115342107538', 1, '2025-07-26 12:00:00', '支付宝', '2025-07-27 12:00:00', 5, 8, NULL, '2025-07-26 11:53:49', 765.00000000, NULL, NULL);
INSERT INTO `appoint` VALUES (11, '2025-07-26 12:01:49', 3, 17, 1, 4.50000000, '这次入住体验非常满意！酒店位置优越，交通便利，周边餐饮购物都很方便。前台服务热情周到，办理入住高效，还贴心升级了房型。房间宽敞整洁，床品舒适柔软，隔音效果很好，一夜安眠无打扰。浴室干湿分离，备品齐全，热水充足稳定。早餐品种丰富，中西式搭配合理，味道也很棒。特别点赞客房服务，响应迅速且态度亲切。酒店设施维护得很新，健身房和泳池都体验了，环境干净专业。退房时还赠送了小礼物，细节满分！性价比超高，下次出差或旅行一定会再次选择这里，也会推荐给朋友！', 'D20250726120149849525', 1, '2025-07-26 12:00:00', '银行卡', '2025-07-27 12:00:00', 5, 5, NULL, '2025-07-26 12:01:52', 800.00000000, NULL, NULL);
INSERT INTO `appoint` VALUES (12, '2025-07-27 11:56:04', 2, 3, 2, 4.50000000, '很欧克', 'D20250727115603230617', 2, '2025-07-27 00:00:00', '银行卡', '2025-07-29 00:00:00', 5, 1, NULL, '2025-07-27 11:56:42', 4.00000000, NULL, NULL);

-- ----------------------------
-- Table structure for appointdet
-- ----------------------------
DROP TABLE IF EXISTS `appointdet`;
CREATE TABLE `appointdet`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '预约明细主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `IdCard` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证',
  `AppointId` int(11) NULL DEFAULT NULL COMMENT '预约订单',
  `Phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `Age` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄',
  `Sex` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别',
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `AppointId`(`AppointId`) USING BTREE,
  CONSTRAINT `appointdet_ibfk_1` FOREIGN KEY (`AppointId`) REFERENCES `appoint` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '预约明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of appointdet
-- ----------------------------
INSERT INTO `appointdet` VALUES (1, '2025-07-22 13:02:36', NULL, 1, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (2, '2025-07-22 13:28:54', NULL, 2, '13888888888', '0', '男', '字母哥');
INSERT INTO `appointdet` VALUES (3, '2025-07-22 13:28:54', NULL, 2, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (4, '2025-07-22 13:30:56', NULL, 3, '13888888888', '0', '男', '字母哥');
INSERT INTO `appointdet` VALUES (5, '2025-07-22 13:30:56', NULL, 3, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (6, '2025-07-22 13:37:43', NULL, 4, '13888888888', '0', '男', '字母哥');
INSERT INTO `appointdet` VALUES (7, '2025-07-22 16:32:48', NULL, 5, '13888888888', '0', '男', '字母哥');
INSERT INTO `appointdet` VALUES (8, '2025-07-22 16:32:48', NULL, 5, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (9, '2025-07-22 21:57:34', NULL, 6, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (10, '2025-07-23 17:06:40', NULL, 7, '13888888888', '0', '男', '字母哥');
INSERT INTO `appointdet` VALUES (11, '2025-07-23 17:06:40', NULL, 7, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (12, '2025-07-23 17:07:58', NULL, 8, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (13, '2025-07-23 20:18:33', NULL, 9, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (14, '2025-07-26 11:53:43', NULL, 10, '13888888888', '0', '男', '字母哥');
INSERT INTO `appointdet` VALUES (15, '2025-07-26 11:53:43', NULL, 10, '15616262422', '0', '男', '可可');
INSERT INTO `appointdet` VALUES (16, '2025-07-26 12:01:49', NULL, 11, '13600001117', '43', '男', '林志玲');
INSERT INTO `appointdet` VALUES (17, '2025-07-27 11:56:04', NULL, 12, '13888888888', '0', '男', '字母哥');
INSERT INTO `appointdet` VALUES (18, '2025-07-27 11:56:04', NULL, 12, '15616262422', '0', '男', '可可');

-- ----------------------------
-- Table structure for appuser
-- ----------------------------
DROP TABLE IF EXISTS `appuser`;
CREATE TABLE `appuser`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `RoleType` int(11) NULL DEFAULT NULL COMMENT '角色',
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `Birth` datetime(0) NULL DEFAULT NULL COMMENT '出生年月',
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `ImageUrls` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `Password` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `UserName` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账号',
  `PhoneNumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号码',
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of appuser
-- ----------------------------
INSERT INTO `appuser` VALUES (1, '2025-07-19 11:06:31', 1, '管理员', NULL, NULL, NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'admin', NULL);
INSERT INTO `appuser` VALUES (2, '2025-07-20 10:53:34', 3, '酒店管理员', NULL, '806105498@qq.com', NULL, 'MD57483781c033b9d71ae4409018c9f29e9', 'Hoteluser123', '13888888888');
INSERT INTO `appuser` VALUES (3, '2025-07-21 19:25:08', 2, '字母哥', '2025-07-22 00:00:00', '806105491@qq.com', 'http://localhost:7245/60531619/12621612.jpg', 'MD5ff23815e947a11f4d3fa61b2190d9652', 'Test001', '13988888888');
INSERT INTO `appuser` VALUES (4, '2025-07-24 11:20:00', 3, '刘强', '2025-04-05 00:00:00', 'liuqiang@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'liuqiang123', '13600004444');
INSERT INTO `appuser` VALUES (5, '2025-07-24 12:00:00', 3, '陈敏', '2025-05-22 00:00:00', 'chenmin@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'chenmin123', '13500005555');
INSERT INTO `appuser` VALUES (6, '2025-07-24 13:30:00', 3, '杨洋', '2025-06-01 00:00:00', 'yangyang@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'yangyang123', '13400006666');
INSERT INTO `appuser` VALUES (7, '2025-07-24 14:10:00', 3, '黄娟', '2025-04-18 00:00:00', 'huangjuan@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'huangjuan123', '13300007777');
INSERT INTO `appuser` VALUES (8, '2025-07-24 15:25:00', 3, '周杰', '2025-02-10 00:00:00', 'zhoujie@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'zhoujie123', '13200008888');
INSERT INTO `appuser` VALUES (9, '2025-07-24 16:40:00', 3, '徐丽', '2025-03-25 00:00:00', 'xuli@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'xuli123', '13100009999');
INSERT INTO `appuser` VALUES (10, '2025-07-24 17:55:00', 3, '吴勇', '2025-01-05 00:00:00', 'wuyong@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'wuyong123', '13000001111');
INSERT INTO `appuser` VALUES (11, '2025-07-24 13:25:00', 2, '张三丰', '1980-01-01 00:00:00', 'zhangsanfeng@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'zhangsf', '13800001111');
INSERT INTO `appuser` VALUES (12, '2025-07-24 13:26:00', 2, '李晓晓', '1985-05-05 00:00:00', 'lixiaoxiao@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'lixiaox', '13800001112');
INSERT INTO `appuser` VALUES (13, '2025-07-24 13:27:00', 2, '王大明', '1990-10-10 00:00:00', 'wangdaming@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'wangdm', '13800001113');
INSERT INTO `appuser` VALUES (14, '2025-07-24 13:28:00', 2, '赵敏', '1992-12-12 00:00:00', 'zhaomin@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'zhaom', '13800001114');
INSERT INTO `appuser` VALUES (15, '2025-07-24 13:29:00', 2, '孙小美', '1995-03-03 00:00:00', 'sunxiaomei@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'sunxm', '13800001115');
INSERT INTO `appuser` VALUES (16, '2025-07-24 13:30:00', 2, '周杰伦', '1979-08-08 00:00:00', 'zhoujielun@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'zhoujl', '13800001116');
INSERT INTO `appuser` VALUES (17, '2025-07-24 13:31:00', 2, '林俊杰', '1981-09-09 00:00:00', 'linjunjie@example.com', 'http://localhost:7245/598763664/126126126.jpg', 'MD521232f297a57a5a743894a0e4a801fc3', 'linjj', '13800001117');
INSERT INTO `appuser` VALUES (18, '2025-07-24 13:32:00', 2, '蔡依林', '1982-11-11 00:00:00', 'caiyilin@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'caiyln', '13800001118');
INSERT INTO `appuser` VALUES (19, '2025-07-24 13:33:00', 2, '吴青峰', '1983-04-04 00:00:00', 'wuqingfeng@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'wuqf', '13800001119');
INSERT INTO `appuser` VALUES (20, '2025-07-24 13:34:00', 2, '陈奕迅', '1974-07-07 00:00:00', 'chenyixun@example.com', NULL, 'MD521232f297a57a5a743894a0e4a801fc3', 'cheneix', '13800001120');

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '封面主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `Path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路径',
  `Title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `Cover` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '封面表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (2, '2025-07-23 10:30:00', '/rooms/deluxe', '尊享豪华客房，城市中心的理想之选', 'http://localhost:7245/531026393/643643347.jpg');
INSERT INTO `banner` VALUES (3, '2025-07-23 12:45:00', '/dining/summermenu', '夏季限定美食节，清凉一夏', 'http://localhost:7245/132019492/125125126.jpg');
INSERT INTO `banner` VALUES (4, '2025-07-23 15:15:00', 'www.baidu.com', '24小时智能健身房，随时畅练', 'http://localhost:7245/254885753/12512512.jpg');

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '员工主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `Photo` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '照片',
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `Salary` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '薪资',
  `Sex` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别',
  `No` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '工号',
  `UserId` int(11) NULL DEFAULT NULL COMMENT '关联账号',
  `Address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `BirthDay` datetime(0) NULL DEFAULT NULL COMMENT '出生年月',
  `IdCard` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证',
  `Phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  INDEX `UserId`(`UserId`) USING BTREE,
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `employee_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '员工表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (1, '2025-07-23 08:45:00', NULL, '李伟', 2, '8500', '男', 'EMP0001', NULL, '上海市黄浦区南京东路100号', '1990-05-12 00:00:00', '310101199005123456', '13812345678');
INSERT INTO `employee` VALUES (2, '2025-07-23 09:00:00', NULL, '王芳', 2, '7800', '女', 'EMP0002', NULL, '北京市朝阳区建国门外大街45号', '1992-08-22 00:00:00', '110101199208221234', '13987654321');
INSERT INTO `employee` VALUES (3, '2025-07-23 09:15:00', NULL, '张强', 2, '9000', '男', 'EMP0003', NULL, '广州市天河区体育西路68号', '1988-03-15 00:00:00', '440101198803151234', '13712349876');
INSERT INTO `employee` VALUES (4, '2025-07-23 09:30:00', NULL, '刘婷', 2, '7500', '女', 'EMP0004', NULL, '深圳市福田区深南大道100号', '1995-11-30 00:00:00', '440301199511301234', '13612345678');
INSERT INTO `employee` VALUES (5, '2025-07-23 09:45:00', NULL, '陈刚', 2, '8200', '男', 'EMP0005', NULL, '成都市武侯区人民南路四段20号', '1987-06-18 00:00:00', '510101198706181234', '13587654321');
INSERT INTO `employee` VALUES (6, '2025-07-23 10:00:00', NULL, '赵敏', 2, '7900', '女', 'EMP0006', NULL, '杭州市西湖区中山中路88号', '1993-04-05 00:00:00', '330101199304051234', '13412345678');
INSERT INTO `employee` VALUES (7, '2025-07-23 10:15:00', NULL, '黄勇', 2, '8800', '男', 'EMP0007', NULL, '武汉市江岸区解放大道123号', '1989-09-25 00:00:00', '420101198909251234', '13387654321');
INSERT INTO `employee` VALUES (8, '2025-07-23 10:30:00', NULL, '周倩', 2, '7600', '女', 'EMP0008', NULL, '西安市雁塔区高新路56号', '1994-07-10 00:00:00', '610101199407101234', '13212345678');
INSERT INTO `employee` VALUES (9, '2025-07-23 10:45:00', NULL, '徐磊', 2, '8400', '男', 'EMP0009', NULL, '南京市鼓楼区中山路77号', '1991-02-19 00:00:00', '320101199102191234', '13187654321');
INSERT INTO `employee` VALUES (10, '2025-07-23 11:00:00', 'http://localhost:7245/395225563/643643347.jpg', '孙丽', 2, '7700', '女', 'EMP0010', NULL, '重庆市渝中区解放碑步行街88号', '1996-10-10 00:00:00', '500101199610031234', '13012345678');

-- ----------------------------
-- Table structure for equipmentinfo
-- ----------------------------
DROP TABLE IF EXISTS `equipmentinfo`;
CREATE TABLE `equipmentinfo`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '设备信息主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `GroupName` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类',
  `IsFree` tinyint(1) NULL DEFAULT NULL COMMENT '是否免费',
  `Name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `Sort` int(11) NULL DEFAULT NULL COMMENT '显示顺序',
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of equipmentinfo
-- ----------------------------
INSERT INTO `equipmentinfo` VALUES (1, '2025-07-21 08:00:00', '清洁服务', 1, '每日打扫', 1);
INSERT INTO `equipmentinfo` VALUES (2, '2025-07-21 08:02:00', '清洁服务', 0, '打扫工具', 2);
INSERT INTO `equipmentinfo` VALUES (3, '2025-07-21 08:04:00', '清洁服务', 1, '需前台索要', 3);
INSERT INTO `equipmentinfo` VALUES (4, '2025-07-21 08:06:00', '清洁服务', 1, '洗衣机', 4);
INSERT INTO `equipmentinfo` VALUES (5, '2025-07-21 08:08:00', '清洁服务', 1, '干衣机', 5);
INSERT INTO `equipmentinfo` VALUES (6, '2025-07-21 08:10:00', '清洁服务', 1, '洗衣用品', 6);
INSERT INTO `equipmentinfo` VALUES (7, '2025-07-21 08:12:00', '清洁服务', 1, '熨衣设备', 7);
INSERT INTO `equipmentinfo` VALUES (8, '2025-07-21 08:14:00', '食品饮品', 1, '速食品', 8);
INSERT INTO `equipmentinfo` VALUES (10, '2025-07-21 08:18:00', '食品饮品', 1, '小食', 10);
INSERT INTO `equipmentinfo` VALUES (12, '2025-07-21 08:22:00', '食品饮品', 1, '咖啡壶/茶壶', 12);
INSERT INTO `equipmentinfo` VALUES (13, '2025-07-21 08:24:00', '食品饮品', 1, '茶包', 13);
INSERT INTO `equipmentinfo` VALUES (14, '2025-07-21 08:26:00', '食品饮品', 1, '软饮', 14);
INSERT INTO `equipmentinfo` VALUES (16, '2025-07-21 08:30:00', '食品饮品', 1, '酒精饮料', 16);
INSERT INTO `equipmentinfo` VALUES (17, '2025-07-21 08:32:00', '食品饮品', 1, '瓶装水', 17);
INSERT INTO `equipmentinfo` VALUES (19, '2025-07-21 08:36:00', '食品饮品', 1, '电热水壶', 19);
INSERT INTO `equipmentinfo` VALUES (20, '2025-07-21 08:38:00', '食品饮品', 1, '迷你吧', 20);
INSERT INTO `equipmentinfo` VALUES (22, '2025-07-21 08:42:00', '洗浴用品', 1, '牙刷', 22);
INSERT INTO `equipmentinfo` VALUES (24, '2025-07-21 08:46:00', '洗浴用品', 0, '需前台索要', 24);
INSERT INTO `equipmentinfo` VALUES (25, '2025-07-21 08:48:00', '洗浴用品', 1, '牙膏', 25);
INSERT INTO `equipmentinfo` VALUES (27, '2025-07-21 08:52:00', '洗浴用品', 1, '沐浴露', 27);
INSERT INTO `equipmentinfo` VALUES (28, '2025-07-21 08:54:00', '洗浴用品', 1, '洗发水', 28);
INSERT INTO `equipmentinfo` VALUES (29, '2025-07-21 08:56:00', '洗浴用品', 1, '护发素', 29);
INSERT INTO `equipmentinfo` VALUES (30, '2025-07-21 08:58:00', '洗浴用品', 1, '香皂', 30);
INSERT INTO `equipmentinfo` VALUES (31, '2025-07-21 09:00:00', '洗浴用品', 1, '浴帽', 31);
INSERT INTO `equipmentinfo` VALUES (33, '2025-07-21 09:04:00', '洗浴用品', 1, '梳子', 33);
INSERT INTO `equipmentinfo` VALUES (35, '2025-07-21 09:08:00', '洗浴用品', 0, '需前台索要', 35);
INSERT INTO `equipmentinfo` VALUES (36, '2025-07-21 09:10:00', '洗浴用品', 1, '剃须刀', 36);
INSERT INTO `equipmentinfo` VALUES (38, '2025-07-21 09:14:00', '洗浴用品', 0, '需前台索要', 38);
INSERT INTO `equipmentinfo` VALUES (39, '2025-07-21 09:16:00', '客房设施', 1, '空调', 39);
INSERT INTO `equipmentinfo` VALUES (41, '2025-07-21 09:20:00', '客房设施', 1, '暖气', 41);
INSERT INTO `equipmentinfo` VALUES (42, '2025-07-21 09:22:00', '客房设施', 1, '电风扇', 42);
INSERT INTO `equipmentinfo` VALUES (43, '2025-07-21 09:24:00', '客房设施', 1, '手动窗帘', 43);
INSERT INTO `equipmentinfo` VALUES (44, '2025-07-21 09:26:00', '客房设施', 1, '自动窗帘', 44);
INSERT INTO `equipmentinfo` VALUES (45, '2025-07-21 09:28:00', '客房设施', 1, '遮光窗帘', 45);
INSERT INTO `equipmentinfo` VALUES (46, '2025-07-21 09:30:00', '客房设施', 1, '地毯', 46);
INSERT INTO `equipmentinfo` VALUES (47, '2025-07-21 09:32:00', '客房设施', 1, '床具:鸭绒被', 47);
INSERT INTO `equipmentinfo` VALUES (48, '2025-07-21 09:34:00', '客房设施', 1, '床具:毯子或被子', 48);
INSERT INTO `equipmentinfo` VALUES (49, '2025-07-21 09:36:00', '客房设施', 1, '空气净化器', 49);
INSERT INTO `equipmentinfo` VALUES (50, '2025-07-21 09:38:00', '便利设施', 1, '管家服务', 50);

-- ----------------------------
-- Table structure for favourablesetting
-- ----------------------------
DROP TABLE IF EXISTS `favourablesetting`;
CREATE TABLE `favourablesetting`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '优惠设置主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `BeginActiveTime` datetime(0) NULL DEFAULT NULL COMMENT '起始有效时间',
  `RoomId` int(11) NULL DEFAULT NULL COMMENT '房间',
  `EndActiveTime` datetime(0) NULL DEFAULT NULL COMMENT '截至有效时间',
  `Discount` double(20, 8) NULL DEFAULT NULL COMMENT '折扣价',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `RoomId`(`RoomId`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  CONSTRAINT `favourablesetting_ibfk_1` FOREIGN KEY (`RoomId`) REFERENCES `room` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `favourablesetting_ibfk_2` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '优惠设置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favourablesetting
-- ----------------------------
INSERT INTO `favourablesetting` VALUES (1, '2025-07-21 11:14:24', 2, '2025-07-21 11:14:21', 1, '2025-07-30 00:00:00', 0.90000000);

-- ----------------------------
-- Table structure for guestinfo
-- ----------------------------
DROP TABLE IF EXISTS `guestinfo`;
CREATE TABLE `guestinfo`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '旅客信息主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `IdCard` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证',
  `BelongUserId` int(11) NULL DEFAULT NULL COMMENT '所属账号',
  `Birth` datetime(0) NULL DEFAULT NULL COMMENT '出生年月',
  `Phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `Sex` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别',
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `BelongUserId`(`BelongUserId`) USING BTREE,
  CONSTRAINT `guestinfo_ibfk_1` FOREIGN KEY (`BelongUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '旅客信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of guestinfo
-- ----------------------------
INSERT INTO `guestinfo` VALUES (1, '2025-07-21 21:59:02', '521890752198567219', 3, '2025-07-22 00:00:00', '13888888888', '男', '字母哥');
INSERT INTO `guestinfo` VALUES (3, '2025-07-22 12:48:48', '521985671298571982', 3, '2025-07-25 00:00:00', '15616262422', '男', '可可');
INSERT INTO `guestinfo` VALUES (4, '2025-07-24 13:30:00', '110102198505052321', 12, '1985-05-05 00:00:00', '13800001112', '女', '李晓晓');
INSERT INTO `guestinfo` VALUES (5, '2025-07-24 13:30:00', '110103199010102334', 13, '1990-10-10 00:00:00', '13800001113', '男', '王大明');
INSERT INTO `guestinfo` VALUES (6, '2025-07-24 13:30:00', '110104199212122349', 14, '1992-12-12 00:00:00', '13800001114', '女', '赵敏');
INSERT INTO `guestinfo` VALUES (7, '2025-07-24 13:30:00', '110105199503032357', 15, '1995-03-03 00:00:00', '13800001115', '女', '孙小美');
INSERT INTO `guestinfo` VALUES (8, '2025-07-24 13:30:00', '110106197908082365', 16, '1979-08-08 00:00:00', '13800001116', '男', '周杰伦');
INSERT INTO `guestinfo` VALUES (9, '2025-07-24 13:30:00', '110107198109092373', 17, '1981-09-09 00:00:00', '13800001117', '男', '林俊杰');
INSERT INTO `guestinfo` VALUES (10, '2025-07-24 13:30:00', '110108198211112382', 18, '1982-11-11 00:00:00', '13800001118', '女', '蔡依林');
INSERT INTO `guestinfo` VALUES (11, '2025-07-24 13:30:00', '110109198304042390', 19, '1983-04-04 00:00:00', '13800001119', '男', '吴青峰');
INSERT INTO `guestinfo` VALUES (12, '2025-07-24 13:30:00', '110110197407072408', 20, '1974-07-07 00:00:00', '13800001120', '男', '陈奕迅');
INSERT INTO `guestinfo` VALUES (13, '2025-07-24 13:35:00', '110101199101012415', 11, '1991-01-01 00:00:00', '13900001111', '男', '张伟');
INSERT INTO `guestinfo` VALUES (14, '2025-07-24 13:35:00', '110102198602022423', 12, '1986-02-02 00:00:00', '13900001112', '女', '李娜');
INSERT INTO `guestinfo` VALUES (15, '2025-07-24 13:35:00', '110103199203032431', 13, '1992-03-03 00:00:00', '13900001113', '男', '王强');
INSERT INTO `guestinfo` VALUES (16, '2025-07-24 13:35:00', '11010419930404244X', 14, '1993-04-04 00:00:00', '13900001114', '女', '赵丽');
INSERT INTO `guestinfo` VALUES (17, '2025-07-24 13:35:00', '110105199405052458', 15, '1994-05-05 00:00:00', '13900001115', '女', '孙丽丽');
INSERT INTO `guestinfo` VALUES (18, '2025-07-24 13:35:00', '110106198006062466', 16, '1980-06-06 00:00:00', '13900001116', '男', '周星驰');
INSERT INTO `guestinfo` VALUES (19, '2025-07-24 13:35:00', '110107198707072474', 17, '1987-07-07 00:00:00', '13900001117', '男', '林志颖');
INSERT INTO `guestinfo` VALUES (20, '2025-07-24 13:35:00', '110108198808082482', 18, '1988-08-08 00:00:00', '13900001118', '女', '蔡徐坤');
INSERT INTO `guestinfo` VALUES (21, '2025-07-24 13:35:00', '110109198909092490', 19, '1989-09-09 00:00:00', '13900001119', '男', '吴亦凡');
INSERT INTO `guestinfo` VALUES (22, '2025-07-24 13:35:00', '110110197510102508', 20, '1975-10-10 00:00:00', '13900001120', '男', '陈小春');
INSERT INTO `guestinfo` VALUES (23, '2025-07-24 13:40:00', '110101199311112516', 11, '1993-11-11 00:00:00', '13700001111', '男', '张建国');
INSERT INTO `guestinfo` VALUES (24, '2025-07-24 13:40:00', '110102198412122524', 12, '1984-12-12 00:00:00', '13700001112', '女', '李倩');
INSERT INTO `guestinfo` VALUES (25, '2025-07-24 13:40:00', '110103199501012532', 13, '1995-01-01 00:00:00', '13700001113', '男', '王建国');
INSERT INTO `guestinfo` VALUES (26, '2025-07-24 13:40:00', '110104199602022540', 14, '1996-02-02 00:00:00', '13700001114', '女', '赵倩');
INSERT INTO `guestinfo` VALUES (27, '2025-07-24 13:40:00', '110105199703032559', 15, '1997-03-03 00:00:00', '13700001115', '女', '孙建国');
INSERT INTO `guestinfo` VALUES (28, '2025-07-24 13:40:00', '110106197804042567', 16, '1978-04-04 00:00:00', '13700001116', '男', '周润发');
INSERT INTO `guestinfo` VALUES (29, '2025-07-24 13:40:00', '110107198905052575', 17, '1989-05-05 00:00:00', '13700001117', '男', '林心如');
INSERT INTO `guestinfo` VALUES (30, '2025-07-24 13:40:00', '110108199006062583', 18, '1990-06-06 00:00:00', '13700001118', '女', '蔡少芬');
INSERT INTO `guestinfo` VALUES (31, '2025-07-24 13:40:00', '110109199107072591', 19, '1991-07-07 00:00:00', '13700001119', '男', '吴彦祖');
INSERT INTO `guestinfo` VALUES (32, '2025-07-24 13:40:00', '110110197608082609', 20, '1976-08-08 00:00:00', '13700001120', '男', '陈小明');
INSERT INTO `guestinfo` VALUES (33, '2025-07-24 13:45:00', '110101199209092617', 11, '1992-09-09 00:00:00', '13600001111', '男', '张丽');
INSERT INTO `guestinfo` VALUES (34, '2025-07-24 13:45:00', '110102198310102625', 12, '1983-10-10 00:00:00', '13600001112', '女', '李婷');
INSERT INTO `guestinfo` VALUES (35, '2025-07-24 13:45:00', '110103199411112633', 13, '1994-11-11 00:00:00', '13600001113', '男', '王芳');
INSERT INTO `guestinfo` VALUES (36, '2025-07-24 13:45:00', '110104199512122641', 14, '1995-12-12 00:00:00', '13600001114', '女', '赵芳');
INSERT INTO `guestinfo` VALUES (37, '2025-07-24 13:45:00', '11010519800101265X', 15, '1980-01-01 00:00:00', '13600001115', '女', '孙芳');
INSERT INTO `guestinfo` VALUES (38, '2025-07-24 13:45:00', '110106198102022668', 16, '1981-02-02 00:00:00', '13600001116', '男', '周润发');
INSERT INTO `guestinfo` VALUES (39, '2025-07-24 13:45:00', '110107198203032676', 17, '1982-03-03 00:00:00', '13600001117', '男', '林志玲');
INSERT INTO `guestinfo` VALUES (40, '2025-07-24 13:45:00', '110108198304042684', 18, '1983-04-04 00:00:00', '13600001118', '女', '蔡少芬');
INSERT INTO `guestinfo` VALUES (41, '2025-07-24 13:45:00', '110109198405052692', 19, '1984-05-05 00:00:00', '13600001119', '男', '吴镇宇');
INSERT INTO `guestinfo` VALUES (42, '2025-07-24 13:45:00', '110110197706062700', 20, '1977-06-06 00:00:00', '13600001120', '男', '陈冠希');
INSERT INTO `guestinfo` VALUES (43, '2025-07-24 13:30:00', '110101199003072316', 11, '1990-03-07 00:00:00', '13800001111', '男', '张三丰');

-- ----------------------------
-- Table structure for hotel
-- ----------------------------
DROP TABLE IF EXISTS `hotel`;
CREATE TABLE `hotel`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '酒店主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `IsPet` tinyint(1) NULL DEFAULT NULL COMMENT '是否可带宠物',
  `Longitude` double(20, 8) NULL DEFAULT NULL COMMENT '经度',
  `HotelImages` varchar(2024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '酒店图片',
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `ProviceCityArea` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省市区',
  `Content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '酒店介绍',
  `Services` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '服务设施',
  `Notice` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '酒店通知',
  `CheckInTip` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '入住提示',
  `MustRead` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '必读',
  `Address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '酒店详细地址',
  `Latitude` double(20, 8) NULL DEFAULT NULL COMMENT '纬度',
  `HotelUserId` int(11) NULL DEFAULT NULL COMMENT '酒店负责人',
  `Cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '酒店封面',
  `IsAudit` tinyint(1) NULL DEFAULT NULL COMMENT '是否审核通过',
  `AuditResult` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核结果',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `HotelUserId`(`HotelUserId`) USING BTREE,
  CONSTRAINT `hotel_ibfk_1` FOREIGN KEY (`HotelUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '酒店表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hotel
-- ----------------------------
INSERT INTO `hotel` VALUES (2, '2025-07-20 08:30:00', 1, 116.40720537, 'http://localhost:7245/1753333700595/7.jpg,http://localhost:7245/1753333700595/0.jpg,http://localhost:7245/1753333700595/4.jpg,http://localhost:7245/1753333700595/0.jpg,http://localhost:7245/1753333700595/2.jpg,http://localhost:7245/1753333700595/1.jpg,http://localhost:7245/1753333700595/0.jpg,http://localhost:7245/1753333700595/3.jpg', '北京朝阳希尔顿欢朋酒店', '北京市,北京市,东城区', '位于北京市CBD核心区，交通便利，提供高品质住宿体验。', '免费WiFi, 停车场, 餐厅, 会议室', '疫情期间请佩戴口罩进入大堂', '入住时间14:00后，请携带身份证办理入住', '请勿携带宠物入内', '北京市东城区正义路2号', 39.90429543, 2, 'http://localhost:7245/364954767/125126512621.jpg', 1, '没问题');
INSERT INTO `hotel` VALUES (3, '2025-07-24 11:30:00', 1, 113.26438213, 'http://localhost:7245/1753333700646/4.jpg,http://localhost:7245/1753333700646/5.jpg,http://localhost:7245/1753333700646/1.jpg,http://localhost:7245/1753333700646/2.jpg,http://localhost:7245/1753333700646/1.jpg,http://localhost:7245/1753333700646/6.jpg,http://localhost:7245/1753333700646/0.jpg,http://localhost:7245/1753333700646/4.jpg', '广州天河万豪酒店', '广东省广州市天河区', '酒店位于天河CBD核心区域，周边高端写字楼林立，步行可达多个购物中心，交通四通八达。', '行政酒廊, 恒温泳池, 商务中心, 宠物友好', '酒店允许携带宠物，需提前预约宠物友好房型。', '请携带宠物疫苗接种证明。', '请勿在房间内烹饪食物。', '广州市天河区天河路230号', 23.12911234, 6, 'http://localhost:7245/1753333662535/8.jpg', 1, '同意');
INSERT INTO `hotel` VALUES (4, '2025-07-24 12:45:00', 0, 114.11221345, 'http://localhost:7245/1753333700680/6.jpg,http://localhost:7245/1753333700680/9.jpg,http://localhost:7245/1753333700680/6.jpg,http://localhost:7245/1753333700680/9.jpg,http://localhost:7245/1753333700680/0.jpg,http://localhost:7245/1753333700680/8.jpg,http://localhost:7245/1753333700680/6.jpg,http://localhost:7245/1753333700680/1.jpg', '深圳南山凯悦酒店', '广东省深圳市南山区', '酒店地处南山区科技核心地带，紧邻科技园，适合商务出差及休闲度假，提供高速网络和智能客控系统。', '高速WiFi, 智能客控, 行政楼层, 健身中心', '疫情期间请佩戴口罩并配合体温检测。', '请提前在线完成入住登记，以节省时间。', '请勿在公共区域大声喧哗。', '深圳市南山区高新科技园中区9号', 22.54611234, 7, 'http://localhost:7245/1753333665923/2.jpg', 1, '同意');
INSERT INTO `hotel` VALUES (5, '2025-07-24 14:00:00', 1, 120.15512344, 'http://localhost:7245/1753333700696/2.jpg,http://localhost:7245/1753333700696/7.jpg,http://localhost:7245/1753333700696/3.jpg,http://localhost:7245/1753333700696/5.jpg,http://localhost:7245/1753333700696/5.jpg,http://localhost:7245/1753333700696/3.jpg,http://localhost:7245/1753333700696/5.jpg,http://localhost:7245/1753333700696/2.jpg', '杭州西湖四季酒店', '浙江省杭州市西湖区', '酒店坐落于西湖风景区核心位置，步行可达西湖断桥，房间可俯瞰湖景，是游客和摄影爱好者的首选住宿。', '湖景房, 免费自行车租赁, 接机服务, 宠物友好', '部分房型提供湖景阳台，需提前预订。', '请勿在房间内吸烟，请使用楼层吸烟区。', '请尊重周边居民休息时间，避免夜间喧闹。', '杭州市西湖区南山路学士桥1号', 30.24411234, 8, 'http://localhost:7245/1753333667907/6.jpg', 1, '同意');
INSERT INTO `hotel` VALUES (6, '2025-07-24 15:20:00', 0, 118.76512345, 'http://localhost:7245/1753333700720/9.jpg,http://localhost:7245/1753333700720/6.jpg,http://localhost:7245/1753333700720/5.jpg,http://localhost:7245/1753333700720/7.jpg,http://localhost:7245/1753333700720/3.jpg,http://localhost:7245/1753333700720/7.jpg,http://localhost:7245/1753333700720/0.jpg,http://localhost:7245/1753333700720/3.jpg', '成都锦江希尔顿酒店', '四川省成都市锦江区', '酒店位于成都市中心锦江区，紧邻春熙路商圈，步行可达太古里购物区，地理位置优越，适合各类旅客。', '健身房, 停车场, 餐厅, 会议厅', '近期商圈人流较大，请注意保管好个人物品。', '请提前12小时取消预订以免产生费用。', '请勿携带易燃易爆物品进入酒店。', '成都市锦江区东大街1号', 30.65811234, 9, 'http://localhost:7245/1753333669667/6.jpg', 1, '同意');
INSERT INTO `hotel` VALUES (7, '2025-07-24 16:35:00', 1, 117.23123456, 'http://localhost:7245/1753333700752/4.jpg,http://localhost:7245/1753333700752/0.jpg,http://localhost:7245/1753333700752/9.jpg,http://localhost:7245/1753333700752/5.jpg,http://localhost:7245/1753333700752/8.jpg,http://localhost:7245/1753333700752/0.jpg,http://localhost:7245/1753333700752/3.jpg,http://localhost:7245/1753333700752/0.jpg', '重庆江北丽枫酒店', '重庆市江北区', '酒店位于江北区繁华商圈，地铁直达，房间配备智能香氛系统，提供温馨舒适的睡眠体验。', '香氛系统, 免费停车场, 洗衣服务, 宠物友好', '提供宠物寄养服务，请提前预约。', '请勿在房间内使用明火或香薰蜡烛。', '请勿在房间内煮食，酒店提供送餐服务。', '重庆市江北区观音桥步行街8号', 29.56311234, 10, 'http://localhost:7245/1753333672027/9.jpg', 1, '同意');
INSERT INTO `hotel` VALUES (8, '2025-07-24 09:00:00', 1, 116.40739634, 'http://localhost:7245/1753333700615/9.jpg,http://localhost:7245/1753333700615/4.jpg,http://localhost:7245/1753333700615/0.jpg,http://localhost:7245/1753333700615/7.jpg,http://localhost:7245/1753333700615/4.jpg,http://localhost:7245/1753333700615/9.jpg,http://localhost:7245/1753333700615/7.jpg,http://localhost:7245/1753333700615/1.jpg', '北京朝阳希尔顿欢朋酒店', '北京市朝阳区', '酒店位于北京市朝阳区核心地段，交通便利，周边商业配套齐全，是商务和休闲旅客的理想选择。', '免费WiFi, 停车场, 餐厅, 会议室', '近期因装修部分区域可能会有噪音，请谅解。', '请携带有效身份证件办理入住。', '本酒店禁止吸烟，请在指定区域吸烟。', '北京市朝阳区建国路88号', 39.91231234, 4, 'http://localhost:7245/1753333674727/5.jpg', 1, '同意');
INSERT INTO `hotel` VALUES (9, '2025-07-24 10:15:00', 0, 121.47370124, 'http://localhost:7245/1753333700626/1.jpg,http://localhost:7245/1753333700626/1.jpg,http://localhost:7245/1753333700626/3.jpg,http://localhost:7245/1753333700626/7.jpg,http://localhost:7245/1753333700626/4.jpg,http://localhost:7245/1753333700626/4.jpg,http://localhost:7245/1753333700626/6.jpg,http://localhost:7245/1753333700626/0.jpg', '上海浦东香格里拉度假酒店', '上海市浦东新区', '酒店毗邻浦东国际机场，拥有豪华客房和优质服务，提供机场免费接送服务，是高端旅客的首选。', '免费接送机, 高尔夫球场, 健身房, 无烟房', '宠物不可入内，请提前确认预订条款。', '请至少提前1小时告知预计抵达时间。', '请勿携带宠物进入酒店区域。', '上海市浦东新区世纪大道100号', 31.23031234, 5, 'http://localhost:7245/1753333677700/8.jpg', 1, '同意');

-- ----------------------------
-- Table structure for hotelintegral
-- ----------------------------
DROP TABLE IF EXISTS `hotelintegral`;
CREATE TABLE `hotelintegral`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '酒店积分主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `UserId` int(11) NULL DEFAULT NULL COMMENT '用户',
  `Title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `RelativeNo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联单号',
  `IntegralValue` double(20, 8) NULL DEFAULT NULL COMMENT '积分值',
  `Type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `UserId`(`UserId`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  CONSTRAINT `hotelintegral_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `hotelintegral_ibfk_2` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '酒店积分表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hotelintegral
-- ----------------------------
INSERT INTO `hotelintegral` VALUES (1, '2025-07-23 08:30:00', 3, '预订酒店获得积分', 'ORDER202507230001', 500.00000000, '增加', 2);
INSERT INTO `hotelintegral` VALUES (2, '2025-07-23 09:15:00', 3, '积分兑换优惠券', 'COUPON202507230001', -200.00000000, '减少', 2);
INSERT INTO `hotelintegral` VALUES (3, '2025-07-23 10:45:00', 3, '签到奖励积分', 'SIGNIN202507230001', 50.00000000, '增加', 2);
INSERT INTO `hotelintegral` VALUES (4, '2025-07-23 11:20:00', 3, '积分过期提醒', 'EXPIRE202507230001', -100.00000000, '减少', 2);
INSERT INTO `hotelintegral` VALUES (5, '2025-07-23 12:00:00', 3, '推荐好友注册奖励', 'REFERRAL202507230001', 150.00000000, '增加', 2);
INSERT INTO `hotelintegral` VALUES (6, '2025-07-23 13:30:00', 3, '预订取消积分返还', 'ORDER202507230002', 300.00000000, '增加', 2);
INSERT INTO `hotelintegral` VALUES (7, '2025-07-23 14:15:00', 3, '积分兑换房型升级', 'UPGRADE202507230001', -400.00000000, '减少', 2);
INSERT INTO `hotelintegral` VALUES (8, '2025-07-23 15:00:00', 3, '节日特别积分奖励', 'FESTIVAL202507230001', 200.00000000, '增加', 2);
INSERT INTO `hotelintegral` VALUES (9, '2025-07-23 16:20:00', 3, '使用积分抵扣部分房费', 'ORDER202507230003', -150.00000000, '减少', 2);
INSERT INTO `hotelintegral` VALUES (10, '2025-07-23 17:00:00', 3, '积分兑换早餐券', 'BREAKFAST202507230001', -80.00000000, '减少', 2);
INSERT INTO `hotelintegral` VALUES (12, '2025-07-23 17:06:40', 3, '酒店预订完成积分抵扣', 'D20250723170640830426', -10.00000000, '酒店预订', 2);
INSERT INTO `hotelintegral` VALUES (13, '2025-07-23 17:07:08', 3, '酒店预订取消积分返还', 'D20250723170640830426', -10.00000000, '酒店预订取消', 2);
INSERT INTO `hotelintegral` VALUES (14, '2025-07-23 17:07:58', 3, '酒店预订完成积分抵扣', 'D20250723170758239506', -10.00000000, '酒店预订', 2);
INSERT INTO `hotelintegral` VALUES (15, '2025-07-23 17:08:03', 3, '酒店预订取消积分返还', 'D20250723170758239506', -10.00000000, '酒店预订取消', 2);
INSERT INTO `hotelintegral` VALUES (16, '2025-07-26 11:57:43', 3, '酒店退房完成赠送积分', 'D20250726115342107538', 765.00000000, '酒店退房完成', 4);
INSERT INTO `hotelintegral` VALUES (17, '2025-07-26 12:02:35', 17, '酒店退房完成赠送积分', 'D20250726120149849525', 800.00000000, '酒店退房完成', 3);
INSERT INTO `hotelintegral` VALUES (18, '2025-07-27 11:56:04', 3, '酒店预订完成积分抵扣', 'D20250727115603230617', -20.00000000, '酒店预订', 2);
INSERT INTO `hotelintegral` VALUES (19, '2025-07-27 11:59:42', 3, '酒店退房完成赠送积分', 'D20250727115603230617', 10.00000000, '酒店退房完成', 2);

-- ----------------------------
-- Table structure for leavefeedback
-- ----------------------------
DROP TABLE IF EXISTS `leavefeedback`;
CREATE TABLE `leavefeedback`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '留言反馈主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `Content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '反馈内容',
  `Title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '反馈标题',
  `DoWithUserId` int(11) NULL DEFAULT NULL COMMENT '处理人',
  `FeedbackUserId` int(11) NULL DEFAULT NULL COMMENT '反馈人',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `ReplayContent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '回复内容',
  `IsDoWith` tinyint(1) NULL DEFAULT NULL COMMENT '是否处理',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  INDEX `FeedbackUserId`(`FeedbackUserId`) USING BTREE,
  INDEX `DoWithUserId`(`DoWithUserId`) USING BTREE,
  CONSTRAINT `leavefeedback_ibfk_1` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `leavefeedback_ibfk_2` FOREIGN KEY (`FeedbackUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `leavefeedback_ibfk_3` FOREIGN KEY (`DoWithUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '留言反馈表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of leavefeedback
-- ----------------------------
INSERT INTO `leavefeedback` VALUES (1, '2025-07-23 12:42:04', '<p>测试</p>', '您好', 1, 3, NULL, '<p>解决了</p>', 1);
INSERT INTO `leavefeedback` VALUES (2, '2025-07-23 12:53:28', '<p>酒店问题</p><p>酒店问题</p><p>在当今的旅游和商务环境中，酒店已成为人们选择住宿的首选。然而，随着旅游业的发展，酒店行业也面临着各种挑战和问题。这些问题不仅影响酒店的运营效率，还可能对客户体验产生负面影响。因此，了解并解决这些问题对于酒店业的成功至关重要。</p><p>首先，酒店业需要关注服务质量的提升。这包括提供高质量的客房服务、餐饮服务以及员工培训等方面。只有确保服务质量达到高标准，才能吸引并留住客户，提高客户满意度。此外，酒店还需要关注设施设备的更新和维护，确保为客户提供舒适、安全的环境。</p><p>其次，酒店业需要注重环保和可持续发展。随着人们对环境保护意识的提高，越来越多的消费者开始关注酒店的环保措施。因此，酒店需要采取节能减排措施，减少对环境的影响。同时，酒店还可以通过推广绿色建筑、使用可再生能源等方式，展示其对环保的承诺。</p><p>此外，酒店业还需要关注安全问题。这包括加强安全管理、提高员工的安全意识以及制定应急预案等方面。只有确保客户的人身和财产安全得到保障，才能赢得客户的信任和口碑。</p><p>最后，酒店业还需要关注市场趋势和客户需求的变化。随着科技的发展和人们生活方式的改变，酒店业也需要不断创新和改进，以满足客户的需求。例如，酒店可以引入智能化设备和服务，提高客户体验；或者推出特色主题房间，吸引更多的客户。</p><p>总之，酒店业面临着诸多挑战和问题，但只要我们能够关注服务质量、环保、安全、市场趋势和客户需求等方面的问题，并采取相应的措施加以解决，就能在激烈的市场竞争中脱颖而出，实现可持续发展。</p>', '测试', NULL, 3, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for messagenotice
-- ----------------------------
DROP TABLE IF EXISTS `messagenotice`;
CREATE TABLE `messagenotice`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '消息通知主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `Content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '通知内容',
  `UserId` int(11) NULL DEFAULT NULL COMMENT '接受人',
  `Type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型',
  `Title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '通知标题',
  `ResultMsg` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发送结果',
  `TargetKey` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标',
  `IsSuccess` tinyint(1) NULL DEFAULT NULL COMMENT '是否成功',
  `ActualSendTime` datetime(0) NULL DEFAULT NULL COMMENT '实际发送时间',
  `IsSend` tinyint(1) NULL DEFAULT NULL COMMENT '是否发送',
  `PlanSendTime` datetime(0) NULL DEFAULT NULL COMMENT '计划发送时间',
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '消息通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of messagenotice
-- ----------------------------
INSERT INTO `messagenotice` VALUES (1, '2025-07-23 20:18:36', '单号：D20250723201833980274\n电话：13988888888\n房间：城际大床房\n房间数量：1使用时间：2025-07-23T12:00至2025-07-24T12:00', 2, '邮箱', '有新的订单需要确认,单号:D20250723201833980274', '发送成功', '806105498@qq.com', 1, '2025-07-23 20:18:41', 1, '2025-07-23 20:18:36');
INSERT INTO `messagenotice` VALUES (2, '2025-07-23 20:18:57', '尊敬的字母哥，您预约的酒店「北京朝阳希尔顿欢朋酒店」已于2025-07-23 20:18确认接单。\n\n预订信息：\n• 房型：城际大床房\n• 房间数量：1\n• 入住日期：2025-07-23\n• 退房日期：2025-07-24\n• 订单号：D20250723201833980274\n\n酒店联系电话：13888888888\n如需了解更多信息，请登录账户查看详情或直接联系酒店。\n祝您入住愉快！', 3, '邮箱', '您的酒店预订已确认 - 北京朝阳希尔顿欢朋酒店', '发送成功', '806105491@qq.com', 1, '2025-07-23 20:19:01', 1, '2025-07-23 20:18:57');
INSERT INTO `messagenotice` VALUES (3, '2025-07-27 11:56:42', '单号：D20250727115603230617\n电话：13988888888\n房间：城际大床房\n房间数量：2使用时间：2025-07-27T00:00至2025-07-29T00:00', 2, '邮箱', '有新的订单需要确认,单号:D20250727115603230617', '发送成功', '806105498@qq.com', 1, '2025-07-27 11:56:51', 1, '2025-07-27 11:56:42');
INSERT INTO `messagenotice` VALUES (4, '2025-07-27 11:57:44', '尊敬的字母哥，您预约的酒店「北京朝阳希尔顿欢朋酒店」已于2025-07-27 11:57确认接单。\n\n预订信息：\n• 房型：城际大床房\n• 房间数量：2\n• 入住日期：2025-07-27\n• 退房日期：2025-07-29\n• 订单号：D20250727115603230617\n\n酒店联系电话：13888888888\n如需了解更多信息，请登录账户查看详情或直接联系酒店。\n祝您入住愉快！', 3, '邮箱', '您的酒店预订已确认 - 北京朝阳希尔顿欢朋酒店', '发送成功', '806105491@qq.com', 1, '2025-07-27 11:57:51', 1, '2025-07-27 11:57:44');

-- ----------------------------
-- Table structure for room
-- ----------------------------
DROP TABLE IF EXISTS `room`;
CREATE TABLE `room`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '房间主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `BreakfastType` int(11) NULL DEFAULT NULL COMMENT '早餐类型枚举(1:无早餐,2:一份早餐,3:二份早餐,4:多份早餐)',
  `AreaSize` double(20, 8) NULL DEFAULT NULL COMMENT '房间大小',
  `IsImmediatelyConfirm` tinyint(1) NULL DEFAULT NULL COMMENT '是否立即确定',
  `MaxPrice` double(20, 8) NULL DEFAULT NULL COMMENT '最大价格',
  `Title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `RoomShape` int(11) NULL DEFAULT NULL COMMENT '房型枚举(1:大床房,2:双人房)',
  `MinPrice` double(20, 8) NULL DEFAULT NULL COMMENT '最小价格',
  `ImageUrls` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '房间主图',
  `Integral` double(20, 8) NULL DEFAULT NULL COMMENT '可抵积分',
  `Content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '房间介绍',
  `IntegralExchangeMoney` double(20, 8) NULL DEFAULT NULL COMMENT '积分可抵金额',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `EquipmentInfoIds` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '设施信息',
  `FeaturedRoomShape` int(11) NULL DEFAULT NULL COMMENT '特色房型枚举(1:酒店套餐,2:亲子主题房,3:家庭房)',
  `Cover` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  `IsFreeCancel` tinyint(1) NULL DEFAULT NULL COMMENT '是否免费取消',
  `IsAudit` tinyint(1) NULL DEFAULT NULL COMMENT '是否审核通过',
  `AuditResult` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核结果',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  CONSTRAINT `room_ibfk_1` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '房间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room
-- ----------------------------
INSERT INTO `room` VALUES (1, '2025-07-21 10:45:00', 2, 8.00000000, 0, 11.00000000, '城际大床房', 1, 1.00000000, 'http://localhost:7245/505590885/1261262176.jpg,http://localhost:7245/15678790/1261262176.jpg,http://localhost:7245/454655579/3463265 125612.jpg', 10.00000000, '<p>测试</p>', 10.00000000, 2, '41,50,49,47,48,19,18,13,30', 1, 'http://localhost:7245/24562144/126512612.jpg', 1, NULL, NULL);
INSERT INTO `room` VALUES (2, '2025-07-24 09:15:00', 2, 35.00000000, 1, 650.00000000, '标准双人房', 2, 500.00000000, 'http://localhost:7245/1753333958150/9.jpg,http://localhost:7245/1753333958150/9.jpg,http://localhost:7245/1753333958150/6.jpg,http://localhost:7245/1753333958150/8.jpg,http://localhost:7245/1753333958150/0.jpg,http://localhost:7245/1753333958150/2.jpg', 300.00000000, '舒适安静的双人房，适合情侣或朋友入住。', 30.00000000, 2, '49,48,34,35,36', 1, 'http://localhost:7245/1753333948950/3.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (3, '2025-07-24 09:30:00', 1, 30.00000000, 0, 500.00000000, '经济单人房', 1, 400.00000000, 'http://localhost:7245/1753333958181/0.jpg,http://localhost:7245/1753333958181/0.jpg,http://localhost:7245/1753333958181/7.jpg,http://localhost:7245/1753333958181/0.jpg,http://localhost:7245/1753333958181/3.jpg,http://localhost:7245/1753333958181/6.jpg', 200.00000000, '性价比高，适合短期差旅人士。', 20.00000000, 2, NULL, 1, 'http://localhost:7245/1753333948999/0.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (4, '2025-07-24 10:00:00', 3, 50.00000000, 1, 900.00000000, '行政套房', 1, 700.00000000, 'http://localhost:7245/1753333958213/2.jpg,http://localhost:7245/1753333958213/3.jpg,http://localhost:7245/1753333958213/9.jpg,http://localhost:7245/1753333958213/7.jpg,http://localhost:7245/1753333958213/2.jpg,http://localhost:7245/1753333958213/5.jpg', 600.00000000, '配备独立办公区和会客区，适合商务人士。', 60.00000000, 3, NULL, 1, 'http://localhost:7245/1753333949024/7.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (5, '2025-07-24 10:15:00', 2, 40.00000000, 1, 750.00000000, '家庭双床房', 2, 600.00000000, 'http://localhost:7245/1753333958243/1.jpg,http://localhost:7245/1753333958243/2.jpg,http://localhost:7245/1753333958243/0.jpg,http://localhost:7245/1753333958243/0.jpg,http://localhost:7245/1753333958243/4.jpg,http://localhost:7245/1753333958243/0.jpg', 400.00000000, '配备两张单人床，适合家庭出行。', 40.00000000, 3, NULL, 3, 'http://localhost:7245/1753333949053/0.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (6, '2025-07-24 10:30:00', 1, 32.00000000, 0, 550.00000000, '标准单人房', 1, 450.00000000, 'http://localhost:7245/1753333958272/0.jpg,http://localhost:7245/1753333958272/3.jpg,http://localhost:7245/1753333958272/6.jpg,http://localhost:7245/1753333958272/1.jpg,http://localhost:7245/1753333958272/3.jpg,http://localhost:7245/1753333958272/0.jpg', 250.00000000, '简洁舒适，适合短住。', 25.00000000, 3, NULL, 1, 'http://localhost:7245/1753333949084/8.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (7, '2025-07-24 11:00:00', 3, 48.00000000, 1, 850.00000000, '豪华双人房', 2, 680.00000000, 'http://localhost:7245/1753333958303/9.jpg,http://localhost:7245/1753333958303/5.jpg,http://localhost:7245/1753333958303/4.jpg,http://localhost:7245/1753333958303/6.jpg,http://localhost:7245/1753333958303/9.jpg,http://localhost:7245/1753333958303/4.jpg', 550.00000000, '大空间双人房，配备浴缸和高速网络。', 55.00000000, 4, NULL, 1, 'http://localhost:7245/1753333949090/9.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (8, '2025-07-24 11:15:00', 2, 38.00000000, 1, 700.00000000, '商务大床房', 1, 580.00000000, 'http://localhost:7245/1753333958334/0.jpg,http://localhost:7245/1753333958334/1.jpg,http://localhost:7245/1753333958334/2.jpg,http://localhost:7245/1753333958334/2.jpg,http://localhost:7245/1753333958334/3.jpg,http://localhost:7245/1753333958334/8.jpg', 350.00000000, '专为商务人士打造，配备办公桌和高速网络。', 35.00000000, 4, NULL, 1, 'http://localhost:7245/1753333949112/8.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (9, '2025-07-24 11:30:00', 1, 30.00000000, 0, 500.00000000, '经济双人房', 2, 420.00000000, 'http://localhost:7245/1753333958341/7.jpg,http://localhost:7245/1753333958341/9.jpg,http://localhost:7245/1753333958341/5.jpg,http://localhost:7245/1753333958341/7.jpg,http://localhost:7245/1753333958341/7.jpg,http://localhost:7245/1753333958341/4.jpg', 200.00000000, '适合预算有限的旅客，基础配置齐全。', 20.00000000, 4, NULL, 1, 'http://localhost:7245/1753333949125/2.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (10, '2025-07-24 12:00:00', 3, 55.00000000, 1, 1200.00000000, '湖景套房', 2, 950.00000000, 'http://localhost:7245/1753333958364/4.jpg,http://localhost:7245/1753333958364/1.jpg,http://localhost:7245/1753333958364/4.jpg,http://localhost:7245/1753333958364/8.jpg,http://localhost:7245/1753333958364/6.jpg,http://localhost:7245/1753333958364/5.jpg', 800.00000000, '可俯瞰西湖全景，配备高端家电和浴缸。', 80.00000000, 5, NULL, 1, 'http://localhost:7245/1753333949143/3.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (11, '2025-07-24 12:15:00', 2, 42.00000000, 1, 800.00000000, '亲子主题房', 2, 650.00000000, 'http://localhost:7245/1753333958375/5.jpg,http://localhost:7245/1753333958375/1.jpg,http://localhost:7245/1753333958375/0.jpg,http://localhost:7245/1753333958375/7.jpg,http://localhost:7245/1753333958375/0.jpg,http://localhost:7245/1753333958375/5.jpg', 400.00000000, '房间布置温馨，配备儿童玩具和亲子设施。', 40.00000000, 5, NULL, 2, 'http://localhost:7245/1753333949166/7.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (12, '2025-07-24 12:30:00', 1, 35.00000000, 0, 600.00000000, '标准单人房', 1, 500.00000000, 'http://localhost:7245/1753333958413/3.jpg,http://localhost:7245/1753333958413/2.jpg,http://localhost:7245/1753333958413/0.jpg,http://localhost:7245/1753333958413/6.jpg,http://localhost:7245/1753333958413/8.jpg,http://localhost:7245/1753333958413/2.jpg', 250.00000000, '简洁舒适，适合出差或短住。', 25.00000000, 5, NULL, 1, 'http://localhost:7245/1753333949171/9.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (13, '2025-07-24 13:00:00', 3, 50.00000000, 1, 900.00000000, '行政双床房', 2, 700.00000000, 'http://localhost:7245/1753333958442/9.jpg,http://localhost:7245/1753333958442/1.jpg,http://localhost:7245/1753333958442/8.jpg,http://localhost:7245/1753333958442/1.jpg,http://localhost:7245/1753333958442/4.jpg,http://localhost:7245/1753333958442/3.jpg', 600.00000000, '配备两张单人床，适合商务出差或家庭入住。', 60.00000000, 6, NULL, 1, 'http://localhost:7245/1753333949189/1.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (14, '2025-07-24 13:15:00', 2, 40.00000000, 1, 750.00000000, '豪华单人房', 1, 620.00000000, 'http://localhost:7245/1753333958473/3.jpg,http://localhost:7245/1753333958473/7.jpg,http://localhost:7245/1753333958473/1.jpg,http://localhost:7245/1753333958473/4.jpg,http://localhost:7245/1753333958473/9.jpg,http://localhost:7245/1753333958473/9.jpg', 450.00000000, '配备大床和办公区，适合商务人士。', 45.00000000, 6, NULL, 1, 'http://localhost:7245/1753333949205/9.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (15, '2025-07-24 13:30:00', 1, 30.00000000, 0, 550.00000000, '经济单人房', 1, 450.00000000, 'http://localhost:7245/1753333958492/6.jpg,http://localhost:7245/1753333958492/1.jpg,http://localhost:7245/1753333958492/3.jpg,http://localhost:7245/1753333958492/1.jpg,http://localhost:7245/1753333958492/3.jpg,http://localhost:7245/1753333958492/4.jpg', 200.00000000, '基础配置齐全，适合预算有限的旅客。', 20.00000000, 6, NULL, 1, 'http://localhost:7245/1753333949235/5.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (16, '2025-07-24 14:00:00', 3, 48.00000000, 1, 850.00000000, '豪华双人房', 2, 680.00000000, 'http://localhost:7245/1753333958517/7.jpg,http://localhost:7245/1753333958517/9.jpg,http://localhost:7245/1753333958517/1.jpg,http://localhost:7245/1753333958517/8.jpg,http://localhost:7245/1753333958517/3.jpg,http://localhost:7245/1753333958517/4.jpg', 550.00000000, '配备两张大床和高速网络，适合家庭或朋友同行。', 55.00000000, 7, NULL, 1, 'http://localhost:7245/1753333949239/7.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (17, '2025-07-24 14:15:00', 2, 38.00000000, 1, 700.00000000, '标准大床房', 1, 580.00000000, 'http://localhost:7245/1753333958549/1.jpg,http://localhost:7245/1753333958549/5.jpg,http://localhost:7245/1753333958549/7.jpg,http://localhost:7245/1753333958549/5.jpg,http://localhost:7245/1753333958549/7.jpg,http://localhost:7245/1753333958549/9.jpg', 350.00000000, '配备一张大床和办公区，适合商务人士。', 35.00000000, 7, NULL, 1, 'http://localhost:7245/1753333949270/5.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (18, '2025-07-24 14:30:00', 1, 30.00000000, 0, 500.00000000, '经济双人房', 2, 420.00000000, 'http://localhost:7245/1753333958580/2.jpg,http://localhost:7245/1753333958580/3.jpg,http://localhost:7245/1753333958580/5.jpg,http://localhost:7245/1753333958580/2.jpg,http://localhost:7245/1753333958580/8.jpg,http://localhost:7245/1753333958580/1.jpg', 200.00000000, '基础配置齐全，适合预算有限的旅客。', 20.00000000, 7, NULL, 1, 'http://localhost:7245/1753333949275/1.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (19, '2025-07-24 15:00:00', 3, 55.00000000, 1, 1200.00000000, '湖景套房', 2, 950.00000000, 'http://localhost:7245/1753333958611/7.jpg,http://localhost:7245/1753333958611/5.jpg,http://localhost:7245/1753333958611/8.jpg,http://localhost:7245/1753333958611/3.jpg,http://localhost:7245/1753333958611/8.jpg,http://localhost:7245/1753333958611/4.jpg', 800.00000000, '可俯瞰西湖全景，配备高端家电和浴缸。', 80.00000000, 5, NULL, 1, 'http://localhost:7245/1753333949295/9.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (20, '2025-07-24 15:15:00', 2, 42.00000000, 1, 800.00000000, '亲子主题房', 2, 650.00000000, 'http://localhost:7245/1753333958648/0.jpg,http://localhost:7245/1753333958648/1.jpg,http://localhost:7245/1753333958648/2.jpg,http://localhost:7245/1753333958648/9.jpg,http://localhost:7245/1753333958648/0.jpg,http://localhost:7245/1753333958648/7.jpg', 400.00000000, '房间布置温馨，配备儿童玩具和亲子设施。', 40.00000000, 5, NULL, 2, 'http://localhost:7245/1753333949310/1.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (21, '2025-07-24 15:30:00', 1, 35.00000000, 0, 600.00000000, '标准单人房', 1, 500.00000000, 'http://localhost:7245/1753333958673/8.jpg,http://localhost:7245/1753333958673/5.jpg,http://localhost:7245/1753333958673/5.jpg,http://localhost:7245/1753333958673/6.jpg,http://localhost:7245/1753333958673/1.jpg,http://localhost:7245/1753333958673/3.jpg', 250.00000000, '简洁舒适，适合出差或短住。', 25.00000000, 5, NULL, 1, 'http://localhost:7245/1753333949325/7.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (22, '2025-07-24 16:00:00', 3, 50.00000000, 1, 900.00000000, '行政双床房', 2, 700.00000000, 'http://localhost:7245/1753333958704/9.jpg,http://localhost:7245/1753333958704/9.jpg,http://localhost:7245/1753333958704/0.jpg,http://localhost:7245/1753333958704/0.jpg,http://localhost:7245/1753333958704/5.jpg,http://localhost:7245/1753333958704/8.jpg', 600.00000000, '配备两张单人床，适合商务出差或家庭入住。', 60.00000000, 6, NULL, 1, 'http://localhost:7245/1753333949341/6.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (23, '2025-07-24 16:15:00', 2, 40.00000000, 1, 750.00000000, '豪华单人房', 1, 620.00000000, 'http://localhost:7245/1753333958735/7.jpg,http://localhost:7245/1753333958735/4.jpg,http://localhost:7245/1753333958735/6.jpg,http://localhost:7245/1753333958735/2.jpg,http://localhost:7245/1753333958735/1.jpg,http://localhost:7245/1753333958735/4.jpg', 450.00000000, '配备大床和办公区，适合商务人士。', 45.00000000, 6, NULL, 1, 'http://localhost:7245/1753333949345/5.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (24, '2025-07-24 16:30:00', 1, 30.00000000, 0, 550.00000000, '经济单人房', 1, 450.00000000, 'http://localhost:7245/1753333958765/6.jpg,http://localhost:7245/1753333958765/4.jpg,http://localhost:7245/1753333958765/2.jpg,http://localhost:7245/1753333958765/1.jpg,http://localhost:7245/1753333958765/5.jpg,http://localhost:7245/1753333958765/4.jpg', 200.00000000, '基础配置齐全，适合预算有限的旅客。', 20.00000000, 6, NULL, 1, 'http://localhost:7245/1753333949375/9.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (25, '2025-07-24 17:00:00', 3, 48.00000000, 1, 850.00000000, '豪华双人房', 2, 680.00000000, 'http://localhost:7245/1753333958775/5.jpg,http://localhost:7245/1753333958775/5.jpg,http://localhost:7245/1753333958775/7.jpg,http://localhost:7245/1753333958775/9.jpg,http://localhost:7245/1753333958775/6.jpg,http://localhost:7245/1753333958775/9.jpg', 550.00000000, '配备两张大床和高速网络，适合家庭或朋友同行。', 55.00000000, 7, NULL, 1, 'http://localhost:7245/1753333949379/6.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (26, '2025-07-24 17:15:00', 2, 38.00000000, 1, 700.00000000, '标准大床房', 1, 580.00000000, 'http://localhost:7245/1753333958820/7.jpg,http://localhost:7245/1753333958820/0.jpg,http://localhost:7245/1753333958820/3.jpg,http://localhost:7245/1753333958820/7.jpg,http://localhost:7245/1753333958820/8.jpg,http://localhost:7245/1753333958820/3.jpg', 350.00000000, '配备一张大床和办公区，适合商务人士。', 35.00000000, 7, NULL, 1, 'http://localhost:7245/1753333949400/0.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (27, '2025-07-24 17:30:00', 1, 30.00000000, 0, 500.00000000, '经济双人房', 2, 420.00000000, 'http://localhost:7245/1753333958865/5.jpg,http://localhost:7245/1753333958865/6.jpg,http://localhost:7245/1753333958865/3.jpg,http://localhost:7245/1753333958865/9.jpg,http://localhost:7245/1753333958865/1.jpg,http://localhost:7245/1753333958865/8.jpg', 200.00000000, '基础配置齐全，适合预算有限的旅客。', 20.00000000, 7, NULL, 1, 'http://localhost:7245/1753333949417/4.jpg', 0, 1, '同意');
INSERT INTO `room` VALUES (28, '2025-07-24 18:00:00', 3, 55.00000000, 1, 1200.00000000, '湖景套房', 2, 950.00000000, 'http://localhost:7245/1753333958884/7.jpg,http://localhost:7245/1753333958884/2.jpg,http://localhost:7245/1753333958884/2.jpg,http://localhost:7245/1753333958884/7.jpg,http://localhost:7245/1753333958884/1.jpg,http://localhost:7245/1753333958884/3.jpg', 800.00000000, '可俯瞰西湖全景，配备高端家电和浴缸。', 80.00000000, 5, NULL, 1, 'http://localhost:7245/1753333949447/1.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (29, '2025-07-24 18:15:00', 2, 42.00000000, 1, 800.00000000, '亲子主题房', 2, 650.00000000, 'http://localhost:7245/1753333958917/2.jpg,http://localhost:7245/1753333958917/5.jpg,http://localhost:7245/1753333958917/5.jpg,http://localhost:7245/1753333958917/1.jpg,http://localhost:7245/1753333958917/6.jpg,http://localhost:7245/1753333958917/6.jpg', 400.00000000, '房间布置温馨，配备儿童玩具和亲子设施。', 40.00000000, 5, NULL, 2, 'http://localhost:7245/1753333949461/9.jpg', 1, 1, '同意');
INSERT INTO `room` VALUES (30, '2025-07-24 18:30:00', 1, 35.00000000, 0, 600.00000000, '标准单人房', 1, 500.00000000, 'http://localhost:7245/1753333958946/0.jpg,http://localhost:7245/1753333958946/0.jpg,http://localhost:7245/1753333958946/0.jpg,http://localhost:7245/1753333958946/4.jpg,http://localhost:7245/1753333958946/7.jpg,http://localhost:7245/1753333958946/8.jpg', 250.00000000, '简洁舒适，适合出差或短住。', 25.00000000, 5, NULL, 1, 'http://localhost:7245/1753333949465/5.jpg', 0, 1, '同意');

-- ----------------------------
-- Table structure for roomdet
-- ----------------------------
DROP TABLE IF EXISTS `roomdet`;
CREATE TABLE `roomdet`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '房间明细主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `Floor` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层',
  `No` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '房号',
  `RoomId` int(11) NULL DEFAULT NULL COMMENT '房间',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  INDEX `RoomId`(`RoomId`) USING BTREE,
  CONSTRAINT `roomdet_ibfk_1` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `roomdet_ibfk_2` FOREIGN KEY (`RoomId`) REFERENCES `room` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 125 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '房间明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roomdet
-- ----------------------------
INSERT INTO `roomdet` VALUES (1, '2025-07-21 19:12:44', 2, '1', '1001', 1);
INSERT INTO `roomdet` VALUES (2, '2025-07-21 19:12:56', 2, '1', '1002', 1);
INSERT INTO `roomdet` VALUES (3, '2025-07-22 15:49:07', 2, '2', '2001', 1);
INSERT INTO `roomdet` VALUES (4, '2025-07-24 09:00:00', 2, '3F', '304', 1);
INSERT INTO `roomdet` VALUES (5, '2025-07-24 09:00:00', 2, '4F', '401', 2);
INSERT INTO `roomdet` VALUES (6, '2025-07-24 09:00:00', 2, '4F', '402', 2);
INSERT INTO `roomdet` VALUES (7, '2025-07-24 09:00:00', 2, '4F', '403', 2);
INSERT INTO `roomdet` VALUES (8, '2025-07-24 09:00:00', 2, '4F', '404', 2);
INSERT INTO `roomdet` VALUES (9, '2025-07-24 09:00:00', 2, '5F', '501', 3);
INSERT INTO `roomdet` VALUES (10, '2025-07-24 09:00:00', 2, '5F', '502', 3);
INSERT INTO `roomdet` VALUES (11, '2025-07-24 09:00:00', 2, '5F', '503', 3);
INSERT INTO `roomdet` VALUES (12, '2025-07-24 09:00:00', 2, '5F', '504', 3);
INSERT INTO `roomdet` VALUES (13, '2025-07-24 09:15:00', 3, '2F', '201', 4);
INSERT INTO `roomdet` VALUES (14, '2025-07-24 09:15:00', 3, '2F', '202', 4);
INSERT INTO `roomdet` VALUES (15, '2025-07-24 09:15:00', 3, '2F', '203', 4);
INSERT INTO `roomdet` VALUES (16, '2025-07-24 09:15:00', 3, '2F', '204', 4);
INSERT INTO `roomdet` VALUES (17, '2025-07-24 09:15:00', 3, '6F', '601', 5);
INSERT INTO `roomdet` VALUES (18, '2025-07-24 09:15:00', 3, '6F', '602', 5);
INSERT INTO `roomdet` VALUES (19, '2025-07-24 09:15:00', 3, '6F', '603', 5);
INSERT INTO `roomdet` VALUES (20, '2025-07-24 09:15:00', 3, '6F', '604', 5);
INSERT INTO `roomdet` VALUES (21, '2025-07-24 09:15:00', 3, '7F', '701', 6);
INSERT INTO `roomdet` VALUES (22, '2025-07-24 09:15:00', 3, '7F', '702', 6);
INSERT INTO `roomdet` VALUES (23, '2025-07-24 09:15:00', 3, '7F', '703', 6);
INSERT INTO `roomdet` VALUES (24, '2025-07-24 09:15:00', 3, '7F', '704', 6);
INSERT INTO `roomdet` VALUES (25, '2025-07-24 09:30:00', 4, '8F', '801', 7);
INSERT INTO `roomdet` VALUES (26, '2025-07-24 09:30:00', 4, '8F', '802', 7);
INSERT INTO `roomdet` VALUES (27, '2025-07-24 09:30:00', 4, '8F', '803', 7);
INSERT INTO `roomdet` VALUES (28, '2025-07-24 09:30:00', 4, '8F', '804', 7);
INSERT INTO `roomdet` VALUES (29, '2025-07-24 09:30:00', 4, '9F', '901', 8);
INSERT INTO `roomdet` VALUES (30, '2025-07-24 09:30:00', 4, '9F', '902', 8);
INSERT INTO `roomdet` VALUES (31, '2025-07-24 09:30:00', 4, '9F', '903', 8);
INSERT INTO `roomdet` VALUES (32, '2025-07-24 09:30:00', 4, '9F', '904', 8);
INSERT INTO `roomdet` VALUES (33, '2025-07-24 09:30:00', 4, '10F', '1001', 9);
INSERT INTO `roomdet` VALUES (34, '2025-07-24 09:30:00', 4, '10F', '1002', 9);
INSERT INTO `roomdet` VALUES (35, '2025-07-24 09:30:00', 4, '10F', '1003', 9);
INSERT INTO `roomdet` VALUES (36, '2025-07-24 09:30:00', 4, '10F', '1004', 9);
INSERT INTO `roomdet` VALUES (37, '2025-07-24 09:45:00', 5, '5F', '501', 10);
INSERT INTO `roomdet` VALUES (38, '2025-07-24 09:45:00', 5, '5F', '502', 10);
INSERT INTO `roomdet` VALUES (39, '2025-07-24 09:45:00', 5, '5F', '503', 10);
INSERT INTO `roomdet` VALUES (40, '2025-07-24 09:45:00', 5, '5F', '504', 10);
INSERT INTO `roomdet` VALUES (41, '2025-07-24 09:45:00', 5, '6F', '601', 11);
INSERT INTO `roomdet` VALUES (42, '2025-07-24 09:45:00', 5, '6F', '602', 11);
INSERT INTO `roomdet` VALUES (43, '2025-07-24 09:45:00', 5, '6F', '603', 11);
INSERT INTO `roomdet` VALUES (44, '2025-07-24 09:45:00', 5, '6F', '604', 11);
INSERT INTO `roomdet` VALUES (45, '2025-07-24 09:45:00', 5, '7F', '701', 12);
INSERT INTO `roomdet` VALUES (46, '2025-07-24 09:45:00', 5, '7F', '702', 12);
INSERT INTO `roomdet` VALUES (47, '2025-07-24 09:45:00', 5, '7F', '703', 12);
INSERT INTO `roomdet` VALUES (48, '2025-07-24 09:45:00', 5, '7F', '704', 12);
INSERT INTO `roomdet` VALUES (49, '2025-07-24 10:00:00', 6, '4F', '401', 13);
INSERT INTO `roomdet` VALUES (50, '2025-07-24 10:00:00', 6, '4F', '402', 13);
INSERT INTO `roomdet` VALUES (51, '2025-07-24 10:00:00', 6, '4F', '403', 13);
INSERT INTO `roomdet` VALUES (52, '2025-07-24 10:00:00', 6, '4F', '404', 13);
INSERT INTO `roomdet` VALUES (53, '2025-07-24 10:00:00', 6, '5F', '501', 14);
INSERT INTO `roomdet` VALUES (54, '2025-07-24 10:00:00', 6, '5F', '502', 14);
INSERT INTO `roomdet` VALUES (55, '2025-07-24 10:00:00', 6, '5F', '503', 14);
INSERT INTO `roomdet` VALUES (56, '2025-07-24 10:00:00', 6, '5F', '504', 14);
INSERT INTO `roomdet` VALUES (57, '2025-07-24 10:00:00', 6, '6F', '601', 15);
INSERT INTO `roomdet` VALUES (58, '2025-07-24 10:00:00', 6, '6F', '602', 15);
INSERT INTO `roomdet` VALUES (59, '2025-07-24 10:00:00', 6, '6F', '603', 15);
INSERT INTO `roomdet` VALUES (60, '2025-07-24 10:00:00', 6, '6F', '604', 15);
INSERT INTO `roomdet` VALUES (61, '2025-07-24 10:15:00', 7, '2F', '201', 16);
INSERT INTO `roomdet` VALUES (62, '2025-07-24 10:15:00', 7, '2F', '202', 16);
INSERT INTO `roomdet` VALUES (63, '2025-07-24 10:15:00', 7, '2F', '203', 16);
INSERT INTO `roomdet` VALUES (64, '2025-07-24 10:15:00', 7, '2F', '204', 16);
INSERT INTO `roomdet` VALUES (65, '2025-07-24 10:15:00', 7, '3F', '301', 17);
INSERT INTO `roomdet` VALUES (66, '2025-07-24 10:15:00', 7, '3F', '302', 17);
INSERT INTO `roomdet` VALUES (67, '2025-07-24 10:15:00', 7, '3F', '303', 17);
INSERT INTO `roomdet` VALUES (68, '2025-07-24 10:15:00', 7, '3F', '304', 17);
INSERT INTO `roomdet` VALUES (69, '2025-07-24 10:15:00', 7, '4F', '401', 18);
INSERT INTO `roomdet` VALUES (70, '2025-07-24 10:15:00', 7, '4F', '402', 18);
INSERT INTO `roomdet` VALUES (71, '2025-07-24 10:15:00', 7, '4F', '403', 18);
INSERT INTO `roomdet` VALUES (72, '2025-07-24 10:15:00', 7, '4F', '404', 18);
INSERT INTO `roomdet` VALUES (73, '2025-07-24 10:30:00', 5, '8F', '801', 19);
INSERT INTO `roomdet` VALUES (74, '2025-07-24 10:30:00', 5, '8F', '802', 19);
INSERT INTO `roomdet` VALUES (75, '2025-07-24 10:30:00', 5, '8F', '803', 19);
INSERT INTO `roomdet` VALUES (76, '2025-07-24 10:30:00', 5, '8F', '804', 19);
INSERT INTO `roomdet` VALUES (77, '2025-07-24 10:30:00', 5, '9F', '901', 20);
INSERT INTO `roomdet` VALUES (78, '2025-07-24 10:30:00', 5, '9F', '902', 20);
INSERT INTO `roomdet` VALUES (79, '2025-07-24 10:30:00', 5, '9F', '903', 20);
INSERT INTO `roomdet` VALUES (80, '2025-07-24 10:30:00', 5, '9F', '904', 20);
INSERT INTO `roomdet` VALUES (81, '2025-07-24 10:30:00', 5, '10F', '1001', 21);
INSERT INTO `roomdet` VALUES (82, '2025-07-24 10:30:00', 5, '10F', '1002', 21);
INSERT INTO `roomdet` VALUES (83, '2025-07-24 10:30:00', 5, '10F', '1003', 21);
INSERT INTO `roomdet` VALUES (84, '2025-07-24 10:30:00', 5, '10F', '1004', 21);
INSERT INTO `roomdet` VALUES (85, '2025-07-24 10:45:00', 6, '7F', '701', 22);
INSERT INTO `roomdet` VALUES (86, '2025-07-24 10:45:00', 6, '7F', '702', 22);
INSERT INTO `roomdet` VALUES (87, '2025-07-24 10:45:00', 6, '7F', '703', 22);
INSERT INTO `roomdet` VALUES (88, '2025-07-24 10:45:00', 6, '7F', '704', 22);
INSERT INTO `roomdet` VALUES (89, '2025-07-24 10:45:00', 6, '8F', '801', 23);
INSERT INTO `roomdet` VALUES (90, '2025-07-24 10:45:00', 6, '8F', '802', 23);
INSERT INTO `roomdet` VALUES (91, '2025-07-24 10:45:00', 6, '8F', '803', 23);
INSERT INTO `roomdet` VALUES (92, '2025-07-24 10:45:00', 6, '8F', '804', 23);
INSERT INTO `roomdet` VALUES (93, '2025-07-24 10:45:00', 6, '9F', '901', 24);
INSERT INTO `roomdet` VALUES (94, '2025-07-24 10:45:00', 6, '9F', '902', 24);
INSERT INTO `roomdet` VALUES (95, '2025-07-24 10:45:00', 6, '9F', '903', 24);
INSERT INTO `roomdet` VALUES (96, '2025-07-24 10:45:00', 6, '9F', '904', 24);
INSERT INTO `roomdet` VALUES (97, '2025-07-24 11:00:00', 7, '5F', '501', 25);
INSERT INTO `roomdet` VALUES (98, '2025-07-24 11:00:00', 7, '5F', '502', 25);
INSERT INTO `roomdet` VALUES (99, '2025-07-24 11:00:00', 7, '5F', '503', 25);
INSERT INTO `roomdet` VALUES (100, '2025-07-24 11:00:00', 7, '5F', '504', 25);
INSERT INTO `roomdet` VALUES (101, '2025-07-24 11:00:00', 7, '6F', '601', 26);
INSERT INTO `roomdet` VALUES (102, '2025-07-24 11:00:00', 7, '6F', '602', 26);
INSERT INTO `roomdet` VALUES (103, '2025-07-24 11:00:00', 7, '6F', '603', 26);
INSERT INTO `roomdet` VALUES (104, '2025-07-24 11:00:00', 7, '6F', '604', 26);
INSERT INTO `roomdet` VALUES (105, '2025-07-24 11:00:00', 7, '7F', '701', 27);
INSERT INTO `roomdet` VALUES (106, '2025-07-24 11:00:00', 7, '7F', '702', 27);
INSERT INTO `roomdet` VALUES (107, '2025-07-24 11:00:00', 7, '7F', '703', 27);
INSERT INTO `roomdet` VALUES (108, '2025-07-24 11:00:00', 7, '7F', '704', 27);
INSERT INTO `roomdet` VALUES (109, '2025-07-24 11:15:00', 5, '11F', '1101', 28);
INSERT INTO `roomdet` VALUES (110, '2025-07-24 11:15:00', 5, '11F', '1102', 28);
INSERT INTO `roomdet` VALUES (111, '2025-07-24 11:15:00', 5, '11F', '1103', 28);
INSERT INTO `roomdet` VALUES (112, '2025-07-24 11:15:00', 5, '11F', '1104', 28);
INSERT INTO `roomdet` VALUES (113, '2025-07-24 11:15:00', 5, '12F', '1201', 29);
INSERT INTO `roomdet` VALUES (114, '2025-07-24 11:15:00', 5, '12F', '1202', 29);
INSERT INTO `roomdet` VALUES (115, '2025-07-24 11:15:00', 5, '12F', '1203', 29);
INSERT INTO `roomdet` VALUES (116, '2025-07-24 11:15:00', 5, '12F', '1204', 29);
INSERT INTO `roomdet` VALUES (117, '2025-07-24 11:15:00', 5, '13F', '1301', 30);
INSERT INTO `roomdet` VALUES (118, '2025-07-24 11:15:00', 5, '13F', '1302', 30);
INSERT INTO `roomdet` VALUES (119, '2025-07-24 11:15:00', 5, '13F', '1303', 30);
INSERT INTO `roomdet` VALUES (120, '2025-07-24 11:15:00', 5, '13F', '1304', 30);
INSERT INTO `roomdet` VALUES (121, '2025-07-24 09:00:00', 2, '3F', '301', 1);
INSERT INTO `roomdet` VALUES (122, '2025-07-24 09:00:00', 2, '3F', '302', 1);
INSERT INTO `roomdet` VALUES (124, '2025-07-24 09:00:00', 2, '3F', '303', 1);

-- ----------------------------
-- Table structure for roommatch
-- ----------------------------
DROP TABLE IF EXISTS `roommatch`;
CREATE TABLE `roommatch`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分配房间主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `AppointId` int(11) NULL DEFAULT NULL COMMENT '订单',
  `RoomDetId` int(11) NULL DEFAULT NULL COMMENT '关联房号',
  `RoomId` int(11) NULL DEFAULT NULL COMMENT '房间',
  `RoomStatus` int(11) NULL DEFAULT NULL COMMENT '房间状态枚举(1:空闲,2:预约中,3:入住中,4:已退房)',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `BeginActiveTime` datetime(0) NULL DEFAULT NULL COMMENT '激活起始时间',
  `EndActiveTime` datetime(0) NULL DEFAULT NULL COMMENT '激活截至时间',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `AppointId`(`AppointId`) USING BTREE,
  INDEX `RoomId`(`RoomId`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  INDEX `RoomDetId`(`RoomDetId`) USING BTREE,
  CONSTRAINT `roommatch_ibfk_1` FOREIGN KEY (`AppointId`) REFERENCES `appoint` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `roommatch_ibfk_2` FOREIGN KEY (`RoomId`) REFERENCES `room` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `roommatch_ibfk_3` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `roommatch_ibfk_4` FOREIGN KEY (`RoomDetId`) REFERENCES `roomdet` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分配房间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roommatch
-- ----------------------------
INSERT INTO `roommatch` VALUES (7, '2025-07-22 16:52:47', 5, NULL, 1, 4, 2, '2025-07-30 14:00:00', '2025-07-31 12:00:00');
INSERT INTO `roommatch` VALUES (8, '2025-07-22 16:52:47', 5, NULL, 1, 4, 2, '2025-07-30 14:00:00', '2025-07-31 12:00:00');
INSERT INTO `roommatch` VALUES (9, '2025-07-22 16:52:47', 5, NULL, 1, 4, 2, '2025-07-31 14:00:00', '2025-08-01 12:00:00');
INSERT INTO `roommatch` VALUES (10, '2025-07-22 16:52:47', 5, NULL, 1, 4, 2, '2025-07-31 14:00:00', '2025-08-01 12:00:00');
INSERT INTO `roommatch` VALUES (11, '2025-07-22 16:52:47', 5, NULL, 1, 4, 2, '2025-08-01 14:00:00', '2025-08-02 12:00:00');
INSERT INTO `roommatch` VALUES (12, '2025-07-22 16:52:47', 5, NULL, 1, 4, 2, '2025-08-01 14:00:00', '2025-08-02 12:00:00');
INSERT INTO `roommatch` VALUES (13, '2025-07-22 16:56:29', 5, 2, 1, 4, 2, '2025-07-30 12:00:00', '2025-07-31 12:00:00');
INSERT INTO `roommatch` VALUES (14, '2025-07-22 16:56:29', 5, 1, 1, 4, 2, '2025-07-30 12:00:00', '2025-07-31 12:00:00');
INSERT INTO `roommatch` VALUES (15, '2025-07-22 16:56:29', 5, 1, 1, 4, 2, '2025-07-31 12:00:00', '2025-08-01 12:00:00');
INSERT INTO `roommatch` VALUES (16, '2025-07-22 16:56:29', 5, 2, 1, 4, 2, '2025-07-31 12:00:00', '2025-08-01 12:00:00');
INSERT INTO `roommatch` VALUES (17, '2025-07-22 16:56:29', 5, 3, 1, 4, 2, '2025-08-01 12:00:00', '2025-08-02 12:00:00');
INSERT INTO `roommatch` VALUES (18, '2025-07-22 16:56:29', 5, 1, 1, 4, 2, '2025-08-01 12:00:00', '2025-08-02 12:00:00');
INSERT INTO `roommatch` VALUES (19, '2025-07-26 11:57:14', 10, 30, 8, 4, 4, '2025-07-26 12:00:00', '2025-07-27 12:00:00');
INSERT INTO `roommatch` VALUES (20, '2025-07-26 12:02:32', 11, 18, 5, 4, 3, '2025-07-26 12:00:00', '2025-07-27 12:00:00');
INSERT INTO `roommatch` VALUES (21, '2025-07-27 11:58:14', 12, 2, 1, 4, 2, '2025-07-27 12:00:00', '2025-07-28 12:00:00');
INSERT INTO `roommatch` VALUES (22, '2025-07-27 11:58:14', 12, 1, 1, 4, 2, '2025-07-27 12:00:00', '2025-07-28 12:00:00');
INSERT INTO `roommatch` VALUES (23, '2025-07-27 11:58:14', 12, 2, 1, 4, 2, '2025-07-28 12:00:00', '2025-07-29 12:00:00');
INSERT INTO `roommatch` VALUES (24, '2025-07-27 11:58:14', 12, 1, 1, 4, 2, '2025-07-28 12:00:00', '2025-07-29 12:00:00');

-- ----------------------------
-- Table structure for roomprice
-- ----------------------------
DROP TABLE IF EXISTS `roomprice`;
CREATE TABLE `roomprice`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '房间价格主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `RoomId` int(11) NULL DEFAULT NULL COMMENT '房间',
  `Price` double(20, 8) NULL DEFAULT NULL COMMENT '价格',
  `EndActiveTime` datetime(0) NULL DEFAULT NULL COMMENT '截至有效时间',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `BeginActiveTime` datetime(0) NULL DEFAULT NULL COMMENT '起始有效时间',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `RoomId`(`RoomId`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  CONSTRAINT `roomprice_ibfk_1` FOREIGN KEY (`RoomId`) REFERENCES `room` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `roomprice_ibfk_2` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '房间价格表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roomprice
-- ----------------------------
INSERT INTO `roomprice` VALUES (1, '2025-07-21 11:10:35', 1, 0.01000000, '2025-07-31 00:00:00', 2, '2025-07-21 11:10:27');

-- ----------------------------
-- Table structure for storagerecord
-- ----------------------------
DROP TABLE IF EXISTS `storagerecord`;
CREATE TABLE `storagerecord`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '寄存记录主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `No` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '房间号',
  `TakeTime` datetime(0) NULL DEFAULT NULL COMMENT '领取时间',
  `TakePicture` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拍照',
  `HotelId` int(11) NULL DEFAULT NULL COMMENT '酒店',
  `Phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '物品信息',
  `RecordUserId` int(11) NULL DEFAULT NULL COMMENT '记录人',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `HotelId`(`HotelId`) USING BTREE,
  CONSTRAINT `storagerecord_ibfk_1` FOREIGN KEY (`HotelId`) REFERENCES `hotel` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '寄存记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of storagerecord
-- ----------------------------
INSERT INTO `storagerecord` VALUES (1, '2025-07-23 14:13:22', '1001', '2025-07-23 14:16:39', 'http://localhost:7245/433629385/643643347.jpg', 2, '13988888888', '行李箱', 3);

-- ----------------------------
-- Table structure for sysnotice
-- ----------------------------
DROP TABLE IF EXISTS `sysnotice`;
CREATE TABLE `sysnotice`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '系统通知主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `Content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '通知内容',
  `Title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `IsPutaway` tinyint(1) NULL DEFAULT NULL COMMENT '是否显示',
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sysnotice
-- ----------------------------
INSERT INTO `sysnotice` VALUES (1, '2025-07-23 08:30:00', '尊敬的客人，感谢您选择我们酒店。为了提升您的入住体验，我们近期对部分客房进行了升级改造，欢迎提出宝贵意见。', '客房升级通知', 1);
INSERT INTO `sysnotice` VALUES (2, '2025-07-23 09:15:00', '酒店餐厅今日推出夏季限定菜单，包括多款清凉饮品和特色菜品，欢迎前来品尝。', '夏季限定菜单上线', 1);
INSERT INTO `sysnotice` VALUES (3, '2025-07-23 10:45:00', '为提升服务质量，酒店将于2025年7月25日进行设施维护，期间部分服务可能受到影响，敬请谅解。', '设施维护通知', 1);
INSERT INTO `sysnotice` VALUES (4, '2025-07-23 11:20:00', '前台服务时间调整，请注意：夜间接待时间为18:00至次日8:00，如有需要请提前联系。', '前台服务时间调整', 1);
INSERT INTO `sysnotice` VALUES (5, '2025-07-23 12:00:00', '酒店健身房将于今日下午14:00至17:00进行设备检修，期间暂停使用，请合理安排锻炼时间。', '健身房设备检修通知', 1);
INSERT INTO `sysnotice` VALUES (6, '2025-07-23 13:30:00', '为了您的安全，酒店将于2025年7月24日上午进行消防演练，请配合工作人员指引，确保演练顺利进行。', '消防演练通知', 1);
INSERT INTO `sysnotice` VALUES (7, '2025-07-23 14:15:00', '酒店推出夏季优惠活动，预订豪华套房可享受8折优惠，活动时间从2025年7月20日至8月20日。', '夏季优惠活动', 1);
INSERT INTO `sysnotice` VALUES (8, '2025-07-23 15:00:00', '酒店泳池将于今日16:00至18:00进行清洁维护，敬请安排好使用时间。', '泳池维护通知', 1);
INSERT INTO `sysnotice` VALUES (9, '2025-07-23 16:20:00', '为了提升您的入住体验，酒店新增自助入住机，请前往一楼大厅使用，操作简便快捷。', '自助入住机上线', 1);
INSERT INTO `sysnotice` VALUES (10, '2025-07-23 17:00:00', '酒店停车场正在进行地面修复工程，进出时请注意安全，建议将车辆停放在B2/B3层。', '停车场施工通知', 1);

-- ----------------------------
-- Table structure for wechatcollection
-- ----------------------------
DROP TABLE IF EXISTS `wechatcollection`;
CREATE TABLE `wechatcollection`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '会话集合主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `LastMessage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最新消息',
  `SelfUserId` int(11) NULL DEFAULT NULL COMMENT '本身用户',
  `OtherUserId` int(11) NULL DEFAULT NULL COMMENT '对方用户',
  `LastTime` datetime(0) NULL DEFAULT NULL COMMENT '最新消息时间',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `SelfUserId`(`SelfUserId`) USING BTREE,
  INDEX `OtherUserId`(`OtherUserId`) USING BTREE,
  CONSTRAINT `wechatcollection_ibfk_1` FOREIGN KEY (`SelfUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `wechatcollection_ibfk_2` FOREIGN KEY (`OtherUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会话集合表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wechatcollection
-- ----------------------------
INSERT INTO `wechatcollection` VALUES (1, '2025-07-21 21:38:59', '这个房型不错', 3, 2, '2025-07-27 11:52:26');
INSERT INTO `wechatcollection` VALUES (2, '2025-07-21 21:38:59', '这个房型不错', 2, 3, '2025-07-27 11:52:26');
INSERT INTO `wechatcollection` VALUES (3, '2025-07-24 13:27:00', 'wa', 16, 9, '2025-07-24 13:27:04');
INSERT INTO `wechatcollection` VALUES (4, '2025-07-24 13:27:00', 'wa', 9, 16, '2025-07-24 13:27:04');
INSERT INTO `wechatcollection` VALUES (5, '2025-07-26 12:01:55', '', 17, 6, '2025-07-26 12:08:29');
INSERT INTO `wechatcollection` VALUES (6, '2025-07-26 12:01:55', '', 6, 17, '2025-07-26 12:08:29');

-- ----------------------------
-- Table structure for wechatmessage
-- ----------------------------
DROP TABLE IF EXISTS `wechatmessage`;
CREATE TABLE `wechatmessage`  (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '会话消息主键',
  `CreationTime` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `OtherUserId` int(11) NULL DEFAULT NULL COMMENT '对方用户',
  `SelfUserId` int(11) NULL DEFAULT NULL COMMENT '自身用户',
  `WechatMessageType` int(11) NULL DEFAULT NULL COMMENT '消息类型',
  `SendTime` datetime(0) NULL DEFAULT NULL COMMENT '发送时间',
  `FilePath` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件路径',
  `Content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '消息内容',
  PRIMARY KEY (`Id`) USING BTREE,
  INDEX `SelfUserId`(`SelfUserId`) USING BTREE,
  INDEX `OtherUserId`(`OtherUserId`) USING BTREE,
  CONSTRAINT `wechatmessage_ibfk_1` FOREIGN KEY (`SelfUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `wechatmessage_ibfk_2` FOREIGN KEY (`OtherUserId`) REFERENCES `appuser` (`Id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会话消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wechatmessage
-- ----------------------------
INSERT INTO `wechatmessage` VALUES (1, '2025-07-21 21:39:02', 2, 3, 1, '2025-07-21 21:39:02', NULL, '哇哇');
INSERT INTO `wechatmessage` VALUES (2, '2025-07-21 21:39:11', 3, 2, 1, '2025-07-21 21:39:11', NULL, '嗯嗯');
INSERT INTO `wechatmessage` VALUES (3, '2025-07-21 21:39:20', 2, 3, 2, '2025-07-21 21:39:20', 'http://localhost:7245/458969099/icon.jpg', '');
INSERT INTO `wechatmessage` VALUES (4, '2025-07-24 13:27:04', 9, 16, 1, '2025-07-24 13:27:04', NULL, 'wa');
INSERT INTO `wechatmessage` VALUES (5, '2025-07-26 12:01:58', 6, 17, 1, '2025-07-26 12:01:58', NULL, 'ces');
INSERT INTO `wechatmessage` VALUES (6, '2025-07-26 12:08:25', 6, 17, 1, '2025-07-26 12:08:25', NULL, '测试');
INSERT INTO `wechatmessage` VALUES (7, '2025-07-26 12:08:29', 6, 17, 2, '2025-07-26 12:08:29', 'http://localhost:7245/713046387/126126126.jpg', '');
INSERT INTO `wechatmessage` VALUES (8, '2025-07-27 11:52:11', 2, 3, 1, '2025-07-27 11:52:11', NULL, '你好啊');
INSERT INTO `wechatmessage` VALUES (9, '2025-07-27 11:52:26', 3, 2, 2, '2025-07-27 11:52:26', 'http://localhost:7245/447817306/643643347.jpg', '这个房型不错');

SET FOREIGN_KEY_CHECKS = 1;
