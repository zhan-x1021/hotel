<template>
    <div class="appoint-detail-container">
        <!-- 顶部状态栏 -->
        <div class="status-header" :class="statusClass">
            <div class="status-icon"><i :class="statusIcon"></i></div>
            <div class="status-info">
                <h1>{{ AppointDetail.AppointStatusFormat }}</h1>
                <p>订单号: {{ AppointDetail.No }}</p>
            </div>
        </div>

        <!-- 主要内容区 -->
        <div class="detail-content">
            <!-- 左侧酒店和房间信息 -->
            <div class="left-panel">
                <!-- 酒店信息卡片 -->
                <div class="detail-card hotel-card">
                    <div class="card-header">
                        <i class="el-icon-office-building"></i>
                        <h2>酒店信息</h2>
                    </div>
                    <div class="card-body" v-if="AppointDetail.HotelDto">
                        <div class="hotel-info-container">
                            <div class="hotel-cover">
                                <el-image :src="AppointDetail.HotelDto.Cover" :fallback="NoImage" fit="cover">
                                </el-image>
                            </div>
                            <div class="hotel-info">
                                <h3>{{ AppointDetail.HotelDto.Name }}</h3>
                                <p><i class="el-icon-location"></i> {{ AppointDetail.HotelDto.Address }}</p>
                                <div class="hotel-services">
                                    <span v-for="(service, index) in hotelServices" :key="index">
                                        {{ service }}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 房间信息卡片 -->
                <div class="detail-card room-card">
                    <div class="card-header">
                        <i class="el-icon-house"></i>
                        <h2>房间信息</h2>
                    </div>
                    <div class="card-body" v-if="AppointDetail.RoomDto">
                        <div class="room-info-container">
                            <!-- 左侧房间图片 -->
                            <div class="room-gallery">
                                <div class="main-image">
                                    <el-image :src="currentRoomImage" :fallback="NoImage" fit="cover"></el-image>
                                </div>
                                <div class="thumbnail-list">
                                    <div v-for="(img, index) in roomImages" :key="index" class="thumbnail-item"
                                        :class="{ active: currentImageIndex === index }" @click="setCurrentImage(index)">
                                        <el-image :src="img" :fallback="NoImage" fit="cover"></el-image>
                                    </div>
                                </div>
                            </div>
                            <!-- 右侧房间信息 -->
                            <div class="room-info">
                                <h3>{{ AppointDetail.RoomDto.Title }}</h3>
                                <div class="room-tags">
                                    <el-tag>{{ AppointDetail.RoomDto.RoomShapeFormat }}</el-tag>
                                    <el-tag type="success">{{ AppointDetail.RoomDto.FeaturedRoomShapeFormat }}</el-tag>
                                    <el-tag type="warning">{{ AppointDetail.RoomDto.BreakfastTypeFormat }}</el-tag>
                                    <el-tag type="info">{{ AppointDetail.RoomDto.AreaSize }}㎡</el-tag>
                                    <el-tag type="danger" v-if="AppointDetail.RoomDto.IsFreeCancel">免费取消</el-tag>
                                </div>
                                <div class="room-description" v-html="AppointDetail.RoomDto.Content"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 入住房间分配 -->
                <div class="detail-card room-assignment-card"
                    v-if="AppointDetail.RoomMatchDtos && AppointDetail.RoomMatchDtos.length">
                    <div class="card-header">
                        <i class="el-icon-key"></i>
                        <h2>房间分配</h2>
                    </div>
                    <div class="card-body">
                        <el-timeline>
                            <el-timeline-item v-for="(room, index) in AppointDetail.RoomMatchDtos" :key="index"
                                :timestamp="formatTimeRange(room.BeginActiveTime, room.EndActiveTime)"
                                :type="getTimelineItemType(index)">
                                <div class="room-assignment-item">
                                    <span class="room-number" v-if="room.RoomDetDto && room.RoomDetDto.No">
                                        {{ room.RoomDetDto.Floor }}层 {{ room.RoomDetDto.No }}房
                                    </span>
                                    <span class="room-status">{{ room.RoomStatusFormat }}</span>
                                </div>
                            </el-timeline-item>
                        </el-timeline>
                    </div>
                </div>
            </div>

            <!-- 右侧预订详情和入住人信息 -->
            <div class="right-panel">
                <!-- 预订详情卡片 -->
                <div class="detail-card booking-card">
                    <div class="card-header">
                        <i class="el-icon-document"></i>
                        <h2>预订详情</h2>
                    </div>
                    <div class="card-body">
                        <div class="info-row">
                            <span class="label">预订时间</span>
                            <span class="value">{{ AppointDetail.CreationTime }}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">入住日期</span>
                            <span class="value highlight">{{ AppointDetail.BeginAppointTime }}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">退房日期</span>
                            <span class="value highlight">{{ AppointDetail.EndAppointTime }}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">预订房间</span>
                            <span class="value">{{ AppointDetail.Qty }}间</span>
                        </div>
                        <div class="info-row">
                            <span class="label">入住人数</span>
                            <span class="value">{{ AppointDetail.TotalPeopleNum }}人</span>
                        </div>
                        <div class="info-row">
                            <span class="label">支付方式</span>
                            <span class="value">{{ AppointDetail.PayType }}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">支付时间</span>
                            <span class="value">{{ AppointDetail.PayTime }}</span>
                        </div>
                        <div class="info-row total-price">
                            <span class="label">总价</span>
                            <span class="value price">¥{{ AppointDetail.TotalMoney }}</span>
                        </div>
                    </div>
                </div>

                <!-- 预订人信息 -->
                <div class="detail-card user-card">
                    <div class="card-header">
                        <i class="el-icon-user"></i>
                        <h2>预订人信息</h2>
                    </div>
                    <div class="card-body" v-if="AppointDetail.ToUserDto">
                        <div class="user-avatar">
                            <el-avatar :size="64" :src="AppointDetail.ToUserDto.ImageUrls || defaultAvatar"></el-avatar>
                        </div>
                        <div class="user-info">
                            <h3>{{ AppointDetail.ToUserDto.Name }}</h3>
                            <p><i class="el-icon-phone"></i> {{ AppointDetail.ToUserDto.PhoneNumber }}</p>
                            <p><i class="el-icon-message"></i> {{ AppointDetail.ToUserDto.Email }}</p>
                            <p><i class="el-icon-user"></i> {{ AppointDetail.ToUserDto.UserName }}</p>
                        </div>
                    </div>
                </div>

                <!-- 入住人信息 -->
                <div class="detail-card guests-card">
                    <div class="card-header">
                        <i class="el-icon-user-solid"></i>
                        <h2>入住人信息</h2>
                    </div>
                    <div class="card-body">
                        <div class="guest-list">
                            <div class="guest-item" v-for="(guest, index) in AppointDetail.AppointDetDtos" :key="index">
                                <div class="guest-avatar">
                                    <el-avatar :size="40">{{ guest.Name.substring(0, 1) }}</el-avatar>
                                </div>
                                <div class="guest-info">
                                    <h4>{{ guest.Name }} <span class="guest-sex">{{ guest.Sex }}</span></h4>
                                    <p><i class="el-icon-phone"></i> {{ guest.Phone }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 评价信息 -->
                <div class="detail-card comment-card" v-if="AppointDetail.Comment">
                    <div class="card-header">
                        <i class="el-icon-chat-dot-square"></i>
                        <h2>用户评价</h2>
                    </div>
                    <div class="card-body">
                        <div class="comment-score">
                            <el-rate v-model="AppointDetail.CommentScore" disabled show-score text-color="#ff9900">
                            </el-rate>
                        </div>
                        <div class="comment-content">
                            {{ AppointDetail.Comment }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import defaultAvatar from '@/assets/默认头像.png'; // 导入默认头像图片
import NoImage from '@/assets/图片失效.png';
import { Post, PostSingleUpdate } from '@/api/http';
import { ref, reactive, nextTick, computed, onBeforeMount } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useCommonStore } from "@/store";
import { ElMessage, ElMessageBox } from 'element-plus';
const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);

