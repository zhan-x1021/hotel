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
                    <el-form-item label="起始有效时间" class="search-input">
                        <el-date-picker v-model="searchForm.BeginActiveTimeRange" type="datetimerange" start-placeholder="开始起始有效时间"
                            end-placeholder="结束起始有效时间" :default-time="['00:00:00']" value-format="yyyy-MM-dd HH:mm:ss" >
                        </el-date-picker>                                       
                    </el-form-item>                
                    <el-form-item label="截至有效时间" class="search-input">
                        <el-date-picker v-model="searchForm.EndActiveTimeRange" type="datetimerange" start-placeholder="开始截至有效时间"
                            end-placeholder="结束截至有效时间" :default-time="['00:00:00']" value-format="yyyy-MM-dd HH:mm:ss" >
                        </el-date-picker>                                       
                    </el-form-item>                
                </el-form>
            </div>
        </el-card>
<!-- 编辑对话框 -->
        <el-dialog :title="formData.Id ? '修改优惠设置' : '添加优惠设置'" v-model="editorShow" width="50%" :lock-scroll="true"
            min-height="500px">
            <el-form v-if="editorShow" ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px"
                size="default">             
              <el-row :gutter="10" class="edit-from-body">

                    <el-col :span="24">
                        <el-form-item label="酒店" prop="HotelId">
                            <el-input-number  v-model="formData.HotelId"  placeholder="请输入酒店"     :clearable="true"  :min="1" :max="1000000"></el-input-number>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="房间" prop="RoomId">
                            <el-input-number  v-model="formData.RoomId"  placeholder="请输入房间"     :clearable="true"  :min="1" :max="1000000"></el-input-number>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="折扣价" prop="Discount">
                            <el-input-number  v-model="formData.Discount"  placeholder="请输入折扣价"     :clearable="true"  :min="1" :max="1000000"></el-input-number>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="起始有效时间" prop="BeginActiveTime">
                            <el-date-picker v-model="formData.BeginActiveTime" align="right" type="datetime" placeholder="选择时间" value-format="YYYY-MM-DD HH:mm:ss">
                            </el-date-picker>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="截至有效时间" prop="EndActiveTime">
                            <el-date-picker v-model="formData.EndActiveTime" align="right" type="datetime" placeholder="选择时间" value-format="YYYY-MM-DD HH:mm:ss">
                            </el-date-picker>
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
        <PaginationTable ref="PaginationTableId" url="/FavourableSetting/List" :column="columnList">
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
import { Post,PostSingleUpdate } from '@/api/http';
import { ColumnType } from '@/components/Tables/columnTypes';
import { useCommonStore } from "@/store";

import { Delete, Edit, Refresh, Search } from '@element-plus/icons-vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import {onMounted,onBeforeMount,nextTick, watch,computed, reactive, ref } from 'vue';
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
    key: "HotelId",
    title: "酒店",
    
    type: ColumnType.SHORTTEXT, 
  },
  {
    key: "BeginActiveTime",
    title: "起始有效时间",
    width: "140px",
    type:ColumnType.DATE,
  },
  {
    key: "RoomId",
    title: "房间",
    
    type: ColumnType.SHORTTEXT, 
  },
  {
    key: "EndActiveTime",
    title: "截至有效时间",
    width: "140px",
    type:ColumnType.DATE,
  },
  {
    key: "Discount",
    title: "折扣价",
    
    type: ColumnType.SHORTTEXT, 
  },
  {
    title: "操作",
    width:"300px",
    key: "Operate",
    type: ColumnType.USERDEFINED,
  },
            ]);

// 表单验证规则
const editModalFormRules = reactive({
"HotelId":[
{ required: true, message: '该项为必填项', trigger: 'blur' },
              ],           
"RoomId":[
{ required: true, message: '该项为必填项', trigger: 'blur' },
              ],           
"Discount":[
{ required: true, message: '该项为必填项', trigger: 'blur' },
              ],           
"BeginActiveTime":[
{ required: true, message: '该项为必填项', trigger: 'blur' },
              ],           
"EndActiveTime":[
{ required: true, message: '该项为必填项', trigger: 'blur' },
              ],           
 });


// 表格引用
const PaginationTableId = ref(null);

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/FavourableSetting/Get`, { Id: Id });
    
    Object.assign(formData, Data);

    editorShow.value = true;

};

// 创建或编辑表单
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    await editModalForm.value.validate(async valid => {
        if (valid) {
            const { Success } = await Post(`/FavourableSetting/CreateOrEdit`, formData);

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
        const { Success } = await Post(`/FavourableSetting/Delete`, { Id: Id });
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


            const { Success } = await Post(`/FavourableSetting/BatchDelete`, { Ids: ids });
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

<style scoped>

</style>