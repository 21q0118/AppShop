<script lang="ts" setup>
import * as echarts from 'echarts'
import { onBeforeMount, onMounted } from 'vue'
import Venuestaticheader from '@/components/VenueAdministrators/header/Venuestaticheader.vue'

type EChartsOption = echarts.EChartsOption;

var chartDom
var myChart
var option: EChartsOption

var chartDom1
var myChart1
var option1: EChartsOption

var chartDom2
var myChart2
var option2

var chartDom3
var myChart3
var option3

var chartDom4
var myChart4
var option4: EChartsOption

onBeforeMount(() => {
  option = {
    title: {
      text: '各活动周内人流量',
      left: '4%'
    },
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['活动1', '活动2', '活动3', '活动4', '活动5']
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },

    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        name: '活动1',
        type: 'line',
        stack: 'Total',
        data: [120, 132, 101, 134, 90, 230, 210]
      },
      {
        name: '活动2',
        type: 'line',
        stack: 'Total',
        data: [220, 182, 191, 234, 290, 330, 310]
      },
      {
        name: '活动3',
        type: 'line',
        stack: 'Total',
        data: [150, 232, 201, 154, 190, 330, 410]
      },
      {
        name: '活动4',
        type: 'line',
        stack: 'Total',
        data: [320, 332, 301, 334, 390, 330, 320]
      },
      {
        name: '活动5',
        type: 'line',
        stack: 'Total',
        data: [820, 932, 901, 934, 1290, 1330, 1320]
      }
    ]
  }
  option1 = {
    title: {
      text: '各展厅拥挤率',
      left: '4%'
    },
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b} : {c} ({d}%)'
    },
    legend: {
      top: '80%'
    },
    series: [
      {
        name: '拥挤率',
        type: 'pie',
        radius: [20, 140],
        center: ['50%', '50%'],
        roseType: 'radius',
        itemStyle: {
          borderRadius: 5
        },
        label: {
          show: false
        },
        emphasis: {
          label: {
            show: true
          }
        },
        data: [
          { value: 40, name: '展厅1' },
          { value: 33, name: '展厅2' },
          { value: 28, name: '展厅3' },
          { value: 22, name: '展厅4' },
          { value: 20, name: '展厅5' }
        ]
      }
    ]
  }

  option2 = {
    title: {
      text: '预约人数\nVS实到人数',
      left: '4%'
    },
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['实到人数', '预约人数']
    },
    toolbox: {
      show: true,
      feature: {
        magicType: { show: true, type: ['line', 'bar'] }
      }
    },
    calculable: true,
    xAxis: [
      {
        type: 'category',
        // prettier-ignore
        data: ['活动1', '活动2', '活动3', '活动4', '活动5']
      }
    ],
    yAxis: [
      {
        type: 'value'
      }
    ],
    series: [
      {
        name: '实到人数',
        type: 'bar',
        data: [
          513, 435, 690, 980, 466, 354
        ],
        markPoint: {
          data: [
            { type: 'max', name: 'Max' },
            { type: 'min', name: 'Min' }
          ]
        },
        markLine: {
          data: [{ type: 'average', name: 'Avg' }]
        }
      },
      {
        name: '预约人数',
        type: 'bar',
        data: [
          639, 514, 795, 1125, 480, 354
        ],
        markPoint: {
          data: [
            { type: 'max', name: 'Max' },
            { type: 'min', name: 'Min' }
          ]
        },
        markLine: {
          data: [{ type: 'average', name: 'Avg' }]
        }
      }
    ]
  }

  option3 = {
    title: {
      text: '好评人数\nVS评分人数',
      left: '4%'
    },
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['好评人数', '评分人数']
    },
    toolbox: {
      show: true,
      feature: {
        magicType: { show: true, type: ['line', 'bar'] }
      }
    },
    calculable: true,
    xAxis: [
      {
        type: 'category',
        // prettier-ignore
        data: ['活动1', '活动2', '活动3', '活动4', '活动5']
      }
    ],
    yAxis: [
      {
        type: 'value'
      }
    ],
    series: [
      {
        name: '好评人数',
        type: 'bar',
        data: [
          410, 425, 651, 887, 410, 80
        ],
        markPoint: {
          data: [
            { type: 'max', name: 'Max' },
            { type: 'min', name: 'Min' }
          ]
        },
        markLine: {
          data: [{ type: 'average', name: 'Avg' }]
        }
      },
      {
        name: '评分人数',
        type: 'bar',
        data: [
          558, 439, 810, 951, 420, 115
        ],
        markPoint: {
          data: [
            { type: 'max', name: 'Max' },
            { type: 'min', name: 'Min' }
          ]
        },
        markLine: {
          data: [{ type: 'average', name: 'Avg' }]
        }
      }
    ]
  }

  option4 = {
    title: {
      text: '活动状态'
    },
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b} : {c}%'
    },
    legend: {
      data: ['未开始', '进行中', '已结束']
    },

    series: [
      {
        name: '状态',
        type: 'funnel',
        left: '10%',
        top: 60,
        bottom: 60,
        width: '80%',
        min: 0,
        max: 100,
        minSize: '0%',
        maxSize: '100%',
        sort: 'descending',
        gap: 2,
        label: {
          show: true,
          position: 'inside'
        },
        labelLine: {
          length: 10,
          lineStyle: {
            width: 1,
            type: 'solid'
          }
        },
        itemStyle: {
          borderColor: '#fff',
          borderWidth: 1
        },
        emphasis: {
          label: {
            fontSize: 20
          }
        },
        data: [
          { value: 100, name: '未开始' },
          { value: 66, name: '进行中' },
          { value: 33, name: '已结束' }
        ]
      }
    ]
  }
})
onMounted(() => {
  chartDom = document.getElementById('econ')
  myChart = echarts.init(chartDom)
  option && myChart.setOption(option)

  chartDom1 = document.getElementById('econ1')
  myChart1 = echarts.init(chartDom1)
  option1 && myChart1.setOption(option1)

  chartDom2 = document.getElementById('econ2')
  myChart2 = echarts.init(chartDom2)
  option2 && myChart2.setOption(option2)

  chartDom3 = document.getElementById('econ3')
  myChart3 = echarts.init(chartDom3)
  option3 && myChart3.setOption(option3)

  chartDom4 = document.getElementById('econ4')
  myChart4 = echarts.init(chartDom4)
  option4 && myChart4.setOption(option4)

})