const AppointId = ref(route.query.AppointId);
const AppointDetail = ref({});
const currentImageIndex = ref(0);

// 当前显示的房间图片
const currentRoomImage = computed(() => {
    if (roomImages.value.length > 0) {
        return roomImages.value[currentImageIndex.value];
    }
    return NoImage;
});

// 设置当前显示的图片
const setCurrentImage = (index) => {
    currentImageIndex.value = index;
};

const GetAppointDetailApi = async () => {
    const { Success, Data } = await Post(`/Appoint/Get`, { Id: AppointId.value });
    if (Success) {
        AppointDetail.value = Data;
    }
}

// 获取酒店服务列表
const hotelServices = computed(() => {
    if (AppointDetail.value && AppointDetail.value.HotelDto && AppointDetail.value.HotelDto.Services) {
        return AppointDetail.value.HotelDto.Services.split(',').map(item => item.trim());
    }
    return [];
});

// 获取房间图片列表
const roomImages = computed(() => {
    if (AppointDetail.value && AppointDetail.value.RoomDto && AppointDetail.value.RoomDto.ImageUrls) {
        return AppointDetail.value.RoomDto.ImageUrls.split(',');
    }
    return [];
});

// 格式化时间范围
const formatTimeRange = (start, end) => {
    if (!start || !end) return '';
    return `${start.substring(0, 10)} ~ ${end.substring(0, 10)}`;
};

