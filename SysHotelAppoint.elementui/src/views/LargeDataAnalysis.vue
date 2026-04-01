<template>
    <div class="large-data-container">
        <!-- 顶部标题 -->
        <dv-border-box-12 class="header-box">
            <div class="header-title">酒店预订系统数据分析大屏</div>
        </dv-border-box-12>

        <!-- 数据统计卡片 -->
        <div class="data-overview">
            <dv-border-box-5 class="data-card" v-for="(item, index) in dataCards" :key="index">
                <div class="card-value">{{ item.value }}</div>
                <div class="card-title">{{ item.title }}</div>
            </dv-border-box-5>
        </div>

        <!-- 图表区域 -->
        <div class="charts-container">
            <!-- 预约状态分布 -->
            <dv-border-box-8 class="chart-item chart-status">
                <div class="chart-title">预约状态分布</div>
                <div class="chart-content" ref="statusChartRef"></div>
            </dv-border-box-8>

            <!-- 月度预约趋势 -->
            <dv-border-box-8 class="chart-item chart-monthly">
                <div class="chart-title">月度预约与收入趋势</div>
                <div class="chart-content" ref="monthlyChartRef"></div>
            </dv-border-box-8>

            <!-- 预约时段分布 -->
            <dv-border-box-8 class="chart-item chart-time">
                <div class="chart-title">预约时段分布</div>
                <div class="chart-content" ref="timeChartRef"></div>
            </dv-border-box-8>

            <!-- 客户分析 -->
            <dv-border-box-8 class="chart-item chart-customer">
                <div class="chart-title">客户分析</div>
                <div class="chart-content" ref="customerChartRef"></div>
            </dv-border-box-8>

            <!-- 预订提前时间分析 -->
            <dv-border-box-8 class="chart-item chart-advance">
                <div class="chart-title">预订提前时间分析</div>
                <div class="chart-content" ref="advanceChartRef"></div>
            </dv-border-box-8>
        </div>
    </div>
</template>

<script setup>
import defaultAvatar from '@/assets/默认头像.png';
import NoImage from '@/assets/图片失效.png';
import { Post, PostSingleUpdate } from '@/api/http';
import { ref, reactive, nextTick, computed, onBeforeMount, onMounted, onUnmounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useCommonStore } from "@/store";
import { ElMessage, ElMessageBox } from 'element-plus';
import * as echarts from 'echarts';
// 引入DataV组件
import {
    BorderBox5,
    BorderBox8,
    BorderBox12,
    DigitalFlop
} from '@kjgl77/datav-vue3';



const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);

// 图表实例引用
const statusChartRef = ref(null);
const monthlyChartRef = ref(null);
const timeChartRef = ref(null);
const customerChartRef = ref(null);
const advanceChartRef = ref(null);

// 图表实例
const statusChart = ref(null);
const monthlyChart = ref(null);
const timeChart = ref(null);
const customerChart = ref(null);
const advanceChart = ref(null);

// 数据
const totalAppoints = ref(0);
const totalRevenue = ref(0);
const avgStayDuration = ref(0);
const newCustomerRate = ref(0);
const completedRate = ref(0);

// 数据卡片
const dataCards = ref([
    { title: '总预约数', value: '0' },
    { title: '总收入(元)', value: '0' },
    { title: '平均入住天数', value: '0' },
    { title: '完成预约率', value: '0%' },
]);

// 格式化百分比，保留2位小数
const formatPercent = (value) => {
    if (value === undefined || value === null || isNaN(value)) return '0.00%';
    return (value * 100).toFixed(2) + '%';
};

// 格式化数字，保留2位小数
const formatNumber = (value) => {
    if (value === undefined || value === null || isNaN(value)) return '0.00';
    return Number(value).toFixed(2);
};

// 安全除法，避免除数为0
const safeDivide = (a, b) => {
    if (b === 0) return 0;
    return a / b;
};

// 初始化图表
const initCharts = () => {
    // 初始化预约状态分布饼图
    statusChart.value = echarts.init(statusChartRef.value);

    // 初始化月度预约柱状图
    monthlyChart.value = echarts.init(monthlyChartRef.value);

    // 初始化预约时段分布饼图
    timeChart.value = echarts.init(timeChartRef.value);

    // 初始化客户分析图
    customerChart.value = echarts.init(customerChartRef.value);

    // 初始化预订提前时间分析图
    advanceChart.value = echarts.init(advanceChartRef.value);
};

