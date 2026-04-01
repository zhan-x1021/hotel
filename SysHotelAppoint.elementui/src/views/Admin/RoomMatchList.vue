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
                    <el-form-item label="房间">
                        <SigleSelect url="/Room/List" columnName="Title" :clearable="true" columnValue="Id"
                            v-model="searchForm.RoomId">
                        </SigleSelect>
                    </el-form-item>
                    <el-form-item label="关联房号">
                        <SigleSelect url="/RoomDet/List" columnName="No" :clearable="true" columnValue="Id"
                            v-model="searchForm.RoomDetId">
                        </SigleSelect>
                    </el-form-item>
                    <el-form-item label="房间状态">
                        <SigleSelect url="/Select/RoomStatusEnum" columnName="Name" :clearable="true" columnValue="Code"
                            v-model="searchForm.RoomStatus">
                        </SigleSelect>
                    </el-form-item>
                    <el-form-item label="酒店">
                        <SigleSelect url="/Hotel/List" columnName="Name" :clearable="true" columnValue="Id"
                            v-model="searchForm.HotelId">
                        </SigleSelect>
                    </el-form-item>
                    <el-form-item label="订单">
                        <SigleSelect url="/Appoint/List" columnName="No" :clearable="true" columnValue="Id"
                            v-model="searchForm.AppointId">
                        </SigleSelect>
                    </el-form-item>
                </el-form>
            </div>
        </el-card>
        <!-- 编辑对话框 -->
        <el-dialog :title="formData.Id ? '修改分配房间' : '添加分配房间'" v-model="editorShow" width="50%" :lock-scroll="true"
            min-height="500px">
            <el-form v-if="editorShow" ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px"
                size="default">
                <el-row :gutter="10" class="edit-from-body">

                    <el-col :span="24">
                        <el-form-item label="房间" prop="RoomId">
                            <SigleSelect url="/Room/List" columnName="Title" columnValue="Id" v-model="formData.RoomId">
                            </SigleSelect>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="关联房号" prop="RoomDetId">
                            <SigleSelect url="/RoomDet/List" columnName="No" columnValue="Id" v-model="formData.RoomDetId">
                            </SigleSelect>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="酒店" prop="HotelId">
                            <SigleSelect url="/Hotel/List" columnName="Name" columnValue="Id" v-model="formData.HotelId">
                            </SigleSelect>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="订单" prop="AppointId">
                            <SigleSelect url="/Appoint/List" columnName="No" columnValue="Id" v-model="formData.AppointId">
                            </SigleSelect>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="房间状态" prop="RoomStatus">
                            <SigleSelect url="/Select/RoomStatusEnum" columnName="Name" columnValue="Code"
                                v-model="formData.RoomStatus">
                            </SigleSelect>
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
        <PaginationTable ref="PaginationTableId" url="/RoomMatch/List" :column="columnList">
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
                <el-button type="primary" size="default" class="margin-top-xs" @click="ShowEditModal(scope.row.Id)">
                    <el-icon>
                        <Edit />
                    </el-icon>修 改
                </el-button>
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
        key: "RoomId",
        hidden: true,
    },
    {
        key: "RoomDto.Title",
        title: "标题",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "RoomDetId",
        hidden: true,
    },
    {
        key: "RoomDetDto.No",
        title: "房号",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "RoomStatus",
        hidden: true,
    }, {
        key: "RoomStatusFormat",
        title: "房间状态",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "HotelId",
        hidden: true,
    },
    {
        key: "HotelDto.Name",
        title: "名称",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "AppointId",
        hidden: true,
    },
    {
        key: "AppointDto.No",
        title: "编号",
        width: "160px",

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
    "RoomId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "RoomDetId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "HotelId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "AppointId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "RoomStatus": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
});


// 表格引用
const PaginationTableId = ref(null);

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/RoomMatch/Get`, { Id: Id });

    Object.assign(formData, Data);

    editorShow.value = true;

};

// 创建或编辑表单
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    await editModalForm.value.validate(async valid => {
        if (valid) {
            const { Success } = await Post(`/RoomMatch/CreateOrEdit`, formData);

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
        const { Success } = await Post(`/RoomMatch/Delete`, { Id: Id });
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


            const { Success } = await Post(`/RoomMatch/BatchDelete`, { Ids: ids });
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