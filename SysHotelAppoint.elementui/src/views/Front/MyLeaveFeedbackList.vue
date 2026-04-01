<template>
    <div>
        <!-- 搜索表单卡片 -->
        <el-card class="box-card">
            <div slot="header" class="clearfix">
                <el-row>
                    <el-button type="primary" size="default" @click="SearchClick">
                        <span>🔍 查询</span>
                    </el-button>
                    <el-button type="warning" size="default" @click="ResetClick">
                        <span>🔄 清空条件</span>
                    </el-button>
                </el-row>
            </div>
            <div class="margin-top-sm">
                <el-form :inline="true" :model="searchForm" size="default">
                    <el-form-item label="反馈标题" prop="Title">
                        <el-input v-model.trim="searchForm.Title" placeholder="请输入反馈标题" :clearable="true"></el-input>
                    </el-form-item>

                    <el-form-item label="是否处理" class="search-input">
                        <el-select v-model="searchForm.IsDoWith" :clearable="true" placeholder="请选择是否处理">
                            <el-option key="true" label="是" value="true"></el-option>
                            <el-option key="false" label="否" value="false"></el-option>
                        </el-select>
                    </el-form-item>
                </el-form>
            </div>
        </el-card>

        <PaginationBox ref="LeaveFeedbackPaginationBox" :where="where" url="/LeaveFeedback/List" :limit="8">
            <template v-slot:content="{ data }">
                <div class="feedback-container">
                    <div v-for="(item, index) in data" :key="index" class="feedback-card"
                        :class="{ 'feedback-processed': item.IsDoWith }">
                        <div class="feedback-header">
                            <div class="feedback-title">
                                <span class="icon">📝</span>
                                <h3>{{ item.Title }}</h3>
                                <el-tag :type="item.IsDoWith ? 'success' : 'warning'" size="small" class="status-tag">
                                    {{ item.IsDoWith ? '已处理 ✓' : '未处理 ⏳' }}
                                </el-tag>
                            </div>
                            <div class="feedback-time">
                                <span class="icon">🕒</span>
                                <span>{{ item.CreationTime }}</span>
                            </div>
                        </div>

                        <div class="feedback-user-info">
                            <span class="icon">👤</span>
                            <span class="label">反馈用户：</span>
                            <span class="value">{{ item.FeedbackUserDto.Name }}</span>

                            <span v-if="item.DoWithUserDto && item.DoWithUserDto.Name" class="processor-info">
                                <span class="icon">🛠️</span>
                                <span class="label">处理人员：</span>
                                <span class="value">{{ item.DoWithUserDto.Name }}</span>
                            </span>
                        </div>

                        <div class="feedback-content">
                            <div class="content-title">📋 反馈内容</div>
                            <div class="rich-content-wrapper">
                                <div class="rich-content" v-html="item.Content"></div>
                            </div>
                        </div>

                        <div v-if="item.ReplayContent" class="feedback-reply">
                            <div class="reply-title">💬 回复内容</div>
                            <div class="rich-content-wrapper">
                                <div class="rich-content" v-html="item.ReplayContent"></div>
                            </div>
                        </div>

                        <div class="feedback-actions">

                            <el-button type="danger" size="small" v-if="item.IsDoWith == null"
                                @click="ShowDeleteModal(item.Id)">
                                <span>🗑️ 删除</span>
                            </el-button>
                        </div>
                    </div>
                </div>
            </template>
        </PaginationBox>
    </div>
</template>

<script setup>
import { Post, PostSingleUpdate } from '@/api/http';
import { ColumnType } from '@/components/Tables/columnTypes';
import { useCommonStore } from "@/store";

import { Delete, Edit, Refresh, Search } from '@element-plus/icons-vue';
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
    "Title": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "FeedbackUserId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "HotelId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "DoWithUserId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "IsDoWith": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "ReplayContent": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Content": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
});


