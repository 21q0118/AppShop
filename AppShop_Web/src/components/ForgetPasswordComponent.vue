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
        <div>
          <img src="@/assets/logo.png" style="height: 30px;">
        </div>
        <el-text class="loginfont" style="font-family: 'MiSans'">修改密码</el-text>
        <div class="account">
          <el-text style="font-family: 'MiSans'">手机号</el-text>
          <el-input v-model="form.telephone" placeholder="请输入手机号"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
        </div>
        <div class="password">
          <el-text style="font-family: 'MiSans'">新密码</el-text>
          <el-input v-model="form.password" placeholder="请输入密码" show-password
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
          </div>
        <div class="password">
          <el-text style="font-family: 'MiSans'">确认密码</el-text>
          <el-input v-model="form.repeatPassword" placeholder="请重复密码" show-password
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
        </div>
        <div class="loginbutton">
          <el-button color="#c05f6c" style="width: 100px;font-family: 'MiSans';" @click="back">返回</el-button>
          <el-button color="#c05f6c" style="width: 100px;font-family: 'MiSans';" @click="login">修改密码</el-button>
        </div>
      </div>
    </div>
    <img class="img1" src="../assets/background.jpg">
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
  margin-top: 30px;
}

.password {
  width: 350px;
  margin-left: 4px;
  margin-top: 30px;
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
import axios from 'axios'
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useStore } from 'vuex'

const store = useStore()



const reset = () => {
  router.push('/resetpassword')
}
const form = reactive({
  password: '',
  telephone: '',
  repeatPassword: ''
})

if(store.state.islogin == true)
{
  form.telephone = store.state.id
}

const back = () => {
  if (store.state.islogin == true) {
    router.push('/userInfo')
  } else {
    router.push('/')
  }
}

const login = () => {
  //console.log(form)
  if (form.password == '' || form.telephone == '' || form.repeatPassword == '') {
    ElMessage.error('请完整输入手机号和密码！')
  } else if (form.password != form.repeatPassword) {
    ElMessage.error('两次输入的密码不一致！')
  }
  else {
    axios.post('/api/updatePw',
      {
        password: form.password,
        telephone: form.telephone

      }).then(res => {
        console.log(res)
        if (res.data.code == 200) {
          router.push('/RetrSuccess')
          ElMessage.success('密码修改成功！')

          //store.dispatch('id_save', res.data.data.User.telephone)
          //store.dispatch('token_save', res.data.data.token)
          //store.dispatch('type_save', res.data.data.type)
          //store.dispatch('login_save', true)

          // if (store.state.type == '用户') {
          //   router.push('/Home')
          // } else if (store.state.type == '场馆管理员') {
          //   console.log(store)
          //   router.push('/VenueHome')
          // } else if (store.state.type == '超级管理员') {
          //   console.log(store)
          //   router.push('/syshome')
          // }

          //store.dispatch('login_save', true)
        
        } else if (res.data.code == 400) {
          ElMessage.error('手机号或密码有误')
        }
      })
  }

}

</script>
