<template>
    <div v-if="Hotel">
        <!-- 面包屑导航 -->
        <div class="breadcrumb">
            <span class="breadcrumb-label">您当前的位置:</span>
            <el-breadcrumb separator-class="el-icon-arrow-right">
                <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
                <el-breadcrumb-item :to="{ path: '/Front/HotelList' }">酒店列表</el-breadcrumb-item>
                <el-breadcrumb-item>酒店详情</el-breadcrumb-item>
            </el-breadcrumb>
        </div>

        <!-- 酒店封面图和基础信息左右布局 -->
        <div class="hotel-main-layout">
            <!-- 左侧：酒店封面图 -->
            <div class="hotel-cover">
                <img :src="coverImage" @error="imgError($event)" class="cover-img" />
                <!-- 酒店主图列表 -->
                <div class="hotel-main-images">
                    <div v-for="(img, idx) in hotelImages" :key="idx" class="main-image-item">
                        <img :src="img" @error="imgError($event)" class="main-img" @click="selectCover(img)"
                            :class="{ 'active-img': img === coverImage }" />
                    </div>
                </div>
            </div>
            <!-- 右侧：酒店基础信息 -->
            <div class="hotel-info-card">
                <h2 class="hotel-title">{{ Hotel.Name }}</h2>
                <div class="hotel-location">{{ Hotel.ProviceCityArea }} | {{ Hotel.Address }}</div>
                <el-tag v-if="Hotel.IsPet" type="success">可带宠物</el-tag>
                <el-tag v-else type="info">不可带宠物</el-tag>
                <el-tag :type="Hotel.IsAudit ? 'success' : 'danger'">{{ Hotel.IsAudit ? '已审核' : '未审核' }}</el-tag>


                <!-- 管理员信息（美观卡片） -->
                <div class="hotel-admin-card">
                    <div class="admin-info">
                        <img :src="Hotel.HotelUserDto && Hotel.HotelUserDto.ImageUrls ? Hotel.HotelUserDto.ImageUrls : defaultAvatar"
                            class="admin-avatar" />
                        <div class="admin-meta">
                            <div class="admin-name">管理员：{{ Hotel.HotelUserDto?.Name || '暂无' }}</div>
                            <div class="admin-phone">电话：{{ Hotel.HotelUserDto?.PhoneNumber || '暂无' }}</div>
                            <div class="admin-email">邮箱：{{ Hotel.HotelUserDto?.Email || '暂无' }}</div>
                        </div>
                    </div>

                    <!-- 咨询酒店按钮 -->
                    <div class="consult-button-container">
                        <el-button type="success" @click="goToLeaveFeedback" class="consult-button">
                            <el-icon>
                                <Message />
                            </el-icon>
                            <span>我要反馈</span>
                        </el-button>
                        <el-button type="primary" @click="consultHotel" class="consult-button">
                            <el-icon>
                                <ChatDotRound />
                            </el-icon>
                            <span>咨询酒店</span>
                        </el-button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 酒店详细介绍 -->
        <el-card class="hotel-detail-card">
            <div class="hotel-section">
                <h3>酒店简介</h3>
                <div>{{ Hotel.Content ? Hotel.Content : '暂无信息' }}</div>
            </div>
            <div class="hotel-section">
                <h3>服务设施</h3>
                <div>{{ Hotel.Services || '暂无信息' }}</div>
            </div>
            <div class="hotel-section">
                <h3>入住须知</h3>
                <div>{{ Hotel.Notice || '暂无信息' }}</div>
            </div>
            <div class="hotel-section">
                <h3>入住提示</h3>
                <div>{{ Hotel.CheckInTip || '暂无信息' }}</div>
            </div>
            <div class="hotel-section">
                <h3>必读</h3>
                <div>{{ Hotel.MustRead || '暂无信息' }}</div>
            </div>
        </el-card>

        <!-- 房间预订区域 -->
        <el-card class="room-booking-card">
            <el-tabs v-model="activeTab" class="hotel-tabs">
                <el-tab-pane label="房间" name="rooms">
                    <!-- 日期选择区域 -->
                    <div class="date-selection-area">
                        <div class="date-picker-container">
                            <span class="date-label">入住日期：</span>
                            <el-date-picker v-model="dateRange" type="daterange" range-separator="至"
                                start-placeholder="入住日期" end-placeholder="离店日期" format="YYYY-MM-DD"
                                value-format="YYYY-MM-DD HH:mm:ss" @change="handleDateChange" unlink-panels
                                :disabled-date="disabledDate" :clearable="false" :editable="false" style="width: 350px;" />
                            <span class="night-count" v-if="nightCount > 0">共 {{ nightCount }} 晚</span>
                        </div>
                    </div>

                    <!-- 房间列表将在这里显示 -->
                    <div class="room-list-container">
                        <!-- 房间列表 -->
                        <div v-for="room in roomList" :key="room.Id" class="room-item">
                            <!-- 左侧：房间图片 -->
                            <div class="room-image-container">
                                <img :src="room.Cover" @error="imgError($event)" class="room-cover-img" />

                                <!-- 图片预览缩略图 -->
                                <div class="room-thumbnails">
                                    <div v-for="(img, idx) in getRoomImages(room)" :key="idx" class="thumbnail-item">
                                        <img :src="img" @error="imgError($event)" class="thumbnail-img"
                                            @click="openGallery(room, idx)" />
                                    </div>
                                </div>
                            </div>

                            <!-- 右侧：房间信息 -->
                            <div class="room-info">
                                <h3 class="room-title">{{ room.Title }}</h3>
                                <div class="room-tags">
                                    <el-tag size="small">{{ room.RoomShapeFormat }}</el-tag>
                                    <el-tag size="small" type="success">{{ room.BreakfastTypeFormat }}</el-tag>
                                    <el-tag size="small" type="info">{{ room.FeaturedRoomShapeFormat }}</el-tag>
                                    <el-tag size="small" type="warning" v-if="room.IsImmediatelyConfirm">即时确认</el-tag>
                                    <el-tag size="small" type="success" v-if="room.IsFreeCancel">免费取消</el-tag>
                                </div>

                                <div class="room-details">
                                    <div class="room-detail-item">
                                        <span class="detail-label">房间面积:</span>
                                        <span class="detail-value">{{ room.AreaSize }}㎡</span>
                                    </div>
                                    <div class="room-detail-item">
                                        <span class="detail-label">剩余房间:</span>
                                        <span class="detail-value">{{ room.RemainingRoomNumber }}间</span>
                                    </div>
                                </div>

                                <div class="room-content" v-html="room.Content"></div>

                                <div class="room-facilities-button">
                                    <el-button type="info" size="small" plain @click="showFacilities(room)"
                                        class="facility-button">
                                        <el-icon>
                                            <List />
                                        </el-icon>
                                        <span>查看房间设施</span>
                                    </el-button>
                                </div>

                                <div class="room-price-booking">
                                    <div class="price-container">
                                        <span class="price-label">价格:</span>
                                        <span class="price-value">¥{{ room.ActualPrice }}</span>

                                        <!-- 积分信息和可抵扣金额显示 -->
                                        <div class="integral-info" v-if="room.Integral > 0">

                                            <el-tooltip effect="dark" placement="top">
                                                <template #content>
                                                    <span>{{ room.Integral }}积分可抵扣¥{{ room.IntegralExchangeMoney }}</span>
                                                </template>
                                                <el-tag size="small" type="success">{{ room.Integral }}积分可抵扣¥{{
                                                    room.IntegralExchangeMoney }}</el-tag>
                                            </el-tooltip>
                                        </div>
                                    </div>
                                    <el-button type="primary" @click="handleBooking(room)"
                                        :disabled="room.RemainingRoomNumber <= 0">
                                        立即预订
                                    </el-button>
                                </div>
                            </div>
                        </div>

                        <!-- 无数据提示 -->
                        <el-empty v-if="roomList.length === 0" description="暂无可预订房间"></el-empty>
                    </div>
                </el-tab-pane>
                <el-tab-pane label="评价" name="comments">

                    <PaginationBox ref="CommentPaginationBox" :where="{ HotelId: route.query.HotelId, AppointStatus: 5 }"
                        url="/Appoint/CommentList" :limit="8">
                        <template v-slot:content="{ data }">
                            <!-- 评价列表 -->
                            <div class="review-list">
                                <div v-for="(item, index) in data" :key="index" class="review-item">
                                    <!-- 用户信息和评分 -->
                                    <div class="review-header">
                                        <div class="user-info">
                                            <img :src="item.ToUserDto && item.ToUserDto.ImageUrls ? item.ToUserDto.ImageUrls : defaultAvatar"
                                                @error="imgError($event)" class="user-avatar" />
                                            <div class="user-meta">
                                                <div class="user-name">{{ item.ToUserDto ? item.ToUserDto.Name : '匿名用户' }}
                                                </div>
                                                <div class="review-date">{{ item.CreationTime }}</div>
                                            </div>
                                        </div>
                                        <div class="review-score">
                                            <span class="score-label">评分：</span>
                                            <el-rate v-model="item.CommentScore" disabled text-color="#ff9900"></el-rate>
                                            <span class="score-value">{{ item.CommentScore }}分</span>
                                        </div>
                                    </div>

                                    <!-- 评价内容 -->
                                    <div class="review-content">{{ item.Comment }}</div>

                                    <!-- 订单信息 -->
                                    <div class="order-info">
                                        <div class="room-info">
                                            <span class="info-label">房型：</span>
                                            <span class="info-value">{{ item.RoomDto ? item.RoomDto.Title : '未知房型' }}</span>
                                            <span class="room-type">{{ item.RoomDto ? item.RoomDto.RoomShapeFormat : ''
                                            }}</span>
                                        </div>
                                        <div class="stay-info">
                                            <span class="info-label">入住：</span>
                                            <span class="info-value">{{ item.BeginAppointTime.split(' ')[0] }} 至 {{
                                                item.EndAppointTime.split(' ')[0] }}</span>
                                            <span class="night-info">共{{ calculateNights(item.BeginAppointTime,
                                                item.EndAppointTime) }}晚</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- 无数据提示 -->
                                <el-empty v-if="data.length === 0" description="暂无评价"></el-empty>
                            </div>
                        </template>
                    </PaginationBox>
                </el-tab-pane>
                <el-tab-pane label="位置" name="postions">
                    <!-- 地图显示区域 -->
                    <div class="map-section">
                        <div class="map-container">
                            <el-skeleton v-if="!mapLoaded" :rows="12" animated />
                            <div id="hotelMap" class="hotel-map"></div>
                        </div>

                    </div>
                </el-tab-pane>
            </el-tabs>
        </el-card>


    </div>

    <!-- 图片预览弹窗 -->
    <el-dialog v-model="dialogVisible" title="图片预览" width="50%" :before-close="() => dialogVisible = false">
        <div class="gallery-container">
            <div class="gallery-main-image">
                <img :src="previewImages[previewIndex]" @error="imgError($event)" class="gallery-img" />
            </div>
            <div class="gallery-thumbnails">
                <div v-for="(img, idx) in previewImages" :key="idx" class="gallery-thumbnail-item">
                    <img :src="img" @error="imgError($event)" class="gallery-thumbnail-img" @click="previewIndex = idx"
                        :class="{ 'active-thumbnail': idx === previewIndex }" />
                </div>
            </div>
            <div class="gallery-controls">
                <el-button type="primary" circle icon="el-icon-arrow-left"
                    @click="previewIndex = (previewIndex - 1 + previewImages.length) % previewImages.length"
                    :disabled="previewImages.length <= 1">
                    <el-icon>
                        <ArrowLeft />
                    </el-icon>
                </el-button>
                <span class="gallery-counter">{{ previewIndex + 1 }} / {{ previewImages.length }}</span>
                <el-button type="primary" circle icon="el-icon-arrow-right"
                    @click="previewIndex = (previewIndex + 1) % previewImages.length" :disabled="previewImages.length <= 1">
                    <el-icon>
                        <ArrowRight />
                    </el-icon>
                </el-button>
            </div>
        </div>
    </el-dialog>

    <!-- 设施信息弹窗 -->
    <el-dialog v-model="facilitiesDialogVisible" title="房间设施" width="50%"
        :before-close="() => facilitiesDialogVisible = false">
        <template #title>
            <div class="dialog-title">
                <el-icon class="dialog-icon">
                    <List />
                </el-icon>
                <span>房间设施详情</span>
            </div>
        </template>
        <div class="facilities-container">
            <div v-if="roomFacilities.length > 0">
                <div class="category-container" v-for="(group, groupName) in groupedFacilities" :key="groupName">
                    <!-- 分类标题 -->
                    <div class="category-title">{{ groupName }}</div>
                    <!-- 分类下的设备列表 -->
                    <div class="facilities-list">
                        <div v-for="item in group" :key="item.Id" class="facility-item">
                            <span>{{ item.Name }}</span>
                            <span v-if="item.IsFree" class="free-tag">免费</span>
                        </div>
                    </div>
                </div>
            </div>
            <el-empty v-else description="暂无设施信息"></el-empty>
        </div>
    </el-dialog>
