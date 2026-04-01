<template>
    <div class="assign-room-container">
        <!-- 日期选择标签页 -->
        <div class="date-tabs">
            <div v-for="dateItem in allDatesData" :key="dateItem.Date" class="date-tab"
                :class="{ active: selectedDate === dateItem.Date }" @click="changeSelectedDate(dateItem.Date)">
                {{ formatDate(dateItem.Date) }}
            </div>
        </div>

        <!-- 选择信息提示 -->
        <div class="selection-info">
            <div class="info-item">
                <el-icon>
                    <Calendar />
                </el-icon>
                <span>入住日期: {{ formatDate(selectedDate) }}</span>
            </div>
            <div class="info-item">
                <el-icon>
                    <House />
                </el-icon>
                <span>房型: {{ roomTypeName }}</span>
            </div>
            <div class="info-item">
                <el-icon><Select /></el-icon>
                <span>当前日期已选择: {{ (selectedRoomDets[selectedDate] || []).length }}/{{ roomsPerDay }}</span>
            </div>
            <div class="info-item">
                <el-icon><Select /></el-icon>
                <span>总计已选择: {{ getTotalselectedRoomDets() }}/{{ roomQty }}</span>
            </div>
        </div>

        <!-- 楼层列表 -->
        <div class="floor-container">
            <div v-for="floor in currentFloorRooms" :key="floor.Floor" class="floor-section">
                <div class="floor-header">
                    <div class="floor-title">{{ floor.Floor }}楼</div>
                    <div class="floor-stats">
                        <span class="stat-item">
                            <span class="stat-dot free"></span>空闲
                        </span>
                        <span class="stat-item">
                            <span class="stat-dot reserved"></span>预约中
                        </span>
                        <span class="stat-item">
                            <span class="stat-dot occupied"></span>入住中
                        </span>
                        <span class="stat-item">
                            <span class="stat-dot checkout"></span>已退房
                        </span>
                    </div>
                </div>
                <div class="room-grid">
                    <div v-for="roomDet in filterRoomsByRoomId(floor.RoomDetViews)" :key="roomDet.No" class="room-card"
                        :class="[
                            getRoomStatusClass(roomDet.RoomStatusFormat),
                            { 'room-selected': isRoomDetSelected(roomDet) },
                            { 'room-disabled': roomDet.RoomStatusFormat !== '空闲' || roomDet.RoomDto.Id !== targetRoomId }
                        ]" @click="handleRoomDetClick(roomDet)">
                        <div class="room-status-indicator"></div>
                        <div class="room-content">
                            <div class="room-no">{{ roomDet.No }}</div>
                            <div class="room-type-tag">{{ roomDet.RoomDto.RoomShapeFormat }}</div>
                            <div class="room-status-tag">{{ roomDet.RoomStatusFormat }}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 底部操作按钮 -->
        <div class="action-buttons">
            <el-button type="info" @click="cancelSelection" plain>取消</el-button>
            <el-button type="primary" :disabled="getTotalselectedRoomDets() !== roomQty" @click="confirmSelection">
                确认选择 ({{ getTotalselectedRoomDets() }}/{{ roomQty }})
            </el-button>
        </div>
    </div>
</template>

<script setup>
import defaultAvatar from '@/assets/默认头像.png';
import NoImage from '@/assets/图片失效.png';
import { Post, PostSingleUpdate } from '@/api/http';
import { ref, reactive, nextTick, computed, onBeforeMount, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useCommonStore } from "@/store";
import { ElMessage, ElMessageBox } from 'element-plus';
import { Calendar, House, Select } from '@element-plus/icons-vue';

const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);

// 存储所有日期的房间数据
const allDatesData = ref([]);
// 当前选中日期的楼层房间数据
const currentFloorRooms = ref([]);
// 当前选中的日期
const selectedDate = ref('');
// 需要选择的房间数量
const roomQty = ref(1);
// 总天数
const totalDays = ref(1);
// 每天需要的房间数
const roomsPerDay = ref(1);
// 已选择的房间 - 修改为对象结构，按日期分组
const selectedRoomDets = ref({});
// 目标房型ID
const targetRoomId = ref(null);
// 房型名称
const roomTypeName = ref('');

