<template>
    <div>
        <el-container>
            <el-header
                style="background-color: rgba(255, 255, 255, 0.95); width: 100%; position: fixed; z-index:1000; padding:0px; box-shadow: 0 1px 0 rgba(0, 0, 0, 0.05); backdrop-filter: blur(8px); transition: all 0.3s ease;">
                <div class="header-container">
                    <!-- 左侧logo和系统名称 -->
                    <div class="left-section">
                        <div class="logo-wrapper">
                            <img class="logo" src="@/assets/logo.png" alt="logo">
                        </div>
                        <span class="system-name">酒店预约管理系统</span>
                    </div>

                    <!-- 地址选择区域 -->
                    <div class="address-selection">
                        <div class="selected-address" @click="openAddressSelector">
                            <el-icon>
                                <Location />
                            </el-icon>
                            <span v-if="selectedAddress.province === '全国'">全国</span>
                            <span v-else-if="selectedAddress.city">
                                {{ selectedAddress.province }}-{{ selectedAddress.city
                                }}-{{ selectedAddress.area }}</span>
                            <span v-else>{{ selectedAddress.province }}</span>
                            <el-icon class="dropdown-icon"><arrow-down /></el-icon>
                        </div>
                    </div>

                    <!-- 中间菜单区域 -->
                    <div class="menu-section">
                        <div class="menu-item" @click="ToPath('/Front/Home')">
                            <span>首页</span>
                        </div>
                        <div class="menu-item" @click="ToPath('/Front/RoomSearch')">
                            <span>好房搜索</span>
                        </div>
                        <div class="menu-item" @click="ToPath('/Front/HotelList')">
                            <span>酒店列表</span>
                        </div>
                        <div class="menu-item" v-if="Token" @click="ToPath('/Front/LeaveFeedbackAdd')">
                            <span>留言反馈</span>
                        </div>
                        <div class="menu-item" v-if="Token" @click="ToPath('/Front/MyAppointOrderList')">
                            <span>我的订单</span>
                        </div>
                        <div class="menu-item" v-if="Token" @click="ToPath('/Front/MyHotelIntegralList')">
                            <span>我的积分</span>
                        </div>
                    
                    </div>

                    <!-- 右侧用户信息 -->
                    <div class="right-section">
                        <template v-if="!Token">
                            <el-button class="auth-btn" type="text" @click="ToRegister()">注册</el-button>
                            <div class="divider"></div>
                            <el-button class="auth-btn" type="text" @click="ToLogin()">登录</el-button>
                        </template>

                        <el-dropdown v-if="Token" trigger="click">
                            <div class="user-info">
                                <el-avatar :size="32" :src="UserInfo.ImageUrls || defaultAvatar" />
                                <span class="username">{{ UserInfo.UserName }}</span>
                                <el-icon class="dropdown-icon"><arrow-down /></el-icon>
                            </div>
                            <template #dropdown>
                                <el-dropdown-menu>
                                    <el-dropdown-item @click="ToUserInfo()">
                                        <el-icon>
                                            <User />
                                        </el-icon>
                                        <span>个人中心</span>
                                    </el-dropdown-item>
                                    <el-dropdown-item @click="ToWeChat()">
                                        <el-icon>
                                            <ChatDotRound />
                                        </el-icon>
                                        <span>消息</span>
                                    </el-dropdown-item>

                                    <el-dropdown-item @click="LoginOut()">
                                        <el-icon>
                                            <SwitchButton />
                                        </el-icon>
                                        <span>退出</span>
                                    </el-dropdown-item>
                                </el-dropdown-menu>
                            </template>
                        </el-dropdown>
                    </div>
                </div>
            </el-header>
            <div style="height: 50px;"></div>
            <el-main class="main-container main-box">
                <router-view></router-view>
            </el-main>
            <div style="height: 20px;"></div>
            <Footer></Footer>
        </el-container>

        <!-- 引入地址选择组件 -->
        <SelectAddress v-model:visible="addressDialogVisible" :initialAddress="selectedAddress"
            @selected="handleAddressSelected" />
    </div>