// 更新数据卡片
const updateDataCards = (data) => {
    if (!data) return;

    totalAppoints.value = data['总预约数量'] || 0;

    if (data['财务分析'] && data['财务分析']['总收入'] !== undefined) {
        totalRevenue.value = formatNumber(data['财务分析']['总收入']);
    }

    if (data['客户分析'] && data['客户分析']['平均入住天数'] !== undefined) {
        avgStayDuration.value = data['客户分析']['平均入住天数'];
    }

    if (data['预约状态分布'] && data['预约状态分布']['已完成比例'] !== undefined) {
        completedRate.value = formatPercent(data['预约状态分布']['已完成比例']);
    }

    dataCards.value = [
        { title: '总预约数', value: totalAppoints.value.toString() },
        { title: '总收入(元)', value: totalRevenue.value },
        { title: '平均入住天数', value: avgStayDuration.value.toString() },
        { title: '完成预约率', value: completedRate.value },
    ];
};

// 渲染预约状态分布图
const renderStatusChart = (data) => {
    if (!data || !data['预约状态分布']) return;

    const statusData = data['预约状态分布'];
    const chartData = [
        { name: '待确定', value: statusData['待确定'] || 0 },
        { name: '待入住', value: statusData['待入住'] || 0 },
        { name: '已完成', value: statusData['已完成'] || 0 },
        { name: '用户取消', value: statusData['用户取消'] || 0 },
        { name: '酒店取消', value: statusData['酒店取消'] || 0 },
        { name: '系统取消', value: statusData['系统取消'] || 0 }
    ];

    const option = {
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
            orient: 'horizontal',
            left: 'center',
            bottom: 0,
            textStyle: {
                color: '#fff'
            }
        },
        series: [
            {
                name: '预约状态',
                type: 'pie',
                radius: ['40%', '70%'],
                center: ['50%', '45%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    borderRadius: 10,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: true,
                    formatter: '{b}: {d}%'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: '18',
                        fontWeight: 'bold'
                    },
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },
                data: chartData
            }
        ]
    };

    statusChart.value.setOption(option);
};

// 渲染月度预约和收入趋势图
const renderMonthlyChart = (data) => {
    if (!data) return;

    const monthlyBookings = data['月度预约数量'];
    const monthlyRevenue = data['月度收入'];

    const months = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
    const bookingData = [];
    const revenueData = [];

    for (let i = 1; i <= 12; i++) {
        bookingData.push(monthlyBookings[i] || 0);
        revenueData.push(formatNumber(monthlyRevenue[i] || 0));
    }

    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        legend: {
            data: ['预约数量', '收入(元)'],
            textStyle: {
                color: '#fff'
            }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: months,
            axisLine: {
                lineStyle: {
                    color: '#fff'
                }
            }
        },
        yAxis: [
            {
                type: 'value',
                name: '预约数量',
                splitLine: {
                    lineStyle: {
                        type: 'dashed',
                        color: 'rgba(255,255,255,0.3)'
                    }
                },
                axisLine: {
                    lineStyle: {
                        color: '#fff'
                    }
                },
                axisLabel: {
                    formatter: '{value}'
                }
            },
            {
                type: 'value',
                name: '收入(元)',
                splitLine: {
                    lineStyle: {
                        type: 'dashed',
                        color: 'rgba(255,255,255,0.3)'
                    }
                },
                axisLine: {
                    lineStyle: {
                        color: '#fff'
                    }
                },
                axisLabel: {
                    formatter: '{value}'
                }
            }
        ],
        series: [
            {
                name: '预约数量',
                type: 'bar',
                data: bookingData,
                label: {
                    show: true,
                    position: 'top',
                    formatter: '{c}'
                },
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#83bff6' },
                        { offset: 0.5, color: '#188df0' },
                        { offset: 1, color: '#188df0' }
                    ])
                }
            },
            {
                name: '收入(元)',
                type: 'line',
                yAxisIndex: 1,
                data: revenueData,
                label: {
                    show: true,
                    position: 'top',
                    formatter: '{c}'
                },
                symbol: 'circle',
                symbolSize: 8,
                itemStyle: {
                    color: '#fac858'
                },
                lineStyle: {
                    width: 3,
                    shadowColor: 'rgba(250,200,88,0.5)',
                    shadowBlur: 10,
                    shadowOffsetY: 8
                }
            }
        ]
    };

    monthlyChart.value.setOption(option);
};

