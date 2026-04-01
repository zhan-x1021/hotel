<template>
    <div class="analysis-container">
        <!-- 页面标题和统计概览 -->
        <div class="header-section">
            <h2>酒店数据综合分析</h2>
            <div class="overview-cards">
                <div class="card" v-for="(card, index) in overviewCards" :key="index">
                    <div class="card-title">{{ card.title }}</div>
                    <div class="card-value">{{ formatNumber(card.value) }}</div>
                </div>
            </div>
        </div>

        <div class="charts-container">
            <!-- 预约状态分析 -->
            <div class="chart-wrapper">
                <div class="chart-title">预约状态分析</div>
                <div id="appointmentStatusChart" class="chart"></div>
            </div>

            <!-- 季节预约与收入分析 -->
            <div class="chart-wrapper">
                <div class="chart-title">季节预约与收入分析</div>
                <div id="seasonalAnalysisChart" class="chart"></div>
            </div>

            <!-- 房型受欢迎度分析 -->
            <div class="chart-wrapper">
                <div class="chart-title">房型受欢迎度分析</div>
                <div id="roomTypeChart" class="chart"></div>
            </div>

            <!-- 入住时长分析 -->
            <div class="chart-wrapper">
                <div class="chart-title">入住时长分析</div>
                <div id="stayDurationChart" class="chart"></div>
            </div>

            <!-- 工作日/周末预订分析 -->
            <div class="chart-wrapper">
                <div class="chart-title">工作日/周末预订分析</div>
                <div id="weekdayWeekendChart" class="chart"></div>
            </div>

            <!-- 提前预订天数分析 -->
            <div class="chart-wrapper">
                <div class="chart-title">提前预订天数分析</div>
                <div id="advanceBookingChart" class="chart"></div>
            </div>
        </div>
    </div>
</template>

<script setup>
import defaultAvatar from '@/assets/默认头像.png'; // 导入默认头像图片
import NoImage from '@/assets/图片失效.png';
import { Post, PostSingleUpdate } from '@/api/http';
import { ref, reactive, nextTick, computed, onBeforeMount, onMounted, onBeforeUnmount } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useCommonStore } from "@/store";
import { ElMessage, ElMessageBox } from 'element-plus';
import * as echarts from 'echarts';

const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);
const HotelDto = computed(() => commonStore.HotelDto);

// 数据存储
const analysisData = ref(null);
const loading = ref(true);
const chartInstances = reactive({});
const overviewCards = ref([]);

// 格式化数字（保留2位小数）
function formatNumber(value) {
    if (value === undefined || value === null) return '0';

    if (typeof value === 'number') {
        if (Number.isInteger(value)) return value.toString();
        return value.toFixed(2);
    }

    return value;
}

// 格式化百分比
function formatPercent(value) {
    if (value === undefined || value === null) return '0%';

    if (typeof value === 'number') {
        return (value * 100).toFixed(2) + '%';
    }

    return value;
}

// 安全除法（防止除以0导致NaN）
function safeDivide(numerator, denominator) {
    if (!denominator || denominator === 0) return 0;
    return numerator / denominator;
}

// 初始化总览卡片数据
function initOverviewCards() {
    if (!analysisData.value) return;

    const data = analysisData.value;
    const statusStats = data['预约状态统计'] || {};

    overviewCards.value = [
        { title: '总预约数', value: statusStats['总预约数'] || 0 },
        { title: '预约成功率', value: formatPercent(statusStats['成功率']) },
        { title: '用户取消率', value: formatPercent(statusStats['用户取消率']) },
        { title: '总收入', value: data['总收入'] ? `¥${data['总收入'].toFixed(2)}` : '¥0.00' }
    ];
}

// 使用容器自适应方式初始化图表
function initChartWithContainer(domId, chartType) {
    const chartDom = document.getElementById(domId);
    if (!chartDom) return null;

    // 使用容器模式初始化，使图表继承容器宽高
    const chart = echarts.init(chartDom, null, {
        renderer: 'canvas',
        useDirtyRect: true // 优化性能
    });

    // 存储图表实例
    chartInstances[chartType] = chart;
    return chart;
}

