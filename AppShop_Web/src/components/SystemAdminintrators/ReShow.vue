<template>
  <el-container class="layout-container">
    <sysstaticheader />
    <el-main style="height: 100vh;background: rgb(255,255,255);padding: 0;z-index: 8">
      <div class="title"
           style="text-align: center;font-size: 40px;width:100%;z-index: 10;margin-top: 60px;font-family: 'MiSans';background: #ecdcec">
        预约人信息
      </div>
      <div style="margin-top: 15px">
        <el-table v-loading :cell-style="{ textAlign: 'center' }"
                  :data="filterTableData"
                  :default-sort="{ prop: 'time', order: 'ascending' }" :header-cell-style="{ 'text-align': 'center' }"
                  lazy
                  max-height="85vh"
                  style="width: 100%;"
        >
          <el-table-column label="序号" type="index" width="100" />
          <el-table-column label="姓名" prop="name" />
          <el-table-column label="证件号码" prop="id" />
          <el-table-column label="电话号码" prop="tel" />
          <el-table-column label="操作" width="600">
            <template #header>
              <el-input v-model="search" placeholder="输入查询参观人姓名" size="default" style="width: 200px" />
              <el-button style="margin-left: 20px" type="primary" @click="tofile">导出为文件</el-button>
              <el-button style="margin-left: 20px" type="primary" @click="comment">查看评价</el-button>
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
  --el-input-focus-border-color: #c05f6c;
}
</style>
<script lang="ts" setup>
import { computed, reactive, ref } from 'vue'
import axios from 'axios'
import store from '@/stores'
import router from '@/router'
import Sysstaticheader from '@/components/SystemAdminintrators/header/Sysstaticheader.vue'

const Tdata = reactive({
  tableData: []
})
const search = ref('')
const filterTableData = computed(() =>
  Tdata.tableData.filter(
    (data) =>
      !search.value ||
      data.name.toLowerCase().includes(search.value.toLowerCase())
  )
)
const handlename = (name) => {
  if (name.length == 2) {
    name = name.substring(0, 1) + '*' // 截取name 字符串截取第一个字符，
    return name // 张三显示为张*
  } else if (name.length == 3) {
    name = name.substring(0, 1) + '*' + name.substring(2, 3) // 截取第一个和第三个字符
    return name // 李思思显示为李*思
  } else if (name.length > 3) {
    name = name.substring(0, 1) + '*' + '*' + name.substring(3, name.length) // 截取第一个和大于第4个字符
    return name // 王五哈哈显示为王**哈
  }
}
const cardHide = (card) => {
  const reg = /^(.{6})(?:\d+)(.{4})$/ // 匹配身份证号前6位和后4位的正则表达式
  const maskedIdCard = card.replace(reg, '$1******$2') // 身份证号脱敏，将中间8位替换为“*”
  return maskedIdCard // 输出：371782******5896
}
// 手机号做脱敏处理
const phoneHide = (phone) => {
  let reg = /^(1[3-9][0-9])\d{4}(\d{4}$)/ // 定义手机号正则表达式
  phone = phone.replace(reg, '$1****$2')
  return phone // 185****6696
}
axios.get('/api/abc/superManager/searchActivityVisitorInf', {
  params: {
    activityId: store.state.user_event_card_id
  },
  headers: {
    token: store.state.token
  }
}).then(res => {
  for (let i = 0; i < res.data.data.length; i++) {
    Tdata.tableData.push({
      name: res.data.data[i].realName,
      id: res.data.data[i].identificationNum,
      tel: res.data.data[i].telephone
    })
  }
})
const tofile = () => {
  axios.get('/api/abc/superManager/generateVisitorFile', {
    params: {
      activityId: store.state.user_event_card_id
    },
    headers: {
      token: store.state.token
    }
  }).then(res => {
    window.open(res.data.data, '_blank')
  })
}
const comment = () => {
  router.push('/syscom')
}
</script>