</template>

<script setup>
import defaultAvatar from '@/assets/默认头像.png'; // 导入默认头像图片
import { useCommonStore } from '@/store';
import { SwitchButton, User, ChatDotRound, ArrowDown, Location } from '@element-plus/icons-vue';
import { computed, ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import Footer from "./Footer.vue";
import SelectAddress from "@/components/Address/SelectAddress.vue";

// 获取store和router实例
const commonStore = useCommonStore()
const router = useRouter()
const route = useRoute()

// 响应式数据
const active = ref(route.path)
const isScrolled = ref(false)
const addressDialogVisible = ref(false)
const selectedAddress = ref({
    province: '全国',
    city: '',
    area: ''
})

// 监听滚动事件
onMounted(() => {
    window.addEventListener('scroll', handleScroll)
    // 初始状态判断
    handleScroll()

    // Initialize address from store
    if (commonStore.GlobalAddress) {
        selectedAddress.value = commonStore.GlobalAddress
    }
})

// 处理滚动事件
const handleScroll = () => {
    isScrolled.value = window.scrollY > 20
}

// 计算属性
const Token = computed(() => commonStore.Token)
const UserInfo = computed(() => commonStore.UserInfo)
const RoleType = computed(() => commonStore.RoleType)
const UserId = computed(() => commonStore.UserId)

// 方法定义
// 前往登录
const ToLogin = () => {
    router.push({
        path: "/Login"
    })
}

// 前往注册
const ToRegister = () => {
    router.push({
        path: "/Register"
    })
}

// 退出
const LoginOut = async () => {
    await commonStore.Logout()
    router.push({
        path: "/Login"
    })
}

// 跳转
const ToPath = async (url) => {
    router.push({
        path: url
    })
}

// 跳转到用户信息
const ToUserInfo = async () => {
    router.push({
        path: "/Front/UserCenter"
    })
}

// 跳转到修改密码
const ToEditPassword = async () => {
    router.push({
        path: "/Front/PasswordEdit"
    })
}

// 返回上一个页面
const goBack = () => {
    router.go(-1)
}
const ToWeChat = async () => {
    router.push({
        path: "/Front/WeChat"
    })
}

// 打开地址选择器
const openAddressSelector = () => {
    addressDialogVisible.value = true
}

// 处理地址选择
const handleAddressSelected = (address) => {
    selectedAddress.value = address
    commonStore.SetGlobalAddress(address);
    //重新加载页面
    window.location.reload();
}
</script>

<style scoped lang="scss">
/* 头部容器 */
.header-container {
    width: var(--content-width);
    height: 60px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: all 0.3s ease;
    position: relative;
}

/* 滚动效果 */
.header-container.scrolled {
    height: 50px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.header-container.scrolled .logo {
    height: 35px;
}

.header-container.scrolled .system-name {
    font-size: 15px;
}

.header-container.scrolled .menu-item {
    height: 50px;
    font-size: 14px;
}

/* 左侧区域 */
.left-section {
    display: flex;
    align-items: center;
    gap: 12px;
    transition: all 0.4s ease;
}

/* Logo包装器 */
.logo-wrapper {
    position: relative;
    overflow: hidden;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.logo-wrapper::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: radial-gradient(circle at center, rgba(255, 107, 107, 0.1) 0%, rgba(74, 86, 226, 0.1) 70%, transparent 100%);
    opacity: 0;
    transition: opacity 0.3s ease;
}

.logo-wrapper:hover::after {
    opacity: 1;
}

/* Logo样式 */
.logo {
    height: 40px;
    object-fit: contain;
    transition: all 0.3s ease;
    animation: fadeInLeft 0.8s ease;
}

.logo:hover {
    transform: scale(1.05);
}

/* 系统名称 */
.system-name {
    font-size: 17px;
    font-weight: 600;
    letter-spacing: 0.5px;
    background: linear-gradient(90deg, #FF6B6B, #4A56E2);
    background-size: 200% auto;
    background-clip: text;
    -webkit-background-clip: text;
    color: transparent;
    text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.05);
    transition: all 0.6s ease;
    animation: fadeInLeft 0.8s ease 0.1s both, shine 3s infinite alternate;
    padding: 3px 6px;
    border-radius: 4px;
    position: relative;
}

.system-name::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(74, 86, 226, 0.05);
    border-radius: 4px;
    transform: scaleX(0);
    transform-origin: left;
    transition: transform 0.3s ease;
    z-index: -1;
}

.system-name:hover {
    background-position: right center;
    transform: translateY(-1px);
    text-shadow: 0px 0px 3px rgba(74, 86, 226, 0.2);
}

.system-name:hover::before {
    transform: scaleX(1);
}

/* 中间菜单区域 */
.menu-section {
    display: flex;
    align-items: center;
    gap: 24px;
}

/* 菜单项样式 */
.menu-item {
    font-size: 15px;
    color: #555;
    cursor: pointer;
    padding: 0 6px;
    position: relative;
    transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
    height: 60px;
    display: flex;
    align-items: center;
    overflow: hidden;
    animation: fadeInDown 0.5s ease both;
}

/* 菜单项背景效果 */
.menu-item::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(74, 86, 226, 0.05);
    transform: scaleY(0);
    transform-origin: top;
    transition: transform 0.4s cubic-bezier(0.65, 0, 0.35, 1);
    z-index: 1;
    border-radius: 4px;
}

