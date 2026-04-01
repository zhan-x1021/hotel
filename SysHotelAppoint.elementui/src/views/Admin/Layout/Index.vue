<template>
    <div class="admin-layout">
        <!-- 顶部导航栏 -->
        <el-header class="header">
            <!-- 左侧区域：Logo和系统名称 -->
            <div class="header-left">
                <el-icon class="menu-toggle" @click="isCollapse = !isCollapse">
                    <Fold v-if="!isCollapse" />
                    <Expand v-else />
                </el-icon>
                <div class="logo">
                    <img src="@/assets/logo.png" alt="系统logo">
                    <h1 class="system-title">酒店预约管理系统</h1>
                </div>
            </div>

            <!-- 右侧区域：用户信息和操作 -->
            <div class="header-right">
                <el-badge :value="4" class="notification-badge">
                    <el-icon class="notification-icon">
                        <Bell />
                    </el-icon>
                </el-badge>

                <el-dropdown trigger="click">
                    <div class="user-info">
                        <el-avatar :size="36" :src="UserInfo.ImageUrls || defaultAvatar" />
                        <div class="user-details">
                            <span class="username">{{ UserInfo.UserName }}</span>
                            <span class="role">{{ RoleType }}</span>
                        </div>
                    </div>
                    <template #dropdown>
                        <el-dropdown-menu>
                            <el-dropdown-item @click="handleUserInfo">
                                <el-icon>
                                    <User />
                                </el-icon>个人信息
                            </el-dropdown-item>
                            <el-dropdown-item @click="handlePasswordEdit">
                                <el-icon>
                                    <Lock />
                                </el-icon>修改密码
                            </el-dropdown-item>
                            <el-dropdown-item @click="handleLogout">
                                <el-icon>
                                    <SwitchButton />
                                </el-icon>退出登录
                            </el-dropdown-item>
                        </el-dropdown-menu>
                    </template>
                </el-dropdown>
            </div>
        </el-header>

        <!-- 主体内容区 -->
        <el-container class="main-container">
            <!-- 侧边栏 -->
            <el-aside :width="isCollapse ? '64px' : '220px'" class="sidebar">
                <el-menu :default-active="activeMenu" :router="true" :collapse="isCollapse" class="sidebar-menu"
                    background-color="#ffffff" text-color="#333333" active-text-color="#409EFF">

                    <!-- 管理员菜单 -->
                    <template v-if="RoleType == '管理员'">

                        <el-menu-item index="/LargeDataAnalysis">
                            <el-icon>
                                <Cpu />
                            </el-icon>
                            <span>数据大屏</span>
                        </el-menu-item>


                        <el-sub-menu index="UserList">
                            <template #title>
                                <el-icon>
                                    <Setting />
                                </el-icon>
                                <span>系统管理</span>
                            </template>
                            <el-menu-item index="/Admin/UserList">
                                <el-icon>
                                    <User />
                                </el-icon>账号管理
                            </el-menu-item>
                        </el-sub-menu>

                        <el-menu-item index="/Admin/HotelList">
                            <el-icon>
                                <OfficeBuilding />
                            </el-icon>
                            <span>酒店管理</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/EquipmentInfoList">
                            <el-icon>
                                <Cpu />
                            </el-icon>
                            <span>设备信息</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/SysNoticeList">
                            <el-icon>
                                <Bell />
                            </el-icon>
                            <span>系统通知</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/BannerList">
                            <el-icon>
                                <Picture />
                            </el-icon>
                            <span>封面管理</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/LeaveFeedbackList">
                            <el-icon>
                                <ChatDotRound />
                            </el-icon>
                            <span>留言反馈</span>
                        </el-menu-item>
                    </template>

                    <!-- 酒店管理员菜单 -->
                    <template v-if="RoleType == '酒店'">

                        <el-menu-item index="/Admin/HotelDataAnalysis">
                            <el-icon>
                                <Cpu />
                            </el-icon>
                            <span>酒店数据分析</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/HotelEdit">
                            <el-icon>
                                <OfficeBuilding />
                            </el-icon>
                            <span>酒店信息</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/HotelIntegralList">
                            <el-icon>
                                <Medal />
                            </el-icon>
                            <span>积分记录</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/RoomList" v-if="HotelDto.IsAudit == true">
                            <el-icon>
                                <House />
                            </el-icon>
                            <span>房间管理</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/RoomDetList" v-if="HotelDto.IsAudit == true">
                            <el-icon>
                                <List />
                            </el-icon>
                            <span>房间明细</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/AppointList">
                            <el-icon>
                                <Calendar />
                            </el-icon>
                            <span>预约记录</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/WeChat" v-if="HotelDto.IsAudit == true">
                            <el-icon>
                                <ChatLineRound />
                            </el-icon>
                            <span>消息中心</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/StorageRecordList">
                            <el-icon>
                                <Box />
                            </el-icon>
                            <span>寄存记录</span>
                        </el-menu-item>

                        <el-menu-item index="/Admin/EmployeeList" v-if="HotelDto.IsAudit == true">
                            <el-icon>
                                <UserFilled />
                            </el-icon>
                            <span>员工管理</span>
                        </el-menu-item>


                    </template>
                </el-menu>
            </el-aside>

            <!-- 主要内容区 -->
            <el-main class="main-content">
                <!-- 面包屑导航 -->
                <div class="breadcrumb-container">
                    <el-breadcrumb separator="/">
                        <el-breadcrumb-item v-for="(item, index) in breadcrumbList" :key="index" :to="item.path">
                            {{ item.title }}
                        </el-breadcrumb-item>
                    </el-breadcrumb>
                    <!-- 返回按钮 -->
                    <el-button class="back-button" @click="goBack" size="small" text>
                        <el-icon>
                            <Back />
                        </el-icon>返回
                    </el-button>
                </div>

                <!-- 路由视图 -->
                <div class="content-wrapper">
                    <router-view></router-view>
                </div>
            </el-main>
        </el-container>
    </div>
