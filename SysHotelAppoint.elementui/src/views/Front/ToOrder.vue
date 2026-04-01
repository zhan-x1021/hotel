<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item :to="{
                path: '/Front/HotelDetail', query: {
                    HotelId: route.query.HotelId
                }
            }">酒店详情</el-breadcrumb-item>
            <el-breadcrumb-item>酒店预订</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <!-- 步骤条 -->
    <div class="steps-container">
        <el-steps :active="1" finish-status="success" simple>
            <el-step title="填写信息"></el-step>
            <el-step title="支付订单"></el-step>
            <el-step title="预订成功"></el-step>
        </el-steps>
    </div>

    <!-- 酒店基本信息展示 -->
    <div class="room-info-container" v-if="Room">
        <div class="room-info-header">
            <h2>预订信息</h2>
        </div>
        <div class="room-info-content">
            <div class="room-image">
                <img :src="Room.Cover || NoImage" alt="房间封面" @error="handleImageError">
            </div>
            <div class="room-details">
                <h3>{{ Room.Title }}</h3>
                <div class="room-tags">
                    <el-tag size="small" type="success" v-if="Room.IsImmediatelyConfirm">即时确认</el-tag>
                    <el-tag size="small" type="info" v-if="Room.IsFreeCancel">免费取消</el-tag>
                    <el-tag size="small">{{ Room.RoomShapeFormat }}</el-tag>
                    <el-tag size="small">{{ Room.BreakfastTypeFormat }}</el-tag>
                    <el-tag size="small">{{ Room.FeaturedRoomShapeFormat }}</el-tag>
                </div>
                <div class="room-info-item">
                    <span class="label">房间面积:</span>
                    <span class="value">{{ Room.AreaSize }}㎡</span>
                </div>
                <div class="room-info-item">
                    <span class="label">入住日期:</span>
                    <span class="value">{{ route.query.CheckInDate }}</span>
                </div>
                <div class="room-info-item">
                    <span class="label">离店日期:</span>
                    <span class="value">{{ route.query.CheckOutDate }}</span>
                </div>
                <div class="room-info-item">
                    <span class="label">剩余房间:</span>
                    <span class="value">{{ Room.RemainingRoomNumber }}间</span>
                </div>
                <div class="room-price">
                    <span class="price-label">价格:</span>
                    <span class="price-value">¥{{ Room.ActualPrice }}</span>
                    <span class="original-price" v-if="Room.OriginalPrice > Room.ActualPrice">¥{{ Room.OriginalPrice
                    }}</span>
                </div>
            </div>
        </div>

        <div class="hotel-info" v-if="Room.HotelDto">
            <h3>酒店信息</h3>
            <div class="hotel-info-item">
                <span class="label">酒店名称:</span>
                <span class="value">{{ Room.HotelDto.Name }}</span>
            </div>
            <div class="hotel-info-item">
                <span class="label">酒店地址:</span>
                <span class="value">{{ Room.HotelDto.Address }}</span>
            </div>
            <div class="hotel-info-item">
                <span class="label">入住提示:</span>
                <span class="value">{{ Room.HotelDto.CheckInTip }}</span>
            </div>
        </div>
    </div>

    <!-- 游客信息选择 -->
    <div class="guest-selection-container">
        <div class="guest-selection-header">
            <h2>选择入住人信息</h2>
            <el-button type="primary" size="small"
                @click="router.push('/Front/UserCenter?currentMenu=GuestInfoList')">添加新游客</el-button>
        </div>

        <div class="guest-selection-content" v-if="GuestInfoList.length > 0">
            <el-checkbox-group v-model="selectedGuests">
                <div class="guest-card" v-for="guest in GuestInfoList" :key="guest.Id">
                    <el-checkbox :label="guest.Id">
                        <div class="guest-info">
                            <div class="guest-name">{{ guest.Name }}</div>
                            <div class="guest-detail">
                                <span>性别：{{ guest.Sex }}</span>
                                <span>电话：{{ guest.Phone }}</span>
                                <span>身份证：{{ guest.IdCard }}</span>
                            </div>
                        </div>
                    </el-checkbox>
                </div>
            </el-checkbox-group>
        </div>

        <div class="no-guest-tip" v-else>
            <el-empty description="暂无游客信息，请先添加">
                <el-button type="primary"
                    @click="router.push('/Front/UserCenter?currentMenu=GuestInfoList')">添加游客</el-button>
            </el-empty>
        </div>
    </div>

    <!-- 预订表单信息 -->
    <div class="booking-form-container">
        <div class="booking-form-header">
            <h2>预订详情</h2>
        </div>
        <div class="booking-form-content">


            <!-- 数量选择 -->
            <div class="form-group">
                <div class="form-label">预订房间数量</div>
                <el-input-number v-model="formData.Qty" :min="1" :max="Room.RemainingRoomNumber || 1"
                    size="large"></el-input-number>
                <div class="form-hint">可预订数量: {{ Room.RemainingRoomNumber || 0 }}间</div>
            </div>

            <!-- 总人数 -->
            <div class="form-group">
                <div class="form-label">入住总人数</div>
                <div class="people-count">
                    <span class="count-value">{{ formData.TotalPeopleNum }}人</span>
                    <div class="form-hint">已自动根据选择的游客数量计算</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 提交按钮 -->
    <div class="submit-container">
        <div class="order-summary">
            <div class="summary-item">
                <span class="summary-label">房间单价：</span>
                <span class="summary-value">¥{{ Room.ActualPrice }}</span>
            </div>
            <div class="summary-item">
                <span class="summary-label">房间数量：</span>
                <span class="summary-value">{{ formData.Qty }}间</span>
            </div>
            <div class="summary-item">
                <span class="summary-label">入住人数：</span>
                <span class="summary-value">{{ formData.TotalPeopleNum }}人</span>
            </div>
            <!-- 积分抵扣选项 -->
            <div class="summary-item" v-if="canUseIntegral">
                <span class="summary-label">积分抵扣：</span>
                <span class="summary-value">
                    <el-checkbox v-model="formData.UseIntegral">
                        使用积分抵扣
                        <el-tooltip content="积分抵扣说明" placement="top">
                            <span class="integral-info">
                                (当前积分: {{ MyIntegral }}, 可抵扣: ¥{{ integralDeductionAmount }})
                            </span>
                        </el-tooltip>
                    </el-checkbox>
                </span>
                <div class="integral-detail" v-if="formData.UseIntegral">
                    <div class="detail-item">
                        <span class="detail-label">使用积分:</span>
                        <span class="detail-value">{{ usedIntegralAmount }}积分</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">抵扣金额:</span>
                        <span class="detail-value">¥{{ integralDeductionAmount }}</span>
                    </div>
                </div>
            </div>
            <div class="summary-item" v-else-if="MyIntegral > 0 && Room.IntegralExchangeMoney <= 0">
                <span class="summary-label">积分抵扣：</span>
                <span class="summary-value">
                    <span class="integral-disabled">此房间不支持积分抵扣</span>
                </span>
            </div>
            <div class="summary-item" v-else-if="MyIntegral <= 0 && Room.IntegralExchangeMoney > 0">
                <span class="summary-label">积分抵扣：</span>
                <span class="summary-value">
                    <span class="integral-disabled">您暂无可用积分</span>
                </span>
            </div>
            <!-- 订单总价 -->
            <div class="summary-item total">
                <span class="summary-label">订单总价：</span>
                <span class="summary-value price">
                    <span v-if="formData.UseIntegral" class="original-price">¥{{ totalPrice }}</span>
                    ¥{{ finalPrice }}
                </span>
            </div>
        </div>
        <el-button type="primary" :disabled="selectedGuests.length === 0" @click="submitOrder">提交订单</el-button>
        <div class="submit-tip" v-if="selectedGuests.length === 0">请至少选择一位游客</div>
    </div>
