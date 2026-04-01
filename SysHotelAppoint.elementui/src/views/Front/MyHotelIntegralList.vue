<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>我的酒店积分</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <!-- 酒店积分列表 -->
    <div class="integral-container">
        <div class="integral-header">
            <h2>我的酒店积分</h2>
            <div class="total-points">
                <span>总积分: </span>
                <span class="point-value">{{ totalIntegralPoints }}</span>
            </div>
        </div>

        <!-- 积分列表 -->
        <div v-if="hotelIntegrals.length > 0" class="hotel-list">
            <el-card v-for="(item, index) in hotelIntegrals" :key="index" class="hotel-card">
                <div class="hotel-info">
                    <div class="hotel-image">
                        <el-image :src="getCoverImage(item.Hotel.Cover)" :error-url="NoImage" fit="cover">
                        </el-image>
                    </div>
                    <div class="hotel-details">
                        <h3 class="hotel-name">{{ item.Hotel.Name }}</h3>
                        <p class="hotel-address">
                            <i class="el-icon-location"></i>
                            {{ item.Hotel.ProviceCityArea }} {{ item.Hotel.Address }}
                        </p>
                        <div class="hotel-services">
                            <span v-for="(service, idx) in getServices(item.Hotel.Services)" :key="idx" class="service-tag">
                                {{ service }}
                            </span>
                        </div>
                    </div>
                    <div class="hotel-points">
                        <div class="points-circle" :class="{ 'high-points': item.TotalIntegral > 200 }">
                            <span class="points-value">{{ item.TotalIntegral }}</span>
                            <span class="points-label">积分</span>
                        </div>
                        <el-button type="primary" size="small" class="view-history-btn"
                            @click="viewIntegralHistory(item.Hotel.Id)">
                            查看积分流水
                        </el-button>
                    </div>
                </div>
            </el-card>
        </div>

        <!-- 无数据提示 -->
        <el-empty v-else description="暂无积分记录" :image-size="200"></el-empty>
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

// 查看积分流水记录
const viewIntegralHistory = (hotelId) => {
    router.push({
        path: '/Front/HotelIntegralDetList',
        query: { HotelId: hotelId }
    });
};

// 酒店积分数据
const hotelIntegrals = ref([]);
const totalIntegralPoints = computed(() => {
    return hotelIntegrals.value.reduce((total, item) => total + item.TotalIntegral, 0);
});

// 获取封面图片
const getCoverImage = (coverUrl) => {
    if (coverUrl) return coverUrl;
    return NoImage;
};

// 获取服务列表
const getServices = (servicesStr) => {
    if (!servicesStr) return [];
    return servicesStr.split(',').slice(0, 3); // 只显示前三个服务
};

onBeforeMount(async () => {
    GetUserAllHotelIntegral();
})

const GetUserAllHotelIntegral = async () => {
    const { Success, Data } = await Post(`/HotelIntegral/GetUserAllHotelIntegral`, { UserId: UserId.value });
    if (Success) {
        hotelIntegrals.value = Data;
        console.log(Data);
    }
}

</script>
<style scoped lang="scss">
/* 积分容器样式 */
.integral-container {
    width: 100%;
    padding: 20px;
    background-color: #f8f9fa;
    border-radius: 8px;
}

/* 积分头部样式 */
.integral-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 2px solid #e4e7ed;
}

.integral-header h2 {
    font-size: 22px;
    color: #303133;
    margin: 0;
}

.total-points {
    font-size: 16px;
    color: #606266;
}

.point-value {
    font-size: 24px;
    font-weight: bold;
    color: #409EFF;
}

/* 酒店列表样式 */
.hotel-list {
    width: 100%;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(600px, 1fr));
    gap: 20px;
}

/* 酒店卡片样式 */
.hotel-card {

    margin-bottom: 15px;
    transition: transform 0.3s, box-shadow 0.3s;
}

.hotel-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

/* 酒店信息样式 */
.hotel-info {
    display: flex;
    align-items: center;
}

/* 酒店图片样式 */
.hotel-image {
    width: 120px;
    height: 120px;
    overflow: hidden;
    border-radius: 6px;
    margin-right: 20px;
}

.hotel-image .el-image {
    width: 100%;
    height: 100%;
}

/* 酒店详情样式 */
.hotel-details {
    flex: 1;
}

.hotel-name {
    margin: 0 0 8px 0;
    font-size: 18px;
    color: #303133;
}

.hotel-address {
    margin: 0 0 12px 0;
    font-size: 14px;
    color: #606266;
}

/* 服务标签样式 */
.hotel-services {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

.service-tag {
    display: inline-block;
    padding: 4px 10px;
    font-size: 12px;
    color: #409EFF;
    background-color: #ecf5ff;
    border-radius: 4px;
}

/* 积分样式 */
.hotel-points {
    width: 100px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.points-circle {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background-color: #f0f9eb;
    border: 2px solid #67c23a;
    margin: 0 auto 10px;
    color: #67c23a;
}

.high-points {
    background-color: #fef0f0;
    border-color: #f56c6c;
    color: #f56c6c;
}

.points-value {
    font-size: 22px;
    font-weight: bold;
    line-height: 1;
}

.points-label {
    font-size: 12px;
    margin-top: 4px;
}

/* 查看积分流水按钮样式 */
.view-history-btn {
    margin-top: 8px;
    font-size: 12px;
}
</style>