</template>

<script setup>
import defaultAvatar from '@/assets/默认头像.png'; // 导入默认头像图片
import { useCommonStore } from '@/store';
import { computed, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import {
    Bell, Back, Setting, User, Lock, SwitchButton,
    OfficeBuilding, Cpu, Picture, ChatDotRound, Edit,
    Medal, House, List, Calendar, ChatLineRound, Box,
    UserFilled, Fold, Expand
} from '@element-plus/icons-vue';

const commonStore = useCommonStore();
const router = useRouter();
const route = useRoute();

// 计算属性
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);
const HotelDto = computed(() => commonStore.HotelDto);

// 控制侧边栏折叠状态
const isCollapse = ref(false);

// 获取当前活动菜单
const activeMenu = computed(() => {
    return route.path;
});

// 面包屑数据
const breadcrumbList = ref([]);

// 监听路由变化，更新面包屑
watch(
    () => route.matched,
    (matched) => {
        // 如果不是首页，添加首页到面包屑
        if (!isHome(matched[0])) {
            breadcrumbList.value = [
                { title: '控制台', path: '/Admin' },
                ...matched.map(item => ({
                    title: item.meta.title || item.name,
                    path: item.path
                }))
            ];
        } else {
            breadcrumbList.value = matched.map(item => ({
                title: item.meta.title || item.name,
                path: item.path
            }));
        }
    },
    { immediate: true }
);

// 判断是否是首页
function isHome(route) {
    return route.path === "/Admin";
}

// 退出登录
function handleLogout() {
    commonStore.Logout();
    router.push("/Login");
}

// 返回上一页
function goBack() {
    router.back();
}

// 查看个人信息
function handleUserInfo() {
    router.push("/Admin/UserPerson");
}

// 修改密码
function handlePasswordEdit() {
    router.push("/Admin/PasswordEdit");
}
</script>