// 修改初始化预约状态图表
function initAppointmentStatusChart() {
    if (!analysisData.value) return;

    const chart = initChartWithContainer('appointmentStatusChart', 'appointmentStatusChart');
    if (!chart) return;

    const statusData = analysisData.value['预约状态统计'];
    if (!statusData) return;

    const pieData = [
        { name: '预约成功', value: statusData['预约成功数'] || 0 },
        { name: '用户取消', value: statusData['用户取消数'] || 0 },
        { name: '酒店取消', value: statusData['酒店取消数'] || 0 },
        { name: '系统取消', value: statusData['系统取消数'] || 0 },
        { name: '待确认', value: statusData['待确认数'] || 0 }
    ];

    const option = {
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
            orient: 'horizontal',
            left: 'center',
            top: 'bottom',
            data: pieData.map(item => item.name)
        },
        series: [
            {
                name: '预约状态',
                type: 'pie',
                radius: ['40%', '70%'],
                avoidLabelOverlap: true,
                itemStyle: {
                    borderRadius: 10,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: true,
                    formatter: '{b}: {c} ({d}%)'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: '16',
                        fontWeight: 'bold'
                    }
                },
                data: pieData
            }
        ],
        color: ['#5470c6', '#91cc75', '#fac858', '#ee6666', '#73c0de']
    };

    chart.setOption(option);
}

// 初始化季节预约与收入分析图表
function initSeasonalAnalysisChart() {
    if (!analysisData.value) return;

    const chart = initChartWithContainer('seasonalAnalysisChart', 'seasonalAnalysisChart');
    if (!chart) return;

    const seasonalBookings = analysisData.value['季节预约统计'];
    const seasonalRevenue = analysisData.value['季节收入统计'];

    if (!seasonalBookings || !seasonalRevenue) return;

    const seasons = ['春季', '夏季', '秋季', '冬季'];
    const bookingData = seasons.map(season => seasonalBookings[season] || 0);
    const revenueData = seasons.map(season => seasonalRevenue[season] || 0);

    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        legend: {
            data: ['预约数量', '收入(元)'],
            top: 'bottom'
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '15%',
            top: '15%',
            containLabel: true
        },
        xAxis: [
            {
                type: 'category',
                data: seasons,
                axisTick: {
                    alignWithLabel: true
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '预约数量',
                position: 'left',
                axisLine: {
                    show: true,
                    lineStyle: {
                        color: '#5470c6'
                    }
                }
            },
            {
                type: 'value',
                name: '收入(元)',
                position: 'right',
                axisLine: {
                    show: true,
                    lineStyle: {
                        color: '#91cc75'
                    }
                }
            }
        ],
        series: [
            {
                name: '预约数量',
                type: 'bar',
                barWidth: '30%',
                data: bookingData,
                itemStyle: {
                    color: '#5470c6'
                },
                label: {
                    show: true,
                    position: 'top'
                }
            },
            {
                name: '收入(元)',
                type: 'line',
                yAxisIndex: 1,
                data: revenueData,
                symbol: 'circle',
                symbolSize: 8,
                itemStyle: {
                    color: '#91cc75'
                },
                label: {
                    show: true,
                    position: 'top',
                    formatter: function (params) {
                        return params.value.toFixed(2);
                    }
                },
                lineStyle: {
                    width: 3
                }
            }
        ],
        animationDuration: 1500,
        animationEasing: 'elasticOut'
    };

    chart.setOption(option);
}

// 初始化房型受欢迎度分析图表
function initRoomTypeChart() {
    if (!analysisData.value) return;

    const chart = initChartWithContainer('roomTypeChart', 'roomTypeChart');
    if (!chart) return;

    const roomTypeBookings = analysisData.value['房型预约统计'];
    const roomTypeRevenue = analysisData.value['房型收入统计'];

    if (!roomTypeBookings || !roomTypeRevenue) return;

    const roomTypes = Object.keys(roomTypeBookings);
    const bookingData = roomTypes.map(type => roomTypeBookings[type] || 0);
    const revenueData = roomTypes.map(type => roomTypeRevenue[type] || 0);

    // 计算每种房型的平均收入
    const avgRevenueData = roomTypes.map((type, index) => {
        const bookings = bookingData[index];
        const revenue = revenueData[index];
        return bookings > 0 ? revenue / bookings : 0;
    });

    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        legend: {
            data: ['预约数量', '总收入(元)', '平均收入(元/次)'],
            orient: 'horizontal',
            left: 'center',
            top: 'bottom'
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '15%',
            top: '15%',
            containLabel: true
        },
        xAxis: [
            {
                type: 'category',
                data: roomTypes,
                axisLabel: {
                    interval: 0,
                    rotate: 30
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '数量/金额',
                min: 0
            }
        ],
        series: [
            {
                name: '预约数量',
                type: 'bar',
                stack: 'total',
                label: {
                    show: true
                },
                emphasis: {
                    focus: 'series'
                },
                data: bookingData
            },
            {
                name: '总收入(元)',
                type: 'bar',
                stack: 'total',
                label: {
                    show: true,
                    formatter: function (params) {
                        return params.value.toFixed(2);
                    }
                },
                emphasis: {
                    focus: 'series'
                },
                data: revenueData
            },
            {
                name: '平均收入(元/次)',
                type: 'line',
                label: {
                    show: true,
                    formatter: function (params) {
                        return params.value.toFixed(2);
                    }
                },
                emphasis: {
                    focus: 'series'
                },
                data: avgRevenueData
            }
        ],
        animationDuration: 1500,
        animationEasing: 'elasticOut'
    };

    chart.setOption(option);
}

