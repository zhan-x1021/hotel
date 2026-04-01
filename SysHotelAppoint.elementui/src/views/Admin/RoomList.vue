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
                    <el-form-item label="特色房型">
                        <SigleSelect url="/Select/FeaturedRoomShapeEnum" columnName="Name" :clearable="true"
                            columnValue="Code" v-model="searchForm.FeaturedRoomShape">
                        </SigleSelect>
                    </el-form-item>
                    <el-form-item label="房型">
                        <SigleSelect url="/Select/RoomShapeEnum" columnName="Name" :clearable="true" columnValue="Code"
                            v-model="searchForm.RoomShape">
                        </SigleSelect>
                    </el-form-item>
                    <el-form-item label="早餐类型">
                        <SigleSelect url="/Select/BreakfastTypeEnum" columnName="Name" :clearable="true" columnValue="Code"
                            v-model="searchForm.BreakfastType">
                        </SigleSelect>
                    </el-form-item>
                    <el-form-item label="是否免费取消" class="search-input">
                        <el-select v-model="searchForm.IsFreeCancel" :clearable="true" placeholder="请选择是否免费取消">
                            <el-option key="true" label="是" value="true">
                            </el-option>
                            <el-option key="false" label="否" value="false">
                            </el-option>
                        </el-select>
                    </el-form-item>

                    <el-form-item label="是否立即确定" class="search-input">
                        <el-select v-model="searchForm.IsImmediatelyConfirm" :clearable="true" placeholder="请选择是否立即确定">
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
        <el-dialog :title="formData.Id ? '修改房间' : '添加房间'" v-model="editorShow" width="50%" :lock-scroll="true"
            min-height="500px">
            <el-form v-if="editorShow" ref="editModalForm" :rules="editModalFormRules" :model="formData" label-width="140px"
                size="default">
                <el-row :gutter="10" class="edit-from-body">

                    <el-col :span="24">
                        <el-form-item label="标题" prop="Title">
                            <el-input type="text" v-model="formData.Title" placeholder="请输入标题" :clearable="true"></el-input>
                        </el-form-item>
                    </el-col>


                    <el-col :span="24">
                        <el-form-item label="特色房型" prop="FeaturedRoomShape">
                            <SigleSelect url="/Select/FeaturedRoomShapeEnum" columnName="Name" columnValue="Code"
                                v-model="formData.FeaturedRoomShape">
                            </SigleSelect>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="房型" prop="RoomShape">
                            <SigleSelect url="/Select/RoomShapeEnum" columnName="Name" columnValue="Code"
                                v-model="formData.RoomShape">
                            </SigleSelect>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="早餐类型" prop="BreakfastType">
                            <SigleSelect url="/Select/BreakfastTypeEnum" columnName="Name" columnValue="Code"
                                v-model="formData.BreakfastType">
                            </SigleSelect>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="封面" prop="Cover">
                            <UploadImages :limit="1" v-model="formData.Cover"></UploadImages>
                        </el-form-item>
                    </el-col>
                    <el-col :span="24">
                        <el-form-item label="房间主图" prop="ImageUrls">
                            <UploadImages :limit="6" v-model="formData.ImageUrls"></UploadImages>
                        </el-form-item>
                    </el-col>

                    <el-col :span="12">
                        <el-form-item label="积分可抵金额" prop="IntegralExchangeMoney">
                            <el-input-number v-model="formData.IntegralExchangeMoney" placeholder="请输入积分可抵金额"
                                :clearable="true" :min="0" :max="1000000"></el-input-number>
                        </el-form-item>
                    </el-col>

                    <el-col :span="12">
                        <el-form-item label="可抵积分" prop="Integral">
                            <el-input-number v-model="formData.Integral" placeholder="请输入可抵积分" :clearable="true" :min="0"
                                :max="1000000"></el-input-number>
                        </el-form-item>
                    </el-col>



                    <el-col :span="12">
                        <el-form-item label="最小价格" prop="MinPrice">
                            <el-input-number v-model="formData.MinPrice" placeholder="请输入最小价格" :clearable="true" :min="0"
                                :max="1000000"></el-input-number>
                        </el-form-item>
                    </el-col>

                    <el-col :span="12">
                        <el-form-item label="最大价格" prop="MaxPrice">
                            <el-input-number v-model="formData.MaxPrice" placeholder="请输入最大价格" :clearable="true" :min="0"
                                :max="1000000"></el-input-number>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="房间大小" prop="AreaSize">
                            <el-input-number v-model="formData.AreaSize" placeholder="请输入房间大小" :clearable="true" :min="0"
                                :max="1000000"></el-input-number>
                        </el-form-item>
                    </el-col>

                    <el-col :span="12">
                        <el-form-item label="是否免费取消" prop="IsFreeCancel">
                            <el-switch v-model="formData.IsFreeCancel" :active-value="true" :inactive-value="false">
                            </el-switch>
                        </el-form-item>
                    </el-col>

                    <el-col :span="12">
                        <el-form-item label="是否立即确定" prop="IsImmediatelyConfirm">
                            <el-switch v-model="formData.IsImmediatelyConfirm" :active-value="true" :inactive-value="false">
                            </el-switch>
                        </el-form-item>
                    </el-col>

                    <!-- 价格设置-->
                    <el-col :span="24">
                        <el-form-item label="价格设置" prop="RoomPriceDtos">
                            <div class="price-setting-container">
                                <div v-for="(item, index) in formData.RoomPriceDtos" :key="index" class="price-item">
                                    <el-row :gutter="10">
                                        <el-col :span="7">
                                            <el-form-item label="价格" :prop="'RoomPriceDtos.' + index + '.Price'"
                                                label-width="60px">
                                                <el-input-number v-model="item.Price" placeholder="请输入价格" :min="0.01"
                                                    :max="1000000" :precision="2"
                                                    @change="validatePrice(index)"></el-input-number>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <el-form-item label="起始时间" :prop="'RoomPriceDtos.' + index + '.BeginActiveTime'"
                                                label-width="80px">
                                                <el-date-picker v-model="item.BeginActiveTime" type="datetime"
                                                    placeholder="选择起始有效时间" format="YYYY-MM-DD HH:mm:ss"
                                                    value-format="YYYY-MM-DD HH:mm:ss" @change="validateDateRange(index)">
                                                </el-date-picker>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <el-form-item label="截止时间" :prop="'RoomPriceDtos.' + index + '.EndActiveTime'"
                                                label-width="80px">
                                                <el-date-picker v-model="item.EndActiveTime" type="datetime"
                                                    placeholder="选择截至有效时间" format="YYYY-MM-DD HH:mm:ss"
                                                    value-format="YYYY-MM-DD HH:mm:ss" @change="validateDateRange(index)">
                                                </el-date-picker>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="1">
                                            <el-button type="danger" circle @click="removePrice(index)">
                                                <el-icon>
                                                    <Delete />
                                                </el-icon>
                                            </el-button>
                                        </el-col>
                                    </el-row>
                                </div>
                                <el-button type="primary" @click="addPrice">添加价格</el-button>
                            </div>
                        </el-form-item>
                    </el-col>

                    <!-- 优惠设置 -->
                    <el-col :span="24">
                        <el-form-item label="优惠设置" prop="FavourableSettingDtos">
                            <div class="price-setting-container">
                                <div v-for="(item, index) in formData.FavourableSettingDtos" :key="index"
                                    class="price-item">
                                    <el-row :gutter="10">
                                        <el-col :span="7">
                                            <el-form-item label="折扣价" :prop="'FavourableSettingDtos.' + index + '.Discount'"
                                                label-width="60px">
                                                <el-input-number v-model="item.Discount" placeholder="请输入折扣价" :min="0.01"
                                                    :max="1" :precision="2" :step="0.1"
                                                    @change="validateDiscount(index)"></el-input-number>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <el-form-item label="起始时间"
                                                :prop="'FavourableSettingDtos.' + index + '.BeginActiveTime'"
                                                label-width="80px">
                                                <el-date-picker v-model="item.BeginActiveTime" type="datetime"
                                                    placeholder="选择起始有效时间" format="YYYY-MM-DD HH:mm:ss"
                                                    value-format="YYYY-MM-DD HH:mm:ss"
                                                    @change="validateDiscountDateRange(index)">
                                                </el-date-picker>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <el-form-item label="截止时间"
                                                :prop="'FavourableSettingDtos.' + index + '.EndActiveTime'"
                                                label-width="80px">
                                                <el-date-picker v-model="item.EndActiveTime" type="datetime"
                                                    placeholder="选择截至有效时间" format="YYYY-MM-DD HH:mm:ss"
                                                    value-format="YYYY-MM-DD HH:mm:ss"
                                                    @change="validateDiscountDateRange(index)">
                                                </el-date-picker>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="1">
                                            <el-button type="danger" circle @click="removeDiscount(index)">
                                                <el-icon>
                                                    <Delete />
                                                </el-icon>
                                            </el-button>
                                        </el-col>
                                    </el-row>
                                </div>
                                <el-button type="primary" @click="addDiscount">添加优惠</el-button>
                            </div>
                        </el-form-item>
                    </el-col>

                    <el-col :span="24">
                        <el-form-item label="房间介绍" prop="Content">
                            <AIRichText v-model="formData.Content"></AIRichText>
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
        <PaginationTable ref="PaginationTableId" url="/Room/List" :column="columnList" :where="where">
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
                <el-button type="success" size="default" class="margin-top-xs" @click="ShowEquipmentInfoSetting(scope.row)">
                    <el-icon>
                        <Setting />
                    </el-icon>设备信息
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
const HotelDto = computed(() => commonStore.HotelDto)
const HotelId = computed(() => HotelDto.value.Id)

