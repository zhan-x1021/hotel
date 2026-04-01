<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>我要反馈</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <div class="feedback-container">


        <el-card shadow="hover" class="feedback-card">
            <!-- 顶部引导文案 -->
            <div class="feedback-header">
                <h2>宾客反馈</h2>
                <p class="feedback-description">
                    我们十分重视您的意见和建议，请填写以下表单告诉我们您的体验或问题，我们将尽快为您处理。
                    您的每一条反馈都将帮助我们提供更优质的服务。
                </p>
            </div>
            <el-form v-if="editorShow" ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px"
                size="default" class="feedback-form">

                <el-divider content-position="left"><i class="el-icon-edit"></i> 填写反馈信息</el-divider>

                <el-row :gutter="20">
                    <el-col :span="24">
                        <el-form-item label="反馈标题" prop="Title">
                            <el-input type="text" v-model="formData.Title" placeholder="请简要描述您的反馈主题（如：房间设施建议）"
                                :clearable="true" maxlength="50" show-word-limit>
                            </el-input>
                            <div class="form-tip">清晰的标题可以帮助我们更快地了解您的反馈重点</div>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="反馈内容" prop="Content">
                            <AIRichText v-model="formData.Content"></AIRichText>
                            <div class="form-tip">请详细描述您的体验、问题或建议，以便我们能更好地为您提供帮助</div>
                        </el-form-item>
                    </el-col>
                </el-row>

                <el-row type="flex" justify="center" align="middle" class="submit-row">
                    <el-form-item>
                        <el-button size="large" type="primary" @click="CreateOrEditForm()" class="submit-btn">
                            <el-icon>
                                <Check />
                            </el-icon>
                            提交反馈
                        </el-button>
                        <el-button size="large" type="info" @click="goBack" plain class="cancel-btn">
                            <el-icon>
                                <Back />
                            </el-icon>
                            返回
                        </el-button>
                    </el-form-item>
                </el-row>

                <div class="feedback-note">
                    <el-icon>
                        <InfoFilled />
                    </el-icon> 提交后，酒店工作人员会在工作时间内尽快处理您的反馈，感谢您的耐心等待。
                </div>
            </el-form>
        </el-card>
    </div>
</template>

<script setup>
import { Post, PostSingleUpdate } from '@/api/http';
import { ColumnType } from '@/components/Tables/columnTypes';
import { useCommonStore } from "@/store";

import { Delete, Edit, Refresh, Search, } from '@element-plus/icons-vue';
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

// 编辑表单数据
const formData = reactive({});

// 编辑对话框显示状态
const editorShow = ref(false);

// 表单引用
const editModalForm = ref(null);

// 返回上一页
const goBack = () => {
    router.back();
};

// 表单验证规则
const editModalFormRules = reactive({
    "Title": [
        { required: true, message: '请输入反馈标题', trigger: 'blur' },
        { min: 2, max: 50, message: '标题长度应在2-50个字符之间', trigger: 'blur' }
    ],
    "FeedbackUserId": [
        { required: true, message: '用户ID不能为空', trigger: 'blur' },
    ],
    "HotelId": [
        { required: true, message: '酒店ID不能为空', trigger: 'blur' },
    ],
    "DoWithUserId": [
        { required: true, message: '处理人ID不能为空', trigger: 'blur' },
    ],
    "IsDoWith": [
        { required: true, message: '是否处理不能为空', trigger: 'blur' },
    ],
    "ReplayContent": [
        { required: true, message: '回复内容不能为空', trigger: 'blur' },
    ],
    "Content": [
        { required: true, message: '请输入反馈内容', trigger: 'blur' },
    ],
});


// 表格引用
const PaginationTableId = ref(null);

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/LeaveFeedback/Get`, { Id: Id });
    Data.FeedbackUserId = UserId.value;
    if (route.query.HotelId) {
        Data.HotelId = route.query.HotelId;
    }

    Object.assign(formData, Data);

    editorShow.value = true;

};

// 创建或编辑表单
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    await editModalForm.value.validate(async valid => {
        if (valid) {
            const { Success } = await Post(`/LeaveFeedback/CreateOrEdit`, formData);

            if (Success) {
                editorShow.value = false;
                if (PaginationTableId.value) {
                    PaginationTableId.value.Reload(searchForm);
                }
                ElMessage.success('您的反馈已成功提交，我们将尽快处理！');
                router.push('/Front/UserCenter?currentMenu=MyLeaveFeedbackList');
            }
        }
    });
};


onBeforeMount(() => {
    ShowEditModal(null)
});
</script>

<style scoped>
/* 整体容器样式 */
.feedback-container {


    margin: 0 auto;
}

/* 顶部标题和描述 */
.feedback-header {
    margin-bottom: 30px;
    text-align: center;
}

.feedback-header h2 {
    font-size: 28px;
    color: #303133;
    margin-bottom: 15px;
    font-weight: 600;
}

.feedback-description {
    color: #606266;
    font-size: 16px;
    line-height: 1.6;
    margin-bottom: 20px;
}

/* 表单卡片样式 */
.feedback-card {
    margin-bottom: 40px;
    border-radius: 8px;
}

/* 表单样式 */
.feedback-form {
    padding: 10px;
}

/* 表单提示文字 */
.form-tip {
    font-size: 12px;
    color: #909399;
    line-height: 1.5;
    margin-top: 5px;
    padding-left: 5px;
}

/* 提交按钮行 */
.submit-row {
    margin-top: 30px;
}

/* 提交按钮 */
.submit-btn {
    min-width: 120px;
    font-weight: 500;
    letter-spacing: 1px;
    margin-right: 15px;
}

/* 取消按钮 */
.cancel-btn {
    min-width: 100px;
}

/* 底部提示 */
.feedback-note {
    text-align: center;
    color: #909399;
    font-size: 14px;
    margin-top: 20px;
    padding: 15px;
    background-color: #f8f9fa;
    border-radius: 4px;
    border-left: 3px solid #409EFF;
}
</style>