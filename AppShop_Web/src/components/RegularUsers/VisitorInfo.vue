<template>
  <el-container class="layout-container">
    <staticheader />
    <el-main style="height: 100vh;background: rgb(255,255,255);padding: 0;z-index: 8">
      <div class="title"
           style="text-align: center;font-size: 40px;width:100%;z-index: 10;margin-top: 60px;font-family: 'MiSans';background: #ecdcec">
        参观人信息
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
          <el-table-column label="参观人ID" prop="visitorId" />
          <el-table-column label="姓名" prop="name" />
          <el-table-column label="证件号码" prop="idnum" />
          <el-table-column label="电话号码" prop="tel" />
          <el-table-column label="操作">
            <template #header>
              <el-input v-model="search" placeholder="输入查询参观人姓名" size="default" style="width: 200px" />
              <el-button style="margin-left: 20px" type="primary" @click="drawer=true">新增</el-button>
            </template>
            <template v-slot="act">
              <el-button-group>
                <el-button size="default" type="danger"
                           @click="deletehandle(act.row)">删除
                </el-button>
              </el-button-group>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <el-drawer
        v-model="drawer"
        :direction="'rtl'"
        append-to-body
        size="500"
      >
        <template #header>
          <el-text style="font-family: MiSans;font-size: 40px">新增预约人</el-text>
        </template>
        <el-form label-position="top" size="large">
          <el-form-item label="姓名">
            <el-input v-model="form.realName" />
          </el-form-item>
          <el-form-item label="电话">
            <el-input v-model="form.telephone" />
          </el-form-item>
          <el-form-item label="身份证号">
            <el-input v-model="form.identificationNum" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="submit">确定</el-button>
            <el-button @click="drawer=false">取消</el-button>
          </el-form-item>
        </el-form>
      </el-drawer>
    </el-main>
  </el-container>
</template>
<style scoped>
.layout-container .el-main {
  padding: 0;
}

.el-input {
  --el-input-focus-border-color: #c05f6c;
}
.layout-container .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 20px;
}
</style>
<script lang="ts" setup>
import { computed, reactive, ref } from 'vue'
import Staticheader from '@/components/RegularUsers/header/staticheader.vue'
import axios from 'axios'
import store from '@/stores'
import { ElMessage } from 'element-plus'

const Tdata = reactive({
  tableData: []
})
axios.get('/api/abc/users/getAllVisitors', {
  headers: {
    token: store.state.token
  },
  params: {
    userId: store.state.id
  }
}).then(res => {
  for (let i = 0; i < res.data.data.length; i++) {
    Tdata.tableData.push({
      visitorId: res.data.data[i].id,
      name: res.data.data[i].realName,
      idnum: res.data.data[i].identificationNum,
      tel: res.data.data[i].telephone
    })
  }
})


const search = ref('')
const form = reactive({
  identificationNum: '',
  realName: '',
  telephone: '',
  userId: store.state.id
})
const filterTableData = computed(() =>
  Tdata.tableData.filter(
    (data) =>
      !search.value ||
      data.name.toLowerCase().includes(search.value.toLowerCase())
  )
)
const deletehandle = (row) => {
  axios.get('/api/abc/users/deleteVisitor', {
    headers: {
      token: store.state.token
    },
    params: {
      userId: store.state.id,
      visitorId: row.visitorId
    }
  }).then(res => {
    if (res.data.code == 400) {
      ElMessage.error(res.data.msg)
    } else if (res.data.code == 200) {
      ElMessage.success('删除成功')
      setTimeout(() => location.reload(), 500)
    }

  })
}
const drawer = ref(false)

const submit = () => {
  if (form.telephone != '' && form.realName != '' && form.identificationNum != '') {
  axios.post('/api/abc/users/addVisitor', JSON.stringify(form), {
    headers: {
      'Content-Type': 'application/json',
      token: store.state.token
    }
  }).then(res => {
    if (res.data.code == 400) {
      ElMessage.error(res.data.msg)
    } else if (res.data.code == 200) {
      ElMessage.success(res.data.data)
      setTimeout(() => location.reload(), 500)
    }
  })
  } else {
    ElMessage.error('请填入完整信息')
  }
}
</script>