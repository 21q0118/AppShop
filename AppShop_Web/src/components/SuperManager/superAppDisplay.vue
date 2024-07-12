<template>
  <el-container class="layout-container">
    <sysstaticheader />
    <el-main style="height: 100vh; background: #f0f2f5; padding: 0; z-index: 8">
      <div class="title"
        style="text-align: center; font-size: 20px; width: 100%; z-index: 10; margin-top: 60px; font-family: 'MiSans'; background: #6c757d; color: #ffffff; padding: 20px 0;">
        全部应用
      </div>
      <div style="margin-top: 15px; padding: 0 20px;">
        <el-table v-loading :cell-style="{ textAlign: 'center' }" :data="filterTableData"
          :header-cell-style="{ 'text-align': 'center' }" lazy max-height="75vh" style="width: 100%; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.1);">
          <el-table-column label="序号" prop="num" type="index" width="100" />
          <el-table-column label="应用图标" prop="icon" width="100">
            <template v-slot="act">
              <el-image :src="act.row.icon" style="width: 50px; height: 50px; border-radius: 5px;"></el-image>
            </template>
          </el-table-column>
          <el-table-column label="应用名称" prop="appName" />
          <el-table-column label="版本号" prop="version" />
          <el-table-column label="安装包大小(MB)" prop="size" />
          <el-table-column label="应用标签" prop="tag" />
          <el-table-column label="评分" prop="score" />
          <el-table-column label="发布时间" prop="createTime" />
          <el-table-column label="更新时间" prop="updateTime" />
          <el-table-column label="开发商" prop="corp" />
          <el-table-column label="操作" width="350">
            <template #header>
              <el-input v-model="search" placeholder="输入应用名称" size="default" style="width: 200px; margin-bottom: 10px;" />
            </template>
            <template v-slot="act">
              <el-button-group>
                <el-button size="default" type="primary" @click.native.stop="appInfo(act.row)">详情
                </el-button>
              </el-button-group>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-main>
  </el-container>
</template>

<style scoped>
.layout-container .el-main {
  padding: 0;
}

.layout-container .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 20px;
}

.el-input {
  --el-input-focus-border-color: #6c757d;
}

.el-table {
  border-radius: 10px;
  overflow: hidden;
}

.el-table th {
  background-color: #6c757d !important;
  color: #ffffff !important;
}

.el-table td {
  background-color: #ffffff !important;
}

.el-table-column label {
  font-weight: bold;
}

.el-button-group .el-button {
  margin-right: 5px;
}
</style>

<script lang="ts" setup>
import { computed, reactive, ref } from 'vue'
import axios from 'axios'
import store from '@/stores'
import router from '@/router'
import Sysstaticheader from '@/components/superManager/superHeader/Sysstaticheader.vue'
import { ElMessage } from 'element-plus'

const dialogVisible = ref(false)
const Tdata = reactive({
  tableData: []
})

var optionsForm = new Array(10);
optionsForm = ["游戏", "社交", "媒体", "办公", "购物", "教育", "医疗", "金融", "旅游", "摄影"]

axios.post('/api/appAll',
  {
    headers: {
      'Content-Type': 'application/json',
      token: store.state.token,
    }
  }).then(res => {
    for (let i = 0; i < res.data.data.length; i++) {
      Tdata.tableData.push({
        num: i + 1,
        appName: res.data.data[i].appName,
        version: res.data.data[i].version,
        size: parseFloat(res.data.data[i].size).toFixed(2), // 保留两位小数
        tag: optionsForm[res.data.data[i].tag - 1],
        updateTime: res.data.data[i].updateTime,
        createTime: res.data.data[i].create_time,
        id: res.data.data[i].id,
        icon: 'http://127.0.0.1:8080'+res.data.data[i].icon,
        score:parseFloat(res.data.data[i].score).toFixed(1),
        corp:res.data.data[i].corp
      })
    }
  })

const appInfo = (row) => {
  store.dispatch('appID_save', row.id)
  router.push('/superAppInfo')
}
const okhandle = (row) => {

}
const condet = reactive({
  content: ''
})

const noform = reactive({
  con: ''
})

const search = ref('')
const filterTableData = computed(() =>
  Tdata.tableData.filter(
    (data) =>
      !search.value ||
      data.appName.toLowerCase().includes(search.value.toLowerCase())
  )
)

</script>
