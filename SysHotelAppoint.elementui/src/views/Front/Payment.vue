<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>订单支付</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <!-- 步骤条 -->
    <div class="steps-container">
        <el-steps :active="2" finish-status="success" simple>
            <el-step title="填写信息"></el-step>
            <el-step title="支付订单"></el-step>
            <el-step title="预订成功"></el-step>
        </el-steps>
    </div>

    <!-- 支付倒计时 -->
    <div class="payment-countdown" v-if="AppointOrder">
        <div class="countdown-header">
            <el-alert title="请在规定时间内完成支付，超时订单将自动取消" type="warning" show-icon />
        </div>
        <div class="countdown-timer">
            <div class="timer-label">支付倒计时:</div>
            <div class="timer-value">{{ countdownFormatted }}</div>
        </div>
    </div>

    <!-- 订单信息 -->
    <div class="order-info-container" v-if="AppointOrder">
        <div class="order-info-header">
            <h2>订单信息</h2>
        </div>
        <div class="order-info-content">
            <div class="order-basic-info">
                <div class="info-item">
                    <span class="label">订单编号:</span>
                    <span class="value">{{ AppointOrder.No }}</span>
                </div>
                <div class="info-item">
                    <span class="label">订单状态:</span>
                    <span class="value status">{{ AppointOrder.AppointStatusFormat }}</span>
                </div>
                <div class="info-item">
                    <span class="label">创建时间:</span>
                    <span class="value">{{ AppointOrder.CreationTime }}</span>
                </div>
            </div>

            <div class="room-info" v-if="AppointOrder.RoomDto">
                <div class="room-image">
                    <img :src="AppointOrder.RoomDto.Cover || NoImage" alt="房间封面" @error="handleImageError">
                </div>
                <div class="room-details">
                    <h3>{{ AppointOrder.RoomDto.Title }}</h3>
                    <div class="room-tags">
                        <el-tag size="small">{{ AppointOrder.RoomDto.RoomShapeFormat }}</el-tag>
                        <el-tag size="small">{{ AppointOrder.RoomDto.BreakfastTypeFormat }}</el-tag>
                        <el-tag size="small">{{ AppointOrder.RoomDto.FeaturedRoomShapeFormat }}</el-tag>
                    </div>
                    <div class="room-info-item">
                        <span class="label">入住日期:</span>
                        <span class="value">{{ AppointOrder.BeginAppointTime }}</span>
                    </div>
                    <div class="room-info-item">
                        <span class="label">离店日期:</span>
                        <span class="value">{{ AppointOrder.EndAppointTime }}</span>
                    </div>
                    <div class="room-info-item">
                        <span class="label">房间数量:</span>
                        <span class="value">{{ AppointOrder.Qty }}间</span>
                    </div>
                    <div class="room-info-item">
                        <span class="label">入住人数:</span>
                        <span class="value">{{ AppointOrder.TotalPeopleNum }}人</span>
                    </div>
                </div>
            </div>

            <div class="hotel-info" v-if="AppointOrder.HotelDto">
                <h3>酒店信息</h3>
                <div class="hotel-info-item">
                    <span class="label">酒店名称:</span>
                    <span class="value">{{ AppointOrder.HotelDto.Name }}</span>
                </div>
                <div class="hotel-info-item">
                    <span class="label">酒店地址:</span>
                    <span class="value">{{ AppointOrder.HotelDto.Address }}</span>
                </div>
                <div class="hotel-info-item">
                    <span class="label">入住提示:</span>
                    <span class="value">{{ AppointOrder.HotelDto.CheckInTip }}</span>
                </div>
            </div>

            <div class="guest-info" v-if="AppointOrder.AppointDetDtos && AppointOrder.AppointDetDtos.length > 0">
                <h3>入住人信息</h3>
                <div class="guest-list">
                    <div class="guest-item" v-for="guest in AppointOrder.AppointDetDtos" :key="guest.Id">
                        <div class="guest-name">{{ guest.Name }}</div>
                        <div class="guest-detail">
                            <span>性别：{{ guest.Sex }}</span>
                            <span>电话：{{ guest.Phone }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 支付方式选择 -->
    <div class="payment-method-container" v-if="AppointOrder">
        <div class="payment-method-header">
            <h2>选择支付方式</h2>
        </div>
        <div class="payment-method-content">
            <div class="payment-options">
                <div class="payment-card" :class="{ active: payType === '微信支付' }" @click="payType = '微信支付'">
                    <el-icon>
                        <Money />
                    </el-icon>
                    <span>微信支付</span>
                </div>
                <div class="payment-card" :class="{ active: payType === '支付宝' }" @click="payType = '支付宝'">
                    <el-icon>
                        <Wallet />
                    </el-icon>
                    <span>支付宝</span>
                </div>
                <div class="payment-card" :class="{ active: payType === '银行卡' }" @click="payType = '银行卡'">
                    <el-icon>
                        <CreditCard />
                    </el-icon>
                    <span>银行卡</span>
                </div>
            </div>
        </div>
    </div>

    <!-- 支付按钮 -->
    <div class="payment-submit-container">
        <div class="total-price">
            <span class="price-label">应付金额:</span>
            <span class="price-value">¥{{ totalPrice }}</span>
        </div>
        <div v-if="countdown <= 0" class="payment-expired">
            <el-tag type="danger">订单已超时</el-tag>
        </div>
        <el-button type="primary" size="large" @click="submitPayment" :loading="paymentLoading" :disabled="countdown <= 0">
            {{ countdown > 0 ? '立即支付' : '已超时' }}
        </el-button>
    </div>
</template>

<script setup>
import defaultAvatar from '@/assets/默认头像.png'; // 导入默认头像图片
import NoImage from '@/assets/图片失效.png';
import { Post, PostSingleUpdate } from '@/api/http';
import { ref, reactive, nextTick, computed, onBeforeMount, onUnmounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useCommonStore } from "@/store";
import { ElMessage, ElMessageBox } from 'element-plus';
import { Money, Wallet, CreditCard } from '@element-plus/icons-vue';

const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);