</template>
<script setup>
import defaultAvatar from '@/assets/默认头像.png'; // 导入默认头像图片
import NoImage from '@/assets/图片失效.png';
import { Post, PostSingleUpdate } from '@/api/http';
import { ref, reactive, nextTick, computed, onBeforeMount, watch, onBeforeUnmount } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useCommonStore } from "@/store";
import { ElMessage, ElMessageBox } from 'element-plus';
import { ArrowLeft, ArrowRight, List, ChatDotRound, Location } from '@element-plus/icons-vue';
const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);
const Hotel = ref(null);
const hotelImages = ref([]);
const coverImage = ref(NoImage); // 封面图
const mainImages = ref([]); // 主图列表

// 地图相关变量
const mapLoaded = ref(false);
const hotelMap = ref(null);
const hotelMarker = ref(null);
const hotelInfoWindow = ref(null);
const mapScriptsLoaded = ref(false);

// 图片失效处理
function imgError(e) {
    e.target.src = NoImage;
}

// 选择主图作为封面图
function selectCover(img) {
    coverImage.value = img;
}

// 监听Hotel数据变化，处理图片数组
watch(
    () => Hotel.value,
    (val) => {
        if (val && val.HotelImages) {
            const imgs = val.HotelImages.split(',').filter(Boolean);
            coverImage.value = imgs.length > 0 ? imgs[0] : NoImage;
            mainImages.value = imgs.length > 1 ? imgs.slice(1) : [];
            hotelImages.value = imgs; // 兼容旧用法
        } else {
            coverImage.value = NoImage;
            mainImages.value = [];
            hotelImages.value = [NoImage];
        }
    },
    { immediate: true }
);

