<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item>首页</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <!-- 首页内容区域 -->
    <div class="home-container">
        <!-- 顶部轮播图 -->
        <div class="banner-section">
            <el-carousel height="500px" :interval="5000" indicator-position="outside" arrow="always">
                <el-carousel-item v-for="(item, index) in BannerList" :key="index" @click="handleBannerClick(item)">
                    <div class="banner-content">
                        <img :src="item.url" :alt="item.title" class="banner-image">
                        <div class="banner-text">
                            <h1>{{ item.title }}</h1>
                            <p>{{ item.description }}</p>
                        </div>
                    </div>
                </el-carousel-item>
            </el-carousel>

            <!-- 搜索预订表单 -->
            <div class="search-box">
                <h2 class="search-title">预订客房</h2>
                <el-form :model="bookingForm" class="booking-form">
                    <el-form-item>
                        <el-date-picker v-model="bookingForm.dateRange" type="daterange" range-separator="至"
                            start-placeholder="入住日期" end-placeholder="离店日期" style="width: 100%"></el-date-picker>
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" style="width: 100%" @click="goToHotelList">立即查询</el-button>
                    </el-form-item>
                </el-form>
            </div>
        </div>

        <!-- 酒店特色服务 -->
        <div class="features-section">
            <div class="section-title">
                <h2>酒店特色服务</h2>
                <div class="title-line"></div>
            </div>
            <div class="features-list">
                <div class="feature-item" v-for="(feature, index) in hotelFeatures" :key="index">
                    <div class="feature-icon">
                        {{ feature.icon }}
                    </div>
                    <h3>{{ feature.title }}</h3>
                    <p>{{ feature.description }}</p>
                </div>
            </div>
        </div>
        <!-- 热门酒店 -->
        <div class="hotel-section">
            <div class="section-title">
                <h2>热门酒店</h2>
                <div class="title-line"></div>
            </div>
            <div class="hotel-list">
                <!-- 使用CSS Grid替代el-row和el-col -->
                <div class="hotel-grid">
                    <div v-for="(hotel, index) in HotHotelList" :key="hotel.Id" class="hotel-card">
                        <div class="hotel-image">
                            <img :src="hotel.Cover || NoImage" :alt="hotel.Name">
                            <div class="hotel-tag">{{ hotel.ProviceCityArea ? hotel.ProviceCityArea.split(',')[2] : '热门' }}
                            </div>
                        </div>
                        <div class="hotel-info">
                            <h3>{{ hotel.Name }}</h3>
                            <div class="hotel-rating">
                                {{ '⭐'.repeat(Math.floor(hotel.CommentScore || 0)) }}
                                <span class="review-count">({{ hotel.CommentCount || 0 }}条点评)</span>
                            </div>
                            <p class="hotel-location">{{ hotel.Address }}</p>
                            <div class="hotel-price">
                                <span class="price-from">起价</span>
                                <span class="price-value">¥{{ Math.floor(Math.random() * 500 + 300) }}</span>
                            </div>
                            <el-button type="primary" class="view-btn" @click="goToHotelDetail(hotel.Id)">查看详情</el-button>
                        </div>
                    </div>
                    <!-- 当没有酒店数据时显示提示 -->
                    <div v-if="HotHotelList.length === 0" class="empty-data">暂无热门酒店数据</div>
                </div>
            </div>
        </div>
        <!-- 优惠活动 -->
        <div class="promotion-section">
            <div class="section-title">
                <h2>优惠活动</h2>
                <div class="title-line"></div>
            </div>
            <el-row :gutter="20">
                <el-col :span="12" v-for="(promo, index) in promotions" :key="index">
                    <div class="promo-card" :style="{ backgroundImage: `url(${promo.image})` }">
                        <div class="promo-content">
                            <h3>{{ promo.title }}</h3>
                            <p>{{ promo.description }}</p>
                            <el-button type="primary" plain>查看详情</el-button>
                        </div>
                    </div>
                </el-col>
            </el-row>
        </div>

        <!-- 系统通知 -->
        <div class="notice-section">
            <div class="section-title">
                <h2>系统通知</h2>
                <div class="title-line"></div>
            </div>
            <div class="notice-container">
                <div class="notice-list">
                    <div v-for="(notice, index) in SysNoticeList" :key="notice.Id" class="notice-item"
                        @click="goToNoticeDetail(notice)">
                        <div class="notice-icon">📢</div>
                        <div class="notice-content">
                            <h4>{{ notice.Title }}</h4>
                            <p>{{ notice.Content }}</p>
                            <div class="notice-time">{{ notice.CreationTime }}</div>
                        </div>
                    </div>
                    <!-- 无数据时显示提示 -->
                    <div v-if="SysNoticeList.length === 0" class="notice-empty">
                        暂无系统通知
                    </div>
                </div>
                <!-- 更多按钮 -->
                <div class="more-button-container">
                    <el-button type="primary" plain @click="goToNoticeList">查看更多</el-button>
                </div>
            </div>
        </div>

        <!-- 客户评价 -->
        <div class="testimonial-section">
            <div class="section-title">
                <h2>宾客评价</h2>
                <div class="title-line"></div>
            </div>
            <el-carousel :interval="4000" type="card" height="250px">
                <el-carousel-item v-for="(review, index) in CommentList" :key="index">
                    <div class="testimonial-card">
                        <div class="testimonial-avatar">
                            <img :src="review.avatar || defaultAvatar" alt="用户头像">
                        </div>
                        <div class="testimonial-content">
                            <div class="rating">
                                {{ '⭐'.repeat(Math.floor(review.rating)) }}
                            </div>
                            <p class="review-text">"{{ review.comment }}"</p>
                            <p class="reviewer-name">— {{ review.name }}</p>
                            <p class="hotel-info">{{ review.hotelName }} · {{ review.roomTitle }}</p>
                        </div>
                    </div>
                </el-carousel-item>
                <!-- 当没有评论数据时显示提示 -->
                <el-carousel-item v-if="CommentList.length === 0">
                    <div class="testimonial-card">
                        <div class="testimonial-content">
                            <p class="review-text" style="text-align: center;">暂无评价数据</p>
                        </div>
                    </div>
                </el-carousel-item>
            </el-carousel>
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


