<template>
  <div>
    <div class="left">
      <div class="title">
        <el-text class="title">场馆预约系统</el-text>
      </div>
      <div class="split">
      </div>
      <div class="title2">
        <el-text class="title2">欢迎使用</el-text>
      </div>
    </div>
    <div class="right">
      <div class="login">
        <div>
          <img src="@/assets/logotext.png" style="height: 30px;">
        </div>
        <el-text class="loginfont" style="font-family: 'MiSans'">登录</el-text>
        <div class="account">
          <el-text style="font-family: 'MiSans'">邮箱</el-text>
          <el-input v-model="form.email" placeholder="请输入邮箱"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
        </div>
        <div class="password">
          <el-text style="font-family: 'MiSans'">验证码</el-text>
          <el-input v-model="form.judgeCode" maxlength="6" placeholder="请输入验证码"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
          <el-button color="#c05f6c"
            style="font-family: 'MiSans'; margin-top: -80px;margin-left: 230px;height: 35px;width: 120px;"
            @click="getCode">获取验证码
          </el-button>
        </div>
        <div class="loginbutton">
          <el-button color="#c05f6c" style="width: 100px;font-family: 'MiSans';" @click="login">登录</el-button>
          <el-link style="color: rgb(84,168,255);margin-top: -17px;margin-left: 150px;" type="primary" @click="login2">
            手机号密码登录
          </el-link>
          <el-link style="color: rgb(84,168,255);margin-top: 15px;margin-left: -70px" type="primary" @click="register">
            新用户注册
          </el-link>
        </div>
      </div>
    </div>
    <img class="img1" src="../../assets/background.jpg">
  </div>
</template>
<style scoped>
.img1 {
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

import { reactive } from 'vue'
import axios from 'axios'
import { useStore } from 'vuex'
import { ElMessage } from 'element-plus'

const store = useStore()

const form = reactive({
  email: '',
  judgeCode: ''
})
const login2 = () => {
  router.push('/login2')
}
const register = () => {
  router.push('/register')
}
const getCode = () => {
  if (form.email == '') {
    ElMessage.error('请输入邮箱')
  } else {
    axios.get('/api/abc/login/generateCode', {
      params: {
        email: form.email
      }
    })
  }
}
const login = () => {
  if (form.email == '' || form.judgeCode == '') {
    ElMessage.error('请完整输入邮箱地址和验证码！')
  }
  else {
    axios.get('/api/abc/login/loginByJudgeCode', {
      params: {
        email: form.email,
        judgeCode: form.judgeCode
      }
    }).then(res => {
      if (res.data.code == 200) {
        ElMessage.success('登录成功')
        store.dispatch('id_save', res.data.data.id)
        store.dispatch('token_save', res.data.data.token)
        store.dispatch('type_save', res.data.data.type)
        store.dispatch('login_save', true)
        if (store.state.type == '用户') {
          router.push('/Home')
        } else if (store.state.type == '场馆管理员') {
          console.log(store)
          router.push('/VenueHome')
        } else if (store.state.type == '超级管理员') {
          console.log(store)
          router.push('/syshome')
        }
      } else if (res.data.code == 400) {
        ElMessage.error('邮箱或验证码有误')
      }
    })
  }
}
</script>

