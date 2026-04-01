<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>房间搜索</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <!-- 日期选择区域 -->
    <div class="date-selection-area">
        <div class="date-picker-container">
            <span class="date-label">入住日期：</span>
            <el-date-picker v-model="dateRange" type="daterange" range-separator="至" start-placeholder="入住日期"
                end-placeholder="离店日期" format="YYYY-MM-DD" value-format="YYYY-MM-DD HH:mm:ss" @change="handleDateChange"
                unlink-panels :disabled-date="disabledDate" :clearable="false" :editable="false" style="width: 350px;" />
            <span class="night-count" v-if="nightCount > 0">共 {{ nightCount }} 晚</span>
        </div>

        <!-- 搜索筛选区域 -->
        <div class="search-filters">
            <div class="filter-item">
                <span class="filter-label">酒店名称：</span>
                <el-input v-model="searchFilters.hotelName" placeholder="输入酒店名称" clearable class="filter-input"></el-input>
            </div>
            <div class="filter-item">
                <span class="filter-label">早餐类型：</span>
                <el-select v-model="searchFilters.breakfastType" placeholder="选择早餐类型" clearable class="filter-select">
                    <el-option key="" label="全部" value=""></el-option>
                    <el-option v-for="item in BreakfastTypeEnum" :key="item.Code" :label="item.Label" :value="item.Code">
                    </el-option>
                </el-select>
            </div>
            <div class="filter-item">
                <span class="filter-label">房型：</span>
                <el-select v-model="searchFilters.roomShape" placeholder="选择房型" clearable class="filter-select">
                    <el-option key="" label="全部" value=""></el-option>
                    <el-option v-for="item in RoomShapeEnum" :key="item.Code" :label="item.Label" :value="item.Code">
                    </el-option>
                </el-select>
            </div>
            <div class="filter-item">
                <span class="filter-label">特色房型：</span>
                <el-select v-model="searchFilters.featuredRoomShape" placeholder="选择特色房型" clearable class="filter-select">
                    <el-option key="" label="全部" value=""></el-option>
                    <el-option v-for="item in FeaturedRoomShapeEnum" :key="item.Code" :label="item.Label"
                        :value="item.Code">
                    </el-option>
                </el-select>
            </div>
            <el-button type="primary" size="default" @click="GetRoomListApi" class="search-button">
                <el-icon class="search-icon">
                    <Search />
                </el-icon>
                搜索
            </el-button>
            <el-button type="info" plain size="default" @click="handleResetFilters" class="reset-button">
                重置
            </el-button>
        </div>

        <!-- 第二行筛选 -->
        <div class="search-filters second-row">
            <div class="filter-item">
                <span class="filter-label">即时确认：</span>
                <el-select v-model="searchFilters.isImmediatelyConfirm" placeholder="即时确认" clearable class="filter-select">
                    <el-option key="" label="全部" value=""></el-option>
                    <el-option key="true" label="是" :value="true"></el-option>
                    <el-option key="false" label="否" :value="false"></el-option>
                </el-select>
            </div>
            <div class="filter-item">
                <span class="filter-label">免费取消：</span>
                <el-select v-model="searchFilters.isFreeCancel" placeholder="免费取消" clearable class="filter-select">
                    <el-option key="" label="全部" value=""></el-option>
                    <el-option key="true" label="是" :value="true"></el-option>
                    <el-option key="false" label="否" :value="false"></el-option>
                </el-select>
            </div>
        </div>

        <!-- 价格范围筛选 -->
        <div class="price-filter">
            <span class="filter-label">价格范围：</span>
            <div class="price-slider-container">
                <el-slider v-model="searchFilters.priceRange" range :min="0" :max="2000" :step="100" class="price-slider">
                </el-slider>
                <div class="price-display">
                    <span>¥{{ searchFilters.priceRange[0] }}</span>
                    <span>-</span>
                    <span>¥{{ searchFilters.priceRange[1] }}</span>
                </div>
            </div>
        </div>
    </div>

    <!-- 房间列表容器 -->
    <div class="room-list-container">
        <!-- 加载中状态 -->
        <div class="loading-container" v-if="loading">
            <el-skeleton :rows="3" animated />
            <el-skeleton :rows="3" animated style="margin-top: 20px" />
        </div>

        <!-- 房间列表 -->
        <div v-else>
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
                    <!-- 酒店信息区域 -->
                    <div class="hotel-info" v-if="room.HotelDto">
                        <h2 class="hotel-name" @click="goToHotelDetail(room.HotelDto.Id)">{{ room.HotelDto.Name }}</h2>
                        <div class="hotel-address">
                            <el-icon>
                                <Location />
                            </el-icon>
                            <span>{{ room.HotelDto.Address }}</span>

                        </div>



                        <!-- 评分和预订量信息 -->
                        <div class="hotel-score-info" v-if="room.HotelDto.CommentScore || room.HotelDto.TotalAppointCount">
                            <div class="score-item" v-if="room.HotelDto.CommentScore">
                                <span class="score-value">{{ room.HotelDto.CommentScore }}</span>
                                <span class="score-label">评分</span>
                            </div>
                            <div class="score-item" v-if="room.HotelDto.CommentCount">
                                <span class="score-value">{{ room.HotelDto.CommentCount }}</span>
                                <span class="score-label">评价数</span>
                            </div>
                            <div class="score-item" v-if="room.HotelDto.TotalAppointCount">
                                <span class="score-value">{{ room.HotelDto.TotalAppointCount }}</span>
                                <span class="score-label">预订量</span>
                            </div>
                            <!-- 查看酒店图片按钮 -->
                            <el-button type="info" size="small" plain @click="openHotelGallery(room.HotelDto)"
                                v-if="room.HotelDto.HotelImages" class="hotel-images-button">
                                <el-icon>
                                    <Picture />
                                </el-icon>
                                查看酒店图片
                            </el-button>
                        </div>

                    </div>

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
                        <el-button type="info" size="small" plain @click="showFacilities(room)" class="facility-button">
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
                                        room.IntegralExchangeMoney
                                    }}</el-tag>
                                </el-tooltip>
                            </div>
                        </div>
                        <el-button type="primary" @click="handleBooking(room)" :disabled="room.RemainingRoomNumber <= 0">
                            立即预订
                        </el-button>
                    </div>
                </div>
            </div>

            <!-- 无数据提示 -->
            <el-empty v-if="roomList.length === 0 && !loading" description="暂无可预订房间"></el-empty>
        </div>
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
                <el-button type="primary" circle
                    @click="previewIndex = (previewIndex - 1 + previewImages.length) % previewImages.length"
                    :disabled="previewImages.length <= 1">
                    <el-icon>
                        <ArrowLeft />
                    </el-icon>
                </el-button>
                <span class="gallery-counter">{{ previewIndex + 1 }} / {{ previewImages.length }}</span>
                <el-button type="primary" circle @click="previewIndex = (previewIndex + 1) % previewImages.length"
                    :disabled="previewImages.length <= 1">
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
import { ref, reactive, nextTick, computed, onBeforeMount, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useCommonStore } from "@/store";
import { ElMessage, ElMessageBox } from 'element-plus';
import { ArrowLeft, ArrowRight, List, Location, Picture, Search } from '@element-plus/icons-vue';