// 搜索表单数据
const searchForm = reactive({});

const where = ref({

})

// 编辑表单数据
const formData = reactive({
    RoomPriceDtos: [],
    FavourableSettingDtos: []
});

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
        hidden: true,
    },
    {
        key: "HotelDto.Name",
        title: "酒店",
        width: "260px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "Title",
        title: "标题",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },

    {
        key: "RoomNumber",
        title: "房数",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "IsFreeCancel",
        title: "是否免费取消",
        width: "140px",
        type: ColumnType.JUDGMENTTAG,
    },
    {
        key: "Cover",
        title: "封面",
        type: ColumnType.IMAGES,
    },
    {
        key: "ImageUrls",
        title: "房间主图",
        type: ColumnType.IMAGES,
        width: "360px",
    },
    {
        key: "EquipmentInfoIds",
        title: "设施信息",
        width: "160px",
        hidden: true,
    },
    {
        key: "FeaturedRoomShape",
        hidden: true,
    }, {
        key: "FeaturedRoomShapeFormat",
        title: "特色房型",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },


    {
        key: "IntegralExchangeMoney",
        title: "积分可抵金额",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "Content",
        title: "房间介绍",
        width: "140px",
        type: ColumnType.RICHTEXT,
    },
    {
        key: "Integral",
        title: "可抵积分",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },

    {
        key: "MinPrice",
        title: "最小价格",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },

    {
        key: "RoomShape",
        hidden: true,
    }, {
        key: "RoomShapeFormat",
        title: "房型",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "MaxPrice",
        title: "最大价格",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "IsImmediatelyConfirm",
        title: "是否立即确定",
        width: "140px",
        type: ColumnType.JUDGMENTTAG,
    },
    {
        key: "AreaSize",
        title: "房间大小",
        width: "160px",

        type: ColumnType.SHORTTEXT,
    },
    {
        key: "BreakfastType",
        hidden: true,
    }, {
        key: "BreakfastTypeFormat",
        title: "早餐类型",
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
    "Title": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "FeaturedRoomShape": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "RoomShape": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "BreakfastType": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Cover": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "HotelId": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "IntegralExchangeMoney": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Integral": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "ImageUrls": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "MinPrice": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "MaxPrice": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "AreaSize": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "EquipmentInfoIds": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "IsFreeCancel": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "IsImmediatelyConfirm": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "Content": [
        { required: true, message: '该项为必填项', trigger: 'blur' },
    ],
    "RoomPriceDtos": [
        {
            type: 'array',
            required: true,
            message: '请至少添加一个价格设置',
            trigger: 'blur',
            validator: (rule, value, callback) => {
                if (value && value.length > 0) {
                    callback();
                } else {
                    callback(new Error('请至少添加一个价格设置'));
                }
            }
        }
    ],
    "FavourableSettingDtos": [
        {
            type: 'array',
            required: false,
            message: '请添加优惠设置',
            trigger: 'blur'
        }
    ]
});

