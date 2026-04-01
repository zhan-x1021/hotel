<template>
    <div>
        <!-- 搜索表单卡片 -->
        <el-card class="box-card">
            <div slot="header" class="clearfix">
                <el-row>
                    <el-button type="primary" size="default" @click="SearchClick">
                        <el-icon>
                            <Search />
                        </el-icon>查询
                    </el-button>
                    <el-button type="warning" size="default" @click="ResetClick">
                        <el-icon>
                            <Refresh />
                        </el-icon>清空条件
                    </el-button>
                </el-row>
            </div>
            <div class="margin-top-sm">
                <el-form :inline="true" :model="searchForm" size="default">
                    <el-form-item label="标题" prop="Title">
                        <el-input v-model.trim="searchForm.Title" placeholder="请输入标题" :clearable="true"></el-input>
                    </el-form-item>

                    <el-form-item label="关联单号" prop="RelativeNo">
                        <el-input v-model.trim="searchForm.RelativeNo" placeholder="请输入关联单号" :clearable="true"></el-input>
                    </el-form-item>

                    <el-form-item label="用户">
                        <SigleSelect url="/User/List" columnName="Name" :clearable="true" columnValue="Id"
                            v-model="searchForm.UserId">
                        </SigleSelect>
                    </el-form-item>
                </el-form>
            </div>
        </el-card>
        <!-- 编辑对话框 -->
        <el-dialog :title="'积分调整'" v-model="editorShow" width="50%" :lock-scroll="true" min-height="500px">
            <el-form v-if="editorShow" ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px"
                size="default">
                <el-row :gutter="10" class="edit-from-body">

                    <el-col :span="24">
                        <el-form-item label="标题" prop="Title">
                            <el-input type="text" v-model="formData.Title" placeholder="请输入标题" :clearable="true"></el-input>
                        </el-form-item>
                    </el-col>



                    <el-col :span="24">
                        <el-form-item label="用户" prop="UserId">
                            <SigleSelect url="/User/List" columnName="Name" columnValue="Id" v-model="formData.UserId">
                            </SigleSelect>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="积分值" prop="IntegralValue">
                            <el-input-number v-model="formData.IntegralValue" placeholder="请输入积分值"
                                :clearable="true"></el-input-number>
                        </el-form-item>
                    </el-col>



                    <el-col :span="24">
                        <el-form-item label="关联单号">
                            <el-input type="text" v-model="formData.RelativeNo" placeholder="请输入关联单号"
                                :clearable="true"></el-input>
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




        <!-- 数据表格 -->
        <PaginationTable ref="PaginationTableId" url="/HotelIntegral/List" :where="{ HotelId: HotelDto.Id }"
            :column="columnList">
            <template v-slot:header>
                <el-button type="primary" size="default" @click="ShowEditModal()">
                    <el-icon>
                        <Edit />
                    </el-icon>新 增
                </el-button>
                <el-button type="danger" size="default" @click="BatchDelete">
                    <el-icon>
                        <Delete />
                    </el-icon>批量删除
                </el-button>
            </template>
            <template v-slot:Operate="scope">

                <el-button type="danger" size="default" class="margin-top-xs" @click="ShowDeleteModal(scope.row.Id)">
                    <el-icon>
                        <Delete />
                    </el-icon>删 除
                </el-button>
            </template>
        </PaginationTable>



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
const HotelDto = computed(() => commonStore.HotelDto)

// 搜索表单数据
const searchForm = reactive({});

// 编辑表单数据
const formData = reactive({});

// 编辑对话框显示状态
const editorShow = ref(false);

// 表单引用
const editModalForm = ref(null);

// 表格列配置
const columnList = ref([
    {
        key: "Id",
        hidden: true,

    },
    {
        key: "Title",
        title: "标题",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "Type",
        title: "类型",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "HotelId",
        hidden: true,
    },
    {
        key: "HotelDto.Name",
        title: "酒店",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "UserId",
        hidden: true,
    },
    {
        key: "UserDto.UserName",
        title: "账号",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "IntegralValue",
        title: "积分值",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "RelativeNo",
        title: "关联单号",
        width: "260px",

        type: ColumnType.SHORTTEXT,
    },
    {
        title: "操作",
        width: "300px",
        key: "Operate",
        type: ColumnType.USERDEFINED,
    },
]);

// 表单验证规则
const editModalFormRules = reactive({
    "Title": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "HotelId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "UserId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "IntegralValue": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Type": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "RelativeNo": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
});


// 表格引用
const PaginationTableId = ref(null);

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/HotelIntegral/Get`, { Id: Id });

    Data.HotelId = HotelDto.value.Id;
    Data.Type = "积分调整";
    Object.assign(formData, Data);

    editorShow.value = true;

};

// 创建或编辑表单
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    await editModalForm.value.validate(async valid => {
        if (valid) {
            const { Success } = await Post(`/HotelIntegral/CreateOrEdit`, formData);

            if (Success) {
                editorShow.value = false;
                PaginationTableId.value.Reload(searchForm);
                ElMessage.success('操作成功');
            }
        }
    });
};

// 搜索点击
const SearchClick = () => {
    PaginationTableId.value.Reload(searchForm);
};

// 重置搜索条件
const ResetClick = () => {
    Object.keys(searchForm).forEach(key => {
        searchForm[key] = undefined;
    });
    PaginationTableId.value.Reload(searchForm);
};

// 显示删除确认框
const ShowDeleteModal = async (Id) => {

    try {
        await ElMessageBox.confirm('确认删除该测试信息吗？', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        })
        const { Success } = await Post(`/HotelIntegral/Delete`, { Id: Id });
        if (Success) {
            PaginationTableId.value.Reload(searchForm);
            ElMessage.success('删除成功');
        }
    }
    catch (error) {
        ElMessage.warning('用户放弃了操作');
    }
};

// 批量删除
const BatchDelete = async () => {
    const ids = PaginationTableId.value.GetSelectionRow().map(x => x.Id);
    if (ids.length > 0) {
        try {
            await ElMessageBox.confirm('确认删除所选的行数据吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            })


            const { Success } = await Post(`/HotelIntegral/BatchDelete`, { Ids: ids });
            if (Success) {
                PaginationTableId.value.Reload(searchForm);
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

});
</script>

<style scoped></style>