// 渲染预约时段分布图
const renderTimeChart = (data) => {
    if (!data || !data['预约时段分布']) return;

    const timeData = data['预约时段分布'];
    const chartData = [
        { name: '早晨预约(6:00-12:00)', value: timeData['早晨预约(6:00-12:00)'] || 0 },
        { name: '下午预约(12:00-18:00)', value: timeData['下午预约(12:00-18:00)'] || 0 },
        { name: '晚间预约(18:00-22:00)', value: timeData['晚间预约(18:00-22:00)'] || 0 },
        { name: '夜间预约(22:00-6:00)', value: timeData['夜间预约(22:00-6:00)'] || 0 }
    ];

    const option = {
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
            orient: 'horizontal',
            left: 'center',
            bottom: 0,
            textStyle: {
                color: '#fff'
            }
        },
        series: [
            {
                name: '预约时段',
                type: 'pie',
                radius: '70%',
                center: ['50%', '45%'],
                itemStyle: {
                    borderRadius: 4,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: true,
                    formatter: '{b}: {d}%'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: '18',
                        fontWeight: 'bold'
                    },
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },
                data: chartData
            }
        ]
    };

    timeChart.value.setOption(option);
};

// 渲染客户分析图
const renderCustomerChart = (data) => {
    if (!data || !data['客户分析']) return;

    const customerData = data['客户分析'];
    const newCustomers = customerData['新客户数量'] || 0;
    const returningCustomers = customerData['回头客数量'] || 0;
    const returnRate = customerData['回头率'] || 0;

    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        grid: {
            top: '15%',
            left: '3%',
            right: '4%',
            bottom: '10%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: ['客户类型分布'],
            axisLine: {
                lineStyle: {
                    color: '#fff'
                }
            }
        },
        yAxis: {
            type: 'value',
            splitLine: {
                lineStyle: {
                    type: 'dashed',
                    color: 'rgba(255,255,255,0.3)'
                }
            },
            axisLine: {
                lineStyle: {
                    color: '#fff'
                }
            }
        },
        series: [
            {
                name: '新客户',
                type: 'bar',
                stack: 'total',
                barWidth: '40%',
                label: {
                    show: true,
                    formatter: '{c} ',
                    position: 'inside'
                },
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#91cc75' },
                        { offset: 1, color: '#5eba49' }
                    ])
                },
                data: [newCustomers]
            },
            {
                name: '回头客',
                type: 'bar',
                stack: 'total',
                label: {
                    show: true,
                    formatter: '{c} ',
                    position: 'inside'
                },
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#fc8452' },
                        { offset: 1, color: '#e86110' }
                    ])
                },
                data: [returningCustomers]
            }
        ]
    };

    // 添加回头率指标
    const gaugeOption = {
        series: [
            {
                type: 'gauge',
                startAngle: 90,
                endAngle: -270,
                radius: '80%',
                center: ['50%', '60%'],
                pointer: {
                    show: false
                },
                progress: {
                    show: true,
                    overlap: false,
                    roundCap: true,
                    clip: false,
                    itemStyle: {
                        color: {
                            type: 'linear',
                            x: 0,
                            y: 0,
                            x2: 0,
                            y2: 1,
                            colorStops: [
                                { offset: 0, color: '#91cc75' },
                                { offset: 1, color: '#5470c6' }
                            ]
                        }
                    }
                },
                axisLine: {
                    lineStyle: {
                        width: 20
                    }
                },
                splitLine: {
                    show: false
                },
                axisTick: {
                    show: false
                },
                axisLabel: {
                    show: false
                },
                title: {
                    show: true,
                    fontSize: 14,
                    offsetCenter: [0, '-20%'],
                    color: '#fff'
                },
                detail: {
                    width: 50,
                    height: 14,
                    fontSize: 18,
                    color: '#fff',
                    formatter: '{value}%',
                    offsetCenter: [0, '30%']
                },
                data: [
                    {
                        name: '客户回头率',
                        value: (returnRate * 100).toFixed(2)
                    }
                ]
            }
        ]
    };

    customerChart.value.setOption({
        grid: { bottom: '55%' },
        legend: {
            data: ['新客户', '回头客'],
            textStyle: { color: '#fff' }
        },
        ...option
    });

    // 创建回头率仪表盘
    setTimeout(() => {
        const returnRateChart = echarts.init(document.createElement('div'));
        returnRateChart.setOption(gaugeOption);
        // 这里可以添加回头率的视觉展示，例如仪表盘或水波图等
    }, 500);
};