// 获取时间轴项目类型，用于交替显示不同颜色
const getTimelineItemType = (index) => {
    const types = ['primary', 'success', 'warning', 'danger', 'info'];
    return types[index % types.length];
};

// 根据预订状态获取对应的样式类
const statusClass = computed(() => {
    if (!AppointDetail.value || !AppointDetail.value.AppointStatus) return 'status-default';

    const statusMap = {
        0: 'status-pending',   // 假设0是待支付
        1: 'status-confirmed', // 假设1是已确认
        2: 'status-checkin',   // 假设2是已入住
        3: 'status-checkout',  // 假设3是已退房
        4: 'status-canceled'   // 假设4是已取消
    };

    return statusMap[AppointDetail.value.AppointStatus] || 'status-default';
});

// 根据预订状态获取对应的图标
const statusIcon = computed(() => {
    if (!AppointDetail.value || !AppointDetail.value.AppointStatus) return 'el-icon-time';

    const iconMap = {
        0: 'el-icon-time',      // 待支付
        1: 'el-icon-check',     // 已确认
        2: 'el-icon-key',       // 已入住
        3: 'el-icon-circle-check', // 已退房
        4: 'el-icon-close'      // 已取消
    };

    return iconMap[AppointDetail.value.AppointStatus] || 'el-icon-time';
});

onBeforeMount(async () => {
    GetAppointDetailApi();
})
</script>

<style scoped lang="scss">
// 主题颜色变量
$primary-color: #409EFF;
$success-color: #67C23A;
$warning-color: #E6A23C;
$danger-color: #F56C6C;
$info-color: #909399;
$background-color: #f5f7fa;
$card-background: #ffffff;
$text-color: #303133;
$text-color-light: #606266;
$border-color: #EBEEF5;