const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);
const GlobalAddress = computed(() => {
    if (commonStore.GlobalAddress) {
        if (commonStore.GlobalAddress.area) {
            return commonStore.GlobalAddress.area;
        }
        else if (commonStore.GlobalAddress.city) {
            return commonStore.GlobalAddress.city;
        }
        else if (commonStore.GlobalAddress.province == "全国") {
            return null;
        }
        else {
            return commonStore.GlobalAddress.province;
        }

    }
    else {
        return null;
    }

});


// 房间列表数据
const roomList = ref([]);
const loading = ref(false);

// 日期选择相关
const dateRange = ref([]);
const SelectDateList = ref([]);
const nightCount = ref(0);

// 搜索筛选条件
const searchFilters = reactive({
    hotelName: '',     // 酒店名称筛选
    breakfastType: '', // 早餐类型筛选
    roomShape: '',     // 房型筛选
    featuredRoomShape: '', // 特色房型筛选
    isImmediatelyConfirm: '', // 即时确认筛选
    isFreeCancel: '',  // 免费取消筛选
    priceRange: [0, 2000]  // 价格范围筛选，默认0-2000
});

// 重置筛选条件
const resetFilters = () => {
    searchFilters.hotelName = '';
    searchFilters.breakfastType = '';
    searchFilters.roomShape = '';
    searchFilters.featuredRoomShape = '';
    searchFilters.isImmediatelyConfirm = '';
    searchFilters.isFreeCancel = '';
    searchFilters.priceRange = [0, 2000];
}

// 重置筛选条件并重新搜索
const handleResetFilters = () => {
    resetFilters();
    GetRoomListApi();
}

// 图片预览相关
const dialogVisible = ref(false);
const previewImages = ref([]);
const previewIndex = ref(0);