const AppointOrder = ref(null);
const payType = ref('微信支付'); // 默认微信支付
const paymentLoading = ref(false);
const countdown = ref(0); // 倒计时秒数
let countdownTimer = null; // 倒计时定时器

// 格式化倒计时显示
const countdownFormatted = computed(() => {
    const minutes = Math.floor(countdown.value / 60);
    const seconds = countdown.value % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
});

// 计算订单总价
const totalPrice = computed(() => {
    if (AppointOrder.value && AppointOrder.value.RoomDto) {
        // 如果有总价就直接用总价，否则用房间价格乘以数量
        if (AppointOrder.value.TotalMoney) {
            return AppointOrder.value.TotalMoney;
        } else if (AppointOrder.value.RoomDto.ActualPrice) {
            return AppointOrder.value.RoomDto.ActualPrice * AppointOrder.value.Qty;
        }
    }
    return 0;
});

// 处理图片加载失败
const handleImageError = (e) => {
    e.target.src = NoImage;
}

// 获取订单信息
const GetAppointOrderApi = async () => {
    let { Data, Success } = await Post("/Appoint/Get", {
        Id: route.query.AppointId
    });
    if (Success) {
        AppointOrder.value = Data;

        // 设置倒计时
        if (Data.CreationTime) {
            initCountdown(Data.CreationTime);
        }
    }
}

// 初始化倒计时
const initCountdown = (creationTime) => {
    // 解析创建时间
    const createTime = new Date(creationTime.replace(/-/g, '/')).getTime();
    // 支付截止时间（创建时间 + 15分钟）
    const deadline = createTime + 15 * 60 * 1000;
    // 当前时间
    const now = new Date().getTime();
    // 剩余秒数
    const remainingSeconds = Math.max(0, Math.floor((deadline - now) / 1000));

    countdown.value = remainingSeconds;

    // 清除之前的定时器
    if (countdownTimer) {
        clearInterval(countdownTimer);
    }

    // 设置定时器
    if (countdown.value > 0) {
        countdownTimer = setInterval(() => {
            if (countdown.value > 0) {
                countdown.value -= 1;
            } else {
                clearInterval(countdownTimer);
                ElMessage.warning('支付超时，订单已失效');
                // 不再自动跳转
            }
        }, 1000);
    } else {
        ElMessage.warning('支付超时，订单已失效');
    }
}

// 提交支付
const submitPayment = () => {
    if (countdown.value <= 0) {
        ElMessage.warning('支付超时，订单已失效');
        return;
    }

    ElMessageBox.confirm('确认支付订单?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(async () => {
        paymentLoading.value = true;
        try {
            // 这里添加支付接口调用
            let { Success } = await Post("/Appoint/Payment", {
                Id: route.query.AppointId,
                PayType: payType.value
            });

            if (Success) {
                ElMessage.success('支付成功');
                // 跳转到支付成功页面或订单列表
                router.push('/Front/MyAppointOrderList');
            }
        } catch (error) {
            console.error('支付失败', error);
            ElMessage.error('支付失败，请重试');
        } finally {
            paymentLoading.value = false;
        }
    }).catch(() => { });
}

onBeforeMount(async () => {
    await GetAppointOrderApi();
});

// 组件销毁时清除定时器
onUnmounted(() => {
    if (countdownTimer) {
        clearInterval(countdownTimer);
    }
});
</script>

