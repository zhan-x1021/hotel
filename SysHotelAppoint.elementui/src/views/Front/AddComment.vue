<template>
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
        <span class="breadcrumb-label">您当前的位置:</span>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/Front/Home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item :to="{ path: '/Front/MyAppointOrderList' }">我的预约订单</el-breadcrumb-item>
            <el-breadcrumb-item>订单评价</el-breadcrumb-item>
        </el-breadcrumb>
    </div>

    <div class="comment-container" v-if="editorShow">
        <div class="comment-header">
            <h2>我的评价</h2>
            <p class="comment-subtitle">您的评价对我们非常重要</p>
        </div>

        <el-form ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px" size="default"
            class="comment-form">
            <el-row :gutter="20">
                <el-col :span="24">
                    <div class="rating-section">
                        <el-form-item label="评分" prop="CommentScore">
                            <el-rate v-model="formData.CommentScore" :texts="texts" allow-half show-text class="custom-rate"
                                void-icon-class="el-icon-star-off" />
                        </el-form-item>
                    </div>

                    <div class="comment-section">
                        <el-form-item label="评价内容" prop="Comment">
                            <el-input type="textarea" v-model="formData.Comment" placeholder="请分享您的住宿体验，您的反馈将帮助我们提供更好的服务..."
                                :clearable="true" :min="0" :rows="6" class="comment-textarea"></el-input>
                        </el-form-item>
                    </div>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="24">
                    <div class="btn-container">
                        <el-button size="large" type="primary" @click="CreateOrEditForm()"
                            class="submit-btn">提交评价</el-button>
                        <el-button size="large" @click="router.go(-1)" class="cancel-btn">取消</el-button>
                    </div>
                </el-col>
            </el-row>
        </el-form>
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
// 编辑表单数据
const formData = reactive({});

// 编辑对话框显示状态
const editorShow = ref(false);

// 表单引用
const editModalForm = ref(null);

// 评分文字提示
const texts = ['很差', '较差', '一般', '满意', '非常满意'];

// 表单验证规则
const editModalFormRules = reactive({
    "No": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "RoomDetId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "ToUserId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "HotelId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "RoomId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "AppointStatus": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "CommentScore": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "ReturnMoney": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Qty": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "TotalPeopleNum": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "TotalMoney": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "BeginAppointTime": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "PayTime": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "EndAppointTime": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "PayType": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Comment": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
});

onBeforeMount(async () => {
    ShowEditModal(route.query.AppointId);
})


// 显示编辑对话框
const ShowEditModal = async (Id) => {
    const { Data } = await Post(`/Appoint/Get`, { Id: Id });
    Object.assign(formData, Data);
    editorShow.value = true;
};

// 退款确认逻辑
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    await editModalForm.value.validate(async valid => {
        if (valid) {
            const { Success } = await Post(`/Appoint/Comment`, formData);

            if (Success) {
                editorShow.value = false;
                router.go(-1);
                ElMessage.success('评价提交成功');
            }
        }
    });
};
</script>
<style scoped lang="scss">
/* 面包屑导航样式 */
.breadcrumb {
    margin-bottom: 20px;
    padding: 10px 0;
    border-bottom: 1px solid #ebeef5;

    .breadcrumb-label {
        color: #606266;
        margin-right: 10px;
        font-size: 14px;
    }
}

/* 评价容器样式 */
.comment-container {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 30px;
    margin: 20px 0;
}

/* 评价标题样式 */
.comment-header {
    text-align: center;
    margin-bottom: 30px;

    h2 {
        font-size: 24px;
        color: #303133;
        margin-bottom: 10px;
        font-weight: 600;
    }

    .comment-subtitle {
        color: #909399;
        font-size: 14px;
    }
}

/* 表单样式 */
.comment-form {
    .rating-section {
        background-color: #f9f9f9;
        padding: 20px;
        border-radius: 6px;
        margin-bottom: 20px;
    }

    .comment-section {
        margin-top: 20px;
    }

    .comment-textarea {
        width: 100%;

        :deep(.el-textarea__inner) {
            border-radius: 4px;
            border: 1px solid #dcdfe6;
            padding: 15px;
            font-size: 14px;
            transition: all 0.3s;

            &:focus {
                border-color: #409eff;
                box-shadow: 0 0 5px rgba(64, 158, 255, 0.2);
            }
        }
    }

    /* 评分样式 */
    .custom-rate {
        :deep(.el-rate__icon) {
            font-size: 24px;
            margin-right: 8px;
        }

        :deep(.el-rate__text) {
            font-size: 14px;
            color: #ff9900;
        }
    }

    /* 按钮容器 */
    .btn-container {
        display: flex;
        justify-content: center;
        margin-top: 40px;

        .submit-btn {
            min-width: 120px;
            font-weight: 500;
            letter-spacing: 1px;
            margin-right: 15px;
            background-color: #409eff;
            border-color: #409eff;

            &:hover {
                background-color: #66b1ff;
                border-color: #66b1ff;
            }
        }

        .cancel-btn {
            min-width: 120px;
            font-weight: 500;
            letter-spacing: 1px;
            color: #606266;
            border-color: #dcdfe6;

            &:hover {
                color: #409eff;
                border-color: #c6e2ff;
                background-color: #ecf5ff;
            }
        }
    }
}
</style>