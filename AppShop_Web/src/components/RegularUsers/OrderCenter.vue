<template>
  <div>
    <el-container class="layout-container">
      <staticheader />
      <el-main style="height: 100vh;background: rgb(255,255,255);padding: 0;z-index: 8">
        <div class="title"
             style="text-align: center;font-size: 40px;width:100%;z-index: 10;margin-top: 60px;font-family: 'MiSans';background: #ecdcec">
          订单中心
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
            <el-table-column label="预约状态" prop="status" />
            <el-table-column label="下单时间" prop="time" />
            <el-table-column label="活动名称" prop="name" />
            <el-table-column label="操作" width="300">
              <template #header>
                <el-input v-model="search" placeholder="输入查询活动名称" size="default" />
              </template>
              <template v-slot="act">
                <el-button-group>
                  <el-button size="default" type="success"
                             v-if="act.row.status=='已完成'"
                             @click="radrawer=true;rate(act.row)">
                    评价
                  </el-button>
                  <el-button v-if="act.row.status=='未开始'" size="default" type="warning"
                             @click="ctrlz(act.row)">
                    撤销
                  </el-button>
                  <el-button size="default" type="danger"
                             @click="deletehandle(act.row)">删除
                  </el-button>
                </el-button-group>
              </template>
            </el-table-column>
          </el-table>
        </div>
        <el-drawer
          v-model="radrawer"
          :direction="'rtl'"
          append-to-body
          size="400"
        >
          <template #header>
            <el-text style="font-family: MiSans;font-size: 40px">评价活动</el-text>
          </template>
          <el-form label-position="top" size="large">
            <el-form-item label="评分">
              <el-rate v-model="raform.rate" :colors="colors" clearable size="large" />
            </el-form-item>
            <el-form-item label="评价内容">
              <el-input v-model="raform.content" :autosize="{minRows:5,maxRows:10}" clearable type="textarea" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="ratesub">提交</el-button>
              <el-button @click="radrawer=false">取消</el-button>
            </el-form-item>
          </el-form>
        </el-drawer>
      </el-main>
    </el-container>
  </div>
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

.header {
  z-index: 10;
  text-align: right;
  font-size: 12px;
  position: fixed;
  width: 100%;
  box-shadow: 0px 1px 5px rgba(138, 134, 134, 0.87);
}

.el-input {
  --el-input-focus-border-color: #c05f6c;
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

const colors = ref(['#99A9BF', '#F7BA2A', '#FF9900'])
const raform = reactive({
  rate: '',
  content: ''
})
const radrawer = ref(false)
const reserveidform = reactive({
  reserveId: ''
})
const rate = (row) => {
  reserveidform.reserveId = row.reserveId
}
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
const deletehandle = (row) => {
  axios.get('/api/abc/users/logicRemoveReserve', {
    headers: {
      token: store.state.token
    },
    params: {
      reserveId: row.reserveId,
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
axios.get('/api/abc/users/mobilegetAllReserves', {
  headers: {
    token: store.state.token
  },
  params: {
    userId: store.state.id
  }
}).then(res => {
  console.log(res.data.data)
  for (let i = 0; i < res.data.data.length; i++) {
    for (let j = 0; j < res.data.data[i].length; j++) {
      Tdata.tableData.push({
        status: res.data.data[i][j].reserveStatus,
        time: res.data.data[i][j].operateTime,
        reserveId: res.data.data[i][j].id,
        name: res.data.data[i][j].activity.activityName
      })
    }
  }
})
const ratesub = () => {
  const form = reactive({
    content: raform.content,
    reserveId: reserveidform.reserveId,
    score: raform.rate,
    userId: store.state.id
  })
  if (form.content != '' && form.score != '') {
    axios.post('/api/abc/users/commentByUser', JSON.stringify(form), {
      headers: {
        'Content-Type': 'application/json',
        token: store.state.token
      }
    }).then(res => {
      if (res.data.code == 400) {
        ElMessage.error(res.data.msg)
      } else if (res.data.code == 200) {
        ElMessage.success('评价成功')
        setTimeout(() => location.reload(), 500)
      }
    })
  } else {
    ElMessage.error('请完整填写')
  }

}
const ctrlz = (row) => {
  axios.get('/api/abc/users/revokeReserveSingle', {
    headers: {
      token: store.state.token
    },
    params: {
      reserveId: row.reserveId
    }
  }).then(res => {
    if (res.data.code == 400) {
      ElMessage.error(res.data.msg)
    } else if (res.data.code == 200) {
      ElMessage.success('撤销成功')
      setTimeout(() => location.reload(), 500)
    }
  })
}
</script>