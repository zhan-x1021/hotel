<template>
    <div>
        <!-- 搜索表单卡片 -->
        <el-card class="box-card">
            <div slot="header" class="clearfix">
                <el-row>
                    <el-button type="primary" size="default" @click="SearchClick">
                        🔍 查询
                    </el-button>
                    <el-button type="warning" size="default" @click="ResetClick">
                        🔄 清空条件
                    </el-button>
                    <el-button type="success" size="default" @click="ShowEditModal()">
                        ✏️ 新增
                    </el-button>
                </el-row>
            </div>
            <div class="margin-top-sm">
                <el-form :inline="true" :model="searchForm" size="default">
                    <el-form-item label="关键词" prop="KeyWord">
                        <el-input v-model.trim="searchForm.KeyWord" placeholder="请输入关键词" :clearable="true"></el-input>
                    </el-form-item>

                </el-form>
            </div>
        </el-card>
        <!-- 编辑对话框 -->
        <el-dialog :title="formData.Id ? '修改旅客信息' : '添加旅客信息'" v-model="editorShow" width="50%" :lock-scroll="true"
            min-height="500px">
            <el-form v-if="editorShow" ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px"
                size="default">
                <el-row :gutter="10" class="edit-from-body">

                    <el-col :span="24">
                        <el-form-item label="姓名" prop="Name">
                            <el-input type="text" v-model="formData.Name" placeholder="请输入姓名" :clearable="true"></el-input>
                        </el-form-item>
                    </el-col>


                    <el-col :span="24">
                        <el-form-item label="身份证" prop="IdCard">
                            <el-input type="text" v-model="formData.IdCard" placeholder="请输入身份证"
                                :clearable="true"></el-input>
                        </el-form-item>
                    </el-col>


                    <el-col :span="24">
                        <el-form-item label="出生年月" prop="Birth">
                            <el-date-picker v-model="formData.Birth" align="right" type="date" placeholder="选择出生时间"
                                format="YYYY-MM-DD" value-format="YYYY-MM-DD HH:mm:ss">
                            </el-date-picker>
                        </el-form-item>
                    </el-col>


                    <el-col :span="24">
                        <el-form-item label="手机号" prop="Phone">
                            <el-input type="text" v-model="formData.Phone" placeholder="请输入手机号"
                                :clearable="true"></el-input>
                        </el-form-item>
                    </el-col>


                    <el-col :span="24">
                        <el-form-item label="性别" prop="Sex">
                            <el-select v-model="formData.Sex" placeholder="请选择性别">
                                <el-option label="男" value="男"></el-option>
                                <el-option label="女" value="女"></el-option>
                            </el-select>
                        </el-form-item>
                    </el-col>

                </el-row>

                <el-row type="flex" justify="end" align="bottom">
                    <el-form-item>
                        <el-button size="default" type="primary" plain @click="CreateOrEditForm()">确 定</el-button>
                        <el-button size="default" @click="editorShow = false">取 消</el-button>
                    </el-form-item>
                </el-row>
            </el-form>
        </el-dialog>

        <PaginationBox ref="GuestInfoPaginationBox" :where="where" url="/GuestInfo/List" :limit="8">
            <template v-slot:content="{ data }">
                <div class="guest-info-container">
                    <el-row :gutter="20">
                        <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="(item, index) in data" :key="index">
                            <el-card class="guest-card" shadow="hover">
                                <div class="guest-header">
                                    <div class="avatar-container">
                                        <el-avatar :size="60" :class="item.Sex === '男' ? 'male-avatar' : 'female-avatar'">
                                            {{ item.Name ? item.Name.substring(0, 1) : '游' }}
                                        </el-avatar>
                                    </div>
                                    <div class="guest-title">
                                        <h3>{{ item.Name }}</h3>
                                        <div class="gender-tag">
                                            <el-tag :type="item.Sex === '男' ? 'primary' : 'danger'" size="small">{{ item.Sex
                                                === '男' ? '👨' : '👩' }} {{ item.Sex }}</el-tag>
                                        </div>
                                    </div>
                                </div>

                                <div class="guest-info">
                                    <div class="info-item">
                                        <span class="emoji-icon">👤</span>
                                        <span>身份证: {{ formatIdCard(item.IdCard) }}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="emoji-icon">📅</span>
                                        <span>出生日期: {{ formatDate(item.Birth) }}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="emoji-icon">📱</span>
                                        <span>手机号: {{ item.Phone }}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="emoji-icon">⏱️</span>
                                        <span>创建时间: {{ formatDate(item.CreationTime) }}</span>
                                    </div>
                                </div>

                                <div class="guest-actions">
                                    <el-button type="primary" size="small" @click="ShowEditModal(item.Id)">
                                        ✏️ 编辑
                                    </el-button>
                                    <el-button type="danger" size="small" @click="ShowDeleteModal(item.Id)">
                                        🗑️ 删除
                                    </el-button>
                                </div>
                            </el-card>
                        </el-col>

                    </el-row>
                </div>
            </template>
        </PaginationBox>
    </div>
</template>

<script setup>
import { Post, PostSingleUpdate } from '@/api/http';
import { ColumnType } from '@/components/Tables/columnTypes';
import { useCommonStore } from "@/store";

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

