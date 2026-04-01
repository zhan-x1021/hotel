<template>
    <!-- 面包屑导航 -->
    <div>
        <!-- 设备信息选择区域 -->
        <div class="equipment-container">
            <div class="category-container" v-for="(group, groupName) in groupedEquipments" :key="groupName">
                <!-- 分类标题 -->
                <div class="category-title">{{ groupName }}</div>
                <!-- 分类下的设备列表 -->
                <div class="equipment-list">
                    <el-checkbox-group v-model="selectedEquipments">
                        <el-checkbox style="margin-top:5px;" v-for="item in group" :key="item.Id" :label="item.Id" border>
                            {{ item.Name }}
                            <span v-if="item.IsFree" class="free-tag">免费</span>
                        </el-checkbox>
                    </el-checkbox-group>
                </div>
            </div>
        </div>

        <!-- 操作按钮 -->
        <div class="action-buttons">
            <el-button type="primary" @click="handleSubmit">保存设置</el-button>
            <el-button @click="handleCancel">取消</el-button>
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

// 设备列表数据
const equipmentList = ref([]);
// 已选择的设备ID列表
const selectedEquipments = ref([]);
// 表单数据
const formData = reactive({
    Id: route.query.RoomId,
    EquipmentInfoIds: []
});

// 按分类分组的设备
const groupedEquipments = computed(() => {
    const groups = {};
    equipmentList.value.forEach(item => {
        if (!groups[item.GroupName]) {
            groups[item.GroupName] = [];
        }
        groups[item.GroupName].push(item);
    });
    return groups;
});

// 获取设备信息列表
const GetEquipmentInfoListApi = async () => {

    const res = await Post("/EquipmentInfo/List", {

    });

    if (res && res.Success) {
        equipmentList.value = res.Data.Items || [];

        // 如果URL中有预选的设备ID，则设置为已选
        if (route.query.EquipmentInfoIds) {

            const preSelectedIds = route.query.EquipmentInfoIds.split(",").map(id => Number(id));
            selectedEquipments.value = preSelectedIds;

        }
    } else {
        ElMessage.error("获取设备信息失败");
    }
}

// 提交设置
const handleSubmit = async () => {
    formData.EquipmentInfoIds = selectedEquipments.value.join(",");

    const { Success } = await Post(`/Room/EquipmentInfoSave`, formData);

    if (Success) {
        // 这里可以添加提交给后端的逻辑
        ElMessage.success("设备信息设置已保存");
        router.back();
    }
}

// 取消操作
const handleCancel = () => {
    router.back();
}

onBeforeMount(async () => {
    GetEquipmentInfoListApi();
})

</script>
<style scoped lang="scss">
// 设备容器样式
.equipment-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    margin-bottom: 20px;
}

// 分类容器样式
.category-container {
    border: 1px solid #ebeef5;
    border-radius: 4px;
    padding: 15px;
    width: 100%;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

// 分类标题样式
.category-title {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 1px solid #ebeef5;
}

// 设备列表样式
.equipment-list {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
}

// 免费标签样式
.free-tag {
    font-size: 12px;
    color: #67c23a;
    margin-left: 5px;
}

// 操作按钮样式
.action-buttons {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}
</style>