// 初始化入住时长分析图表
function initStayDurationChart() {
    if (!analysisData.value) return;

    const chart = initChartWithContainer('stayDurationChart', 'stayDurationChart');
    if (!chart) return;

    const stayDurationData = analysisData.value['入住时长统计'];
    if (!stayDurationData) return;

    const categories = ['入住1天', '入住2天', '入住3天', '入住4-7天', '入住超过7天'];
    const data = categories.map(cat => stayDurationData[cat] || 0);
    const total = data.reduce((sum, val) => sum + val, 0);

    // 计算百分比
    const percentData = data.map(val => {
        return total > 0 ? (val / total * 100).toFixed(2) : 0;
    });

    const option = {
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
            orient: 'horizontal',
            left: 'center',
            top: 'bottom',
            data: categories
        },
        series: [
            {
                name: '入住时长',
                type: 'pie',
                radius: ['30%', '60%'],
                center: ['50%', '45%'],
                roseType: 'radius',
                itemStyle: {
                    borderRadius: 8
                },
                label: {
                    show: true,
                    formatter: '{b}: {c} ({d}%)'
                },
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },
                data: categories.map((cat, index) => {
                    return {
                        name: cat,
                        value: data[index]
                    };
                })
            }
        ],
        animationDuration: 1500,
        animationEasing: 'elasticOut'
    };

    chart.setOption(option);
}

// 初始化工作日/周末预订分析图表
function initWeekdayWeekendChart() {
    if (!analysisData.value) return;

    const chart = initChartWithContainer('weekdayWeekendChart', 'weekdayWeekendChart');
    if (!chart) return;

    const weekdayWeekendData = analysisData.value['工作日/周末统计'];
    if (!weekdayWeekendData) return;

    const categories = ['工作日', '周末'];
    const bookingData = [
        weekdayWeekendData['工作日预订数'] || 0,
        weekdayWeekendData['周末预订数'] || 0
    ];
    const revenueData = [
        weekdayWeekendData['工作日收入'] || 0,
        weekdayWeekendData['周末收入'] || 0
    ];

    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        legend: {
            data: ['预订数量', '收入金额'],
            top: 'bottom'
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '15%',
            containLabel: true
        },
        xAxis: [
            {
                type: 'category',
                data: categories
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '预订数量',
                position: 'left'
            },
            {
                type: 'value',
                name: '收入金额',
                position: 'right',
                axisLine: {
                    show: true,
                    lineStyle: {
                        color: '#91cc75'
                    }
                }
            }
        ],
        series: [
            {
                name: '预订数量',
                type: 'bar',
                barWidth: '40%',
                data: bookingData,
                label: {
                    show: true,
                    position: 'top',
                    formatter: '{c}'
                },
                itemStyle: {
                    color: '#5470c6'
                }
            },
            {
                name: '收入金额',
                type: 'bar',
                yAxisIndex: 1,
                barWidth: '40%',
                data: revenueData,
                label: {
                    show: true,
                    position: 'top',
                    formatter: '{c}'
                },
                itemStyle: {
                    color: '#91cc75'
                }
            }
        ],
        animationDuration: 1500,
        animationDelay: function (idx) {
            return idx * 100;
        }
    };

    chart.setOption(option);
}