// 整体容器样式
.appoint-detail-container {
    padding: 20px;
    background-color: $background-color;
    min-height: 100vh;

    // 顶部状态栏
    .status-header {
        display: flex;
        align-items: center;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        color: white;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        position: relative;
        overflow: hidden;

        &::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.2) 0%, rgba(255, 255, 255, 0) 100%);
            z-index: 1;
        }

        .status-icon {
            font-size: 36px;
            margin-right: 20px;
            z-index: 2;
        }

        .status-info {
            flex: 1;
            z-index: 2;

            h1 {
                margin: 0;
                font-size: 24px;
                font-weight: bold;
            }

            p {
                margin: 5px 0 0;
                font-size: 14px;
                opacity: 0.8;
            }
        }

        // 不同状态的颜色
        &.status-pending {
            background: linear-gradient(135deg, $warning-color, darken($warning-color, 20%));
        }

        &.status-confirmed {
            background: linear-gradient(135deg, $primary-color, darken($primary-color, 20%));
        }

        &.status-checkin {
            background: linear-gradient(135deg, $success-color, darken($success-color, 20%));
        }

        &.status-checkout {
            background: linear-gradient(135deg, $info-color, darken($info-color, 20%));
        }

        &.status-canceled {
            background: linear-gradient(135deg, $danger-color, darken($danger-color, 20%));
        }

        &.status-default {
            background: linear-gradient(135deg, $info-color, darken($info-color, 20%));
        }
    }

    // 主要内容区
    .detail-content {
        display: flex;
        gap: 20px;

        // 左侧面板
        .left-panel {
            flex: 3;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        // 右侧面板
        .right-panel {
            flex: 2;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        // 卡片通用样式
        .detail-card {
            background-color: $card-background;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;

            &:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            }

            .card-header {
                padding: 15px 20px;
                border-bottom: 1px solid $border-color;
                background-color: rgba(64, 158, 255, 0.05);
                display: flex;
                align-items: center;

                i {
                    font-size: 20px;
                    color: $primary-color;
                    margin-right: 10px;
                }

                h2 {
                    margin: 0;
                    font-size: 18px;
                    color: $text-color;
                }
            }

            .card-body {
                padding: 20px;
            }
        }

        // 酒店卡片样式
        .hotel-card {
            .hotel-info-container {
                display: flex;
                align-items: flex-start;
                gap: 20px;
            }

            .hotel-cover {
                width: 140px;
                height: 140px;
                border-radius: 8px;
                overflow: hidden;
                flex-shrink: 0;
                border: 1px solid $border-color;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);

                .el-image {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }
            }

            .hotel-info {
                flex: 1;

                h3 {
                    margin: 0 0 10px;
                    font-size: 18px;
                    color: $text-color;
                }

                p {
                    margin: 5px 0;
                    color: $text-color-light;

                    i {
                        margin-right: 5px;
                        color: $primary-color;
                    }
                }

                .hotel-services {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                    margin-top: 10px;

                    span {
                        padding: 4px 8px;
                        background-color: rgba(64, 158, 255, 0.1);
                        border-radius: 4px;
                        font-size: 12px;
                        color: $primary-color;
                    }
                }
            }
        }

        // 房间卡片样式
        .room-card {
            .room-info-container {
                display: flex;
                gap: 20px;
            }

            .room-gallery {
                width: 45%;
                flex-shrink: 0;
                display: flex;
                flex-direction: column;
                gap: 10px;

                .main-image {
                    width: 100%;
                    height: 150px;
                    border-radius: 8px;
                    overflow: hidden;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);

                    .el-image {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }
                }

                .thumbnail-list {
                    display: flex;
                    gap: 8px;
                    overflow-x: auto;
                    padding-bottom: 5px;

                    &::-webkit-scrollbar {
                        height: 4px;
                    }

                    &::-webkit-scrollbar-track {
                        background: $border-color;
                        border-radius: 2px;
                    }

                    &::-webkit-scrollbar-thumb {
                        background: $primary-color;
                        border-radius: 2px;
                    }

                    .thumbnail-item {
                        width: 50px;
                        height: 50px;
                        border-radius: 4px;
                        overflow: hidden;
                        cursor: pointer;
                        border: 2px solid transparent;
                        transition: all 0.3s;
                        flex-shrink: 0;

                        &.active {
                            border-color: $primary-color;
                            transform: translateY(-2px);
                        }

                        .el-image {
                            width: 100%;
                            height: 100%;
                            object-fit: cover;
                        }
                    }
                }
            }

            .room-info {
                flex: 1;

                h3 {
                    margin: 0 0 10px;
                    font-size: 18px;
                    color: $text-color;
                }

                .room-tags {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                    margin-bottom: 15px;
                }

                .room-description {
                    margin-top: 15px;
                    color: $text-color-light;
                    font-size: 14px;
                    line-height: 1.6;
                    padding: 10px;
                    background-color: rgba(245, 247, 250, 0.5);
                    border-radius: 6px;
                }
            }
        }

        // 房间分配卡片样式
        .room-assignment-card {
            .room-assignment-item {
                display: flex;
                justify-content: space-between;
                align-items: center;

                .room-number {
                    font-weight: bold;
                    color: $text-color;
                }

                .room-status {
                    padding: 2px 8px;
                    background-color: rgba(103, 194, 58, 0.1);
                    color: $success-color;
                    border-radius: 4px;
                    font-size: 12px;
                }
            }
        }

        // 预订详情卡片样式
        .booking-card {
            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px dashed $border-color;

                &:last-child {
                    border-bottom: none;
                }

                .label {
                    color: $text-color-light;
                    font-size: 14px;
                }

                .value {
                    color: $text-color;
                    font-size: 14px;
                    font-weight: 500;

                    &.highlight {
                        color: $primary-color;
                        font-weight: bold;
                    }

                    &.price {
                        color: $danger-color;
                        font-size: 20px;
                        font-weight: bold;
                    }
                }
            }

            .total-price {
                margin-top: 10px;
                padding-top: 15px;
                border-top: 2px solid $border-color;
            }
        }

        // 用户卡片样式
        .user-card {
            .card-body {
                display: flex;
                align-items: center;
            }

            .user-avatar {
                margin-right: 20px;
            }

            .user-info {
                h3 {
                    margin: 0 0 10px;
                    font-size: 18px;
                    color: $text-color;
                }

                p {
                    margin: 5px 0;
                    color: $text-color-light;

                    i {
                        margin-right: 5px;
                        color: $primary-color;
                    }
                }
            }
        }

        // 入住人卡片样式
        .guests-card {
            .guest-list {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .guest-item {
                display: flex;
                align-items: center;
                padding: 10px;
                background-color: rgba(245, 247, 250, 0.5);
                border-radius: 6px;

                .guest-avatar {
                    margin-right: 15px;
                }

                .guest-info {
                    h4 {
                        margin: 0 0 5px;
                        font-size: 16px;
                        color: $text-color;

                        .guest-sex {
                            font-size: 12px;
                            padding: 1px 6px;
                            background-color: rgba(64, 158, 255, 0.1);
                            color: $primary-color;
                            border-radius: 4px;
                            margin-left: 8px;
                        }
                    }

                    p {
                        margin: 0;
                        color: $text-color-light;
                        font-size: 14px;

                        i {
                            margin-right: 5px;
                            color: $primary-color;
                        }
                    }
                }
            }
        }

        // 评价卡片样式
        .comment-card {
            .comment-score {
                margin-bottom: 15px;
            }

            .comment-content {
                color: $text-color;
                font-size: 14px;
                line-height: 1.6;
                padding: 15px;
                background-color: rgba(245, 247, 250, 0.5);
                border-radius: 6px;
                border-left: 4px solid $primary-color;
            }
        }
    }
}

// 响应式布局
@media (max-width: 1200px) {
    .appoint-detail-container {
        .detail-content {
            flex-direction: column;
        }
    }
}

@media (max-width: 768px) {
    .appoint-detail-container {
        .detail-content {
            .room-card {
                .room-info-container {
                    flex-direction: column;

                    .room-gallery {
                        width: 100%;
                        margin-bottom: 15px;
                    }
                }
            }
        }
    }
}
</style>