const GetHotelApi = async () => {
    const { Data } = await Post("/Hotel/Get", { Id: route.query.HotelId });
    Hotel.value = Data;
};

// 标签页控制
const activeTab = ref('rooms');

// 日期选择相关
const dateRange = ref([]);
const SelectDateList = ref([]);
const nightCount = ref(0);

// 禁用今天之前的日期
const disabledDate = (time) => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    return time.getTime() < today.getTime();
};

// 处理日期变化
function handleDateChange(val) {

    if (val && val.length === 2) {
        // 更新SelectDateList
        SelectDateList.value = [...val]; // 创建新数组以确保响应式更新

        // 计算入住晚数
        const startDate = new Date(val[0]);
        const endDate = new Date(val[1]);
        const diffTime = Math.abs(endDate - startDate);
        nightCount.value = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        GetRoomListApi();

    } else {
        nightCount.value = 0;
        SelectDateList.value = [];
    }
}

//查询房间
const GetRoomListApi = async () => {
    const { Data } = await Post("/Room/UserList", {
        HotelId: route.query.HotelId,
        SelectDateList: SelectDateList.value
    });
    roomList.value = Data;
}

// 房间列表数据
const roomList = ref([]);

// 获取房间图片列表
function getRoomImages(room) {
    if (room.ImageUrls) {
        return room.ImageUrls.split(',').filter(Boolean);
    }
    return [];
}