// 初始化提前预订天数分析图表
function initAdvanceBookingChart() {
    if (!analysisData.value) return;

    const chart = initChartWithContainer('advanceBookingChart', 'advanceBookingChart');
    if (!chart) return;

    const advanceBookingData = analysisData.value['提前预订天数统计'];
    if (!advanceBookingData) return;

    const categories = ['当天预订', '提前1天', '提前2天', '提前3-7天', '提前超过7天'];
    const data = categories.map(cat => advanceBookingData[cat] || 0);

    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'value',
            boundaryGap: [0, 0.01]
        },
        yAxis: {
            type: 'category',
            data: categories
        },
        series: [
            {
                name: '预订数量',
                type: 'bar',
                data: data,
                label: {
                    show: true,
                    position: 'right',
                    formatter: '{c}'
                },
                itemStyle: {
                    color: function (params) {
                        const colorList = ['#fac858', '#91cc75', '#5470c6', '#73c0de', '#ee6666'];
                        return colorList[params.dataIndex];
                    }
                }
            }
        ],
        animationDuration: 1500,
        animationEasing: 'elasticOut'
    };

    chart.setOption(option);
}

// 初始化所有图表
function initAllCharts() {
    initOverviewCards();
    nextTick(() => {
        initAppointmentStatusChart();
        initSeasonalAnalysisChart();
        initRoomTypeChart();
        initStayDurationChart();
        initWeekdayWeekendChart();
        initAdvanceBookingChart();
    });
}

// 改进处理窗口大小变化函数
function handleResize() {
    // 使用防抖处理，避免频繁触发
    if (window.resizeTimer) {
        clearTimeout(window.resizeTimer);
    }

    window.resizeTimer = setTimeout(() => {
        for (const key in chartInstances) {
            if (chartInstances[key]) {
                // 根据容器大小调整图表
                chartInstances[key].resize();

                // 根据窗口宽度调整图表配置
                const screenWidth = window.innerWidth;
                if (screenWidth < 768) {
                    // 小屏幕适配
                    adjustChartForSmallScreen(chartInstances[key], key);
                } else if (screenWidth < 1200) {
                    // 中屏幕适配
                    adjustChartForMediumScreen(chartInstances[key], key);
                } else {
                    // 大屏幕配置
                    resetChartConfig(chartInstances[key], key);
                }
            }
        }
    }, 100); // 100ms防抖
}

// 添加中屏幕适配
function adjustChartForMediumScreen(chart, chartType) {
    const option = chart.getOption();

    // 中屏幕下的配置调整
    if (option.legend) {
        // 调整图例布局
        if (['roomTypeChart', 'seasonalAnalysisChart'].includes(chartType)) {
            option.legend.orient = 'horizontal';
            option.legend.left = 'center';
            option.legend.itemWidth = 15;
            option.legend.itemHeight = 10;
        }
    }

    // 根据不同图表类型特殊处理
    if (chartType === 'roomTypeChart') {
        // 房型图表需要调整x轴标签角度
        if (option.xAxis && option.xAxis[0]) {
            option.xAxis[0].axisLabel = {
                interval: 0,
                rotate: 45 // 更大的旋转角度以适应空间
            };
        }
    }

    chart.setOption(option);
}

// 强化小屏幕图表适配
function adjustChartForSmallScreen(chart, chartType) {
    const option = chart.getOption();

    // 通用配置调整
    if (option.legend) {
        option.legend.textStyle = { fontSize: 10 };

        // 简化图例显示
        if (chartType === 'roomTypeChart' && option.legend.data && option.legend.data.length > 3) {
            // 如果数据项太多，只显示简化版图例
            option.legend.selectedMode = 'single';
        }
    }

    // 调整文字大小和显示方式
    if (option.series) {
        option.series.forEach(series => {
            if (series.label) {
                series.label.fontSize = 10;

                // 只在一些关键点显示标签
                if (chartType !== 'appointmentStatusChart' && chartType !== 'stayDurationChart') {
                    series.label.show = false;
                }
            }

            // 简化饼图
            if (series.type === 'pie') {
                series.radius = ['35%', '60%']; // 调整饼图大小
                series.itemStyle.borderWidth = 1; // 减小边框
            }

            // 简化柱状图
            if (series.type === 'bar') {
                series.barWidth = '40%'; // 调整柱子宽度
            }
        });
    }

    // 调整网格位置，确保图表内容能完全显示
    if (option.grid) {
        option.grid.bottom = '20%';
    }

    chart.setOption(option);
}

