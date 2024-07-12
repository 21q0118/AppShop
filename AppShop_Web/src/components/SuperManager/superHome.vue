<template>
  <div>
    <el-container class="layout-container">
      <Sysanimationheader ref="myHeader" />
      <el-main style="height: 100vh;">

        <div class="welcome" style="width: 100% ;height: 100%">
          <div class="welcome1">APP应用商店管理系统</div>
          <div class="welcome2">超级管理员</div>
          <div class="font" @click="scroll">
          </div>
        </div>
      </el-main>
      <el-footer style="height: auto;background: rgb(250,250,250);padding: 0;z-index: 8">

      </el-footer>
    </el-container>
    <img class="background" src="../../assets/background.jpg">
  </div>
</template>
<style scoped>
.background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -10;
  background-repeat: no-repeat;
}

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

.welcome1 {
  position: absolute;
  font-family: "MiSans";
  font-weight: bold;
  font-size: 60px;
  color: #ffffff;
  text-align: center;
  left: 45%;
  margin-left: -250px;
  top: 50%;
  margin-top: -72.67px;
}

.welcome2 {
  position: absolute;
  font-family: "MiSans";
  font-weight: normal;
  font-size: 30px;
  color: #ffffff;
  text-align: center;
  left: 54%;
  margin-left: -135px;
  top: 55%;
  margin-top: -33px;
}


.tel {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
}

.location {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
}

.time {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
}

.bottom {
  margin-top: 13px;
  line-height: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 2s;
}

.image {
  width: 100%;
  height: 310px;
  display: block;
  border: rgba(237, 237, 255, 0);
}
</style>
<script lang="ts" setup>

import Sysanimationheader from '@/components/superManager/superHeader/Sysanimationheader.vue'

</script>