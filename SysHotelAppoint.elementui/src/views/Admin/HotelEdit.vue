<template>
    <div class="hotel-edit-container">
        <el-card v-if="editorShow" class="hotel-form-card" shadow="hover">
            <template #header>
                <div class="card-header">
                    <h2>酒店信息编辑</h2>
                    <div class="audit-badge">
                        <el-tag v-if="formData.IsAudit === true" type="success" effect="dark">审核通过</el-tag>
                        <el-tag v-if="formData.IsAudit === false" type="danger" effect="dark">审核不通过</el-tag>
                        <el-tag v-if="formData.IsAudit === null" type="warning" effect="dark">待审核</el-tag>
                    </div>
                </div>
            </template>

            <el-form ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px" size="default"
                class="hotel-form">

                <!-- 基本信息部分 -->
                <div class="form-section">
                    <h3 class="section-title">基本信息</h3>
                    <el-divider></el-divider>

                    <el-row :gutter="20">
                        <el-col :span="24">
                            <el-form-item label="酒店名称" prop="Name">
                                <el-input type="text" v-model.trim="formData.Name" placeholder="请输入酒店名称"
                                    clearable></el-input>
                            </el-form-item>
                        </el-col>

                        <el-col :span="24">
                            <el-form-item label="酒店封面" prop="Cover">
                                <UploadImages :limit="1" v-model="formData.Cover"></UploadImages>
                            </el-form-item>
                        </el-col>

                        <el-col :span="24">
                            <el-form-item label="酒店图片集" prop="HotelImages">
                                <UploadImages :limit="8" v-model="formData.HotelImages"></UploadImages>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </div>

                <!-- 位置信息部分 -->
                <div class="form-section">
                    <h3 class="section-title">位置信息</h3>
                    <el-divider></el-divider>

                    <el-row :gutter="20">
                        <el-col :span="24">
                            <el-form-item label="酒店详细地址" prop="Address">
                                <el-input type="text" v-model="formData.Address" placeholder="请选择酒店详细地址" clearable disabled>
                                    <template #append>
                                        <el-button type="primary" @click="AddressOpenLogLatSelectToast">
                                            <el-icon class="el-icon--left">
                                                <Location />
                                            </el-icon>选择地址
                                        </el-button>
                                    </template>
                                </el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </div>

                <!-- 设施与服务部分 -->
                <div class="form-section">
                    <h3 class="section-title">设施与服务</h3>
                    <el-divider></el-divider>

                    <el-row :gutter="20">
                        <el-col :span="24">
                            <el-form-item label="服务设施" prop="Services">
                                <el-input type="textarea" :rows="3" v-model.trim="formData.Services" placeholder="请输入服务设施"
                                    clearable></el-input>
                            </el-form-item>
                        </el-col>

                        <el-col :span="24">
                            <el-form-item label="是否可带宠物" prop="IsPet">
                                <el-switch v-model="formData.IsPet" :active-value="true" :inactive-value="false"
                                    active-text="允许" inactive-text="不允许">
                                </el-switch>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </div>

                <!-- 入住规则部分 -->
                <div class="form-section">
                    <h3 class="section-title">入住规则</h3>
                    <el-divider></el-divider>

                    <el-row :gutter="20">
                        <el-col :span="24">
                            <el-form-item label="酒店通知" prop="Notice">
                                <el-input type="textarea" :rows="3" v-model.trim="formData.Notice" placeholder="请输入酒店通知"
                                    clearable></el-input>
                            </el-form-item>
                        </el-col>

                        <el-col :span="24">
                            <el-form-item label="入住提示" prop="CheckInTip">
                                <el-input type="textarea" :rows="3" v-model.trim="formData.CheckInTip" placeholder="请输入入住提示"
                                    clearable></el-input>
                            </el-form-item>
                        </el-col>

                        <el-col :span="24">
                            <el-form-item label="必读事项" prop="MustRead">
                                <el-input type="textarea" :rows="3" v-model.trim="formData.MustRead" placeholder="请输入必读事项"
                                    clearable></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </div>

                <!-- 酒店介绍部分 -->
                <div class="form-section">
                    <h3 class="section-title">酒店介绍</h3>
                    <el-divider></el-divider>

                    <el-row :gutter="20">
                        <el-col :span="24">
                            <el-form-item label="酒店介绍" prop="Content">
                                <AIRichText v-model="formData.Content"></AIRichText>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </div>

                <!-- 审核信息部分 -->
                <div v-if="formData.AuditResult" class="form-section">
                    <h3 class="section-title">审核信息</h3>
                    <el-divider></el-divider>

                    <el-row :gutter="20">
                        <el-col :span="24">
                            <el-form-item label="审核结果" prop="AuditResult">
                                <div class="audit-result">
                                    {{ formData.AuditResult }}
                                </div>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </div>

                <!-- 提交按钮部分 -->
                <div class="form-actions">
                    <el-button v-if="formData.IsAudit === null" type="primary" :icon="Check"
                        @click="CreateOrEditForm()">提交审核</el-button>
                    <el-button v-if="formData.IsAudit === true" type="primary" :icon="Edit"
                        @click="CreateOrEditForm()">保存修改</el-button>
                    <el-button v-if="formData.IsAudit === false" type="danger" :icon="Refresh"
                        @click="CreateOrEditForm()">再次提交审核</el-button>
                </div>
            </el-form>
        </el-card>

        <LogLatSelectToast ref="AddressLogLatSelectToastRef"></LogLatSelectToast>
    </div>
