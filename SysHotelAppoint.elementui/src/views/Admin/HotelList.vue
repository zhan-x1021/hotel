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

                    <el-form-item label="关键词" prop="KeyWord">
                        <el-input v-model.trim="searchForm.KeyWord" placeholder="请输入关键词" :clearable="true"></el-input>
                    </el-form-item>


                    <el-form-item label="酒店负责人">
                        <SigleSelect url="/User/List" columnName="Name" :clearable="true" columnValue="Id"
                            v-model="searchForm.HotelUserId">
                        </SigleSelect>
                    </el-form-item>
                    <el-form-item label="是否可带宠物" class="search-input">
                        <el-select v-model="searchForm.IsPet" :clearable="true" placeholder="请选择是否可带宠物">
                            <el-option key="true" label="是" value="true">
                            </el-option>
                            <el-option key="false" label="否" value="false">
                            </el-option>
                        </el-select>
                    </el-form-item>

                </el-form>
            </div>
        </el-card>
        <!-- 编辑对话框 -->
        <el-dialog :title="'进行审核'" v-model="editorShow" width="50%" :lock-scroll="true" min-height="500px">
            <el-form v-if="editorShow" ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px"
                size="default">
                <el-row :gutter="10" class="edit-from-body">
                    <el-col :span="24">
                        <el-form-item label="审核状态" prop="IsAudit">
                            <el-select v-model="formData.IsAudit" :clearable="true" placeholder="请选择审核状态">
                                <el-option label="通过" value="true"></el-option>
                                <el-option label="不通过" value="false"></el-option>
                            </el-select>
                        </el-form-item>
                    </el-col>



                    <el-col :span="24">
                        <el-form-item label="审核结果" prop="AuditResult">
                            <el-input type="textarea" :rows="10" v-model.trim="formData.AuditResult" placeholder="请输入酒店通知"
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
        <PaginationTable ref="PaginationTableId" url="/Hotel/List" :column="columnList">
            <template v-slot:header>
                <!-- <el-button type="primary" size="default" @click="ShowEditModal()">
                    <el-icon>
                        <Edit />
                    </el-icon>新 增
                </el-button> -->
                <el-button type="danger" size="default" @click="BatchDelete">
                    <el-icon>
                        <Delete />
                    </el-icon>批量删除
                </el-button>
            </template>
            <template v-slot:Operate="scope">
                <el-button type="primary" size="default" class="margin-top-xs" @click="ShowEditModal(scope.row.Id)"
                    v-if="scope.row.IsAudit != true">
                    <el-icon>
                        <Edit />
                    </el-icon>进行审核
                </el-button>
                <el-button type="danger" size="default" class="margin-top-xs" @click="ShowDeleteModal(scope.row.Id)">
                    <el-icon>
                        <Delete />
                    </el-icon>删 除
                </el-button>
            </template>
        </PaginationTable>

        <LogLatSelectToast ref="ProviceCityAreaLogLatSelectToastRef"></LogLatSelectToast>
        <LogLatSelectToast ref="AddressLogLatSelectToastRef"></LogLatSelectToast>


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
        key: "IsAudit",
        hidden: true,

    },

    {
        key: "Name",
        title: "名称",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },

    {
        key: "Cover",
        title: "酒店封面",
        type: ColumnType.IMAGES,
    },
    {
        key: "HotelUserDto.UserName",
        title: "负责人账号",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "HotelImages",
        title: "酒店图片",
        width: "260px",

        type: ColumnType.IMAGES,
    }, {
        key: "Services",
        title: "服务设施",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "Notice",
        title: "酒店通知",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "CheckInTip",
        title: "入住提示",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "AuditFormat",
        title: "是否审核",
        width: "160px",
        type: ColumnType.VHTML,
        template: function (row, index) {
            console.log(row)
            if (row.IsAudit == null) {
                return "<span style='color: #ff0000;'>待审核</span>";
            }
            else if (row.IsAudit == true) {
                return "<span style='color: #00ff00;'>审核通过</span>";
            }
            else {
                return "<span style='color: #ff0000;'>审核不通过</span>";
            }
        }
    },
    {
        key: "MustRead",
        title: "必读",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "IsPet",
        title: "是否可带宠物",
        width: "140px",
        type: ColumnType.JUDGMENTTAG,
    },
    {
        key: "Longitude",
        hidden: true,
    },


    {
        key: "ProviceCityArea",
        title: "省市区",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },

    {
        key: "AuditResult",
        title: "审核结果",
        width: "160px",
        ype: ColumnType.SHORTTEXT,
    },
    {
        key: "Content",
        title: "酒店介绍",
        width: "140px",
        type: ColumnType.RICHTEXT,
    },

    {
        key: "Address",
        title: "酒店详细地址",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "Latitude",
        hidden: true,
    },
    {
        key: "HotelUserId",
        hidden: true,
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

    "IsAudit": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "AuditResult": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
});

// 地址选择弹窗引用
const ProviceCityAreaLogLatSelectToastRef = ref(null);

// 打开地址选择弹窗
const ProviceCityAreaOpenLogLatSelectToast = () => {
    ProviceCityAreaLogLatSelectToastRef.value.OpenToast(formData.Latitude, formData.Longitude, formData.ProviceCityArea, (data) => {
        formData.ProviceCityAreaLatitude = data.lat;
        formData.ProviceCityAreaLongitude = data.lng;
        formData.ProviceCityArea = data.fullAddress;
        formData.ProviceCityAreaProviceCityArea = data.province + " " + data.city + " " + data.district;
    });
};
// 地址选择弹窗引用
const AddressLogLatSelectToastRef = ref(null);

// 打开地址选择弹窗
const AddressOpenLogLatSelectToast = () => {
    AddressLogLatSelectToastRef.value.OpenToast(formData.Latitude, formData.Longitude, formData.Address, (data) => {
        formData.AddressLatitude = data.lat;
        formData.AddressLongitude = data.lng;
        formData.Address = data.fullAddress;
        formData.AddressProviceCityArea = data.province + " " + data.city + " " + data.district;
    });
};

// 表格引用
const PaginationTableId = ref(null);

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/Hotel/Get`, { Id: Id });

    Object.assign(formData, Data);

    editorShow.value = true;

};

// 创建或编辑表单
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    await editModalForm.value.validate(async valid => {
        if (valid) {
            const { Success } = await Post(`/Hotel/CreateOrEdit`, formData);

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
        const { Success } = await Post(`/Hotel/Delete`, { Id: Id });
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


            const { Success } = await Post(`/Hotel/BatchDelete`, { Ids: ids });
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