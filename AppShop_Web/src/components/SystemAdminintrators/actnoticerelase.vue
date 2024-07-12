<template>
  <el-container class="layout-container">
    <sysstaticheader />
    <el-main style="height: 100vh;background: rgb(255,255,255);padding: 0;z-index: 8">
      <div class="title"
           style="text-align: center;font-size: 40px;width:100%;z-index: 10;margin-top: 60px;font-family: 'MiSans';background: #ecdcec">
        通知中心
      </div>
      <div style="margin-top: 15px">
        <el-table v-loading :cell-style="{ textAlign: 'center' }"
                  :data="filterTableData"
                  :header-cell-style="{ 'text-align': 'center' }"
                  lazy
                  max-height="85vh"
                  style="width: 100%;"
        >
          <el-table-column label="序号" type="index" width="100" />
          <el-table-column label="内容" prop="content" />
          <el-table-column label="发送时间" prop="operateTime" />
          <el-table-column label="操作" width="350">
            <template #header>
              <el-input v-model="search" placeholder="输入查询时间" size="default" style="width:200px;" />
            </template>
            <template v-slot="act">
              <el-button-group>
                <el-button size="default" type="danger"
                           @click.native.stop="deletehandle(act.row)">撤销
                </el-button>
              </el-button-group>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div style="margin-top: 15px;padding: 20px">
        <el-dialog v-model="dialogVisible" title="发布通知">
          <el-form>
            <el-form-item label="通知内容">
              <el-input v-model="noform.con" :autosize="{minRows:20,maxRows:100}" type="textarea" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="onSubmit">发布</el-button>
              <el-button>取消</el-button>
            </el-form-item>
          </el-form>
        </el-dialog>
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
import Sysstaticheader from '@/components/SystemAdminintrators/header/Sysstaticheader.vue'
import { ElMessage } from 'element-plus'

const dialogVisible = ref(false)
const Tdata = reactive({
  tableData: []
})

axios.get('/api/abc/superManager/getMessageSendByStadium', {
  headers: {
    token: store.state.token
  },
  params: {
    stadiumId: store.state.user_home_card_id,
    superManagerId: store.state.id
  }
}).then(res => {
  for (let i = 0; i < res.data.data.length; i++) {
    Tdata.tableData.push({
      content: res.data.data[i].content,
      operateTime: res.data.data[i].operateTime,
      id: res.data.data[i].id
    })
  }
})
const deletehandle = (row) => {
  axios.get('/api/abc/superManager/deleteMessageSendByOwn', {
    headers: {
      token: store.state.token
    },
    params: {
      messageId: row.id,
      superManagerId: store.state.id
    }
  }).then(res => {
    if (res.data.code == 400) {
      ElMessage.error(res.data.msg)
    } else if (res.data.code == 200) {
      ElMessage.success(res.data.data)
      setTimeout(() => location.reload(), 600)
    }
  })
}
const okhandle = (row) => {

}
const condet = reactive({
  content: ''
})

const noform = reactive({
  con: ''
})
const onSubmit = () => {
  axios.get('/api/abc/superManager/sendMessage', {
    params: {
      content: noform.con,
      managerId: store.state.id
    },
    headers: {
      token: store.state.token
    }
  })
}
const search = ref('')
const filterTableData = computed(() =>
  Tdata.tableData.filter(
    (data) =>
      !search.value ||
      data.operateTime.toLowerCase().includes(search.value.toLowerCase())
  )
)
const nosu = () => {
  dialogVisible.value = true
}
</script>