// 预订表单
const bookingForm = reactive({
    dateRange: '',

});

// 酒店特色服务
const hotelFeatures = reactive([
    {
        icon: '🍽️',
        title: '精致美食',
        description: '提供各类中西式美食，满足您的味蕾需求'
    },
    {
        icon: '🏋️‍♂️',
        title: '健身中心',
        description: '配备现代化健身设备，让您保持健康的生活方式'
    },
    {
        icon: '🏊‍♂️',
        title: '游泳池',
        description: '室内恒温泳池，全年开放，畅享游泳乐趣'
    },
    {
        icon: '💻',
        title: '商务中心',
        description: '提供全方位商务服务，满足您的工作需求'
    }
]);

// 优惠活动
const promotions = reactive([
    {
        title: '周末特惠',
        description: '周末入住享受7折优惠，另赠双人自助早餐',
        image: 'https://images.unsplash.com/photo-1551776552-dde6cd3ef7c0?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'
    },
    {
        title: '长住优惠',
        description: '连住5晚以上享受额外优惠，并获得免费接送机服务',
        image: 'https://images.unsplash.com/photo-1529290130-4ca3753253ae?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'
    }
]);

// 客户评价数据将从API获取，CommentList变量已在上方定义



const BannerList = ref([]);
const BannerListApi = async function () {
    const { Data: { Items } } = await Post('/Banner/List', {})
    if (Items && Items.length > 0) {
        // 将接口返回的数据转换为轮播图所需格式
        BannerList.value = Items.map(item => ({
            url: item.Cover || NoImage,
            title: item.Title,
            description: '',
            path: item.Path
        }));
    }
}

// 处理轮播图点击事件
const handleBannerClick = (banner) => {
    if (banner.path) {
        // 判断是否为外部链接
        if (banner.path.startsWith('http://') || banner.path.startsWith('https://') || banner.path.startsWith('www.')) {
            // 如果是完整URL或以www开头，作为外部链接在新窗口打开
            const url = banner.path.startsWith('www.') ? 'http://' + banner.path : banner.path;
            window.open(url, '_blank');
        } else {
            // 作为内部路由路径跳转
            router.push(banner.path);
        }
    }
};
const SysNoticeList = ref([]);
const SysNoticeListApi = async function () {
    const { Data: { Items } } = await Post('/SysNotice/List', { Limit: 5, IsShow: true })
    if (Items && Items.length > 0) {
        // 将接口返回的数据直接赋值给SysNoticeList
        SysNoticeList.value = Items;
    }
}

