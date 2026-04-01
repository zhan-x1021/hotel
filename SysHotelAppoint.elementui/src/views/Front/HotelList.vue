<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>酒店列表</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <!-- 关键词搜索区域 -->
    <div class="keyword-search-box">
        <!-- 输入框，支持回车或按钮搜索 -->
        <el-input v-model="KeyWord" placeholder="请输入酒店名称关键词" class="keyword-input" clearable @keyup.enter="onSearch">
            <template #append>
                <el-button type="primary" @click="onSearch">搜索</el-button>
            </template>
        </el-input>
        <!-- 历史关键词tag展示 -->
        <div class="keyword-tags" v-if="historyKeywords.length">
            <span class="tag-label">历史搜索：</span>
            <el-tag v-for="(tag, idx) in historyKeywords" :key="tag" closable @close="removeTag(idx)" @click="useTag(tag)"
                class="keyword-tag">{{ tag }}</el-tag>
        </div>
    </div>

    <PaginationBox ref="HotelPaginationBox" :where="{ IsAudit: true, KeyWord, GlobalAddress: GlobalAddress }"
        url="/Hotel/List" :limit="6">
        <template v-slot:content="{ data }">
            <!-- 酒店列表区域 -->
            <div class="hotel-list-grid">
                <!-- 遍历酒店数据，渲染每个酒店卡片 -->
                <div class="hotel-card" v-for="(item, index) in data" :key="item.Id" @click="ToHotelDetail(item.Id)">
                    <!-- 酒店封面图片 -->
                    <div class="hotel-cover">
                        <img :src="item.Cover || NoImage" alt="酒店封面" class="cover-img" />
                        <span v-if="item.IsPet" class="pet-tag">宠物友好</span>
                        <div class="hotel-stats">
                            <span class="stat-item" v-if="item.CommentScore > 0">
                                <i class="el-icon-star-on"></i> {{ item.CommentScore.toFixed(1) }}
                            </span>
                            <span class="stat-item" v-if="item.CommentCount > 0">
                                <i class="el-icon-chat-line-square"></i> {{ item.CommentCount }}
                            </span>
                            <span class="stat-item" v-if="item.TotalAppointCount > 0">
                                <i class="el-icon-date"></i> {{ item.TotalAppointCount }}
                            </span>
                        </div>
                    </div>
                    <!-- 酒店信息主体 -->
                    <div class="hotel-info">
                        <!-- 酒店名称 -->
                        <div class="hotel-title">{{ item.Name }}</div>
                        <!-- 地区信息 -->
                        <div class="hotel-location">
                            <i class="el-icon-location"></i> {{ item.ProviceCityArea }}
                        </div>
                        <!-- 酒店地址 -->
                        <div class="hotel-address">{{ item.Address }}</div>
                        <!-- 酒店描述 -->
                        <div class="hotel-content">{{ item.Content }}</div>
                        <!-- 酒店服务 -->
                        <div class="hotel-services">
                            <div class="service-tags">
                                <el-tag v-for="(service, idx) in getServicesList(item.Services)" :key="idx" size="small"
                                    class="service-tag">
                                    {{ service }}
                                </el-tag>
                            </div>
                        </div>
                        <!-- 重要须知 -->
                        <div class="hotel-notice" v-if="item.Notice">
                            <span class="notice-label">重要提示：</span>{{ item.Notice }}
                        </div>
                    </div>
                    <!-- 酒店底部信息 -->
                    <div class="hotel-footer">
                        <div class="hotel-created">
                            创建于 {{ formatDate(item.CreationTime) }}
                        </div>
                        <div class="hotel-actions">
                            <el-button size="small" type="primary">查看详情</el-button>
                        </div>
                    </div>
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
const HotelPaginationBox = ref(null);

const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);

onBeforeMount(async () => {
})

const ToHotelDetail = (Id) => {
    router.push({
        path: '/Front/HotelDetail',
        query: { HotelId: Id }
    })
}

// 关键词搜索相关
const KeyWord = ref(''); // 当前关键词
const historyKeywords = ref([]); // 历史关键词tag

// 页面加载时从本地存储恢复历史关键词
onBeforeMount(() => {
    const saved = localStorage.getItem('hotel_keyword_history');
    if (saved) {
        historyKeywords.value = JSON.parse(saved);
    }
});

// 格式化日期函数
const formatDate = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
};

// 将服务字符串拆分为数组
const getServicesList = (servicesString) => {
    if (!servicesString) return [];
    return servicesString.split(',').map(item => item.trim()).filter(item => item);
};