</template>

<script setup>
import { Post } from '@/api/http';
import NoImage from '@/assets/图片失效.png';
import { useCommonStore } from "@/store";
import { ElMessage, ElMessageBox } from 'element-plus';
import { computed, onBeforeMount, reactive, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);

//得到我当前的积分
const MyIntegral = ref(0);

// 计算订单总价
const totalPrice = computed(() => {
    if (Room.value && Room.value.ActualPrice) {
        return Room.value.ActualPrice * formData.Qty;
    }
    return 0;
});

// 计算积分可抵扣的金额
const integralDeductionAmount = computed(() => {
    if (Room.value && Room.value.IntegralExchangeMoney && Room.value.Integral) {
        // 计算总可用积分(每个房间可用积分 * 房间数量)
        const totalAvailableIntegral = Room.value.Integral * formData.Qty;
        // 实际可使用积分 = min(用户拥有积分, 总可用积分)
        const actualIntegral = Math.min(MyIntegral.value, totalAvailableIntegral);
        // 计算可抵扣金额 (按比例)
        const exchangeRate = Room.value.IntegralExchangeMoney / Room.value.Integral;
        return Math.round(actualIntegral * exchangeRate * 100) / 100;
    }
    return 0;
});

// 计算用户实际使用的积分数量
const usedIntegralAmount = computed(() => {
    if (formData.UseIntegral && Room.value && Room.value.Integral) {
        // 最多可以使用的积分 = 积分要求 * 房间数量
        const maxIntegral = Room.value.Integral * formData.Qty;
        // 实际使用积分 = min(用户拥有积分, 最多可用积分)
        return Math.min(MyIntegral.value, maxIntegral);
    }
    return 0;
});

