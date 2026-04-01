<template>
    <div>
        <!-- 地址选择弹窗 -->
        <el-dialog v-model="dialogVisible" title="选择地址" width="60%" :before-close="handleClose" destroy-on-close>
            <div class="address-selector">
                <!-- 全国选项 -->
                <div class="address-level">
                    <div class="address-item" :class="{ active: tempAddress.province === '全国' }" @click="selectAllChina">
                        全国
                    </div>
                </div>

                <!-- 省份选择 -->
                <div class="address-level" v-if="showProvinces">
                    <div v-for="(province, index) in provinces" :key="index" class="address-item"
                        :class="{ active: tempAddress.province === province.label }"
                        @click="selectProvince(province.label)">
                        {{ province.label }}
                    </div>
                </div>

                <!-- 城市选择 -->
                <div class="address-level" v-if="tempAddress.province && tempAddress.province !== '全国'">
                    <div v-for="(city, index) in citiesOfSelectedProvince" :key="index" class="address-item"
                        :class="{ active: tempAddress.city === city.label }" @click="selectCity(city.label)">
                        {{ city.label }}
                    </div>
                </div>

                <!-- 区县选择 -->
                <div class="address-level" v-if="tempAddress.city">
                    <div v-for="(area, index) in areasOfSelectedCity" :key="index" class="address-item"
                        :class="{ active: tempAddress.area === area.label }" @click="selectArea(area.label)">
                        {{ area.label }}
                    </div>
                </div>
            </div>

            <template #footer>
                <div class="dialog-footer">
                    <el-button @click="handleCancel">取消</el-button>
                    <el-button type="primary" @click="handleConfirm">确认</el-button>
                </div>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, computed, defineEmits, defineProps } from 'vue';
import regionData from '@/utils/chian-area-data.js';


// 接收父组件传递的props
const props = defineProps({
    visible: {
        type: Boolean,
        default: false
    },
    initialAddress: {
        type: Object,
        default: () => ({
            province: '全国',
            city: '',
            area: ''
        })
    }
});

// 定义事件
const emit = defineEmits(['update:visible', 'selected']);

// 地址选择弹窗可见性
const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
});

// 选中的地址数据
const selectedAddress = ref({
    province: props.initialAddress.province || '全国',
    city: props.initialAddress.city || '',
    area: props.initialAddress.area || ''
});

// 临时保存用户选择的地址
const tempAddress = ref({ ...selectedAddress.value });

// 显示省份列表
const showProvinces = ref(true);

// 获取所有省份列表
const provinces = computed(() => {
    return regionData;
});

// 获取选中省份的城市列表
const citiesOfSelectedProvince = computed(() => {
    if (!tempAddress.value.province || tempAddress.value.province === '全国') {
        return [];
    }

    const selectedProvinceObj = provinces.value.find(p => p.label === tempAddress.value.province);
    return selectedProvinceObj ? selectedProvinceObj.children || [] : [];
});

// 获取选中城市的区县列表
const areasOfSelectedCity = computed(() => {
    if (!tempAddress.value.province || !tempAddress.value.city || tempAddress.value.province === '全国') {
        return [];
    }

    const selectedProvinceObj = provinces.value.find(p => p.label === tempAddress.value.province);
    if (!selectedProvinceObj) return [];

    const selectedCityObj = selectedProvinceObj.children.find(c => c.label === tempAddress.value.city);
    return selectedCityObj ? selectedCityObj.children || [] : [];
});

// 选择全国
const selectAllChina = () => {
    tempAddress.value = {
        province: '全国',
        city: '',
        area: ''
    };
};

// 选择省份
const selectProvince = (province) => {
    tempAddress.value.province = province;
    tempAddress.value.city = '';
    tempAddress.value.area = '';
};

// 选择城市
const selectCity = (city) => {
    tempAddress.value.city = city;
    tempAddress.value.area = '';
};

// 选择区县
const selectArea = (area) => {
    tempAddress.value.area = area;
};

// 处理关闭弹窗
const handleClose = () => {
    dialogVisible.value = false;
};

// 处理取消选择
const handleCancel = () => {
    // 重置为之前的选择
    tempAddress.value = { ...selectedAddress.value };
    dialogVisible.value = false;
};

// 处理确认选择
const handleConfirm = () => {
    // 更新选中的地址
    selectedAddress.value = { ...tempAddress.value };

    // 发送选中的地址给父组件
    emit('selected', selectedAddress.value);

    // 关闭弹窗
    dialogVisible.value = false;
};
</script>

<style scoped>
/* 地址选择器样式 */
.address-selector {
    display: flex;
    flex-direction: column;
    gap: 15px;
    max-height: 60vh;
    overflow-y: auto;
}

/* 地址选择级别 */
.address-level {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    padding: 10px 0;
    border-bottom: 1px solid #eee;
}

/* 地址选择项 */
.address-item {
    padding: 6px 12px;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s;
    background-color: #f5f7fa;
    border: 1px solid transparent;
}

/* 地址选择项悬停效果 */
.address-item:hover {
    background-color: #e6f7ff;
    color: #1890ff;
}

/* 选中状态 */
.address-item.active {
    background-color: #e6f7ff;
    color: #1890ff;
    border-color: #91d5ff;
}

/* 弹窗底部按钮 */
.dialog-footer {
    display: flex;
    justify-content: flex-end;
    margin-top: 20px;
}
</style>