// 设施信息相关
const facilitiesDialogVisible = ref(false);
const roomFacilities = ref([]);


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
    } else {
        nightCount.value = 0;
        SelectDateList.value = [];
    }
}

// 图片失效处理
function imgError(e) {
    e.target.src = NoImage;
}

// 获取房间图片列表
function getRoomImages(room) {
    if (room.ImageUrls) {
        return room.ImageUrls.split(',').filter(Boolean);
    }
    return [];
}

// 打开图片预览
function openGallery(room, index) {
    // 如果是房间图片预览
    if (index !== undefined) {
        const images = getRoomImages(room);
        if (images.length > 0) {
            previewImages.value = images;
            previewIndex.value = index;
            dialogVisible.value = true;
        }
    }
}

// 打开酒店图片预览
function openHotelGallery(hotel) {
    if (hotel && hotel.HotelImages) {
        const images = hotel.HotelImages.split(',').filter(Boolean);
        if (images.length > 0) {
            previewImages.value = images;
            previewIndex.value = 0;
            dialogVisible.value = true;
        }
    }
}

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
            HotelId: room.HotelId,
            CheckInDate: SelectDateList.value[0],
            CheckOutDate: SelectDateList.value[1],
            NightCount: nightCount.value
        }
    });
}

// 跳转到酒店详情
function goToHotelDetail(hotelId) {
    router.push({ path: '/Front/HotelDetail', query: { HotelId: hotelId } });
}

// 查询房间
const GetRoomListApi = async () => {
    try {
        loading.value = true;
        const { Data } = await Post("/Room/UserList", {
            SelectDateList: SelectDateList.value,
            GlobalAddress: GlobalAddress.value,
            BreakfastType: searchFilters.breakfastType || undefined,
            HotelName: searchFilters.hotelName || undefined,
            RoomShape: searchFilters.roomShape || undefined,
            FeaturedRoomShape: searchFilters.featuredRoomShape || undefined,
            IsImmediatelyConfirm: searchFilters.isImmediatelyConfirm,
            IsFreeCancel: searchFilters.isFreeCancel,
            MinPrice: searchFilters.priceRange[0],
            MaxPrice: searchFilters.priceRange[1]
        });
        roomList.value = Data;
    } catch (error) {
        console.error("获取房间列表失败", error);
        ElMessage.error("获取房间列表失败");
        roomList.value = [];
    } finally {
        loading.value = false;
    }
}