// 判断是否可以使用积分抵扣
const canUseIntegral = computed(() => {
    return MyIntegral.value > 0 && Room.value &&
        Room.value.IntegralExchangeMoney > 0 &&
        Room.value.Integral > 0;
});

// 计算最终价格（考虑积分抵扣后）
const finalPrice = computed(() => {
    let price = totalPrice.value;
    if (formData.UseIntegral && canUseIntegral.value) {
        price = Math.max(0, price - integralDeductionAmount.value);
    }
    return price;
});

const Room = ref({});
const GuestInfoList = ref([]);
const selectedGuests = ref([]); // 选中的游客ID列表

// 表单数据
const formData = reactive({

    Qty: 1, // 默认预订1间
    TotalPeopleNum: 1, // 默认1人入住
    UseIntegral: false // 是否使用积分抵扣
});

// 监听选中的游客，自动计算总人数
watch(selectedGuests, (newVal) => {
    if (newVal && newVal.length > 0) {
        formData.TotalPeopleNum = newVal.length;
    } else {
        formData.TotalPeopleNum = 1; // 如果没有选中游客，默认为1人
    }
});

// 处理图片加载失败
const handleImageError = (e) => {
    e.target.src = NoImage;
}

const GetRoomByUserApi = async () => {
    let { Data, Success } = await Post("/Room/UserGet", {
        HotelId: route.query.HotelId,
        Id: route.query.RoomId,
        SelectDateList: [route.query.CheckInDate, route.query.CheckOutDate]
    });
    if (Success) {
        Room.value = Data;
    }
}

const GetGuestInfoListApi = async () => {
    let { Data: { Items }, Success } = await Post("/GuestInfo/List", {
        BelongUserId: UserId.value
    });
    if (Success) {
        GuestInfoList.value = Items;
    }
}

// 得到我当前的积分
const GetMyIntegralApi = async () => {
    let { Data, Success } = await Post("/HotelIntegral/GetUserHotelIntegral", {
        UserId: UserId.value,
        HotelId: route.query.HotelId
    });
    if (Success) {
        MyIntegral.value = Data;
        console.log("用户积分：", MyIntegral.value);
    }
}

onBeforeMount(async () => {
    GetRoomByUserApi();
    GetGuestInfoListApi();
    GetMyIntegralApi();
})

// 提交订单
const submitOrder = () => {
    if (selectedGuests.length === 0) {
        ElMessage.warning('请至少选择一位游客');
        return;
    }

    if (formData.Qty < 1) {
        ElMessage.warning('预订房间数量不能小于1');
        return;
    }

    // 这里可以添加订单提交逻辑
    ElMessageBox.confirm('确认提交订单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(async () => {

        // 跳转到支付页面，携带选中的游客ID和房间信息

        let { Data, Success } = await Post("/Appoint/ToOrder", {
            ToUserId: UserId.value,
            RoomId: route.query.RoomId,
            HotelId: route.query.HotelId,
            BeginAppointTime: route.query.CheckInDate,
            EndAppointTime: route.query.CheckOutDate,
            GuestIds: selectedGuests.value,
            TotalMoney: finalPrice.value,
            Qty: formData.Qty,
            TotalPeopleNum: formData.TotalPeopleNum,
            UseIntegral: formData.UseIntegral,
            IntegralAmount: formData.UseIntegral ? usedIntegralAmount.value : 0
        })
        if (Success) {
            router.push({
                path: '/Front/Payment',
                query: {
                    AppointId: Data.Id
                }
            });
        }


    }).catch(() => { });
}
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

/* 房间信息容器 */
.room-info-container {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-bottom: 30px;

    .room-info-header {
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
        margin-bottom: 20px;

        h2 {
            margin: 0;
            font-size: 20px;
            color: #333;
        }
    }

    .room-info-content {
        display: flex;
        margin-bottom: 20px;

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

            .room-price {
                margin-top: 15px;
                font-size: 16px;

                .price-label {
                    color: #666;
                    margin-right: 10px;
                }

                .price-value {
                    color: #f56c6c;
                    font-size: 20px;
                    font-weight: bold;
                }

                .original-price {
                    color: #999;
                    text-decoration: line-through;
                    margin-left: 10px;
                    font-size: 14px;
                }
            }
        }
    }

    .hotel-info {
        border-top: 1px solid #eee;
        padding-top: 20px;

        h3 {
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 16px;
            color: #333;
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
    }
}