const where = ref({});

// 编辑表单数据
const formData = reactive({});

// 编辑对话框显示状态
const editorShow = ref(false);

// 表单引用
const editModalForm = ref(null);


// 表单验证规则
const editModalFormRules = reactive({
    "Name": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "BelongUserId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "IdCard": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Birth": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Phone": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
        {
            validator: (rule, value, callback) => {
                var reg = /^1[34578]\d{9}$/;
                if (!value || !reg.test(value)) {
                    callback(new Error('请输入正确的手机号'));
                }
                else {
                    callback();
                }
            }, trigger: 'blur'
        },
    ],
    "Sex": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
});


// 表格引用
const GuestInfoPaginationBox = ref(null);

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/GuestInfo/Get`, { Id: Id });
    Data.BelongUserId = UserId.value;
    Object.assign(formData, Data);

    editorShow.value = true;

};

// 创建或编辑表单
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    await editModalForm.value.validate(async valid => {
        if (valid) {
            const { Success } = await Post(`/GuestInfo/CreateOrEdit`, formData);

            if (Success) {
                editorShow.value = false;
                GuestInfoPaginationBox.value.Reload(searchForm);
                ElMessage.success('操作成功');
            }
        }
    });
};

// 搜索点击
const SearchClick = () => {
    GuestInfoPaginationBox.value.Reload(searchForm);
};

// 重置搜索条件
const ResetClick = () => {
    Object.keys(searchForm).forEach(key => {
        searchForm[key] = undefined;
    });
    GuestInfoPaginationBox.value.Reload(searchForm);
};

// 显示删除确认框
const ShowDeleteModal = async (Id) => {

    try {
        await ElMessageBox.confirm('确认删除该测试信息吗？', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        })
        const { Success } = await Post(`/GuestInfo/Delete`, { Id: Id });
        if (Success) {
            GuestInfoPaginationBox.value.Reload(searchForm);
            ElMessage.success('删除成功');
        }
    }
    catch (error) {
        ElMessage.warning('用户放弃了操作');
    }
};

// 批量删除
const BatchDelete = async () => {
    const ids = GuestInfoPaginationBox.value.GetSelectionRow().map(x => x.Id);
    if (ids.length > 0) {
        try {
            await ElMessageBox.confirm('确认删除所选的行数据吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            })


            const { Success } = await Post(`/GuestInfo/BatchDelete`, { Ids: ids });
            if (Success) {
                GuestInfoPaginationBox.value.Reload(searchForm);
                ElMessage.success('删除成功');
            }
        }
        catch (error) {
            ElMessage.warning('用户放弃了操作');
        }
    }
    else {
        ElMessage.warning('用户放弃了操作');
    }
};

// 格式化身份证号码，保留前4位和后4位，中间用*代替
const formatIdCard = (idCard) => {
    if (!idCard) return '';
    if (idCard.length < 8) return idCard;
    return idCard.substring(0, 4) + '**********' + idCard.substring(idCard.length - 4);
};

// 格式化日期，只显示年月日
const formatDate = (date) => {
    if (!date) return '';
    return date.split(' ')[0];
};

onBeforeMount(() => {
    where.value.BelongUserId = UserId.value;
});
</script>

<style scoped>
/* 旅客信息容器 */
.guest-info-container {
    width: 100%;
    margin-top: 20px;
}

/* 旅客卡片样式 */
.guest-card {
    height: 100%;
    margin-bottom: 20px;
    border-radius: 12px;
    overflow: hidden;
    transition: all 0.3s ease;
    border: 1px solid #ebeef5;
}

.guest-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
    border-color: var(--el-color-primary-light-5);
}

/* 旅客信息头部 */
.guest-header {
    display: flex;
    align-items: center;
    padding: 15px;
    border-bottom: 1px solid #f0f0f0;
    background: linear-gradient(to right, var(--el-color-primary-light-8), var(--el-color-primary-light-9));
}

.avatar-container {
    margin-right: 15px;
}

.male-avatar {
    background-color: var(--el-color-primary);
    color: #fff;
}

.female-avatar {
    background-color: var(--el-color-danger);
    color: #fff;
}

.guest-title {
    flex: 1;
}

.guest-title h3 {
    margin: 0 0 5px 0;
    font-size: 18px;
    font-weight: 600;
    color: #333;
}

.gender-tag {
    margin-top: 5px;
}

/* 旅客信息内容 */
.guest-info {
    padding: 15px;
}

.info-item {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
    color: #606266;
}

.info-item .el-icon {
    margin-right: 10px;
    font-size: 16px;
    color: var(--el-color-primary);
}

/* 操作按钮区域 */
.guest-actions {
    display: flex;
    justify-content: flex-end;
    padding: 10px 15px;
    border-top: 1px solid #f0f0f0;
    background-color: #f9f9f9;
}

.guest-actions .el-button {
    margin-left: 10px;
}

/* 响应式调整 */
@media screen and (max-width: 768px) {
    .guest-header {
        flex-direction: column;
        text-align: center;
    }

    .avatar-container {
        margin-right: 0;
        margin-bottom: 10px;
    }
}
</style>