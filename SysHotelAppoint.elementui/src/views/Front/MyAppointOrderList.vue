<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>我的预约订单</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <PaginationBox ref="AppointPaginationBox" :where="where" url="/Appoint/List" :limit="8">
        <template v-slot:content="{ data }">
            <div class="order-container">
                <div v-if="data && data.length > 0" class="order-list">
                    <div v-for="(item, index) in  data " :key="index" class="order-card">
                        <div class="order-header">
                            <div class="order-info">
                                <span class="order-no">订单号: {{ item.No }}</span>
                                <span class="order-time">预订时间: {{ item.CreationTime }}</span>
                            </div>
                            <div class="order-status" :class="getStatusClass(item.AppointStatus)">
                                {{ item.AppointStatusFormat }}
                            </div>
                        </div>

                        <div class="order-content">
                            <div class="hotel-image">
                                <el-image :src="item.RoomDto.Cover" :fallback="NoImage" fit="cover">
                                </el-image>
                            </div>

                            <div class="order-details">
                                <h3 class="hotel-name">{{ item.HotelDto.Name }}</h3>
                                <div class="room-info">
                                    <span class="room-title">{{ item.RoomDto.Title }}</span>
                                    <span class="room-type">{{ item.RoomDto.RoomShapeFormat }} |
                                        {{ item.RoomDto.BreakfastTypeFormat }}</span>
                                </div>
                                <div class="time-info">
                                    <div class="check-in">
                                        <i class="el-icon-date"></i>
                                        <span>入住: {{ formatDate(item.BeginAppointTime) }}</span>
                                    </div>
                                    <div class="check-out">
                                        <i class="el-icon-date"></i>
                                        <span>离店: {{ formatDate(item.EndAppointTime) }}</span>
                                    </div>
                                </div>
                                <div class="guest-info">
                                    <span class="guest-title">入住人:</span>
                                    <div class="guest-list">
                                        <el-tag v-for="(guest, gIndex) in item.AppointDetDtos" :key="gIndex" size="small"
                                            effect="plain">
                                            {{ guest.Name }} ({{ guest.Phone }})
                                        </el-tag>
                                    </div>
                                </div>
                            </div>

                            <div class="price-container">
                                <div class="price-info" v-if="item.TotalMoney">
                                    <span class="price-label">总价:</span>
                                    <span class="price-value">¥{{ item.TotalMoney }}</span>
                                </div>
                            </div>
                        </div>

                        <div class="order-footer">
                            <div class="action-buttons">
                                <el-button v-if="item.AppointStatus === 9" type="success" size="small"
                                    @click="toPay(item.Id)">
                                    去支付
                                </el-button>
                                <el-button v-if="[1, 6, 9].includes(item.AppointStatus)" type="danger" size="small"
                                    @click="cancelOrder(item.Id)">
                                    取消预约
                                </el-button>
                                <el-button type="primary" size="small" @click="viewDetail(item.Id)">
                                    查看详情
                                </el-button>
                                <el-button v-if="item.AppointStatus === 8" type="success" size="small"
                                    @click="addComment(item.Id)">
                                    评价
                                </el-button>

                                <el-button type="info" size="small" @click="contactHotel(item.HotelDto)">
                                    联系酒店
                                </el-button>
                                <el-button type="success" size="small" @click="viewHotel(item.HotelDto.Id)">
                                    查看酒店
                                </el-button>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-else class="empty-data">
                    <el-empty description="暂无预约订单"></el-empty>
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
const AppointPaginationBox = ref(null);
const where = ref({
    ToUserId: UserId.value
})

// 格式化日期，只显示日期部分
const formatDate = (dateStr) => {
    if (!dateStr) return '';
    return dateStr.split(' ')[0];
};

// 根据订单状态获取对应的CSS类
const getStatusClass = (status) => {
    switch (status) {
        case 1: return 'status-waiting';
        case 2: return 'status-checkin';
        case 3: return 'status-user-cancel';
        case 4: return 'status-hotel-cancel';
        case 5: return 'status-completed';
        case 6: return 'status-pending';
        case 7: return 'status-cancel-request';
        case 8: return 'status-checkout';
        case 9: return 'status-unpaid';
        case 10: return 'status-system-cancel';
        default: return '';
    }
};

// 取消订单
const cancelOrder = (id) => {
    ElMessageBox.confirm('确定要取消此预约订单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        // 这里添加取消订单的API调用
        Post('/Appoint/UserCancel', { Id: id }).then(res => {
            if (res.Success) {
                ElMessage.success('订单已取消');
                AppointPaginationBox.value.Reload();
            } else {
                ElMessage.error(res.Msg || '取消失败');
            }
        });
    }).catch(() => { });
};