.menu-item:hover::before {
    transform: scaleY(1);
}

/* 菜单动画延迟 */
.menu-item:nth-child(1) {
    animation-delay: 0.05s;
}

.menu-item:nth-child(2) {
    animation-delay: 0.1s;
}

.menu-item:nth-child(3) {
    animation-delay: 0.15s;
}

.menu-item:nth-child(4) {
    animation-delay: 0.2s;
}

.menu-item:nth-child(5) {
    animation-delay: 0.25s;
}

.menu-item:nth-child(6) {
    animation-delay: 0.3s;
}

/* 菜单项span标签 */
.menu-item span {
    position: relative;
    z-index: 2;
    transition: all 0.3s ease;
    display: inline-block;
}

/* 菜单项悬停效果 */
.menu-item:hover {
    color: var(--primary-color);
}

.menu-item:hover span {
    transform: translateY(-2px);
    animation: pulse 0.5s ease;
}

@keyframes pulse {
    0% {
        transform: scale(1) translateY(-2px);
    }

    50% {
        transform: scale(1.05) translateY(-2px);
    }

    100% {
        transform: scale(1) translateY(-2px);
    }
}

/* 菜单项下划线效果 */
.menu-item::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 2px;
    background: linear-gradient(to right, #FF6B6B, #4A56E2);
    transform: scaleX(0);
    transform-origin: center;
    transition: transform 0.4s cubic-bezier(0.65, 0, 0.35, 1);
    z-index: 1;
}

/* 菜单项悬停时下划线效果 */
.menu-item:hover::after {
    transform: scaleX(1);
}

/* 闪光效果 */
.menu-item:hover::after {
    animation: shine 1.5s infinite;
    background: linear-gradient(to right,
            #FF6B6B 0%,
            #4A56E2 20%,
            #FF6B6B 40%,
            #4A56E2 60%,
            #FF6B6B 80%,
            #4A56E2 100%);
    background-size: 200% auto;
}

/* 菜单项选中状态 */
.menu-item.active {
    color: #4A56E2;
    font-weight: 500;
}

.menu-item.active::after {
    transform: scaleX(1);
    height: 3px;
}

/* 菜单项点击效果 */
.menu-item:active span {
    transform: translateY(1px);
}

/* 右侧区域 */
.right-section {
    display: flex;
    align-items: center;
    gap: 8px;
    animation: fadeInRight 0.8s ease 0.2s both;
}

/* 分隔线 */
.divider {
    height: 16px;
    width: 1px;
    background-color: #ddd;
    margin: 0 4px;
}

/* 认证按钮 */
.auth-btn {
    font-size: 14px;
    color: #555;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.auth-btn:hover {
    color: var(--primary-color);
    transform: translateY(-1px);
}

.auth-btn:active {
    transform: translateY(1px);
}

/* 用户信息样式 */
.user-info {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    padding: 4px 12px;
    border-radius: 50px;
    transition: all 0.3s ease;
    border: 1px solid transparent;
}

.user-info:hover {
    background-color: #f7f9fc;
    border-color: #eaedf1;
    transform: translateY(-1px);
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03);
}