// 表格引用
const LeaveFeedbackPaginationBox = ref(null);

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/LeaveFeedback/Get`, { Id: Id });

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
                LeaveFeedbackPaginationBox.value.Reload(searchForm);
                ElMessage.success('操作成功');
            }
        }
    });
};

// 搜索点击
const SearchClick = () => {
    LeaveFeedbackPaginationBox.value.Reload(searchForm);
};

// 重置搜索条件
const ResetClick = () => {
    Object.keys(searchForm).forEach(key => {
        searchForm[key] = undefined;
    });
    LeaveFeedbackPaginationBox.value.Reload(searchForm);
};

// 显示删除确认框
const ShowDeleteModal = async (Id) => {

    try {
        await ElMessageBox.confirm('确认删除该测试信息吗？', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        })
        const { Success } = await Post(`/LeaveFeedback/Delete`, { Id: Id });
        if (Success) {
            LeaveFeedbackPaginationBox.value.Reload(searchForm);
            ElMessage.success('删除成功');
        }
    }
    catch (error) {
        ElMessage.warning('用户放弃了操作');
    }
};

// 批量删除
const BatchDelete = async () => {
    const ids = LeaveFeedbackPaginationBox.value.GetSelectionRow().map(x => x.Id);
    if (ids.length > 0) {
        try {
            await ElMessageBox.confirm('确认删除所选的行数据吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            })


            const { Success } = await Post(`/LeaveFeedback/BatchDelete`, { Ids: ids });
            if (Success) {
                LeaveFeedbackPaginationBox.value.Reload(searchForm);
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
onBeforeMount(() => {
    where.value.FeedbackUserId = UserId.value;
});
</script>

<style scoped>
/* 反馈列表容器 - 单行显示 */
.feedback-container {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 20px;

}

/* 反馈卡片样式 */
.feedback-card {
    background: #ffffff;
    border-radius: 10px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
    padding: 20px;
    transition: all 0.3s ease;
    border-left: 5px solid #e6a23c;
    position: relative;
    overflow: hidden;
    width: 100%;
}

/* 已处理的反馈卡片 */
.feedback-processed {
    border-left: 5px solid #67c23a;
}

/* 反馈卡片悬停效果 */
.feedback-card:hover {
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
    transform: translateY(-2px);
}

/* 反馈卡片头部 */
.feedback-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    padding-bottom: 12px;
    border-bottom: 1px solid #f0f0f0;
}

/* 反馈标题 */
.feedback-title {
    display: flex;
    align-items: center;
    gap: 8px;
}

.feedback-title h3 {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
    color: #303133;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* 状态标签 */
.status-tag {
    margin-left: 8px;
}

/* 反馈时间 */
.feedback-time {
    display: flex;
    align-items: center;
    color: #909399;
    font-size: 13px;
    gap: 4px;
}

/* 用户信息区域 */
.feedback-user-info {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 20px;
    margin-bottom: 16px;
    padding-bottom: 12px;
    border-bottom: 1px solid #f0f0f0;
}

.processor-info {
    display: flex;
    align-items: center;
}

/* 图标样式 */
.icon {
    font-size: 16px;
    margin-right: 2px;
}

/* 标签样式 */
.label {
    font-weight: 600;
    color: #606266;
    margin-right: 4px;
}

/* 值样式 */
.value {
    color: #409eff;
}

/* 反馈内容 */
.feedback-content,
.feedback-reply {
    margin-bottom: 20px;
}

.content-title,
.reply-title {
    font-weight: 600;
    color: #606266;
    margin-bottom: 10px;
    font-size: 15px;
    display: flex;
    align-items: center;
    gap: 6px;
}

/* 富文本内容容器 */
.rich-content-wrapper {
    background: #f9f9f9;
    border-radius: 8px;
    padding: 15px;
    position: relative;
}

/* 富文本内容 */
.rich-content {
    max-height: 300px;
    overflow-y: auto;
    color: #606266;
    line-height: 1.6;
    font-size: 14px;
}

/* 富文本样式覆盖 */
.rich-content :deep(p) {
    margin-bottom: 10px;
}

.rich-content :deep(img) {
    max-width: 100%;
    height: auto;
}

/* 回复区域 */
.feedback-reply {
    margin-top: 25px;
    padding-top: 15px;
    border-top: 1px dashed #e8e8e8;
}

/* 操作按钮区域 */
.feedback-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 20px;
}

/* 科技感背景效果 */
.feedback-card::after {
    content: '';
    position: absolute;
    top: -30px;
    right: -30px;
    width: 120px;
    height: 120px;
    background: radial-gradient(circle, rgba(100, 100, 255, 0.05) 0%, rgba(0, 0, 0, 0) 70%);
    border-radius: 50%;
    pointer-events: none;
    z-index: -1;
}
</style>