// 初始化房间数量和目标房型ID
const initParams = () => {
    const qty = route.query.Qty;
    if (qty && !isNaN(parseInt(qty))) {
        roomsPerDay.value = parseInt(qty);
    }

    // 计算开始和结束日期之间的天数
    const beginDate = route.query.BeginAppointTime;
    const endDate = route.query.EndAppointTime;

    if (beginDate && endDate) {
        const start = new Date(beginDate);
        const end = new Date(endDate);
        const diffTime = Math.abs(end - start);
        totalDays.value = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        // 计算总需要的房间数 = 天数 * 每天房间数
        roomQty.value = totalDays.value * roomsPerDay.value;
    }

    const roomId = route.query.RoomId;
    if (roomId && !isNaN(parseInt(roomId))) {
        targetRoomId.value = parseInt(roomId);
    }
};

// 过滤符合RoomId的房间
const filterRoomsByRoomId = (rooms) => {
    if (!targetRoomId.value) return rooms;

    // 返回所有房间，但在UI上会根据RoomId区分显示样式
    return rooms;
};

// 判断房间明细是否已被选中
const isRoomDetSelected = (roomDet) => {
    // 检查当前日期下是否有该房间
    const currentDateRoomDets = selectedRoomDets.value[selectedDate.value] || [];
    return currentDateRoomDets.some(selectedRoomDet => selectedRoomDet.No === roomDet.No);
};

// 获取所有已选房间的总数
const getTotalselectedRoomDets = () => {
    return Object.values(selectedRoomDets.value).reduce((total, rooms) => total + rooms.length, 0);
};

// 处理房间明细点击事件
const handleRoomDetClick = (roomDet) => {
    // 添加调试输出，查看房间明细对象结构
    console.log('房间明细对象结构:', roomDet);

    // 检查房间明细是否符合条件：必须是空闲状态且RoomId匹配
    if (roomDet.RoomStatusFormat !== '空闲') {
        ElMessage.warning('只能选择空闲状态的房间');
        return;
    }

    if (targetRoomId.value && roomDet.RoomDto.Id !== targetRoomId.value) {
        ElMessage.warning('只能选择指定房型的房间');
        return;
    }

    // 初始化当前日期的选择数组
    if (!selectedRoomDets.value[selectedDate.value]) {
        selectedRoomDets.value[selectedDate.value] = [];
    }

    // 如果已经选中，则取消选择
    if (isRoomDetSelected(roomDet)) {
        selectedRoomDets.value[selectedDate.value] = selectedRoomDets.value[selectedDate.value].filter(
            selectedRoomDet => selectedRoomDet.No !== roomDet.No
        );
        return;
    }

    // 检查当前日期已选择的房间明细数量是否达到每天需要的房间数
    if (selectedRoomDets.value[selectedDate.value].length >= roomsPerDay.value) {
        ElMessage.warning(`当前日期最多只能选择${roomsPerDay.value}间房间`);
        return;
    }

    // 如果已达到总选择上限，提示用户
    if (getTotalselectedRoomDets() >= roomQty.value) {
        ElMessage.warning(`最多只能选择${roomQty.value}间房间（${roomsPerDay.value}间/天 × ${totalDays.value}天）`);
        return;
    }

    // 添加到已选择列表
    selectedRoomDets.value[selectedDate.value].push(roomDet);
};

