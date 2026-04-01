<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>系统通知</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <PaginationBox ref="SysNoticePaginationBox" :where="{ IsShow: true }" url="/SysNotice/List" :limit="8">
        <template v-slot:content="{ data }">
            <div class="notice-container">
                <div v-for="(item, index) in data" :key="index" class="notice-card" @click="showNoticeDetail(item)">
                    <div class="notice-content">
                        <div class="notice-header">
                            <h3 class="notice-title">{{ item.Title }}</h3>
                            <span class="notice-time">{{ item.CreationTime }}</span>
                        </div>
                        <div class="notice-body">
                            <p class="notice-text">{{ item.Content }}</p>
                        </div>
                    </div>
                </div>
                <div v-if="data.length === 0" class="no-data">
                    <el-empty description="暂无通知"></el-empty>
                </div>
            </div>
        </template>
    </PaginationBox>

    <!-- 通知详情对话框 -->
    <el-dialog v-model="dialogVisible" :title="currentNotice.Title" width="50%" :before-close="handleClose">
        <div class="dialog-content">
            <p class="dialog-time">发布时间：{{ currentNotice.CreationTime }}</p>
            <div class="dialog-divider"></div>
            <p class="dialog-text">{{ currentNotice.Content }}</p>
        </div>
        <template #footer>
            <span class="dialog-footer">
                <el-button @click="dialogVisible = false">关闭</el-button>
            </span>
        </template>
    </el-dialog>
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
const SysNoticePaginationBox = ref(null);

// 通知详情对话框相关
const dialogVisible = ref(false);
const currentNotice = ref({
    Id: '',
    CreationTime: '',
    Content: '',
    Title: ''
});

// 展示通知详情
const showNoticeDetail = (item) => {
    currentNotice.value = item;
    dialogVisible.value = true;
};

// 关闭对话框
const handleClose = () => {
    dialogVisible.value = false;
};

onBeforeMount(async () => {
})
</script>
<style scoped lang="scss">
/* 面包屑导航样式 */
.breadcrumb {
    margin-bottom: 20px;
    padding: 10px 0;
    display: flex;
    align-items: center;

    .breadcrumb-label {
        margin-right: 8px;
        color: #606266;
        font-size: 14px;
    }
}

/* 通知列表容器 */
.notice-container {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 10px 0;
}

/* 通知卡片样式 */
.notice-card {
    padding: 20px;
    border-radius: 8px;
    background: #fff;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
    cursor: pointer;
    border-left: 4px solid #409EFF;

    &:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.1);
        border-left: 4px solid #2c88e6;
    }

    .notice-content {
        width: 100%;
    }

    /* 通知标题和时间 */
    .notice-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;

        .notice-title {
            font-size: 16px;
            font-weight: 600;
            color: #303133;
            margin: 0;
        }

        .notice-time {
            font-size: 12px;
            color: #909399;
        }
    }

    /* 通知内容 */
    .notice-body {
        .notice-text {
            font-size: 14px;
            color: #606266;
            line-height: 1.5;
            margin: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
    }
}

/* 无数据样式 */
.no-data {
    padding: 40px 0;
    display: flex;
    justify-content: center;
}

/* 对话框内容样式 */
.dialog-content {
    padding: 10px 0;

    .dialog-time {
        font-size: 14px;
        color: #909399;
        margin-bottom: 15px;
    }

    .dialog-divider {
        height: 1px;
        background-color: #EBEEF5;
        margin: 15px 0;
    }

    .dialog-text {
        font-size: 14px;
        color: #303133;
        line-height: 1.8;
    }
}

/* 对话框底部样式 */
.dialog-footer {
    width: 100%;
    display: flex;
    justify-content: flex-end;
}
</style>