</template>

<script setup>
import { Post, PostSingleUpdate } from '@/api/http';
import { ColumnType } from '@/components/Tables/columnTypes';
import { useCommonStore } from "@/store";

import { Delete, Edit, Refresh, Search, Check, Location } from '@element-plus/icons-vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { onMounted, onBeforeMount, nextTick, watch, computed, reactive, ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';

const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
// 计算属性
const Token = computed(() => commonStore.Token)
const UserInfo = computed(() => commonStore.UserInfo)
const RoleType = computed(() => commonStore.RoleType)
const UserId = computed(() => commonStore.UserId)

// 搜索表单数据
const searchForm = reactive({});

// 编辑表单数据
const formData = reactive({});

// 编辑对话框显示状态
const editorShow = ref(false);

// 表单引用
const editModalForm = ref(null);

// 表单验证规则
const editModalFormRules = reactive({
    "HotelUserId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "HotelImages": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Cover": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Name": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Services": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Notice": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "CheckInTip": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "MustRead": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "IsPet": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "ProviceCityArea": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Address": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Content": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
});

// 地址选择弹窗引用
const ProviceCityAreaLogLatSelectToastRef = ref(null);

// 地址选择弹窗引用
const AddressLogLatSelectToastRef = ref(null);

// 打开地址选择弹窗
const AddressOpenLogLatSelectToast = () => {
    AddressLogLatSelectToastRef.value.OpenToast(formData.Latitude, formData.Longitude, formData.Address, (data) => {
        console.log(data.lat);
        formData.Latitude = data.lat;
        formData.Longitude = data.lng;
        formData.Address = data.fullAddress;
        formData.ProviceCityArea = data.province + "," + data.city + "," + data.district;
    });
};

// 表格引用
const PaginationTableId = ref(null);

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/Hotel/Get`, { Id: 0, HotelUserId: UserId.value });

    Data.HotelUserId = UserId.value;
    Object.assign(formData, Data);

    editorShow.value = true;

};

// 创建或编辑表单
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    await editModalForm.value.validate(async valid => {
        if (valid) {
            if (formData.IsAudit == false) {
                formData.IsAudit = null;
                formData.AuditResult = null;
            }
            const { Success } = await Post(`/Hotel/CreateOrEdit`, formData);

            if (Success) {
                editorShow.value = false;
                ShowEditModal(null);
                ElMessage.success('操作成功');
            }
        }
    });
};


onBeforeMount(() => {
    ShowEditModal(null);
});
</script>

<style scoped>
/* 酒店编辑容器 */
.hotel-edit-container {

    min-height: 100vh;
}

/* 卡片样式 */
.hotel-form-card {
    border-radius: 8px;
    margin-bottom: 20px;
}

/* 卡片头部样式 */
.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.card-header h2 {
    margin: 0;
    color: #303133;
    font-size: 20px;
    font-weight: 600;
}

/* 表单样式 */
.hotel-form {
    padding: 10px;
}

/* 表单分区样式 */
.form-section {
    margin-bottom: 30px;
    background-color: #ffffff;
    border-radius: 6px;
    padding: 20px;

}

/* 分区标题样式 */
.section-title {
    color: #409EFF;
    font-size: 16px;
    font-weight: 600;
    margin-top: 0;
    margin-bottom: 10px;
}

/* 表单操作区域 */
.form-actions {
    display: flex;
    justify-content: center;
    margin-top: 40px;
    padding: 20px;
}

/* 审核结果样式 */
.audit-result {
    padding: 10px;
    border-left: 3px solid #409EFF;
    background-color: #f0f9ff;
    color: #606266;
}

/* 审核状态标签 */
.audit-badge {
    display: flex;
    align-items: center;
}

/* 表单项间距 */
.el-form-item {
    margin-bottom: 22px;
}
</style>