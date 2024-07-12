<template>
  <div>
    <div class="left">
      <div class="title">
        <el-text class="title">APP应用商店</el-text>
      </div>
      <div class="split">
      </div>
      <div class="title2">
        <el-text class="title2">管理系统</el-text>
      </div>
    </div>
    <div class="right">
      <div class="login">
        <el-text class="loginfont" style="font-family: 'MiSans'">出错啦！</el-text>
        <div class="photo">
          <img class="gifphoto" src="../assets/fail.gif">
        </div>
        <div class="loginbutton">
          <el-button color="#c05f6c" style="width: 100px;font-family: 'MiSans';"
                     @click="returnHome">返回主页
          </el-button>
        </div>
      </div>
    </div>
    <img class="background" src="../assets/background.jpg">
  </div>
</template>
<style scoped>
.gifphoto {
  width: 35%;
  margin-left: 5%;
  margin-top: 20%;
}

.background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -10;
  background-repeat: no-repeat;
  background-size: cover;
  background-attachment: fixed;
}

.title {
  font-family: "MiSans";
  font-weight: bold;
  font-size: 55px;
  color: #333333;
  margin-top: 34%;
  margin-left: 17%;
}

.split {
  background: #c00000;
  height: 10px;
  width: 325px;
  margin-left: 31.2%;
  margin-top: 10px;
  margin-bottom: 10px;
}

.title2 {
  font-family: "MiSans";
  font-size: 40px;
  color: #333333;
  font-weight: normal;
  margin-left: 17%;
}

.left {
  position: absolute;
  left: 0;
  width: 70%;
  height: 100%;
}

.right {
  position: absolute;
  right: 0;
  background: rgba(255, 255, 255, 0.18);
  width: 30%;
  height: 100%;
  box-shadow: -1px 0px 5px rgba(138, 134, 134, 0.87);
  display: flex;
  justify-content: center;
  align-items: center;
}

.login {
  margin-left: 37%;
  font-family: "MiSans";
  font-size: 30px;
  color: #333333;
  margin-top: -10%;
}

.loginfont {
  font-family: "MiSans";
  font-size: 30px;
  color: #333333;
}

.account {
  width: 350px;
  margin-left: 4px;
  margin-top: 50px;
}

.password {
  width: 200px;
  margin-left: 4px;
  margin-top: 50px;
}

.loginbutton {
  margin-left: 4px;
  margin-top: 50px;
}

.el-input__wrapper {
  background: rgba(255, 255, 255, 0.6);
}

.el-input {
  --el-input-focus-border-color: #c05f6c;
}
</style>
<script lang="ts" setup>
import router from '@/router'

const returnHome = () => {
  router.push('/')
}
</script>
  
  