// 图片预览相关
const dialogVisible = ref(false);
const previewImages = ref([]);
const previewIndex = ref(0);

// 设施信息相关
const facilitiesDialogVisible = ref(false);
const roomFacilities = ref([]);
const currentRoomId = ref(null);

// 按分类分组的设施
const groupedFacilities = computed(() => {
    const groups = {};
    roomFacilities.value.forEach(item => {
        if (!groups[item.GroupName]) {
            groups[item.GroupName] = [];
        }
        groups[item.GroupName].push(item);
    });
    return groups;
});

// 显示设施信息
async function showFacilities(room) {
    if (!room.EquipmentInfoIds) {
        roomFacilities.value = [];
        facilitiesDialogVisible.value = true;
        return;
    }

    try {

        const equipmentIds = room.EquipmentInfoIds.split(',').map(id => Number(id));
        const { Data } = await Post("/EquipmentInfo/List", {});

        if (Data && Data.Items) {
            // 过滤出房间拥有的设施
            roomFacilities.value = Data.Items.filter(item => equipmentIds.includes(item.Id));
        } else {
            roomFacilities.value = [];
        }

        facilitiesDialogVisible.value = true;
    } catch (error) {
        console.error("获取设施信息失败", error);
        ElMessage.error("获取设施信息失败");
    }
}

// 打开图片预览
function openGallery(room, index) {
    const images = getRoomImages(room);
    if (images.length > 0) {
        previewImages.value = images;
        previewIndex.value = index;
        dialogVisible.value = true;
    }
}

// 处理预订
function handleBooking(room) {
    if (SelectDateList.value.length !== 2) {
        ElMessage.warning('请先选择入住和离店日期');
        return;
    }

    if (!Token.value) {
        ElMessage.warning('请先登录');
        router.push('/Login');
        return;
    }

    // 跳转到预订页面
    router.push({
        path: '/Front/ToOrder',
        query: {
            RoomId: room.Id,
            HotelId: route.query.HotelId,
            CheckInDate: SelectDateList.value[0],
            CheckOutDate: SelectDateList.value[1],
            NightCount: nightCount.value
        }
    });
}

// 咨询酒店
const consultHotel = async function () {
    if (!Token.value) {
        ElMessage.warning('请先登录');
        router.push('/Login');
        return;
    }

    let { Success } = await Post("/WechatCollection/InsertWechatCollection",
        {
            SelfUserId: UserId.value,
            OtherUserId: Hotel.value.HotelUserId,
        });
    if (Success) {
        router.push({
            path: "/Front/Wechat",
            query: {
                OtherUserId: Hotel.value.HotelUserId
            }
        })
    }
}

// 计算入住天数
function calculateNights(beginTime, endTime) {
    const begin = new Date(beginTime);
    const end = new Date(endTime);
    const diffTime = Math.abs(end - begin);
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
}

// 加载地图相关脚本
const loadMapScripts = () => {
    return new Promise((resolve, reject) => {
        // 如果已经加载过，直接返回
        if (window.TMap) {
            mapScriptsLoaded.value = true;
            resolve();
            return;
        }

        // 记录需要加载的脚本数量
        let loadedCount = 0;
        const totalScripts = 2;

        // 创建和加载第一个脚本
        const script1 = document.createElement('script');
        script1.charset = 'utf-8';
        script1.src = 'https://map.qq.com/api/js?v=2.exp&key=R33BZ-DISK4-4J7UB-D3JHM-GQA3E-V6BBF&libraries=place';
        script1.async = true;

        // 创建和加载第二个脚本
        const script2 = document.createElement('script');
        script2.src = 'https://map.qq.com/api/gljs?v=1.exp&key=R33BZ-DISK4-4J7UB-D3JHM-GQA3E-V6BBF&libraries=service';
        script2.async = true;

        // 脚本加载成功的处理函数
        const handleScriptLoad = () => {
            loadedCount++;
            if (loadedCount === totalScripts) {
                mapScriptsLoaded.value = true;
                resolve();
            }
        };

        // 脚本加载失败的处理函数
        const handleScriptError = (error) => {
            reject(error);
            ElMessage.error('地图脚本加载失败，请刷新重试');
        };

        // 设置事件监听
        script1.addEventListener('load', handleScriptLoad);
        script1.addEventListener('error', handleScriptError);
        script2.addEventListener('load', handleScriptLoad);
        script2.addEventListener('error', handleScriptError);

        // 添加到文档中
        document.head.appendChild(script1);
        document.head.appendChild(script2);
    });
};

