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
        <el-text class="loginfont" style="font-family: 'MiSans';">注册</el-text>
        <div class="OCR">
          <el-upload
            :auto-upload="true"
            :file-list="fileList"
            :multiple="false"
            :on-change="beforeUpload"
            :show-file-list="false"
            action="#"
          >
          <el-button color="#c05f6c" style="font-family: 'MiSans';margin-left: 4px">上传身份证图片</el-button>
          </el-upload>
        </div>
        <div class="account">
          <el-text style="font-family: 'MiSans'">姓名</el-text>
          <el-input v-model="form.realName" placeholder="上传身份证自动识别姓名" :readonly="true"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
        </div>
        <div class="password">
          <el-text style="font-family: 'MiSans'">身份证号</el-text>
          <el-input v-model="form.identificationNum" maxlength="18" placeholder="上传身份证自动识别身份证号" :readonly="true"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
          <el-text style="font-family: 'MiSans'">手机号</el-text>
          <el-input v-model="form.telephone" placeholder="请输入手机号"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
        </div>
        <el-divider />
        <div class="account">
          <el-text style="font-family: 'MiSans'">邮箱</el-text>
          <el-input v-model="form.email" placeholder="请输入邮箱"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
        </div>
        <div class="code">
          <el-text style="font-family: 'MiSans'">验证码</el-text>
          <el-input v-model="form.judgeCode" maxlength="6" placeholder="请输入邮箱验证码"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
          <el-button color="#c05f6c"
            style="font-family: 'MiSans';margin-top: -80px;margin-left: 230px;height: 35px;width: 120px;"
            @click="getCode">获取验证码
          </el-button>
        </div>
        <el-divider />
        <div class="password">
          <el-text style="font-family: 'MiSans'">用户名</el-text>
          <el-input v-model="form.userName" placeholder="请输入用户名"
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
          <el-text style="font-family: 'MiSans'">密码</el-text>
          <el-input v-model="form.userPassword" placeholder="请输入密码" show-password
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
          <el-text style="font-family: 'MiSans'">验证密码</el-text>
          <el-input v-model="form2.password2" placeholder="请再次输入密码" show-password
            style="font-family: 'MiSans';font-weight: lighter;height: 35px" />
        </div>
        <div class="loginbutton">
          <el-button color="#c05f6c" style="width: 100px;font-family: 'MiSans';" @click="register">下一步</el-button>
          <el-link style="color: rgb(84,168,255);margin-top: 10px;margin-left: 195px;" type="primary" @click="login1">
            返回登录
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

.account {
  width: 350px;
  margin-left: 4px;
}

.password {
  width: 350px;
  margin-left: 4px;
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
}

.loginfont {
  font-family: "MiSans";
  font-size: 30px;
  color: #333333;
}

.account {
  width: 350px;
  margin-left: 4px;
}

.code {
  width: 200px;
  margin-left: 4px;
}

.password {
  width: 350px;
  margin-left: 4px;
}

.loginbutton {
  margin-left: 4px;
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
import { reactive, ref } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const form = reactive({
  email: '',
  identificationNum: '',
  imageURL: '',
  judgeCode: '',
  realName: '',
  telephone: '',
  userName: '',
  userPassword: ''
})
const form2 = reactive({
  password2: ''
})
const login1 = () => {
  router.push('/')
}
const fileList = ref([])
const beforeUpload = (file, fileList1) => {
  fileList.value = fileList1
  let fd = new FormData()
  fileList.value.forEach(item => {
    fd.append('file', item.raw)
    console.log(item.raw)
  })
  axios.post(`/api/abc/ocr/ocr`, fd
    , {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    }).then(res => {
    form.identificationNum = res.data.data.idNumber
    form.realName = res.data.data.name
  })
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
const register = () => {
  if (form.email == '' || form.judgeCode == '' || form.realName == '' || form.telephone == '' || form.userName == '' || form.userPassword == '' || form2.password2 == '') {
    ElMessage.error("请完整填写信息！")
  } else {
    if (form.userPassword == form2.password2) {
      axios.post('/api/abc/users/register', JSON.stringify(form), {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then(res => {
        console.log(res.data)
        if (res.data.code == '400') {
          ElMessage.error(res.data.msg)
        } else if (res.data.code == '200') {
          ElMessage.success(res.data.msg)
          router.push('/registerSuccess')
        }
      })
      console.log(form)
    } else {
      ElMessage.error('两次密码不一致')
    }

  }
}
</script>

