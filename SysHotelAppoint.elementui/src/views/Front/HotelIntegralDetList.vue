<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item :to="{ path: '/Front/MyHotelIntegralList' }">我的酒店积分</el-breadcrumb-item>
            <el-breadcrumb-item>积分明细</el-breadcrumb-item>
        </el-breadcrumb>
    </div>
    <PaginationBox ref="HotelIntegralPaginationBox" :where="{ UserId: UserId, HotelId: route.query.HotelId }"
        url="/HotelIntegral/List" :limit="8">
        <template v-slot:content="{ data }">
            <!-- 积分记录列表 -->
            <div class="integral-list">
                <div v-for="(item, index) in data" :key="index" class="integral-item">
                    <!-- 积分记录卡片 -->
                    <div class="integral-card">
                        <div class="integral-header">
                            <div class="hotel-name">{{ item.HotelDto ? item.HotelDto.Name : '未知酒店' }}</div>
                            <div class="integral-time">{{ item.CreationTime }}</div>
                        </div>
                        <div class="integral-content">
                            <div class="integral-title">{{ item.Title }}</div>
                            <div class="integral-value"
                                :class="{ 'increase': item.Type === '增加', 'decrease': item.Type === '减少' }">
                                {{ item.Type === '增加' ? '+' : '' }}{{ item.IntegralValue }}
                            </div>
                        </div>
                        <div class="integral-footer">
                            <div class="relative-no">订单号: {{ item.RelativeNo }}</div>
                        </div>
                    </div>
                </div>
                <!-- 没有数据时显示的内容 -->
                <div v-if="data.length === 0" class="no-data">
                    <el-empty description="暂无积分记录"></el-empty>
                </div>
            </div>
        </template>
    </PaginationBox>
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
onBeforeMount(async () => {
})
</script>
<style scoped lang="scss">
/* 积分列表容器 */
.integral-list {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 16px;

}

/* 积分项样式 */
.integral-item {
    width: 100%;
}

/* 积分卡片样式 */
.integral-card {
    background-color: #fff;
    border-radius: 8px;
    padding: 16px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
}

.integral-card:hover {
    box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.15);
    transform: translateY(-2px);
}

/* 积分卡片头部 */
.integral-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 12px;
    padding-bottom: 8px;
    border-bottom: 1px solid #ebeef5;
}

.hotel-name {
    font-weight: bold;
    font-size: 16px;
    color: #303133;
}

.integral-time {
    color: #909399;
    font-size: 14px;
}

/* 积分卡片内容 */
.integral-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
}

.integral-title {
    font-size: 16px;
    color: #606266;
}

.integral-value {
    font-size: 18px;
    font-weight: bold;
}

/* 增加积分显示绿色 */
.increase {
    color: #67C23A;
}

/* 减少积分显示红色 */
.decrease {
    color: #F56C6C;
}

/* 积分卡片底部 */
.integral-footer {
    color: #909399;
    font-size: 13px;
}

/* 无数据样式 */
.no-data {
    margin-top: 40px;
    width: 100%;
}

/* 面包屑样式 */
.breadcrumb {
    margin-bottom: 20px;
    padding: 8px 0;
    display: flex;
    align-items: center;
}

.breadcrumb-label {
    margin-right: 8px;
    color: #606266;
}
</style>