<template>
    <!-- 页面标题 -->
    <div class="page-header">
        <h2>📦 我的寄存记录</h2>
        <p>查看您在各酒店的物品寄存情况</p>
    </div>

    <!-- 寄存记录列表 -->
    <PaginationBox ref="StorageRecordPaginationBox" :where="{ RecordUserId: UserId }" url="/StorageRecord/List" :limit="8">
        <template v-slot:content="{ data }">
            <div class="storage-records-container">

                <div v-for="(item, index) in data" :key="index" class="storage-record-card">
                    <!-- 卡片头部 - 寄存编号和时间 -->
                    <div class="card-header">
                        <span class="record-number">🔖 寄存编号: {{ item.No }}</span>
                        <span class="record-time">📅 创建时间: {{ item.CreationTime }}</span>
                    </div>

                    <!-- 卡片内容 - 物品信息和图片 -->
                    <div class="card-content">
                        <div class="item-info">
                            <h3>🏷️ {{ item.Name }}</h3>
                            <p v-if="item.TakeTime"><span class="info-label">🕒 取件时间:</span> {{ item.TakeTime }}</p>
                            <p><span class="info-label">📱 联系电话:</span> {{ item.Phone }}</p>
                        </div>
                        <div class="item-image">
                            <el-image :src="item.TakePicture" :preview-src-list="[item.TakePicture]" fit="cover"
                                :fallback="NoImage">
                            </el-image>
                        </div>
                    </div>

                    <!-- 酒店信息 -->
                    <div class="hotel-info" v-if="item.HotelDto">
                        <div class="hotel-header">
                            <h4>🏨 {{ item.HotelDto.Name }}</h4>
                        </div>
                        <div class="hotel-flex-container">
                            <div class="hotel-content">
                                <p v-if="item.HotelDto.ProviceCityArea">
                                    <span class="info-label">📍 位置:</span>
                                    {{ item.HotelDto.ProviceCityArea }} {{ item.HotelDto.Address }}
                                </p>
                                <p v-if="item.HotelDto.Content" v-html="item.HotelDto.Content"></p>
                            </div>
                            <div class="hotel-image" v-if="item.HotelDto.Cover">
                                <el-image :src="item.HotelDto.Cover" :fallback="NoImage" fit="cover">
                                </el-image>
                            </div>
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

const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);
const StorageRecordPaginationBox = ref(null);





onBeforeMount(async () => {
    // 页面加载时的初始化逻辑
});
</script>

<style scoped lang="scss">
/* 页面标题样式 */
.page-header {
    margin-bottom: 30px;
    text-align: center;

    h2 {
        font-size: 28px;
        color: #303133;
        margin-bottom: 10px;
    }

    p {
        color: #909399;
        font-size: 16px;
    }
}

/* 寄存记录列表容器 */
.storage-records-container {
    width: 100%;
    margin-bottom: 30px;
}

/* 寄存记录网格布局 */
.storage-records-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 20px;
    width: 100%;
}

/* 寄存记录卡片样式 */
.storage-record-card {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    transition: transform 0.3s, box-shadow 0.3s;
    display: flex;
    flex-direction: column;

    &:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
    }
}

/* 卡片头部样式 */
.card-header {
    padding: 15px;
    background: linear-gradient(135deg, #409eff 0%, #1890ff 100%);
    color: white;
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 5px;

    .record-number {
        font-weight: bold;
        font-size: 14px;
    }

    .record-time {
        font-size: 13px;
    }
}

/* 卡片内容样式 */
.card-content {
    padding: 15px;
    display: grid;
    grid-template-columns: 1fr 120px;
    gap: 15px;
    border-bottom: 1px solid #ebeef5;

    .item-info {
        h3 {
            margin: 0 0 10px;
            color: #303133;
        }

        p {
            margin: 5px 0;
            color: #606266;
            font-size: 14px;
        }
    }

    .item-image {
        width: 120px;
        height: 120px;

        .el-image {
            width: 100%;
            height: 100%;
            border-radius: 4px;
        }
    }
}

/* 酒店信息样式 */
.hotel-info {
    padding: 15px;
    background-color: #f9fafc;
    border-bottom: 1px solid #ebeef5;

    .hotel-header {
        margin-bottom: 10px;

        h4 {
            margin: 0;
            color: #303133;
            font-size: 16px;
        }
    }

    .hotel-flex-container {
        display: flex;
        gap: 15px;
    }

    .hotel-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 5px;
        margin-bottom: 10px;

        p {
            margin: 0;
            color: #606266;
            font-size: 14px;
        }
    }

    .hotel-image {
        width: 180px;
        height: 120px;
        margin-top: 0;
        flex-shrink: 0;

        .el-image {
            width: 100%;
            height: 100%;
            border-radius: 4px;
            object-fit: cover;
        }
    }
}

/* 操作按钮样式 */
.card-actions {
    padding: 15px;
    display: flex;
    gap: 10px;
    justify-content: flex-end;
}

/* 信息标签样式 */
.info-label {
    color: #909399;
    margin-right: 5px;
}

/* 空数据样式 */
.empty-data {
    display: flex;
    justify-content: center;
    padding: 60px 0;
    width: 100%;
}

/* 响应式调整 */
@media (max-width: 768px) {
    .storage-records-grid {
        grid-template-columns: 1fr;
    }

    .card-content {
        grid-template-columns: 1fr;

        .item-image {
            width: 100%;
            height: 180px;
        }
    }

    .hotel-flex-container {
        flex-direction: column;
    }

    .hotel-image {
        width: 100% !important;
        height: 180px !important;
        margin-top: 10px;
    }
}
</style>