<style scoped lang="scss">
/* 面包屑导航样式 */
.breadcrumb {
    padding: 15px 0;
    margin-bottom: 20px;
    border-bottom: 1px solid #eee;

    .breadcrumb-label {
        margin-right: 10px;
        color: #666;
    }
}

/* 步骤条样式 */
.steps-container {
    margin: 30px 0;
    padding: 0 20px;
}

/* 支付倒计时 */
.payment-countdown {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-bottom: 30px;

    .countdown-timer {
        display: flex;
        align-items: center;
        justify-content: center;
        margin-top: 15px;

        .timer-label {
            font-size: 16px;
            color: #333;
            margin-right: 10px;
        }

        .timer-value {
            font-size: 24px;
            font-weight: bold;
            color: #f56c6c;
            background-color: #f9f9f9;
            padding: 5px 15px;
            border-radius: 4px;
        }
    }
}

/* 订单信息容器 */
.order-info-container {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-bottom: 30px;

    .order-info-header {
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
        margin-bottom: 20px;

        h2 {
            margin: 0;
            font-size: 20px;
            color: #333;
        }
    }

    .order-info-content {
        .order-basic-info {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 6px;
            margin-bottom: 20px;

            .info-item {
                .label {
                    color: #666;
                    margin-right: 10px;
                }

                .value {
                    color: #333;
                    font-weight: bold;

                    &.status {
                        color: #e6a23c;
                    }
                }
            }
        }

        .room-info {
            display: flex;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;

            .room-image {
                width: 200px;
                height: 150px;
                margin-right: 20px;
                overflow: hidden;
                border-radius: 4px;

                img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }
            }

            .room-details {
                flex: 1;

                h3 {
                    margin-top: 0;
                    margin-bottom: 10px;
                    font-size: 18px;
                    color: #333;
                }

                .room-tags {
                    margin-bottom: 15px;

                    .el-tag {
                        margin-right: 8px;
                        margin-bottom: 5px;
                    }
                }

                .room-info-item {
                    margin-bottom: 8px;
                    font-size: 14px;

                    .label {
                        color: #666;
                        margin-right: 10px;
                        display: inline-block;
                        width: 80px;
                    }

                    .value {
                        color: #333;
                    }
                }
            }
        }

        .hotel-info,
        .guest-info {
            margin-bottom: 20px;

            h3 {
                margin-top: 0;
                margin-bottom: 15px;
                font-size: 16px;
                color: #333;
                border-bottom: 1px dashed #eee;
                padding-bottom: 10px;
            }

            .hotel-info-item {
                margin-bottom: 8px;
                font-size: 14px;

                .label {
                    color: #666;
                    margin-right: 10px;
                    display: inline-block;
                    width: 80px;
                }

                .value {
                    color: #333;
                }
            }

            .guest-list {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;

                .guest-item {
                    padding: 10px 15px;
                    background-color: #f9f9f9;
                    border-radius: 4px;
                    min-width: 200px;

                    .guest-name {
                        font-weight: bold;
                        margin-bottom: 5px;
                    }

                    .guest-detail {
                        font-size: 14px;
                        color: #666;

                        span {
                            margin-right: 15px;
                            display: inline-block;
                        }
                    }
                }
            }
        }
    }
}

/* 支付方式选择 */
.payment-method-container {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-bottom: 30px;

    .payment-method-header {
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
        margin-bottom: 20px;

        h2 {
            margin: 0;
            font-size: 20px;
            color: #333;
        }
    }

    .payment-method-content {
        .payment-options {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;

            .payment-card {
                display: flex;
                align-items: center;
                padding: 15px 25px;
                border: 1px solid #eee;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s;
                min-width: 150px;

                &.active {
                    border-color: #409eff;
                    background-color: #ecf5ff;
                }

                &:hover {
                    border-color: #c0c4cc;
                }

                .el-icon {
                    font-size: 24px;
                    margin-right: 10px;
                    color: #409eff;
                }

                span {
                    font-size: 16px;
                    color: #333;
                }
            }
        }
    }
}

/* 支付按钮 */
.payment-submit-container {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-top: 30px;

    .total-price {
        margin-right: 20px;

        .price-label {
            font-size: 16px;
            color: #666;
            margin-right: 10px;
        }

        .price-value {
            font-size: 24px;
            font-weight: bold;
            color: #f56c6c;
        }
    }

    .payment-expired {
        margin-right: 15px;
        padding: 8px 15px;
        background-color: #fde2e2;
        border: 1px solid #f56c6c;
        border-radius: 4px;
        color: #f56c6c;
        font-size: 14px;
    }

    .el-button {
        padding: 12px 30px;
        font-size: 16px;
    }
}
</style>