// 确认选择
const confirmSelection = async () => {
    const totalSelected = getTotalselectedRoomDets();
    if (totalSelected !== roomQty.value) {
        ElMessage.warning(`请选择${roomQty.value}间房间（${roomsPerDay.value}间/天 × ${totalDays.value}天）`);
        return;
    }

    // 检查每个日期是否都选择了正确数量的房间
    for (const dateItem of allDatesData.value) {
        const dateRooms = selectedRoomDets.value[dateItem.Date] || [];
        if (dateRooms.length !== roomsPerDay.value) {
            ElMessage.warning(`${formatDate(dateItem.Date)}需要选择${roomsPerDay.value}间房间`);
            return;
        }
    }

    // 准备提交数据
    let bodys = [];

    // 获取预约ID
    const appointId = route.query.AppointId ? parseInt(route.query.AppointId) : null;

    // 遍历每个日期的已选房间明细
    for (const [date, roomDets] of Object.entries(selectedRoomDets.value)) {

        // 为每个房间明细创建一条记录
        for (const roomDet of roomDets) {
            // 计算当前日期的开始和结束时间
            const currentDate = new Date(date);
            const beginActiveTime = new Date(currentDate);
            beginActiveTime.setHours(12, 0, 0); // 设置为当天14:00

            const endActiveTime = new Date(currentDate);
            endActiveTime.setHours(12, 0, 0); // 设置为当天12:00
            endActiveTime.setDate(endActiveTime.getDate() + 1); // 加一天

            bodys.push({
                AppointId: appointId,
                RoomDetId: roomDet.RoomDetId, // 房间明细ID
                HotelId: route.query.HotelId,
                RoomId: roomDet.RoomDto.Id, // 房型ID，避免使用可选链
                BeginActiveTime: window.YMDHMSFormat(beginActiveTime),
                EndActiveTime: window.YMDHMSFormat(endActiveTime),
                RoomStatus: 3 // 设置为入住中状态
            });
        }
    }

    // 如果没有数据，提示用户
    if (bodys.length === 0) {
        ElMessage.warning("没有可提交的数据，请重新选择房间");
        return;
    }

    try {

        const { Success } = await Post("/RoomMatch/BatchCreateOrEdit", bodys);
        if (Success) {
            ElMessage.success("分配成功");
            router.go(-1);
        } else {
            ElMessage.error("分配失败，请重试");
        }
    } catch (error) {
        ElMessage.error("分配失败，请重试");
        console.error("房间分配失败:", error);
    }
};

// 取消选择
const cancelSelection = () => {
    router.go(-1);
};

// 根据房间状态返回对应的样式类名
const getRoomStatusClass = (status) => {
    const statusMap = {
        '空闲': 'room-free',
        '预约中': 'room-reserved',
        '入住中': 'room-occupied',
        '已退房': 'room-checkout'
    };
    return statusMap[status] || '';
};

// 格式化日期显示
const formatDate = (dateStr) => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const weekday = ['日', '一', '二', '三', '四', '五', '六'][date.getDay()];
    return `${month}月${day}日 (周${weekday})`;
};

// 格式化ISO时间，避免时区偏移问题
const formatISOTimeWithoutOffset = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

// 切换选中的日期
const changeSelectedDate = (date) => {
    selectedDate.value = date;
    updateCurrentFloorRooms();
    // 切换日期时清空已选择的房间
    // selectedRoomDets.value = {}; // 清空所有日期的选择
};

// 更新当前选中日期的楼层房间数据
const updateCurrentFloorRooms = () => {
    const selectedDateData = allDatesData.value.find(item => item.Date === selectedDate.value);
    if (selectedDateData) {
        currentFloorRooms.value = selectedDateData.RoomViews || [];
    } else {
        currentFloorRooms.value = [];
    }
    getRoomTypeName();
};

// 获取房型名称
const getRoomTypeName = () => {
    if (!currentFloorRooms.value || currentFloorRooms.value.length === 0) return;

    // 遍历所有楼层和房间明细，找到匹配的房型名称
    for (const floor of currentFloorRooms.value) {
        for (const roomDet of floor.RoomDetViews) {
            if (roomDet.RoomDto.Id === targetRoomId.value) {
                roomTypeName.value = roomDet.RoomDto.Title;
                return;
            }
        }
    }
};

onBeforeMount(async () => {
    initParams();
    await GetAllRoomViewApi();
});

// 监听allDatesData变化，初始化选中日期
watch(allDatesData, (newVal) => {
    if (newVal.length > 0 && !selectedDate.value) {
        selectedDate.value = newVal[0].Date;
        updateCurrentFloorRooms();
    }
}, { immediate: true });

const GetAllRoomViewApi = async () => {
    const { Data } = await Post(`/RoomDet/GetAllRoomView`, {
        HotelId: route.query.HotelId,
        BeginDate: route.query.BeginAppointTime,
        EndDate: route.query.EndAppointTime
    });
    allDatesData.value = Data;

    // 如果有数据且未选择日期，则默认选择第一个日期
    if (Data && Data.length > 0 && !selectedDate.value) {
        selectedDate.value = Data[0].Date;
        updateCurrentFloorRooms();
    }
};
</script>

<style scoped lang="scss">
/* 整体容器 */
.assign-room-container {
    padding: 20px;
    background-color: #f5f7fa;
    min-height: calc(100vh - 100px);
}