const ShowEquipmentInfoSetting = (row) => {
    router.push({
        path: "/Admin/RoomEquipmentInfoSetting",
        query: { EquipmentInfoIds: row.EquipmentInfoIds, RoomId: row.Id }
    });
}


// 表格引用
const PaginationTableId = ref(null);

ShowEquipmentInfoSetting

// 显示编辑对话框
const ShowEditModal = async (Id) => {

    const { Data } = await Post(`/Room/Get`, { Id: Id });
    if (!Data.HotelId) {
        Data.HotelId = HotelId.value;
    }
    if (!Data.RoomPriceDtos) {
        Data.RoomPriceDtos = [];
    }
    if (!Data.FavourableSettingDtos) {
        Data.FavourableSettingDtos = [];
    }
    Object.assign(formData, Data);

    editorShow.value = true;

};

// 创建或编辑表单
const CreateOrEditForm = async () => {
    if (!editModalForm.value) return;

    // 验证价格时间设置
    if (!validatePriceTimeSettings()) {
        return;
    }

    // 验证优惠时间设置
    if (!validateDiscountTimeSettings()) {
        return;
    }

    await editModalForm.value.validate(async valid => {
        if (valid) {
            const { Success } = await Post(`/Room/CreateOrEdit`, formData);

            if (Success) {
                editorShow.value = false;
                PaginationTableId.value.Reload(searchForm);
                ElMessage.success('操作成功');
            }
        }
    });
};

