<template>
    <div v-if="SysNotice">
        <!-- 面包屑导航 -->
        <div class="breadcrumb">
            <span class="breadcrumb-label">您当前的位置:</span>
            <el-breadcrumb separator-class="el-icon-arrow-right">
                <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
                <el-breadcrumb-item>通知详情</el-breadcrumb-item>
            </el-breadcrumb>
        </div>

        <!-- 通知详情内容区域 -->
        <div class="notice-container">
            <!-- 通知标题 -->
            <div class="notice-header">
                <h1 class="notice-title">{{ SysNotice.Title }}</h1>
                <div class="notice-meta">
                    <span class="notice-time">发布时间：{{ SysNotice.CreationTime }}</span>
                </div>
            </div>
            <!-- 分割线 -->
            <el-divider></el-divider>
            <!-- 通知内容 -->
            <div class="notice-content">
                {{ SysNotice.Content }}
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
const SysNotice = ref(null);
const GetSysNoticeApi = async () => {
    const { Data } = await Post("/SysNotice/Get", { Id: route.query.SysNoticeId });
    SysNotice.value = Data;
};
onBeforeMount(async () => {
    await GetSysNoticeApi();
})
</script>
<style scoped lang="scss">
/* 面包屑导航样式 */
.breadcrumb {
    margin-bottom: 20px;
    padding: 10px 0;
    border-bottom: 1px solid #ebeef5;

    .breadcrumb-label {
        margin-right: 10px;
        color: #606266;
    }
}

/* 通知容器样式 */
.notice-container {

    margin: 20px auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

/* 通知标题区域样式 */
.notice-header {
    text-align: center;
    margin-bottom: 20px;

    .notice-title {
        font-size: 24px;
        font-weight: bold;
        color: #303133;
        margin-bottom: 15px;
    }

    .notice-meta {
        color: #909399;
        font-size: 14px;
    }
}

/* 通知内容样式 */
.notice-content {
    line-height: 1.8;
    font-size: 16px;
    color: #303133;
    padding: 10px 0;
    white-space: pre-line;
}
</style>