/* 日期标签页样式 */
.date-tabs {
    display: flex;
    margin-bottom: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
    overflow-x: auto;
    padding: 10px;
}

.date-tab {
    padding: 10px 20px;
    margin-right: 10px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s;
    font-size: 14px;
    white-space: nowrap;
}

.date-tab:hover {
    background-color: #f0f7ff;
    color: #409EFF;
}

.date-tab.active {
    background-color: #409EFF;
    color: #fff;
    font-weight: bold;
}

/* 选择信息提示 */
.selection-info {
    display: flex;
    justify-content: space-between;
    background-color: #fff;
    padding: 15px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.info-item {
    display: flex;
    align-items: center;
    font-size: 14px;

    .el-icon {
        margin-right: 8px;
        color: #409EFF;
    }
}

/* 楼层容器 */
.floor-container {
    margin-bottom: 30px;
}

/* 楼层区域样式 */
.floor-section {
    margin-bottom: 30px;
    background-color: #fff;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

/* 楼层头部 */
.floor-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

/* 楼层标题 */
.floor-title {
    font-size: 18px;
    font-weight: bold;
    color: #303133;
    position: relative;
    padding-left: 15px;
}

.floor-title:before {
    content: '';
    position: absolute;
    left: 0;
    top: 50%;
    transform: translateY(-50%);
    width: 4px;
    height: 18px;
    background-color: #409EFF;
    border-radius: 2px;
}

/* 楼层统计 */
.floor-stats {
    display: flex;
    gap: 15px;
}

.stat-item {
    display: flex;
    align-items: center;
    font-size: 12px;
    color: #606266;
}

.stat-dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    margin-right: 5px;
}

.stat-dot.free {
    background-color: #67C23A;
}

.stat-dot.reserved {
    background-color: #E6A23C;
}

.stat-dot.occupied {
    background-color: #F56C6C;
}

.stat-dot.checkout {
    background-color: #909399;
}

/* 房间网格布局 */
.room-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
    gap: 15px;
}

/* 房间卡片样式 */
.room-card {
    height: 90px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    cursor: pointer;
    transition: all 0.3s;
    position: relative;
    display: flex;
    flex-direction: column;
}

.room-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* 房间状态指示条 */
.room-status-indicator {
    height: 4px;
    width: 100%;
}

.room-free .room-status-indicator {
    background-color: #67C23A;
}

.room-reserved .room-status-indicator {
    background-color: #E6A23C;
}

.room-occupied .room-status-indicator {
    background-color: #F56C6C;
}

.room-checkout .room-status-indicator {
    background-color: #909399;
}

/* 房间内容 */
.room-content {
    flex: 1;
    padding: 10px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    background-color: #fff;
}

/* 房间号样式 */
.room-no {
    font-size: 18px;
    font-weight: bold;
    color: #303133;
    text-align: center;
    margin-bottom: 5px;
}

/* 房间类型标签 */
.room-type-tag {
    font-size: 12px;
    color: #606266;
    background-color: #f0f2f5;
    padding: 2px 6px;
    border-radius: 4px;
    text-align: center;
    margin-bottom: 5px;
}

/* 房间状态标签 */
.room-status-tag {
    font-size: 12px;
    padding: 2px 6px;
    border-radius: 4px;
    text-align: center;
    font-weight: bold;
}

.room-free .room-status-tag {
    color: #67C23A;
    background-color: rgba(103, 194, 58, 0.1);
}

.room-reserved .room-status-tag {
    color: #E6A23C;
    background-color: rgba(230, 162, 60, 0.1);
}

.room-occupied .room-status-tag {
    color: #F56C6C;
    background-color: rgba(245, 108, 108, 0.1);
}

.room-checkout .room-status-tag {
    color: #909399;
    background-color: rgba(144, 147, 153, 0.1);
}

/* 已选中的房间样式 */
.room-selected {
    border: 2px solid #409EFF;
    box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.room-selected .room-no {
    color: #409EFF;
}

/* 禁用的房间样式 */
.room-disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.room-disabled:hover {
    transform: none;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

/* 底部操作按钮 */
.action-buttons {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 30px;
    padding: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 -2px 12px 0 rgba(0, 0, 0, 0.05);
    position: sticky;
    bottom: 0;
}
</style> 