// 查看更多通知
const goToNoticeList = () => {
    router.push('/Front/SysNoticeList');
}

// 查看通知详情
const goToNoticeDetail = (notice) => {
    router.push({ path: '/Front/SysNoticeDetail', query: { SysNoticeId: notice.Id } });
}

const CommentList = ref([]);
const CommentListApi = async function () {
    const { Data: { Items } } = await Post('/Appoint/CommentList', { AppointStatus: 5, Limit: 5 })
    if (Items && Items.length > 0) {
        // 筛选出有评论内容的记录
        const commentsWithContent = Items.filter(item => item.Comment && item.CommentScore);

        // 将API返回的数据转换为评论展示所需格式
        CommentList.value = commentsWithContent.map(item => ({
            name: item.ToUserDto ? item.ToUserDto.Name : '匿名用户',
            avatar: item.ToUserDto && item.ToUserDto.ImageUrls ? item.ToUserDto.ImageUrls : defaultAvatar,
            rating: item.CommentScore || 0,
            comment: item.Comment.length > 80 ? item.Comment.slice(0, 80) + '...' : item.Comment,
            hotelName: item.HotelDto ? item.HotelDto.Name : '',
            roomTitle: item.RoomDto ? item.RoomDto.Title : '',
            date: item.CreationTime
        }));
    }
}

const HotHotelList = ref([]);
const HotHotelListApi = async function () {
    const { Data: { Items } } = await Post('/Hotel/HotHotelList', { IsAudit: true })
    if (Items && Items.length > 0) {
        // 最多只显示5条记录
        HotHotelList.value = Items.slice(0, 5);
    } else {
        HotHotelList.value = [];
    }
}

// 查看酒店详情
const goToHotelDetail = (hotelId) => {
    router.push({ path: '/Front/HotelDetail', query: { HotelId: hotelId } });
}
const goToHotelList = () => {

    router.push({
        path: '/Front/RoomSearch', query: {
            CheckInDate: bookingForm.dateRange[0],
            CheckOutDate: bookingForm.dateRange[1],

        }
    });
}
onBeforeMount(async () => {
    // 页面加载时的初始化操作
    BannerListApi();
    SysNoticeListApi();
    CommentListApi();
    HotHotelListApi();
})




</script>

<style scoped lang="scss">
/* 首页容器样式 */
.home-container {
    width: 100%;

    margin: 0 auto;
    padding: 0 15px;
}

/* 轮播图区域样式 */
.banner-section {
    position: relative;
    margin-bottom: 60px;

    .banner-content {
        position: relative;
        height: 100%;
        cursor: pointer;
        /* 添加手型光标 */

        &:hover {
            .banner-image {
                transform: scale(1.02);
                /* 轻微放大效果 */
                transition: transform 0.3s ease;
            }
        }

        .banner-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .banner-text {
            position: absolute;
            left: 50px;
            bottom: 50px;
            color: #fff;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);

            h1 {
                font-size: 36px;
                margin-bottom: 10px;
            }

            p {
                font-size: 18px;
                max-width: 400px;
            }
        }
    }

    /* 搜索框样式 */
    .search-box {
        position: absolute;
        right: 50px;
        top: 50%;
        transform: translateY(-50%);
        background: rgba(255, 255, 255, 0.9);
        padding: 25px;
        border-radius: 8px;
        width: 300px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);

        .search-title {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
    }
}

/* 通用区块标题样式 */
.section-title {
    text-align: center;
    margin-bottom: 30px;

    h2 {
        font-size: 28px;
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }

    .title-line {
        width: 60px;
        height: 3px;
        background-color: #409EFF;
        margin: 0 auto;
    }
}

/* 酒店特色服务样式 */
.features-section {
    padding: 50px 0;
    background-color: #f9f9f9;
    margin-bottom: 60px;

    .features-list {
        display: flex;
        justify-content: space-between;

        .feature-item {
            flex: 1;
            text-align: center;
            padding: 0 15px;

            .feature-icon {
                font-size: 40px;
                color: #409EFF;
                margin-bottom: 15px;
            }

            h3 {
                margin-bottom: 10px;
                color: #333;
            }

            p {
                color: #666;
                line-height: 1.6;
            }
        }
    }
}