</script>

<template>
  <el-container>
    <venuestaticheader />
    <el-main style="padding: 0;margin-top: 60px;height: 100%;background:rgb(250,250,250)">
      <div class="title"
           style="text-align: center;font-size: 40px;width:100%;z-index: 10;font-family: 'MiSans';background: #ecdcec">
        数据统计
      </div>
      <div style="height: 100vh;margin-top: 10px;">
        <div id="econ"
             style="width: 70%;height: 38%;box-shadow: 5px 5px 5px rgb(155,155,155);border: rgb(155,155,155);display: inline-block;background: white;border-radius: 5px;margin-left: 10px;vertical-align: top" />
        <div id="econ1"
             style="width: 27%;height: 48%;display: inline-block;box-shadow: 5px 5px 5px rgb(155,155,155);margin-left: 20px;background: white;border-radius: 5px;vertical-align: top" />
        <div id="econ2"
             style="width: 35%;height: 50%;box-shadow: 5px 5px 5px rgb(155,155,155);border: rgb(155,155,155);display: inline-block;background: white;border-radius: 5px;margin-left: 10px;vertical-align: top;margin-top: -70px" />
        <div id="econ3"
             style="width: 34.55%;height: 50%;box-shadow: 5px 5px 5px rgb(155,155,155);border: rgb(155,155,155);display: inline-block;background: white;border-radius: 5px;margin-left: 10px;vertical-align: top;margin-top: -70px" />
        <div id="econ4"
             style="width: 27%;height: 41.5%;display: inline-block;box-shadow: 5px 5px 5px rgb(155,155,155);margin-left: 19px;background: white;border-radius: 5px;margin-top: 10px;vertical-align: top" />
      </div>
    </el-main>
  </el-container>
</template>

<style scoped>

</style>