// 重置图表配置
function resetChartConfig(chart, chartType) {
    // 重新初始化对应图表
    switch (chartType) {
        case 'appointmentStatusChart':
            initAppointmentStatusChart();
            break;
        case 'seasonalAnalysisChart':
            initSeasonalAnalysisChart();
            break;
        case 'roomTypeChart':
            initRoomTypeChart();
            break;
        case 'stayDurationChart':
            initStayDurationChart();
            break;
        case 'weekdayWeekendChart':
            initWeekdayWeekendChart();
            break;
        case 'advanceBookingChart':
            initAdvanceBookingChart();
            break;
    }
}

// 获取酒店数据分析
async function GetHotelDataAnalysis() {
    try {
        loading.value = true;
        const res = await Post("/DataAnalysis/HotelDataAnalysis", {
            HotelId: HotelDto.value.Id,
        });

        if (res.Success && res.Data) {
            analysisData.value = res.Data;
            initAllCharts();
        } else {
            ElMessage.error(res.Msg || '获取数据失败');
        }
    } catch (error) {
        console.error('获取数据失败:', error);
        ElMessage.error('获取数据失败');
    } finally {
        loading.value = false;
    }
}

// 监听容器大小变化
function observeChartContainers() {
    if (window.ResizeObserver) {
        const chartContainers = document.querySelectorAll('.chart');
        const resizeObserver = new ResizeObserver(entries => {
            for (let entry of entries) {
                // 找到对应的图表实例
                for (const key in chartInstances) {
                    if (chartInstances[key] && entry.target.id === key.replace('Chart', '')) {
                        chartInstances[key].resize();
                    }
                }
            }
        });

        chartContainers.forEach(container => {
            resizeObserver.observe(container);
        });

        // 存储观察器实例以便清理
        window.chartResizeObserver = resizeObserver;
    }
}

// 生命周期钩子
onBeforeMount(async () => {
    await GetHotelDataAnalysis();
});

// 在组件挂载后启用容器观察
onMounted(() => {
    window.addEventListener('resize', handleResize);
    nextTick(() => {
        observeChartContainers();
    });
});

// 在组件卸载前清理资源
onBeforeUnmount(() => {
    window.removeEventListener('resize', handleResize);
    if (window.chartResizeObserver) {
        window.chartResizeObserver.disconnect();
    }
    if (window.resizeTimer) {
        clearTimeout(window.resizeTimer);
    }
    // 销毁图表实例
    for (const key in chartInstances) {
        if (chartInstances[key]) {
            chartInstances[key].dispose();
        }
    }
});
</script>

<style scoped lang="scss">
.analysis-container {
    padding: 20px;
    min-height: 100vh;
    background-color: #f5f7fa;
}

/* 头部区域 */
.header-section {
    margin-bottom: 30px;

    h2 {
        font-size: 24px;
        margin-bottom: 20px;
        color: #303133;
        text-align: center;
    }
}

/* 统计卡片 */
.overview-cards {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: space-between;
    margin-bottom: 30px;

    @media (max-width: 768px) {
        gap: 10px;
    }

    @media (max-width: 480px) {
        flex-direction: column;
    }

    .card {
        flex: 1;
        min-width: 200px;
        background: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
        text-align: center;
        transition: transform 0.3s;

        &:hover {
            transform: translateY(-5px);
        }

        .card-title {
            font-size: 16px;
            color: #606266;
            margin-bottom: 10px;
        }

        .card-value {
            font-size: 24px;
            font-weight: bold;
            color: #409eff;
        }

        @media (max-width: 768px) {
            min-width: 150px;
            padding: 15px 10px;
        }

        @media (max-width: 480px) {
            min-width: auto;
            padding: 10px;
        }
    }
}

/* 图表容器 */
.charts-container {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;

    @media (max-width: 1200px) {
        grid-template-columns: 1fr;
    }

    @media (max-width: 768px) {
        gap: 15px;
    }

    @media (max-width: 480px) {
        gap: 10px;
    }
}

/* 单个图表 */
.chart-wrapper {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 20px;

    @media (max-width: 768px) {
        padding: 15px 10px;
    }

    @media (max-width: 480px) {
        padding: 10px 5px;
    }

    .chart-title {
        font-size: 18px;
        color: #303133;
        margin-bottom: 20px;
        font-weight: 500;
        text-align: center;

        @media (max-width: 768px) {
            font-size: 16px;
            margin-bottom: 15px;
        }

        @media (max-width: 480px) {
            font-size: 14px;
            margin-bottom: 10px;
        }
    }

    .chart {
        height: 350px;
        width: 100%;

        @media (max-width: 768px) {
            height: 300px;
        }

        @media (max-width: 480px) {
            height: 250px;
        }
    }
}
</style>