// 验证价格时间设置
const validatePriceTimeSettings = () => {
    const priceDtos = formData.RoomPriceDtos;

    // 检查每条记录的起始时间是否小于截至时间
    for (let i = 0; i < priceDtos.length; i++) {
        const item = priceDtos[i];
        if (!item.BeginActiveTime || !item.EndActiveTime) {
            ElMessage.error(`第${i + 1}条价格记录的起始时间和截至时间不能为空`);
            return false;
        }

        const beginTime = new Date(item.BeginActiveTime);
        const endTime = new Date(item.EndActiveTime);

        if (beginTime >= endTime) {
            ElMessage.error(`第${i + 1}条价格记录的起始时间不能大于或等于截至时间`);
            return false;
        }
    }

    // 检查多条记录之间是否存在时间交叉
    for (let i = 0; i < priceDtos.length; i++) {
        const itemI = priceDtos[i];
        const beginTimeI = new Date(itemI.BeginActiveTime);
        const endTimeI = new Date(itemI.EndActiveTime);

        for (let j = i + 1; j < priceDtos.length; j++) {
            const itemJ = priceDtos[j];
            const beginTimeJ = new Date(itemJ.BeginActiveTime);
            const endTimeJ = new Date(itemJ.EndActiveTime);

            // 检查时间段是否交叉
            if ((beginTimeI <= endTimeJ && endTimeI >= beginTimeJ) ||
                (beginTimeJ <= endTimeI && endTimeJ >= beginTimeI)) {
                ElMessage.error(`第${i + 1}条和第${j + 1}条价格记录的时间段存在交叉，请调整`);
                return false;
            }
        }
    }

    return true;
};

