<template>
  <el-container class="layout-container">
    <venuestaticheader />
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
              <el-input v-model="search" placeholder="输入查询时间" size="default" style="width: 200px" />
              <el-button style="margin-left: 20px" type="primary" @click="realse">发布</el-button>
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
      <el-dialog v-model="dialogVisible">
        <template #header>
          <el-text style="font-family: MiSans;font-size: 30px">发布通知</el-text>
        </template>
      <div style="margin-top: 15px;padding: 20px">
        <el-form label-position="top" size="large">
          <el-form-item label="通知内容">
            <el-input v-model="noform.con" :autosize="{minRows:20,maxRows:100}" type="textarea" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSubmit">发布</el-button>
            <el-button @click="dialogVisible=false">取消</el-button>
          </el-form-item>
        </el-form>
      </div>
      </el-dialog>

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
import Venuestaticheader from '@/components/VenueAdministrators/header/Venuestaticheader.vue'
import axios from 'axios'
import store from '@/stores'
import { ElMessage } from 'element-plus'

const dialogVisible = ref(false)
const Tdata = reactive({
  tableData: []
})

axios.get('/api/abc/managers/getMessageSendByOwn', {
  headers: {
    token: store.state.token
  },
  params: {
    managerId: store.state.id
  }
}).then(res => {
  console.log(res)
  for (let i = 0; i < res.data.data.length; i++) {
    Tdata.tableData.push({
      content: res.data.data[i].content,
      operateTime: res.data.data[i].operateTime,
      id: res.data.data[i].id
    })
  }
})
const deletehandle = (row) => {
  axios.get('/api/abc/managers/deleteMessageSendByOwn', {
    headers: {
      token: store.state.token
    },
    params: {
      messageId: row.id,
      managerId: store.state.id
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
const opendia = (row, event, column) => {
  dialogVisible.value = true
  condet.content = row.content
  axios.get('/api/abc/messgae/readMessage', {
    headers: {
      token: store.state.token
    },
    params: {
      messageId: row.id,
      userId: store.state.id
    }
  })
}
const noform = reactive({
  con: ''
})
const onSubmit = () => {
  if (noform.con != '') {
    axios.get('/api/abc/managers/sendMessage', {
      params: {
        String: noform.con,
        managerId: store.state.id
      },
      headers: {
        token: store.state.token
      }
    }).then(res => {
      if (res.data.code == 400) {
        ElMessage.error(res.data.msg)
      } else if (res.data.code == 200) {
        ElMessage.success(res.data.data)
        setTimeout(() => location.reload(), 600)
      }
    })
  } else {
    ElMessage.error('请完整输入')
  }

}
const search = ref('')
const filterTableData = computed(() =>
  Tdata.tableData.filter(
    (data) =>
      !search.value ||
      data.operateTime.toLowerCase().includes(search.value.toLowerCase())
  )
)
const realse = () => {
  dialogVisible.value = true
}
</script>