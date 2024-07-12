<template>
  <el-header ref="header" class="header" style="background: rgba(255,255,255,1)">
    <div class="logo" style="text-align: left;">
      <img src="@/assets/logo.png" style="height: 40px;margin-top: 15px">
    </div>
    <div class="toolbar" style="margin-top: -55px">
      <el-tooltip content="首页" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 54px; margin-top: 21px" @click="tovhome">
          <house />
        </el-icon>
      </el-tooltip>
      <el-tooltip content="查看应用" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 50px; margin-top: 20px" @click="tovapp">
          <Notification />
        </el-icon>
      </el-tooltip>
      <el-tooltip content="新增应用" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 50px; margin-top: 20px" @click="tovadd">
          <FolderAdd />
        </el-icon>
      </el-tooltip>
      <el-tooltip content="个人中心" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 50px; margin-top: 20px" @click="touser">
          <User />
        </el-icon>
      </el-tooltip>

      <el-tooltip content="数据统计" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 50px; margin-top: 20px" @click="tocount">
          <PieChart />
        </el-icon>
      </el-tooltip>
      <el-tooltip content="退出系统" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 8px; margin-top: 20px" @click="quit">
          <SwitchButton />
        </el-icon>
      </el-tooltip>
    </div>
  </el-header>
</template>
<style scoped>
.header {
  z-index: 10;
  text-align: right;
  font-size: 12px;
  position: fixed;
  width: 100%;
  box-shadow: 0px 1px 5px rgba(138, 134, 134, 0.87);
}

.el-icon:hover {
  color: #c05f6c;
}
</style>
<script lang="ts" setup>
import { Bell, House, SwitchButton } from '@element-plus/icons-vue'
import router from '@/router'
import store from '@/stores'

const tovhome = () => {
  router.push('/homeindex')
}
const tovapp = () => {
  router.push('/appDisplay')
}
const tovadd = () => {
  router.push('/add')
}
const touser = () => {
  router.push('/userInfo')
}
const tocount = () => {
  router.push('/sysecharts')
}
const quit = () => {
  store.dispatch('id_save', 0)
  store.dispatch('token_save', 0)
  store.dispatch('type_save', 0)
  store.dispatch('login_save', false)
  router.push('/')
}
</script>