// 渲染预订提前时间分析图
const renderAdvanceChart = (data) => {
    if (!data || !data['预订提前时间分析']) return;

    const advanceData = data['预订提前时间分析'];
    const categories = ['当天预订', '提前1-3天', '提前4-7天', '提前8-14天', '提前15-30天', '提前30天以上'];
    const values = categories.map(key => advanceData[key] || 0);

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
            type: 'category',
            data: categories,
            axisLabel: {
                interval: 0,
                rotate: 30,
                textStyle: {
                    color: '#fff'
                }
            },
            axisLine: {
                lineStyle: {
                    color: '#fff'
                }
            }
        },
        yAxis: {
            type: 'value',
            splitLine: {
                lineStyle: {
                    type: 'dashed',
                    color: 'rgba(255,255,255,0.3)'
                }
            },
            axisLine: {
                lineStyle: {
                    color: '#fff'
                }
            }
        },
        series: [
            {
                name: '预订数量',
                type: 'bar',
                barWidth: '60%',
                data: values.map((value, index) => {
                    return {
                        value: value,
                        itemStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                { offset: 0, color: ['#83bff6', '#a0cfff', '#c2e9fb', '#fbc2eb', '#fdcbf1', '#e6e9fe'][index % 6] },
                                { offset: 1, color: ['#188df0', '#64b5f6', '#76decc', '#fb7293', '#d4a4eb', '#8d98b3'][index % 6] }
                            ])
                        },
                        label: {
                            show: true,
                            position: 'top',
                            formatter: '{c}'
                        }
                    };
                })
            }
        ]
    };

    advanceChart.value.setOption(option);
};

// 更新所有图表
const updateAllCharts = (data) => {
    if (!data) return;

    updateDataCards(data);
    renderStatusChart(data);
    renderMonthlyChart(data);
    renderTimeChart(data);
    renderCustomerChart(data);
    renderAdvanceChart(data);
};

// 窗口大小变化时重绘图表
const resizeCharts = () => {
    statusChart.value?.resize();
    monthlyChart.value?.resize();
    timeChart.value?.resize();
    customerChart.value?.resize();
    advanceChart.value?.resize();
};

// API调用
const AdminHotelDataAnalysisApi = async () => {
    const { Success, Data } = await Post(`/DataAnalysis/SynthesizeStatistics`, {});

    if (Success && Data) {
        nextTick(() => {
            initCharts();
            updateAllCharts(Data);
        });
    } else {
        ElMessage.error('获取数据失败，请稍后重试');
    }
};

// 生命周期钩子
onMounted(() => {
    window.addEventListener('resize', resizeCharts);
});

onUnmounted(() => {
    window.removeEventListener('resize', resizeCharts);
    statusChart.value?.dispose();
    monthlyChart.value?.dispose();
    timeChart.value?.dispose();
    customerChart.value?.dispose();
    advanceChart.value?.dispose();
});

onBeforeMount(async () => {
    await AdminHotelDataAnalysisApi();
});
</script>

<style scoped lang="scss">
.large-data-container {
    width: 100%;
    height: 100vh;
    background-color: #0f1c30;
    color: #fff;
    padding: 20px;
    box-sizing: border-box;
    overflow: hidden;
    display: flex;
    flex-direction: column;
}

/* 顶部标题 */
.header-box {
    height: 80px;
    width: 100%;
    margin-bottom: 20px;
}

.header-title {
    font-size: 28px;
    font-weight: bold;
    color: #fff;
    text-align: center;
    line-height: 60px;
    text-shadow: 0 0 10px rgba(0, 255, 255, 0.5);
    letter-spacing: 2px;
}

/* 数据概览卡片 */
.data-overview {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
    height: 100px;
}

.data-card {
    flex: 1;
    margin: 0 10px;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 15px;
    box-sizing: border-box;
}

.card-value {
    font-size: 24px;
    font-weight: bold;
    color: #40e0d0;
    margin-bottom: 10px;
}

.card-title {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.8);
}

/* 图表容器 */
.charts-container {
    flex: 1;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: repeat(2, 1fr);
    grid-gap: 20px;
    padding-bottom: 20px;
}

.chart-item {
    padding: 15px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
}

.chart-title {
    font-size: 16px;
    margin-bottom: 15px;
    color: rgba(255, 255, 255, 0.9);
    text-align: center;
}

.chart-content {
    flex: 1;
    width: 100%;
}

.chart-monthly {
    grid-column: span 2;
}
</style>