<template>
  <el-container class="layout-container">
    <sysstaticheader />
    <el-main style="height: 100vh; background: rgb(255,255,255); padding: 0; z-index: 8">
      <div class="title"
        style="text-align: center; font-size: 20px; width: 100%; z-index: 10; margin-top: 60px; font-family: 'MiSans'; background: #6c757d; color: #ffffff; padding: 20px 0;">
        补全信息成为管理员
      </div>
      <div style="margin: 15px auto; width: 50%; display: flex; flex-direction: column; align-items: center;">


        <img v-if="imageUrl" :src="imageUrl" class="avatar" />
        <el-icon v-else class="avatar-uploader-icon">
          <Plus />
        </el-icon>


        <div class="name" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">姓名：</el-text>
          <el-input disabled v-model="form.userName" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div>
        <div class="petname" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">昵称：</el-text>
          <el-input disabled v-model="form.petName" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div>
        <div class="telephone" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">电话：</el-text>
          <el-input disabled v-model="form.telephone" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div>
        <!-- <div class="tag" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">权限：</el-text>
          <el-input disabled v-model="form.tag" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div> -->
        <div class="corp" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">公司：</el-text>
          <el-input v-model="form.crop" placeholder="请填写注册公司"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div>
        <hr style="width: 100%;" />
        <div class="addbutton">
          <el-button style="width: 100px; font-family: 'MiSans';" @click="cancel">返回</el-button>
          <el-button type="primary" style="width: 100px; font-family: 'MiSans';" @click="update">注册成为管理员</el-button>
        </div>
      </div>
    </el-main>
  </el-container>
</template>

<script lang="ts" setup>
import axios from 'axios'
import router from '@/router'
import store from '@/stores'
import { ElMessage } from 'element-plus';
import { reactive, ref } from 'vue'
import Sysstaticheader from '@/components/superManager/superHeader/Sysstaticheader.vue'

import { Plus } from '@element-plus/icons-vue'

import type { UploadProps } from 'element-plus'



// axios.post(`/api/searchAppByMan?telephone=${store.state.id}`,
//   {
//     headers: {
//       'Content-Type': 'application/json',
//       token: store.state.token,
//     }
//   }).then(res => {

//   })
const imageUrl = ref('')
var iconURL;
var newiconURL;


console.log(store.state.appID)


const handleAvatarSuccess: UploadProps['onSuccess'] = (response, uploadFile) => {
  if (response.code === 200) {
    imageUrl.value = URL.createObjectURL(uploadFile.raw!);// Save the returned image URL
    ElMessage.success('上传成功');
    iconURL = response.data;
    newiconURL = response.data;
  } else {
    ElMessage.error('上传失败');
  }
}


const beforeAvatarUpload: UploadProps['beforeUpload'] = (rawFile) => {
  if (rawFile.type !== 'image/jpeg') {
    ElMessage.error('Avatar picture must be JPG format!')
    return false
  } else if (rawFile.size / 1024 / 1024 > 2) {
    ElMessage.error('Avatar picture size can not exceed 2MB!')
    return false
  }
  return true
}

const value = ref('')


var optionsForm = new Array(2);
optionsForm = ["管理员", "普通用户"]

axios.post(`/api/userInfo?telephone=${store.state.commitID}`,
  {
    // headers: {
    //   'Content-Type': 'application/json',
    //   token: store.state.token,
    // }
  }).then(res => {
    imageUrl.value = "http://localhost:8080" + res.data.data.user.icon;
    newiconURL = res.data.data.user.icon;
    form.userName = res.data.data.user.userName;
    form.petName = res.data.data.user.petName;
    form.telephone = res.data.data.user.telephone;
    form.crop = res.data.data.corp;
    form.tag = optionsForm[res.data.data.user.tag];


    value.value = res.data.data.tag;
    // options.push({
    //   value: res.data.tag,
    value.value = optionsForm[res.data.data.tag - 1];
    // options.push({
    //   value: res.data.tag,
    //   label: optionsForm[res.data.tag -1]
    // });

  })


const form = reactive({
  userName: '',
  petName: '',
  telephone: '',
  crop: '',
  tag: ''
})

const triggerFilePicker = () => {
  const filePicker = document.getElementById('file-picker') as HTMLInputElement;
  if (filePicker) {
    filePicker.click();
  }
};


var cancel = function () {
  // 你的代码
  router.push('/superUser')
};

const update = () => {
  if (form.crop == '') {
    ElMessage.error('请补全公司信息！')
  } else {
    axios.post('/api/commitManager',
      {
        headers: {
          'Content-Type': 'application/json',
          token: store.state.token,
        },
        telephone: form.telephone,
        corp: form.crop
      }).then(res => {
        console.log(res)
        if (res.data.code === 200) {
          ElMessage.success('更新成功')
          router.push('/superUser')
        } else if (res.data.code === 400) {
          ElMessage.error('更新失败')
        }
      }).catch(err => {
        console.error(err);
        ElMessage.error('更新失败，请重试！');
      });
  }
};

const password = () => {
  router.push('/password')
}

</script>

<style>
#upload-container {
  width: 150px;
  height: 50px;
  background: #94d3e7;
  padding-bottom: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.progress {
  margin-top: 10px;
}

.addbutton {
  margin-left: 4px;
  margin-top: 50px;
}

.item {
  margin-bottom: 10px;
}

.info {
  font-size: 14px;
  margin: 5px 0;
}

.state {
  font-size: 12px;
  color: #999;
}
</style>


<style scoped>
.avatar-uploader .avatar {
  width: 178px;
  height: 178px;
  display: block;
}
</style>

<style>
.avatar-uploader .el-upload {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  text-align: center;
}
</style>