// 搜索方法
function onSearch() {
    // 新关键词加入历史tag，去重
    if (KeyWord.value && !historyKeywords.value.includes(KeyWord.value)) {
        historyKeywords.value.unshift(KeyWord.value);
        // 最多保存8个
        if (historyKeywords.value.length > 8) historyKeywords.value.length = 8;
        localStorage.setItem('hotel_keyword_history', JSON.stringify(historyKeywords.value));
    }
    // 触发分页刷新
    HotelPaginationBox.value.Reload({ KeyWord: KeyWord.value });
}

// 点击tag快速搜索
function useTag(tag) {
    KeyWord.value = tag;
    onSearch();
}

// 删除tag
function removeTag(idx) {
    historyKeywords.value.splice(idx, 1);
    localStorage.setItem('hotel_keyword_history', JSON.stringify(historyKeywords.value));
}
</script>
<style scoped lang="scss">
/* 酒店列表区域采用grid布局 */
.hotel-list-grid {
    width: 100%;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: 32px;
    background: #f7faff;
    padding: 32px 16px;
    border-radius: 18px;
    box-shadow: 0 4px 32px 0 rgba(30, 60, 120, 0.06);
}

/* 酒店卡片样式 */
.hotel-card {
    background: #fff;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 2px 12px 0 rgba(30, 60, 120, 0.06);
    display: flex;
    flex-direction: column;
    transition: transform 0.2s, box-shadow 0.2s;
    position: relative;
    border: 1.5px solid #e3eaf5;
    cursor: pointer;

    &:hover {
        transform: translateY(-6px) scale(1.03);
        box-shadow: 0 8px 32px 0 #2e7cff22;
        border-color: #2e7cff;
    }
}

/* 酒店封面图片区域 */
.hotel-cover {
    position: relative;
    width: 100%;
    height: 180px;
    background: #f0f4fa;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
}

.cover-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-bottom: 1.5px solid #e3eaf5;
}

/* 宠物友好标签 */
.pet-tag {
    position: absolute;
    top: 12px;
    left: 12px;
    background: #2e7cff;
    color: #fff;
    font-size: 13px;
    padding: 2px 10px;
    border-radius: 12px;
    font-weight: bold;
    letter-spacing: 1px;
    box-shadow: 0 2px 8px #2e7cff33;
}

/* 酒店统计信息 */
.hotel-stats {
    position: absolute;
    bottom: 10px;
    right: 10px;
    display: flex;
    gap: 10px;
}

.stat-item {
    background: rgba(0, 0, 0, 0.6);
    color: #fff;
    padding: 2px 8px;
    border-radius: 10px;
    font-size: 12px;
    display: flex;
    align-items: center;
    gap: 4px;
}

/* 酒店信息主体 */
.hotel-info {
    padding: 18px 18px 8px 18px;
    display: flex;
    flex-direction: column;
    gap: 8px;
    flex: 1;
}

.hotel-title {
    font-size: 20px;
    font-weight: 700;
    color: #2e7cff;
    margin-bottom: 2px;
    letter-spacing: 1px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.hotel-location {
    font-size: 14px;
    color: #5a6d8a;
    display: flex;
    align-items: center;
    gap: 5px;
}

.hotel-address {
    font-size: 14px;
    color: #5a6d8a;
    margin-bottom: 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.hotel-content {
    font-size: 14px;
    color: #6b7a90;
    margin: 5px 0;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    overflow: hidden;
    line-height: 1.4;
}

.hotel-services {
    margin: 5px 0;
}

.service-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
}

.service-tag {
    margin: 0;
    font-size: 12px;
}

.hotel-notice {
    font-size: 13px;
    color: #6b7a90;
    margin-top: 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.notice-label {
    color: #ffb300;
    font-weight: 600;
}

/* 酒店底部信息 */
.hotel-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 18px;
    border-top: 1px solid #e3eaf5;
    background: #f7faff;
}

.hotel-created {
    font-size: 12px;
    color: #8899aa;
}

.keyword-search-box {
    width: 100%;
    margin: 24px 0 0 0;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

.keyword-input {
    width: 320px;
    margin-bottom: 10px;
}

.keyword-tags {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
}

.tag-label {
    color: #7a8fa7;
    font-size: 13px;
    margin-right: 8px;
}

.keyword-tag {
    cursor: pointer;
    user-select: none;
    transition: box-shadow 0.2s;

    &:hover {
        box-shadow: 0 2px 8px #2e7cff22;
        border-color: #2e7cff;
    }
}
</style>