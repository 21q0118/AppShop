<template>
  <el-container class="layout-container">
    <sysstaticheader />
    <el-main style="height: 100vh; background: #f0f2f5; padding: 0; z-index: 8">
      <div class="title"
        style="text-align: center; font-size: 20px; width: 100%; z-index: 10; margin-top: 60px; font-family: 'MiSans'; background: #6c757d; color: #ffffff; padding: 20px 0;">
        申请管理员列表
      </div>
      <div style="margin-top: 15px; padding: 0 20px;">
        <el-table v-loading :cell-style="{ textAlign: 'center' }" :data="filterTableData"
          :header-cell-style="{ 'text-align': 'center' }" lazy max-height="75vh"
          style="width: 100%; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.1);">
          <el-table-column label="序号" prop="num" type="index" width="100" />
          <el-table-column label="头像" prop="icon" width="100">
            <template v-slot="act">
              <el-image :src="act.row.icon" style="width: 50px; height: 50px; border-radius: 5px;"></el-image>
            </template>
          </el-table-column>
          <el-table-column label="用户名" prop="userName" />
          <el-table-column label="电话号码" prop="telephone" />
          <el-table-column label="昵称" prop="petName" />
          <el-table-column label="注册公司" prop="corp" />
          <el-table-column label="操作" width="350">
            <template #header>
              <el-input v-model="search" placeholder="输入应用名称" size="default"
                style="width: 200px; margin-bottom: 10px;" />
            </template>
            <template v-slot="act">
              <el-button-group>
                <el-button size="default" type="primary" @click.native.stop="agree(act.row)">同意
                </el-button>
                <el-button size="default" type="danger" @click.native.stop="disagree(act.row)">拒绝
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

axios.post('/api/allCommit',
  {
    headers: {
      'Content-Type': 'application/json',
      token: store.state.token,
    }
  }).then(res => {
    const promises = res.data.data.map((user, index) => {
      Tdata.tableData.push({
        num: index + 1,
        telephone: user.telephone,
        corp: user.corp,
        //Supericon: 'http://127.0.0.1:8080' + user.icon,
      });
      return axios.post(`/api/userInfo?telephone=${user.telephone}`, {
        headers: {
          'Content-Type': 'application/json',
          token: store.state.token,
        }
      }).then(res => {
        Tdata.tableData[index].userName = res.data.data.user.userName;
        Tdata.tableData[index].petName = res.data.data.user.petName;
        Tdata.tableData[index].icon = 'http://127.0.0.1:8080' + res.data.data.user.icon
      });
    });

    Promise.all(promises).then(() => {
      console.log('所有管理员请求已完成');
    }).catch(error => {
      console.error('管理员请求出错', error);
    });
  }).catch(error => {
    console.error('初始管理员请求出错', error);
  });

const agree = (row) => {
  axios.post('/api/agreeManager',
    {
      headers: {
        'Content-Type': 'application/json',
        token: store.state.token,
      },
      telephone: row.telephone,
      corp: row.corp,
    }).then(res => {
      console.log(res)
      if (res.data.code === 200) {
        ElMessage.success('操作成功')
        router.push('/superUser')
      } else if (res.data.code === 400) {
        ElMessage.error('操作失败')
      }
    }).catch(err => {
      console.error(err);
      ElMessage.error('操作失败，请重试！');
    });
}

const disagree = (row) => {
  axios.post('/api/disagreeManager',
    {
      headers: {
        'Content-Type': 'application/json',
        token: store.state.token,
      },
      telephone: row.telephone,
      corp: row.corp,
    }).then(res => {
      console.log(res)
      if (res.data.code === 200) {
        ElMessage.success('操作成功')
        router.push('/superUser')
      } else if (res.data.code === 400) {
        ElMessage.error('操作失败')
      }
    }).catch(err => {
      console.error(err);
      ElMessage.error('操作失败，请重试！');
    });
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
      data.userName.toLowerCase().includes(search.value.toLowerCase())
  )
)

</script>
