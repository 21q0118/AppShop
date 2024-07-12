<template>
  <div>
    <el-container class="layout-container">
      <staticheader />
      <el-main style="height: 100vh;background: rgb(255,255,255);padding: 0;z-index: 8">
        <div class="title"
             style="text-align: center;font-size: 40px;width:100%;z-index: 10;margin-top: 60px;font-family: 'MiSans';background: #ecdcec">
          通知中心
        </div>
        <div style="margin-top: 15px">
          <el-table v-loading :cell-style="{ textAlign: 'center' }"
                    :data="filterTableData"
                    lazy
                    max-height="85vh"
                    style="width: 100%;"
                    @row-click="opendia"
                    :header-cell-style="{ 'text-align': 'center' }"
          >
            <el-table-column label="序号" type="index" width="100" />
            <el-table-column label="状态" prop="isRead" />
            <el-table-column label="发送时间" prop="operateTime" />
            <el-table-column label="发信人" prop="invokeName" />
            <el-table-column label="操作" width="300">
              <template #header>
                <el-input v-model="search" placeholder="输入查询发信人" size="default" />
              </template>
              <template v-slot="act">
                <el-button-group>
                  <el-button size="default" type="danger"
                             @click.native.stop="deletehandle(act.row)">删除
                  </el-button>
                </el-button-group>
              </template>
            </el-table-column>
          </el-table>
        </div>
        <el-dialog
          v-model="dialogVisible"
          align-center
          width="30%"
          :before-close="diaclose"
        >
          <template #header>
            <el-text style="font-family: MiSans;font-size: 30px">内容</el-text>
          </template>
          <span>{{ condet.content }}</span>
          <template #footer>
      <span class="dialog-footer">
        <el-button @click="diaclose">关闭</el-button>
      </span>
          </template>
        </el-dialog>
      </el-main>
    </el-container>
  </div>
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

.header {
  z-index: 10;
  text-align: right;
  font-size: 12px;
  position: fixed;
  width: 100%;
  box-shadow: 0px 1px 5px rgba(138, 134, 134, 0.87);
}

.image {
  width: 100%;
  height: 310px;
  display: block;
  border: rgba(237, 237, 255, 0);
}
</style>
<script lang="ts" setup>
import { computed, reactive, ref } from 'vue'
import Staticheader from '@/components/RegularUsers/header/staticheader.vue'
import axios from 'axios'
import store from '@/stores'
import { ElMessage } from 'element-plus'

const dialogVisible = ref(false)
const Tdata = reactive({
  tableData: []
})
const search = ref('')
const filterTableData = computed(() =>
  Tdata.tableData.filter(
    (data) =>
      !search.value ||
      data.invokeName.toLowerCase().includes(search.value.toLowerCase())
  )
)
axios.get('/api/abc/users/getAllMessage', {
  headers: {
    token: store.state.token
  },
  params: {
    userId: store.state.id
  }
}).then(res => {
  for (let i = 0; i < res.data.data.length; i++) {
    Tdata.tableData.push({
      content: res.data.data[i].content,
      id: res.data.data[i].id,
      invokeName: res.data.data[i].invokeName,
      isRead: res.data.data[i].isRead,
      operateTime: res.data.data[i].operateTime
    })
  }
})
const deletehandle = (row) => {
  axios.get('/api/abc/messgae/deleteMessage', {
    headers: {
      token: store.state.token
    },
    params: {
      messageId: row.id,
      userId: store.state.id
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
const diaclose = () => {
  dialogVisible.value = false
  setTimeout(() => location.reload(), 500)
}
</script>