/* 游客选择样式 */
.guest-selection-container {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-bottom: 30px;

    .guest-selection-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
        margin-bottom: 20px;

        h2 {
            margin: 0;
            font-size: 20px;
            color: #333;
        }
    }

    .guest-selection-content {

        /* 使用弹性布局，允许卡片水平排列并自动换行 */
        .el-checkbox-group {
            display: flex;
            flex-wrap: wrap;
            width: 100%;
            gap: 15px;
            /* 卡片之间的间距 */
        }

        .guest-card {
            width: calc(33.33% - 10px);
            /* 一行显示3个卡片 */
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 4px;
            transition: all 0.3s;
            box-sizing: border-box;

            @media (max-width: 1200px) {
                width: calc(50% - 7.5px);
                /* 在中等屏幕上一行显示2个 */
            }

            @media (max-width: 768px) {
                width: 100%;
                /* 在小屏幕上一行显示1个 */
            }

            &:hover {
                background-color: #f9f9f9;
            }

            .el-checkbox {
                width: 100%;
                display: flex;
                align-items: center;
            }

            .guest-info {
                margin-left: 10px;
                flex: 1;

                .guest-name {
                    font-weight: bold;
                    font-size: 16px;
                    margin-bottom: 5px;
                }

                .guest-detail {
                    font-size: 14px;
                    color: #666;

                    span {
                        margin-right: 15px;
                        display: inline-block;
                        margin-bottom: 5px;
                    }
                }
            }
        }
    }

    .no-guest-tip {
        padding: 30px 0;
    }
}

/* 预订表单样式 */
.booking-form-container {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-bottom: 30px;

    .booking-form-header {
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
        margin-bottom: 20px;

        h2 {
            margin: 0;
            font-size: 20px;
            color: #333;
        }
    }

    .booking-form-content {
        .form-group {
            margin-bottom: 20px;

            .form-label {
                font-size: 16px;
                color: #333;
                margin-bottom: 8px;
                font-weight: bold;
            }


            .el-input-number {
                width: 100%;
                margin-top: 8px;
            }

            .form-hint {
                font-size: 14px;
                color: #999;
                margin-top: 8px;
            }

            .people-count {
                padding: 10px 15px;
                background-color: #f5f7fa;
                border-radius: 4px;
                margin-top: 8px;

                .count-value {
                    font-size: 18px;
                    font-weight: bold;
                    color: #409eff;
                }
            }
        }
    }
}

/* 提交按钮样式 */
.submit-container {
    text-align: center;
    padding: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    margin-top: 30px;

    .order-summary {
        display: flex;
        justify-content: space-around;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 20px;
        padding: 15px;
        background-color: #f9f9f9;
        border-radius: 6px;
        border: 1px solid #eee;

        .summary-item {
            display: flex;
            align-items: flex-start;
            flex-direction: column;

            .summary-label {
                font-size: 15px;
                color: #666;
                margin-right: 10px;
            }

            .summary-value {
                font-size: 16px;
                font-weight: bold;
                color: #f56c6c;

                .integral-info {
                    font-weight: normal;
                    font-size: 13px;
                    color: #909399;
                    margin-left: 5px;
                }

                .integral-disabled {
                    color: #909399;
                    font-size: 14px;
                    font-weight: normal;
                }

                &.price {
                    font-size: 20px;

                    .original-price {
                        color: #999;
                        text-decoration: line-through;
                        margin-right: 10px;
                        font-size: 14px;
                        font-weight: normal;
                    }
                }
            }

            .integral-detail {
                margin-top: 10px;
                background-color: #f5f7fa;
                padding: 8px 12px;
                border-radius: 4px;
                width: 100%;

                .detail-item {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 5px;
                    font-size: 13px;

                    &:last-child {
                        margin-bottom: 0;
                    }

                    .detail-label {
                        color: #606266;
                    }

                    .detail-value {
                        color: #409eff;
                        font-weight: bold;
                    }
                }
            }

            &.total {
                .summary-label {
                    font-size: 16px;
                    color: #333;
                }

                .summary-value {
                    font-size: 20px;
                    font-weight: bold;
                    color: #f56c6c;
                }
            }
        }
    }

    .submit-tip {
        color: #999;
        font-size: 14px;
        margin-top: 10px;
    }
}
</style>