/* 优惠活动样式 */
.promotion-section {
    margin-bottom: 60px;

    .promo-card {
        height: 250px;
        border-radius: 8px;
        overflow: hidden;
        background-size: cover;
        background-position: center;
        position: relative;
        margin-bottom: 20px;

        &::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to right, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.3));
        }

        .promo-content {
            position: relative;
            z-index: 1;
            padding: 30px;
            color: #fff;

            h3 {
                font-size: 24px;
                margin-bottom: 10px;
            }

            p {
                margin-bottom: 20px;
                max-width: 80%;
            }
        }
    }
}

/* 系统通知样式 */
.notice-section {
    margin-bottom: 60px;

    .notice-container {
        background-color: #f9f9f9;
        border-radius: 8px;
        padding: 20px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);

        .notice-list {
            display: flex;
            flex-direction: column;

            .notice-item {
                display: flex;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #eee;

                &:last-child {
                    border-bottom: none;
                }

                .notice-icon {
                    font-size: 30px;
                    color: #409EFF;
                    margin-right: 15px;
                }

                .notice-content {
                    flex: 1;

                    h4 {
                        font-size: 18px;
                        font-weight: bold;
                        color: #333;
                        margin-bottom: 5px;
                    }

                    p {
                        font-size: 14px;
                        color: #666;
                        line-height: 1.5;
                        margin-bottom: 5px;
                    }

                    .notice-time {
                        font-size: 12px;
                        color: #999;
                    }
                }
            }

            .notice-empty {
                text-align: center;
                padding: 20px;
                color: #999;
            }
        }

        .more-button-container {
            text-align: center;
            margin-top: 20px;
        }
    }
}

/* 客户评价样式 */
.testimonial-section {
    margin-bottom: 60px;

    .testimonial-card {
        background-color: #fff;
        padding: 30px;
        border-radius: 8px;
        display: flex;
        height: 100%;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);

        .testimonial-avatar {
            flex: 0 0 80px;
            margin-right: 20px;

            img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
            }
        }

        .testimonial-content {
            flex: 1;

            .rating {
                color: #F7BA2A;
                margin-bottom: 10px;

                i {
                    margin-right: 5px;
                }
            }

            .review-text {
                font-style: italic;
                margin-bottom: 15px;
                line-height: 1.6;
            }

            .reviewer-name {
                text-align: right;
                color: #666;
                font-weight: bold;
            }

            .hotel-info {
                margin-top: 10px;
                font-size: 14px;
                color: #999;
            }
        }
    }
}

/* 热门酒店样式 */
.hotel-section {
    margin-bottom: 60px;

    .hotel-list {
        width: 100%;

        .hotel-grid {
            /* 使用CSS Grid布局 */
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            grid-gap: 20px;
            width: 100%;
        }

        .empty-data {
            text-align: center;
            padding: 40px 0;
            color: #999;
            font-size: 16px;
            width: 100%;
            grid-column: 1 / -1;
            /* 跨越所有列 */
        }

        .hotel-card {
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;

            .hotel-image {
                position: relative;
                height: 200px;

                img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .hotel-tag {
                    position: absolute;
                    top: 10px;
                    left: 10px;
                    background-color: #409EFF;
                    color: #fff;
                    padding: 5px 10px;
                    border-radius: 4px;
                    font-size: 14px;
                    font-weight: bold;
                }
            }

            .hotel-info {
                padding: 15px 20px;
                flex-grow: 1;

                h3 {
                    font-size: 18px;
                    margin-bottom: 5px;
                    color: #333;
                    /* 添加文本溢出处理 */
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                .hotel-rating {
                    display: flex;
                    align-items: center;
                    margin-bottom: 5px;

                    .review-count {
                        font-size: 14px;
                        color: #999;
                        margin-left: 5px;
                    }
                }

                .hotel-location {
                    font-size: 14px;
                    color: #666;
                    margin-bottom: 10px;
                    /* 添加文本溢出处理 */
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                .hotel-price {
                    display: flex;
                    align-items: baseline;
                    margin-bottom: 15px;

                    .price-from {
                        font-size: 14px;
                        color: #999;
                        margin-right: 5px;
                    }

                    .price-value {
                        font-size: 24px;
                        font-weight: bold;
                        color: #409EFF;
                    }
                }

                .view-btn {
                    width: 100%;
                }
            }
        }
    }
}
</style>