<style scoped lang="scss">
/* 整体布局样式 */
.admin-layout {
    height: 100vh;
    display: flex;
    flex-direction: column;
    background-color: #f5f7fa;
}

/* 顶部导航栏样式 */
.header {
    background-color: #ffffff;
    border-bottom: 1px solid #ebeef5;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px;
    height: 60px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    position: relative;
    z-index: 10;
}

/* 左侧区域样式 */
.header-left {
    display: flex;
    align-items: center;
    gap: 15px;
}

/* 菜单折叠按钮 */
.menu-toggle {
    font-size: 20px;
    cursor: pointer;
    color: #606266;
    padding: 5px;
    border-radius: 4px;
    transition: all 0.3s;
}

.menu-toggle:hover {
    background-color: #f0f2f5;
    color: #409EFF;
}

/* Logo样式 */
.logo {
    display: flex;
    align-items: center;
    gap: 12px;
}

.logo img {
    height: 32px;
    width: auto;
    object-fit: contain;
}

.system-title {
    font-size: 16px;
    font-weight: 600;
    color: #303133;
    margin: 0;
    white-space: nowrap;
}

/* 右侧用户信息样式 */
.header-right {
    display: flex;
    align-items: center;
    gap: 20px;
}

/* 通知图标 */
.notification-icon {
    font-size: 20px;
    cursor: pointer;
    color: #606266;
    transition: color 0.3s;
}

.notification-icon:hover {
    color: #409EFF;
}

.notification-badge :deep(.el-badge__content) {
    background-color: #f56c6c;
}

/* 用户信息样式 */
.user-info {
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    padding: 5px;
    border-radius: 4px;
    transition: background-color 0.3s;
}

.user-info:hover {
    background-color: #f5f7fa;
}

.user-details {
    display: flex;
    flex-direction: column;
}

.username {
    font-size: 14px;
    color: #303133;
    font-weight: 500;
    line-height: 1.2;
}

.role {
    font-size: 12px;
    color: #909399;
    line-height: 1.2;
}

/* 主体容器样式 */
.main-container {
    flex: 1;
    overflow: hidden;
}

/* 侧边栏样式 */
.sidebar {
    background-color: #ffffff;
    border-right: 1px solid #ebeef5;
    height: 100%;
    transition: width 0.3s;
    box-shadow: 2px 0 8px rgba(0, 0, 0, 0.02);
    overflow-x: hidden;
}

/* 侧边栏菜单样式 */
.sidebar-menu {
    border-right: none;
    height: 100%;
}

.sidebar-menu :deep(.el-menu-item),
.sidebar-menu :deep(.el-sub-menu__title) {
    height: 50px;
    line-height: 50px;
    font-size: 14px;
}

.sidebar-menu :deep(.el-menu-item.is-active) {
    background-color: #ecf5ff;
    border-right: 3px solid #409EFF;
}

.sidebar-menu :deep(.el-menu-item):hover,
.sidebar-menu :deep(.el-sub-menu__title):hover {
    background-color: #f5f7fa;
}

/* 菜单图标样式 */
.sidebar-menu :deep(.el-icon) {
    margin-right: 10px;
    font-size: 18px;
    vertical-align: middle;
}

/* 主内容区样式 */
.main-content {
    padding: 0;
    height: calc(100vh - 60px);
    overflow: hidden;
    display: flex;
    flex-direction: column;
}

/* 面包屑容器 */
.breadcrumb-container {
    padding: 16px 20px;
    background-color: #ffffff;
    border-bottom: 1px solid #ebeef5;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

/* 返回按钮样式 */
.back-button {
    display: flex;
    align-items: center;
    gap: 5px;
    color: #409EFF;
}

.back-button:hover {
    color: #66b1ff;
}

/* 内容包装器 */
.content-wrapper {
    padding: 20px;
    flex: 1;
    overflow-y: auto;
}
</style>