// 查看订单详情
const viewDetail = (id) => {
    router.push({
        path: '/Front/OrderDetail',
        query: {
            AppointId: id
        }
    });
};

// 添加评价
const addComment = (id) => {
    router.push({
        path: '/Front/AddComment',
        query: {
            AppointId: id
        }
    });
};

// 去支付
const toPay = (id) => {
    router.push({
        path: '/Front/Payment',
        query: {
            AppointId: id
        }
    });
};

// 联系酒店
const contactHotel = async (hotelDto) => {


    let { Success } = await Post("/WechatCollection/InsertWechatCollection",
        {
            SelfUserId: UserId.value,
            OtherUserId: hotelDto.HotelUserId,
        });
    if (Success) {
        router.push({
            path: "/Front/Wechat",
            query: {
                OtherUserId: hotelDto.HotelUserId
            }
        })
    }
};

// 查看酒店
const viewHotel = (hotelId) => {
    router.push({
        path: '/Front/HotelDetail',
        query: { HotelId: hotelId }
    });
};
onBeforeMount(async () => {
})
</script>

<style scoped lang="scss">
.breadcrumb {
    margin-bottom: 20px;
    padding: 10px 0;

    /* 面包屑导航样式 */
    .breadcrumb-label {
        margin-right: 10px;
        color: #606266;
    }
}

.order-container {
    width: 100%;
    /* 订单容器样式 */
}

.order-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
    /* 订单列表样式 */
}

.order-card {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    overflow: hidden;
    transition: all 0.3s;
    /* 订单卡片样式 */

    &:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.15);
    }
}

.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 20px;
    background: #f5f7fa;
    border-bottom: 1px solid #ebeef5;
    /* 订单头部样式 */

    .order-info {
        display: flex;
        gap: 20px;

        .order-no {
            font-weight: bold;
            color: #303133;
        }

        .order-time {
            color: #909399;
        }
    }

    .order-status {
        font-weight: bold;
        padding: 5px 12px;
        border-radius: 4px;

        &.status-waiting {
            background-color: #e6a23c;
            color: #fff;
        }

        &.status-checkin {
            background-color: #409eff;
            color: #fff;
        }

        &.status-user-cancel,
        &.status-hotel-cancel,
        &.status-system-cancel {
            background-color: #909399;
            color: #fff;
        }

        &.status-completed,
        &.status-checkout {
            background-color: #67c23a;
            color: #fff;
        }

        &.status-pending {
            background-color: #e6a23c;
            color: #fff;
        }

        &.status-cancel-request {
            background-color: #f56c6c;
            color: #fff;
        }

        &.status-unpaid {
            background-color: #ff9900;
            color: #fff;
        }
    }
}

.order-content {
    display: flex;
    padding: 20px;
    /* 订单内容样式 */

    .hotel-image {
        width: 150px;
        height: 120px;
        border-radius: 6px;
        overflow: hidden;
        margin-right: 20px;
        flex-shrink: 0;

        .el-image {
            width: 100%;
            height: 100%;
        }
    }

    .order-details {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 10px;

        .hotel-name {
            margin: 0;
            font-size: 18px;
            color: #303133;
        }

        .room-info {
            display: flex;
            align-items: center;
            gap: 10px;

            .room-title {
                font-weight: bold;
                color: #303133;
            }

            .room-type {
                color: #606266;
            }
        }

        .time-info {
            display: flex;
            gap: 20px;
            color: #606266;

            .check-in,
            .check-out {
                display: flex;
                align-items: center;
                gap: 5px;
            }
        }

        .guest-info {
            display: flex;
            align-items: center;

            .guest-title {
                margin-right: 10px;
                color: #606266;
            }

            .guest-list {
                display: flex;
                flex-wrap: wrap;
                gap: 5px;
            }
        }
    }

    .price-container {
        display: flex;
        justify-content: flex-end;
        margin-top: 10px;

        .price-info {
            text-align: right;

            .price-label {
                color: #606266;
                margin-right: 5px;
            }

            .price-value {
                font-size: 18px;
                font-weight: bold;
                color: #f56c6c;
            }
        }
    }
}

.order-footer {
    padding: 15px 20px;
    border-top: 1px dashed #ebeef5;
    margin-top: 10px;

    .action-buttons {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }
}

.room-description {
    padding: 0 20px 20px;
    border-top: 1px dashed #ebeef5;
    margin-top: 10px;

    .description-title {
        font-weight: bold;
        margin-bottom: 10px;
        padding-top: 15px;
        color: #303133;
    }

    .description-content {
        color: #606266;
        line-height: 1.6;
    }
}

.empty-data {
    padding: 40px 0;
    display: flex;
    justify-content: center;
}
</style>
