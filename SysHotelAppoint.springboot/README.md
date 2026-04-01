# 酒店预约系统后端（Spring Boot）

## 项目简介

本项目为酒店预约系统的后端部分，基于 Spring Boot 3 开发，提供酒店、房间、预约、用户、积分、消息等核心业务的 RESTful API。支持多角色（管理员、酒店、用户）管理，具备完善的预约、支付、积分、消息、反馈等功能。

## 技术栈

- Java 17
- Spring Boot 3.3.1
- MyBatis-Plus 3.5.7
- MySQL 8.x
- Lombok
- JWT
- WebSocket
- Apache POI（Excel 导入导出）
- 邮件服务（QQ 邮箱）

## 主要功能模块

- **用户管理**：注册、登录、找回密码、修改密码、用户信息管理、角色分配
- **酒店管理**：酒店信息增删改查、热门酒店推荐
- **房间管理**：房间信息、房型、价格、设施、批量操作
- **预约管理**：预约下单、支付、取消、确认、退房、评价、自动取消未支付订单
- **积分管理**：积分获取、抵扣、查询、汇总
- **消息通知**：系统消息、预约消息、消息推送
- **员工管理**：员工信息管理
- **仓储管理**：物品寄存、领取
- **反馈与留言**：用户反馈、留言管理
- **文件上传**：支持多文件上传
- **数据分析**：酒店数据统计、综合统计
- **下拉枚举接口**：角色、房型、早餐类型、房间状态、预约状态等
- **微信会话与消息**：会话管理、消息发送、管理员消息推送

## 目录结构

```
src/main/java/com/example/web/
├── controller/   # 控制器层，RESTful API
├── service/      # 业务逻辑层
├── entity/       # 实体类（数据模型）
├── mapper/       # MyBatis-Plus 持久层
├── dto/          # 数据传输对象
├── enums/        # 枚举类型
├── tools/        # 工具类与通用组件
├── jobs/         # 定时任务
├── sockets/      # WebSocket相关
├── SysConst.java # 常量定义
├── WebApplication.java # 启动类
```

## 环境与配置

1. **JDK 17**
2. **MySQL 8.x**，并创建数据库 `SysHotelAppoint`，配置见 `src/main/resources/application.yml`
3. **Maven 3.6+**
4. 邮箱配置（用于找回密码等）：已在 `application.yml` 配置 QQ 邮箱
5. 端口默认：`7245`

**application.yml 主要配置示例：**

```yaml
server:
  port: 7245
spring:
  datasource:
    username: root
    password: 123456
    url: jdbc:mysql://localhost:3306/SysHotelAppoint?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
  mail:
    username: 806105498@qq.com
    password: jhtrzsovfmaebdgg
    host: smtp.qq.com
mybatis-plus:
  mapper-locations: mapper/*.xml
  type-aliases-package: com.example.web.entity
```

## 启动方式

1. 安装依赖：
   ```bash
   mvn clean install
   ```
2. 启动服务：
   ```bash
   mvn spring-boot:run
   ```
   或直接运行 `WebApplication.java`

## 常见问题

- 数据库连接失败：请检查 `application.yml` 的数据库配置和本地 MySQL 服务
- 邮箱发送失败：请检查邮箱配置和授权码
- 端口冲突：修改 `application.yml` 的 `server.port`

## 依赖说明（pom.xml）

- spring-boot-starter-web
- spring-boot-starter-jdbc
- mybatis-plus-spring-boot3-starter
- mysql-connector-j
- lombok
- java-jwt
- spring-boot-starter-mail
- spring-boot-starter-websocket
- apache poi/poi-ooxml
- commons-beanutils
- httpclient

## 其他

- 所有接口均为 RESTful 风格，部分支持文件上传/下载、WebSocket 通信
- 详细接口文档建议结合前端或代码注释查看

---

如有问题请联系开发者或查阅代码注释。
