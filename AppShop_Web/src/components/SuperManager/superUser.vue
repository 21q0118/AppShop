<template>
  <el-container class="layout-container">
    <sysstaticheader />
    <el-main style="height: 100vh; background: #f0f2f5; padding: 0; z-index: 8">
      <div class="title"
        style="text-align: center; font-size: 20px; width: 100%; z-index: 10; margin-top: 60px; font-family: 'MiSans'; background: #6c757d; color: #ffffff; padding: 20px 0;">
        管理员
      </div>
      <div style="margin-top: 15px; padding: 0 20px;">
        <el-table v-loading :cell-style="{ textAlign: 'center' }" :data="filteredAdminTableData"
          :header-cell-style="{ 'text-align': 'center' }" lazy max-height="75vh"
          style="width: 100%; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.1);">
          <el-table-column label="序号" prop="num" type="index" width="100" />
          <el-table-column label="头像" prop="Supericon" width="100">
            <template v-slot="act">
              <el-image :src="act.row.Supericon" style="width: 50px; height: 50px; border-radius: 5px;"></el-image>
            </template>
          </el-table-column>
          <el-table-column label="用户名" prop="SuperuserName" />
          <el-table-column label="电话号码" prop="Supertelephone" />
          <el-table-column label="昵称" prop="SuperpetName" />
          <el-table-column label="注册公司" prop="Supercorp" />
          <el-table-column label="操作" width="350">
            <template #header>
              <el-input v-model="searchAdmin" placeholder="输入用户名" size="default"
                style="width: 200px; margin-bottom: 10px;" />
            </template>
            <template v-slot="act">
              <el-button-group>
                <el-button size="default" type="primary" @click.native.stop="appInfo(act.row)">撤销管理员权限
                </el-button>
                <el-button size="default" type="danger" @click.native.stop="delSuperUser(act.row)">注销账号
                </el-button>
              </el-button-group>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <div class="title"
        style="text-align: center; font-size: 20px; width: 100%; z-index: 10; margin-top: 60px; font-family: 'MiSans'; background: #6c757d; color: #ffffff; padding: 20px 0;">
        普通用户
      </div>
      <div style="margin-top: 15px; padding: 0 20px;">
        <el-table v-loading :cell-style="{ textAlign: 'center' }" :data="filteredAppTableData"
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
          <el-table-column label="操作" width="350">
            <template #header>
              <el-input v-model="searchApp" placeholder="输入应用名称" size="default"
                style="width: 200px; margin-bottom: 10px;" />
            </template>
            <template v-slot="act">
              <el-button-group>
                <el-button size="default" type="primary" @click.native.stop="userInfo(act.row)">注册为开发者
                </el-button>
                <el-button size="default" type="danger" @click.native.stop="delUser(act.row)">注销账号
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

const adminData = reactive({
  tableData: []
})

const appData = reactive({
  tableData: []
})

axios.post(`/api/searchUserByTag?tag=0`,
  {
    headers: {
      'Content-Type': 'application/json',
      token: store.state.token,
    }
  }).then(res => {
    const promises = res.data.data.map((user, index) => {
      adminData.tableData.push({
        num: index + 1,
        SuperuserName: user.userName,
        SuperpetName: user.petName,
        Supertelephone: user.telephone,
        Supericon: 'http://127.0.0.1:8080' + user.icon,
      });

      return axios.post(`/api/SearchCoprByTel?telephone=${user.telephone}`, {
        headers: {
          'Content-Type': 'application/json',
          token: store.state.token,
        }
      }).then(res => {
        adminData.tableData[index].Supercorp = res.data.data;
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

axios.post(`/api/searchUserByTag?tag=1`,
  {
    headers: {
      'Content-Type': 'application/json',
      token: store.state.token,
    }
  }).then(res => {
    for (let j = 0; j < res.data.data.length; j++) {
      appData.tableData.push({
        num: j + 1,
        userName: res.data.data[j].userName,
        petName: res.data.data[j].petName,
        telephone: res.data.data[j].telephone,
        icon: 'http://127.0.0.1:8080' + res.data.data[j].icon,
      })
    }
    console.log('所有应用请求已完成');
  }).catch(error => {
    console.error('应用请求出错', error);
  });

const appInfo = (row) => {
  store.dispatch('appID_save', row.id)
  router.push('/superAppInfo')
}


const userInfo = (row) => {
  store.dispatch('commitID_save', row.telephone)
  console.log("row.telephone = " + row.telephone)
  console.log("sdsds" + store.state.commitID)
  router.push('/superUserInfo')
}

const delUser = (row) => {
  axios.post(`/api/delUser?telephone=${row.telephone}`,
    {
      headers: {
        'Content-Type': 'application/json',
        token: store.state.token,
      }
    }).then(res => {
      ElMessage.success('注销成功')
      router.push('/superUser')
      console.log('所有应用请求已完成');
    }).catch(error => {
      console.error('应用请求出错', error);
    });
}


const delSuperUser = (row) => {
  axios.post(`/api/delUser?telephone=${row.Supertelephone}`,
    {
      headers: {
        'Content-Type': 'application/json',
        token: store.state.token,
      }
    }).then(res => {
      ElMessage.success('注销成功')
      router.push('/superUser')
      console.log('所有应用请求已完成');
    }).catch(error => {
      console.error('应用请求出错', error);
    });
}


const okhandle = (row) => {
  // 这里可以处理 okhandle 逻辑
}

const condet = reactive({
  content: ''
})

const noform = reactive({
  con: ''
})

const searchAdmin = ref('')
const searchApp = ref('')

const filteredAdminTableData = computed(() =>
  adminData.tableData.filter(
    (data) =>
      !searchAdmin.value ||
      data.SuperuserName.toLowerCase().includes(searchAdmin.value.toLowerCase())
  )
)

const filteredAppTableData = computed(() =>
  appData.tableData.filter(
    (data) =>
      !searchApp.value ||
      data.userName.toLowerCase().includes(searchApp.value.toLowerCase())
  )
)
</script>