/* 下拉图标 */
.dropdown-icon {
    margin-left: 4px;
    font-size: 12px;
    color: #999;
    transition: transform 0.3s ease;
}

.user-info:hover .dropdown-icon {
    transform: rotate(180deg);
    color: var(--primary-color);
}

/* 用户名样式 */
.username {
    font-size: 14px;
    color: #333;
}

/* 下拉菜单项样式 */
:deep(.el-dropdown-menu__item) {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 16px;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

:deep(.el-dropdown-menu__item:hover) {
    background-color: #f5f7fa;
    transform: translateX(4px);
    color: var(--primary-color);
}

:deep(.el-dropdown-menu__item:hover::before) {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 3px;
    height: 100%;
    background: linear-gradient(to bottom, #FF6B6B, #4A56E2);
    animation: slideDown 0.3s ease-out;
}

:deep(.el-dropdown-menu__item:hover i) {
    transform: scale(1.2) rotate(5deg);
    color: #4A56E2;
}

:deep(.el-dropdown-menu__item span) {
    transition: all 0.3s ease;
}

:deep(.el-dropdown-menu__item:hover span) {
    transform: translateX(4px);
}

:deep(.el-dropdown-menu) {
    border-radius: 8px;
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
    border: none;
    overflow: hidden;
}

/* 按钮样式 */
.el-button--text {
    font-size: 14px;
    transition: all 0.3s ease;
}

/* 主容器样式 */
.main-container {
    position: relative;
    width: var(--content-width);
    margin: 0 auto;
}

/* 主内容区域最小高度 */
.main-box {
    min-height: calc(100vh - 120px);
}

/* 主内容区域padding调整 */
.el-main {
    padding: 20px 0px 0px 0px !important;
    overflow: hidden;
}

/* 更新el-header样式 */
:deep(.el-header) {
    box-shadow: 0 1px 0 rgba(0, 0, 0, 0.05);
    backdrop-filter: blur(8px);
    background-color: rgba(255, 255, 255, 0.95) !important;
    transition: all 0.3s ease;
}

/* 动画关键帧 */
@keyframes fadeInDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes fadeInLeft {
    from {
        opacity: 0;
        transform: translateX(-20px);
    }

    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes fadeInRight {
    from {
        opacity: 0;
        transform: translateX(20px);
    }

    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes slideDown {
    from {
        height: 0;
    }

    to {
        height: 100%;
    }
}

@keyframes shine {
    to {
        background-position: 200% center;
    }
}

/* 地址选择区域 */
.address-selection {
    margin-right: 20px;
    animation: fadeInDown 0.5s ease both;
    animation-delay: 0.15s;
}

/* 已选择的地址样式 */
.selected-address {
    display: flex;
    align-items: center;
    gap: 5px;
    cursor: pointer;
    padding: 6px 12px;
    border-radius: 20px;
    background-color: #f5f7fa;
    border: 1px solid #eaedf1;
    transition: all 0.3s ease;
    font-size: 14px;
    color: #555;
}

.selected-address:hover {
    background-color: #e6f7ff;
    border-color: #91d5ff;
    color: #1890ff;
    transform: translateY(-1px);
}

.selected-address .el-icon {
    font-size: 14px;
}

/* 调整header-container布局，使地址选择器能够放在合适的位置 */
.header-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.left-section {
    flex: 0 0 auto;
}

.menu-section {
    flex: 1 1 auto;
    justify-content: center;
}

.right-section {
    flex: 0 0 auto;
}
</style>