// 实时验证日期范围
const validateDateRange = (index) => {
    const item = formData.RoomPriceDtos[index];
    if (item.BeginActiveTime && item.EndActiveTime) {
        const beginTime = new Date(item.BeginActiveTime);
        const endTime = new Date(item.EndActiveTime);

        // 检查当前记录的开始时间是否小于结束时间
        if (beginTime >= endTime) {
            ElMessage.error(`第${index + 1}条价格记录的起始时间不能大于或等于截至时间`);
            item.BeginActiveTime = ''; // 清空无效时间
            item.EndActiveTime = '';
            return;
        }

        // 检查与其他记录是否存在时间交叉
        for (let i = 0; i < formData.RoomPriceDtos.length; i++) {
            if (i !== index) { // 不与自己比较
                const otherItem = formData.RoomPriceDtos[i];
                if (otherItem.BeginActiveTime && otherItem.EndActiveTime) {
                    const otherBeginTime = new Date(otherItem.BeginActiveTime);
                    const otherEndTime = new Date(otherItem.EndActiveTime);

                    // 检查时间段是否交叉
                    if ((beginTime < otherEndTime && endTime > otherBeginTime)) {
                        ElMessage.error(`第${index + 1}条和第${i + 1}条价格记录的时间段存在交叉，请调整`);
                        item.BeginActiveTime = ''; // 清空无效时间
                        item.EndActiveTime = '';
                        return;
                    }
                }
            }
        }
    }
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
        const { Success } = await Post(`/Room/Delete`, { Id: Id });
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


            const { Success } = await Post(`/Room/BatchDelete`, { Ids: ids });
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

// 添加价格
const addPrice = () => {
    formData.RoomPriceDtos.push({
        Price: 0.01,
        BeginActiveTime: '',
        EndActiveTime: '',
        HotelId: HotelId.value
    });
};

// 删除价格
const removePrice = (index) => {
    formData.RoomPriceDtos.splice(index, 1);
};

// 验证价格
const validatePrice = (index) => {
    const item = formData.RoomPriceDtos[index];
    if (item.Price <= 0) {
        ElMessage.error(`价格必须大于0`);
        item.Price = 0.01;
    }
};

// 添加优惠
const addDiscount = () => {
    formData.FavourableSettingDtos.push({
        Discount: 0.9,
        BeginActiveTime: '',
        EndActiveTime: '',
        HotelId: HotelId.value,
        RoomId: formData.Id || null
    });
};

// 删除优惠
const removeDiscount = (index) => {
    formData.FavourableSettingDtos.splice(index, 1);
};

// 验证折扣
const validateDiscount = (index) => {
    const item = formData.FavourableSettingDtos[index];
    if (item.Discount <= 0 || item.Discount > 1) {
        ElMessage.error(`折扣价必须大于0且小于等于1`);
        item.Discount = 0.9;
    }
};

// 验证优惠时间设置
const validateDiscountTimeSettings = () => {
    const discountDtos = formData.FavourableSettingDtos;

    // 如果没有优惠设置，直接返回true
    if (!discountDtos || discountDtos.length === 0) {
        return true;
    }

    // 检查每条记录的起始时间是否小于截至时间
    for (let i = 0; i < discountDtos.length; i++) {
        const item = discountDtos[i];
        if (!item.BeginActiveTime || !item.EndActiveTime) {
            ElMessage.error(`第${i + 1}条优惠记录的起始时间和截至时间不能为空`);
            return false;
        }

        const beginTime = new Date(item.BeginActiveTime);
        const endTime = new Date(item.EndActiveTime);

        if (beginTime >= endTime) {
            ElMessage.error(`第${i + 1}条优惠记录的起始时间不能大于或等于截至时间`);
            return false;
        }
    }

    // 检查多条记录之间是否存在时间交叉
    for (let i = 0; i < discountDtos.length; i++) {
        const itemI = discountDtos[i];
        const beginTimeI = new Date(itemI.BeginActiveTime);
        const endTimeI = new Date(itemI.EndActiveTime);

        for (let j = i + 1; j < discountDtos.length; j++) {
            const itemJ = discountDtos[j];
            const beginTimeJ = new Date(itemJ.BeginActiveTime);
            const endTimeJ = new Date(itemJ.EndActiveTime);

            // 检查时间段是否交叉
            if ((beginTimeI <= endTimeJ && endTimeI >= beginTimeJ) ||
                (beginTimeJ <= endTimeI && endTimeJ >= beginTimeI)) {
                ElMessage.error(`第${i + 1}条和第${j + 1}条优惠记录的时间段存在交叉，请调整`);
                return false;
            }
        }
    }

    return true;
};

// 实时验证优惠日期范围
const validateDiscountDateRange = (index) => {
    const item = formData.FavourableSettingDtos[index];
    if (item.BeginActiveTime && item.EndActiveTime) {
        const beginTime = new Date(item.BeginActiveTime);
        const endTime = new Date(item.EndActiveTime);

        // 检查当前记录的开始时间是否小于结束时间
        if (beginTime >= endTime) {
            ElMessage.error(`第${index + 1}条优惠记录的起始时间不能大于或等于截至时间`);
            item.BeginActiveTime = ''; // 清空无效时间
            item.EndActiveTime = '';
            return;
        }

        // 检查与其他记录是否存在时间交叉
        for (let i = 0; i < formData.FavourableSettingDtos.length; i++) {
            if (i !== index) { // 不与自己比较
                const otherItem = formData.FavourableSettingDtos[i];
                if (otherItem.BeginActiveTime && otherItem.EndActiveTime) {
                    const otherBeginTime = new Date(otherItem.BeginActiveTime);
                    const otherEndTime = new Date(otherItem.EndActiveTime);

                    // 检查时间段是否交叉
                    if ((beginTime < otherEndTime && endTime > otherBeginTime)) {
                        ElMessage.error(`第${index + 1}条和第${i + 1}条优惠记录的时间段存在交叉，请调整`);
                        item.BeginActiveTime = ''; // 清空无效时间
                        item.EndActiveTime = '';
                        return;
                    }
                }
            }
        }
    }
};
onBeforeMount(() => {

    if (RoleType.value == '酒店') {
        where.value.HotelId = HotelId.value;
    }

});
</script>

<style scoped>
.price-setting-container {
    border: 1px solid #ebeef5;
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 10px;
}

.price-item {
    margin-bottom: 15px;
    padding-bottom: 15px;
    border-bottom: 1px dashed #ebeef5;
}

.price-item:last-child {
    border-bottom: none;
}
</style>