async function initDate() {
    // 检查路由是否包含日期参数
    const hasCheckInDate = route.query.CheckInDate;
    const hasCheckOutDate = route.query.CheckOutDate;

    if (hasCheckInDate && hasCheckOutDate) {
        // 将URL参数中的日期字符串转换为Date对象
        const checkInDate = new Date(route.query.CheckInDate);
        const checkOutDate = new Date(route.query.CheckOutDate);

        // 格式化日期为 YYYY-MM-DD 12:00:00
        const formatDate = (date) => {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day} 12:00:00`;
        };

        // 格式化从URL获取的日期
        const formattedCheckInDate = formatDate(checkInDate);
        const formattedCheckOutDate = formatDate(checkOutDate);

        // 使用nextTick确保DOM更新后再设置值
        nextTick(() => {
            dateRange.value = [formattedCheckInDate, formattedCheckOutDate];
            SelectDateList.value = [formattedCheckInDate, formattedCheckOutDate];

            // 计算入住晚数
            const diffTime = Math.abs(checkOutDate - checkInDate);
            nightCount.value = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

            GetRoomListApi();
        });
    } else {
        // 如果URL中没有日期参数，则使用默认日期（今天和明天）
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
}
// 早餐类型枚举
const BreakfastTypeEnum = ref([]);

const BreakfastTypeEnumApi = async () => {
    const { Data: { Items } } = await Post("/Select/BreakfastTypeEnum");
    BreakfastTypeEnum.value = Items;
}
//房型枚举
const RoomShapeEnum = ref([]);
const RoomShapeEnumApi = async () => {
    const { Data: { Items } } = await Post("/Select/RoomShapeEnum");
    RoomShapeEnum.value = Items;
}
//特色房型枚举
const FeaturedRoomShapeEnum = ref([]);
const FeaturedRoomShapeEnumApi = async () => {
    const { Data: { Items } } = await Post("/Select/FeaturedRoomShapeEnum");
    FeaturedRoomShapeEnum.value = Items;
}


onBeforeMount(async () => {
    resetFilters(); // 重置筛选条件
    await initDate();
    await BreakfastTypeEnumApi();
    await RoomShapeEnumApi();
    await FeaturedRoomShapeEnumApi();
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

/* 日期选择区域 */
.date-selection-area {
    padding: 15px;
    /* 内边距 */
    background: #fff;
    /* 白色背景 */
    border-radius: 8px;
    /* 圆角 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    /* 阴影 */
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

/* 搜索筛选区域 */
.search-filters {
    display: flex;
    /* 横向排列 */
    align-items: center;
    /* 垂直居中 */
    flex-wrap: wrap;
    /* 允许换行 */
    margin-top: 15px;
    /* 顶部间距 */
    gap: 20px;
    /* 筛选项间距 */
    padding-top: 15px;
    /* 顶部内边距 */
    border-top: 1px dashed #eee;
    /* 顶部分隔线 */
}

.search-filters.second-row {
    border-top: none;
    /* 移除第二行的顶部分隔线 */
    padding-top: 5px;
    /* 减少顶部内边距 */
    margin-top: 5px;
    /* 减少顶部间距 */
}

.filter-item {
    display: flex;
    /* 横向排列 */
    align-items: center;
    /* 垂直居中 */
}

.filter-label {
    font-size: 15px;
    /* 标签字号 */
    color: #555;
    /* 标签颜色 */
    margin-right: 10px;
    /* 右侧间距 */
}

.filter-select,
.filter-input {
    width: 180px;
    /* 下拉框和输入框宽度 */
}

.search-button {
    margin-left: auto;
    /* 靠右对齐 */
}

.search-icon {
    margin-right: 5px;
    /* 图标右侧间距 */
}

/* 价格范围筛选样式 */
.price-filter {
    margin-top: 15px;
    display: flex;
    align-items: center;
}

.price-slider-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    margin-left: 10px;
}

.price-slider {
    width: 100%;
    margin-bottom: 10px;
}

.price-display {
    display: flex;
    justify-content: space-between;
    color: #409EFF;
    font-weight: bold;
}

/* 房间列表容器 */
.room-list-container {
    min-height: 200px;
    /* 最小高度 */
}

/* 加载状态容器 */
.loading-container {
    padding: 20px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

/* 房间项样式 */
.room-item {
    display: flex;
    /* 横向排列 */
    background: #fff;
    /* 白色背景 */
    border-radius: 8px;
    /* 圆角 */
    padding: 20px;
    /* 内边距 */
    margin-bottom: 20px;
    /* 底部间距 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
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
    flex-wrap: wrap;
    /* 允许换行 */
    padding-bottom: 5px;
    /* 底部内边距 */
}

.thumbnail-item {
    flex: 0 0 calc(25% - 6px);
    /* 每行4个，考虑间距 */
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
    /* 占据剩余空间 */
}

/* 酒店信息区域 */
.hotel-info {
    margin-bottom: 15px;
    padding-bottom: 15px;
    border-bottom: 1px dashed #eee;
    position: relative;
}

/* 分割线 */
.hotel-info:after {
    content: '房间信息';
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    background-color: #fff;
    padding: 0 15px;
    color: #409EFF;
    font-size: 12px;
    font-weight: bold;
}

.hotel-name {
    font-size: 20px;
    font-weight: bold;
    color: #333;
    margin-bottom: 5px;
    cursor: pointer;
    transition: color 0.3s;
}

.hotel-name:hover {
    color: #409EFF;
}

.hotel-address {
    font-size: 14px;
    color: #666;
    margin-bottom: 5px;
    display: flex;
    align-items: center;
}

.hotel-address .el-icon {
    margin-right: 5px;
    color: #409EFF;
    font-size: 16px;
}

.pet-friendly-tag {
    margin-left: 10px;
}

.hotel-description {
    font-size: 14px;
    color: #555;
    margin-top: 5px;
    margin-bottom: 10px;
    line-height: 1.6;
    word-break: break-word;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 3;
    /* 显示3行 */
    -webkit-box-orient: vertical;
}

.hotel-score-info {
    display: flex;
    align-items: center;
    margin-top: 5px;
    margin-bottom: 10px;
    gap: 15px;
    flex-wrap: wrap;
}

.score-item {
    display: flex;
    align-items: baseline;
}

.score-value {
    font-size: 18px;
    font-weight: bold;
    color: #f56c6c;
    margin-right: 5px;
}

.score-label {
    font-size: 12px;
    color: #666;
}

.hotel-images-button {
    margin-left: auto;
    font-size: 13px;
    display: inline-flex;
    align-items: center;
}

.hotel-images-button .el-icon {
    margin-right: 5px;
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
</style>