// 初始化酒店地图
const initHotelMap = async () => {
    // 确保有酒店数据且有经纬度
    if (!Hotel.value || !Hotel.value.Longitude || !Hotel.value.Latitude) {
        return;
    }

    // 等待脚本加载完成
    if (!mapScriptsLoaded.value) {
        try {
            await loadMapScripts();
        } catch (error) {
            console.error('加载地图脚本失败:', error);
            return;
        }
    }

    // 确保TMap已经加载
    if (!window.TMap) {
        ElMessage.error('地图组件未加载完成，请稍后再试');
        return;
    }

    // 创建地图实例
    const position = new TMap.LatLng(Hotel.value.Latitude, Hotel.value.Longitude);

    hotelMap.value = new TMap.Map('hotelMap', {
        zoom: 15,
        center: position,
        showControl: true,
        mapStyleId: 'style1'
    });

    // 添加酒店位置标记
    hotelMarker.value = new TMap.MultiMarker({
        map: hotelMap.value,
        geometries: [{
            id: 'hotel',
            position: position,
        }]
    });

    // 添加信息窗口
    hotelInfoWindow.value = new TMap.InfoWindow({
        map: hotelMap.value,
        position: position,
        content: `
            <div class="custom-info-window">
                <h3>${Hotel.value.Name}</h3>
                <p>${Hotel.value.Address}</p>
            </div>
        `,
        offset: { x: 0, y: -50 }
    });

    hotelInfoWindow.value.open();
    mapLoaded.value = true;
};

// 监听标签页切换，当切换到位置标签页时初始化地图
watch(activeTab, (newVal) => {
    if (newVal === 'postions') {
        // 在下一个DOM更新周期初始化地图
        nextTick(() => {
            initHotelMap();
        });
    }
});

// 监听Hotel数据变化，当在位置标签页时更新地图
watch(Hotel, (newVal) => {
    if (activeTab.value === 'postions' && newVal) {
        // 在下一个DOM更新周期初始化地图
        nextTick(() => {
            initHotelMap();
        });
    }
});

// 销毁地图以释放资源
onBeforeUnmount(() => {
    if (hotelMap.value) {
        hotelMap.value.destroy();
        hotelMap.value = null;
    }
});


