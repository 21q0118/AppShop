<template>

  <el-header ref="header" :style="{'background': bgColor}" class="header">
    <div class="logo" style="text-align: left;">
      <img src="@/assets/logo.png" style="height: 40px;margin-top: 15px">
    </div>
    <div class="toolbar" style="margin-top: -55px">
      <el-tooltip content="首页" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 54px; margin-top: 21px" @click="tohome">
          <house />
        </el-icon>
      </el-tooltip>
      <el-tooltip content="参观人信息" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 54px; margin-top: 21px" @click="tovisitor">
          <View />
        </el-icon>
      </el-tooltip>
      <el-tooltip content="订单中心" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 50px; margin-top: 20px" @click="toorder">
          <Tickets />
        </el-icon>
      </el-tooltip>
      <el-tooltip content="通知中心" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 50px; margin-top: 20px" @click="tonotice">
          <Bell />
        </el-icon>
      </el-tooltip>
      <el-tooltip content="个人中心" effect="light">
        <el-icon color="rgb(51,48,48)" size="20" style="margin-right: 50px; margin-top: 20px" @click="topersonal">
          <User />
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
import { ref } from 'vue'
import router from '@/router'
import store from '@/stores'

let bgColor = ref<string>(`rgba(255, 255, 255, 0)`)

// 动态设置背景色透明度
const setBgColor = (v: number) => {
  bgColor.value = `rgba(250,250,250,${v})`
}
defineExpose({ setBgColor })
const tohome = () => {
  router.push('/Home')
}
const tovisitor = () => {
  router.push('/Visitor')
}
const toorder = () => {
  router.push('/Order')
}
const tonotice = () => {
  router.push('/Notice')
}
const topersonal = () => {
  router.push('/Personal')
}
const quit = () => {
  store.dispatch('id_save', 0)
  store.dispatch('token_save', 0)
  store.dispatch('type_save', 0)
  store.dispatch('login_save', false)
  router.push('/')
}
</script>