async function InitDate() {

    // 设置默认日期为今天和明天
    const today = new Date();
    const tomorrow = new Date();
    tomorrow.setDate(today.getDate() + 1);

    // 格式化日期为 YYYY-MM-DD 12:00:00
    const formatDate = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day} 12:00:00`;

    };

    // 初始化日期范围为今天和明天
    const formattedToday = formatDate(today);
    const formattedTomorrow = formatDate(tomorrow);

    // 使用nextTick确保DOM更新后再设置值
    nextTick(() => {
        dateRange.value = [formattedToday, formattedTomorrow];
        SelectDateList.value = [formattedToday, formattedTomorrow];
        nightCount.value = 1; // 默认一晚
        GetRoomListApi();
    });
}

// 跳转到留言反馈页面
const goToLeaveFeedback = () => {
    router.push({
        path: '/Front/LeaveFeedbackAdd',
        query: { HotelId: route.query.HotelId }
    });
}

// 初始化日期范围
onBeforeMount(async () => {
    await GetHotelApi();
    await InitDate();
})
</script>
<style scoped>
/* 面包屑导航区域 */
.breadcrumb {
    margin-bottom: 20px;
    /* 底部间距 */
}

.breadcrumb-label {
    margin-right: 10px;
    /* 标签右侧间距 */
    color: #666;
    /* 字体颜色 */
}

/* 酒店主区域左右布局 */
.hotel-main-layout {
    display: flex;
    /* 横向排列 */
    align-items: flex-start;
    /* 顶部对齐 */
    gap: 32px;
    /* 左右间距 */
    background: #fff;
    /* 白色背景 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    /* 阴影 */
    padding: 20px;
    /* 内边距 */
    border-radius: 8px;
    /* 圆角 */
    margin-bottom: 20px;
    /* 底部间距 */
}

/* 酒店封面图区域 */
.hotel-cover {
    flex: 0 0 320px;
    /* 固定宽度 */
    text-align: center;
    /* 图片居中 */
}

.cover-img {
    width: 100%;
    /* 宽度自适应 */
    max-width: 320px;
    /* 最大宽度 */
    height: 200px;
    /* 固定高度 */
    object-fit: cover;
    /* 填充裁剪 */
    border-radius: 8px;
    /* 圆角 */
    box-shadow: 0 1px 6px rgba(0, 0, 0, 0.08);
    /* 图片阴影 */
    margin-bottom: 10px;
    /* 底部间距 */
}

/* 主图横向滚动列表 */
.hotel-main-images {
    display: flex;
    /* 横向排列 */
    gap: 10px;
    /* 图片间距 */
    overflow-x: auto;
    /* 横向滚动 */
    padding-bottom: 4px;
    /* 底部内边距 */
}

.main-image-item {
    flex: 0 0 auto;
    /* 固定宽度项 */
}

.main-img {
    width: 60px;
    /* 缩略图宽度 */
    height: 45px;
    /* 缩略图高度 */
    object-fit: cover;
    /* 填充裁剪 */
    border-radius: 4px;
    /* 圆角 */
    border: 2px solid transparent;
    /* 默认无边框 */
    cursor: pointer;
    /* 鼠标指针 */
    transition: border 0.2s;
    /* 边框动画 */
}

.main-img.active-img {
    border: 2px solid #409EFF;
    /* 选中高亮 */
}

/* 酒店基础信息卡片 */
.hotel-info-card {
    flex: 1 1 0%;
    /* 占据剩余空间 */
    border-radius: 8px;
    /* 圆角 */
    padding: 10px 0;
    /* 上下内边距 */
}

.hotel-title {
    font-size: 22px;
    /* 标题字号 */
    font-weight: bold;
    /* 加粗 */
    color: #222;
    /* 标题颜色 */
    margin-bottom: 8px;
    /* 底部间距 */
}

.hotel-location {
    font-size: 15px;
    /* 位置字号 */
    color: #888;
    /* 位置颜色 */
    margin-bottom: 8px;
    /* 底部间距 */
}

.el-tag {
    margin-right: 8px;
    /* 标签间距 */
    margin-bottom: 8px;
}

/* 管理员信息卡片 */
.hotel-admin-card {
    background: #f7f8fa;
    /* 浅灰背景 */
    border-radius: 6px;
    /* 圆角 */
    padding: 10px 12px;
    /* 内边距 */
    margin-top: 12px;
    /* 顶部间距 */
}

.admin-info {
    display: flex;
    /* 横向排列 */
    align-items: center;
    /* 垂直居中 */
}

.admin-avatar {
    width: 48px;
    /* 头像宽度 */
    height: 48px;
    /* 头像高度 */
    border-radius: 50%;
    /* 圆形头像 */
    object-fit: cover;
    /* 填充裁剪 */
    margin-right: 12px;
    /* 右侧间距 */
    border: 1px solid #eee;
    /* 头像边框 */
}

.admin-meta {
    flex: 1;
    /* 占据剩余空间 */
}

.admin-name,
.admin-phone,
.admin-email {
    font-size: 14px;
    /* 信息字号 */
    color: #444;
    /* 信息颜色 */
    margin-bottom: 2px;
    /* 信息间距 */
}

/* 咨询酒店按钮容器 */
.consult-button-container {
    margin-top: 10px;
    /* 顶部间距 */
    text-align: right;
    /* 右对齐 */
}

.consult-button {
    display: inline-flex;
    align-items: center;
    font-size: 13px;
    transition: all 0.3s;
}

.consult-button .el-icon {
    margin-right: 5px;
}

/* 酒店详细介绍卡片 */
.hotel-detail-card {
    background: #fff;
    /* 白色背景 */
    border-radius: 8px;
    /* 圆角 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    /* 阴影 */
    padding: 20px;
    /* 内边距 */
    margin-bottom: 20px;
    /* 底部间距 */
}

.hotel-section {
    margin-bottom: 18px;
    /* 区块间距 */
}

.hotel-section h3 {
    font-size: 17px;
    /* 小标题字号 */
    font-weight: bold;
    /* 加粗 */
    color: #409EFF;
    /* 小标题主色 */
    margin-bottom: 6px;
    /* 底部间距 */
    border-left: 4px solid #409EFF;
    /* 左侧高亮条 */
    padding-left: 8px;
    /* 左侧内边距 */
}

.hotel-section div {
    font-size: 15px;
    /* 内容字号 */
    color: #555;
    /* 内容颜色 */
    line-height: 1.7;
    /* 行高 */
    text-align: justify;
    /* 两端对齐 */
}

/* 房间预订卡片 */
.room-booking-card {
    background: #fff;
    /* 白色背景 */
    border-radius: 8px;
    /* 圆角 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    /* 阴影 */
    margin-bottom: 20px;
    /* 底部间距 */
}

/* 标签页样式 */
.hotel-tabs {
    padding: 10px 0;
    /* 标签页内边距 */
}

/* 日期选择区域 */
.date-selection-area {
    padding: 15px 0;
    /* 上下内边距 */
    border-bottom: 1px solid #eee;
    /* 底部分隔线 */
    margin-bottom: 20px;
    /* 底部间距 */
}

.date-picker-container {
    display: flex;
    /* 横向排列 */
    align-items: center;
    /* 垂直居中 */
    flex-wrap: wrap;
    /* 允许换行 */
}

.date-label {
    font-size: 15px;
    /* 标签字号 */
    color: #555;
    /* 标签颜色 */
    margin-right: 10px;
    /* 右侧间距 */
}

.night-count {
    margin-left: 15px;
    /* 左侧间距 */
    color: #409EFF;
    /* 高亮色 */
    font-weight: bold;
    /* 加粗 */
}

/* 房间列表容器 */
.room-list-container {
    min-height: 200px;
    /* 最小高度 */
}

/* 房间项样式 */
.room-item {
    display: flex;


    /* 圆角 */
    padding: 20px;
    /* 内边距 */
    margin-bottom: 20px;

    /* 阴影效果 */
    transition: box-shadow 0.3s;
    /* 过渡动画 */
}

.room-item:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    /* 悬停阴影 */
}

/* 房间图片区域 */
.room-image-container {
    flex: 0 0 240px;
    /* 固定宽度 */
    margin-right: 20px;
    /* 右侧间距 */
}

.room-cover-img {
    width: 240px;
    /* 图片宽度 */
    height: 160px;
    /* 图片高度 */
    object-fit: cover;
    /* 填充裁剪 */
    border-radius: 6px;
    /* 圆角 */
    margin-bottom: 10px;
    /* 底部间距 */
}

/* 缩略图容器 */
.room-thumbnails {
    display: flex;
    /* 横向排列 */
    gap: 8px;
    /* 间距 */
    overflow-x: auto;
    /* 横向滚动 */
    padding-bottom: 5px;
    /* 底部内边距 */
}

.thumbnail-item {
    flex: 0 0 auto;
    /* 固定宽度项 */
}

.thumbnail-img {
    width: 50px;
    /* 缩略图宽度 */
    height: 40px;
    /* 缩略图高度 */
    object-fit: cover;
    /* 填充裁剪 */
    border-radius: 4px;
    /* 圆角 */
    cursor: pointer;
    /* 鼠标指针 */
    border: 1px solid #eee;
    /* 边框 */
    transition: transform 0.2s;
    /* 过渡动画 */
}

.thumbnail-img:hover {
    transform: scale(1.05);
    /* 悬停放大 */
}

/* 房间信息区域 */
.room-info {
    flex: 1;

}

.room-title {
    font-size: 18px;
    /* 标题字号 */
    font-weight: bold;
    /* 加粗 */
    color: #333;
    /* 标题颜色 */
    margin-bottom: 8px;
    /* 底部间距 */
}

.room-tags {
    margin-bottom: 12px;
    /* 底部间距 */
}

.room-tags .el-tag {
    margin-right: 6px;
    /* 标签间距 */
    margin-bottom: 5px;
    /* 底部间距 */
}

/* 房间详情项 */
.room-details {
    display: flex;
    /* 横向排列 */
    flex-wrap: wrap;
    /* 允许换行 */
    margin-bottom: 10px;
    /* 底部间距 */
}

.room-detail-item {
    margin-right: 20px;
    /* 右侧间距 */
    margin-bottom: 5px;
    /* 底部间距 */
}

.detail-label {
    color: #666;
    /* 标签颜色 */
    margin-right: 5px;
    /* 右侧间距 */
}

.detail-value {
    color: #333;
    /* 值颜色 */
    font-weight: 500;
    /* 半粗体 */
}

/* 房间内容区域 */
.room-content {
    margin: 10px 0;
    /* 上下间距 */
    font-size: 14px;
    /* 内容字号 */
    color: #555;
    /* 内容颜色 */
    line-height: 1.5;
    /* 行高 */
    max-height: 60px;
    /* 最大高度 */
    overflow: hidden;
    /* 溢出隐藏 */
}

/* 房间设施按钮样式 */
.room-facilities-button {
    margin: 10px 0;
    /* 上下间距 */
}

.facility-button {
    display: inline-flex;
    align-items: center;
    font-size: 13px;
    transition: all 0.3s;
}

.facility-button .el-icon {
    margin-right: 5px;
}

/* 设施信息弹窗样式 */
.facilities-container {
    padding: 10px;
}

/* 对话框标题样式 */
.dialog-title {
    display: flex;
    align-items: center;
    font-size: 16px;
    font-weight: bold;
}

.dialog-icon {
    margin-right: 8px;
    font-size: 18px;
    color: #409EFF;
}

.category-container {
    margin-bottom: 20px;
    border-radius: 6px;
    padding: 10px;
    background-color: #f7f8fa;
}

.category-title {
    font-size: 16px;
    font-weight: bold;
    color: #333;
    margin-bottom: 15px;
    border-left: 4px solid #409EFF;
    padding-left: 8px;
}

.facilities-list {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
}

.facility-item {
    display: flex;
    align-items: center;
    background-color: #f0f9eb;
    border: 1px solid #e1f3d8;
    color: #333;
    padding: 6px 12px;
    border-radius: 4px;
    font-size: 14px;
}

.free-tag {
    background-color: #67C23A;
    color: white;
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 12px;
    margin-left: 10px;
}

/* 价格和预订区域 */
.room-price-booking {
    display: flex;
    /* 横向排列 */
    justify-content: space-between;
    /* 两端对齐 */
    align-items: center;
    /* 垂直居中 */
    margin-top: auto;
    /* 自动顶部间距，推到底部 */
    padding-top: 10px;
    /* 顶部内边距 */
    border-top: 1px dashed #eee;
    /* 顶部分隔线 */
}

.price-container {
    display: flex;
    /* 横向排列 */
    align-items: center;
    /* 垂直居中对齐 */
    flex-wrap: wrap;
    /* 允许换行 */
    gap: 8px;
    /* 元素间距 */
}

.price-label {
    font-size: 14px;
    /* 标签字号 */
    color: #666;
    /* 标签颜色 */
    margin-right: 5px;
    /* 右侧间距 */
}

.price-value {
    font-size: 22px;
    /* 价格字号 */
    color: #f56c6c;
    /* 价格颜色 */
    font-weight: bold;
    /* 加粗 */
}

/* 积分信息和可抵扣金额样式 */
.integral-info {
    display: flex;
    align-items: center;
    /* 垂直居中 */
    gap: 8px;
    /* 标签之间的间距 */
    margin-left: 10px;
    /* 左侧间距 */
}

.integral-info .el-tag {
    display: inline-flex;
    /* 行内弹性布局 */
    align-items: center;
    /* 垂直居中 */
    height: 24px;
    /* 固定高度 */
    padding: 0 8px;
    /* 内边距 */
    font-size: 12px;
    /* 字体大小 */
}

/* 图片预览弹窗样式 */
.gallery-container {
    display: flex;
    /* 弹性布局 */
    flex-direction: column;
    /* 纵向排列 */
    align-items: center;
    /* 居中 */
    padding: 10px;
    /* 内边距 */
}

.gallery-main-image {
    width: 100%;
    /* 宽度自适应 */
    max-width: 800px;
    /* 最大宽度 */
    height: 400px;
    /* 固定高度 */
    object-fit: contain;
    /* 保持比例 */
    margin-bottom: 15px;
    /* 底部间距 */
    border-radius: 8px;
    /* 圆角 */
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    /* 阴影 */
}

.gallery-img {
    width: 100%;
    /* 宽度自适应 */
    height: 100%;
    /* 高度自适应 */
    object-fit: contain;
    /* 保持比例 */
}

.gallery-thumbnails {
    display: flex;
    /* 横向排列 */
    gap: 10px;
    /* 缩略图间距 */
    overflow-x: auto;
    /* 横向滚动 */
    padding: 10px 0;
    /* 顶部底部内边距 */
    width: 100%;
    /* 宽度自适应 */
    max-width: 800px;
    /* 最大宽度 */
}

.gallery-thumbnail-item {
    flex: 0 0 auto;
    /* 固定宽度项 */
}

.gallery-thumbnail-img {
    width: 80px;
    /* 缩略图宽度 */
    height: 60px;
    /* 缩略图高度 */
    object-fit: cover;
    /* 填充裁剪 */
    border-radius: 4px;
    /* 圆角 */
    cursor: pointer;
    /* 鼠标指针 */
    border: 1px solid #eee;
    /* 边框 */
    transition: transform 0.2s;
    /* 过渡动画 */
}

.gallery-thumbnail-img:hover {
    transform: scale(1.05);
    /* 悬停放大 */
}

.gallery-thumbnail-img.active-thumbnail {
    border: 2px solid #409EFF;
    /* 选中高亮 */
}

.gallery-controls {
    display: flex;
    /* 横向排列 */
    justify-content: space-between;
    /* 两端对齐 */
    align-items: center;
    /* 垂直居中 */
    width: 100%;
    /* 宽度自适应 */
    max-width: 800px;
    /* 最大宽度 */
    margin-top: 15px;
    /* 顶部间距 */
}

.gallery-counter {
    font-size: 16px;
    /* 计数器字号 */
    color: #333;
    /* 计数器颜色 */
    font-weight: bold;
    /* 加粗 */
}

/* 评价列表样式 */
.review-list {
    margin-top: 20px;
    padding: 0 10px;
}

.review-item {
    background-color: #f9f9f9;
    border: 1px solid #eee;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 15px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.review-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.user-info {
    display: flex;
    align-items: center;
}

.user-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 10px;
    border: 1px solid #eee;
}

.user-meta {
    display: flex;
    flex-direction: column;
}

.user-name {
    font-size: 15px;
    font-weight: bold;
    color: #333;
}

.review-date {
    font-size: 12px;
    color: #888;
    margin-top: 2px;
}

.review-score {
    display: flex;
    align-items: center;
}

.score-label {
    font-size: 14px;
    color: #666;
    margin-right: 5px;
}

.score-value {
    font-size: 16px;
    font-weight: bold;
    color: #f56c6c;
}

.review-content {
    font-size: 14px;
    color: #555;
    line-height: 1.6;
    margin-bottom: 10px;
}

.order-info {
    display: flex;
    justify-content: space-between;
    font-size: 13px;
    color: #666;
    margin-top: 10px;
}

.info-label {
    margin-right: 5px;
}

.info-value {
    font-weight: 500;
    color: #333;
}

.room-type {
    font-size: 12px;
    color: #888;
    margin-left: 5px;
}

.night-info {
    margin-left: 5px;
}

/* 位置标签页样式 */
.map-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 15px 0;
    border-bottom: 1px solid #eee;
    margin-bottom: 20px;
}

.map-container {
    width: 100%;

    height: 400px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    margin-bottom: 20px;
}

.hotel-map {
    width: 100%;
    height: 100%;
}
</style>