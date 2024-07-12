<template>
  <el-container class="layout-container">
    <sysstaticheader />
    <el-main style="height: 100vh; background: rgb(255,255,255); padding: 0; z-index: 8">
      <div class="title"
        style="text-align: center; font-size: 20px; width: 100%; z-index: 10; margin-top: 60px; font-family: 'MiSans'; background: #6c757d; color: #ffffff; padding: 20px 0;">
        应用详情
      </div>
      <div style="margin: 15px auto; width: 50%; display: flex; flex-direction: column; align-items: center;">


        <img v-if="imageUrl" :src="imageUrl" class="avatar" />
        <el-icon v-else class="avatar-uploader-icon">
          <Plus />
        </el-icon>


        <div class="appName" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">应用名称：</el-text>
          <el-input disabled v-model="form.appName" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div>
        <div class="version" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">版本号：</el-text>
          <el-input disabled v-model="form.version" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div>
        <div class="size" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">安装包大小(MB)：</el-text>
          <el-input disabled v-model="form.size" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div>
        <div class="corp" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">开发商：</el-text>
          <el-input disabled v-model="form.corp" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
        </div>
        <div class="tag" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">选择应用分区：</el-text>
          <el-select disabled v-model="value" clearable placeholder="Select" style="width: 100%;">
            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </div>

        <div class="num-score-container"
          style="display: flex; width: 100%; justify-content: space-between; margin-bottom: 15px;">
          <div class="num" style="width: 48%;">
            <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">评价人数：</el-text>
            <el-input disabled v-model="form.num" placeholder="NULL"
              style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
          </div>
          <div class="score" style="width: 48%;">
            <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">评分：</el-text>
            <el-input disabled v-model="form.score" placeholder="NULL"
              style="font-family: 'MiSans'; font-weight: lighter; height: 35px; width: 100%;"></el-input>
          </div>
        </div>



        <div class="index" style="margin-bottom: 15px; width: 100%;">
          <el-text style="font-family: 'MiSans'; margin-bottom: 20px;">应用简介：</el-text>
          <el-input disabled v-model="form.index" placeholder="NULL"
            style="font-family: 'MiSans'; font-weight: lighter; width: 100%;" :autosize="{ minRows: 2, maxRows: 4 }"
            type="textarea" />
        </div>


        <!-- 
        <div style="display: flex; flex-direction: column; align-items: center; width: 100%;">
          <el-button type="primary" @click="triggerFilePicker"
            style="width: 100px; font-family: 'MiSans;margin-bottom: 10px;">选择文件</el-button>
          <div id="upload-list" style="width: 100%; text-align: center; margin-bottom: 10px;"></div>
          <input type="file" id="file-picker" style="display: none" @change="handleFileChange" />
        </div> -->
        <hr style="width: 100%;" />
        <div class="addbutton">
          <el-button style="width: 100px; font-family: 'MiSans';" @click="cancel">返回</el-button>
          <!-- <el-button type="primary" style="width: 100px; font-family: 'MiSans';" @click="add">更新应用</el-button> -->
          <el-button type="danger" style="width: 100px; font-family: 'MiSans';" @click="down">下架应用</el-button>
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

let fileName: string | null = null;
let size: number | null = null;
const value = ref('')
const options = [
  { value: '1', label: '游戏' },
  { value: '2', label: '社交' },
  { value: '3', label: '媒体' },
  { value: '4', label: '办公' },
  { value: '5', label: '购物' },
  { value: '6', label: '教育' },
  { value: '7', label: '医疗' },
  { value: '8', label: '金融' },
  { value: '9', label: '旅游' },
  { value: '10', label: '摄影' }
]

var optionsForm = new Array(10);
optionsForm = ["游戏", "社交", "媒体", "办公", "购物", "教育", "医疗", "金融", "旅游", "摄影"]

console.log(store.state.appID)
axios.post(`/api/searchAppByID?appId=${store.state.appID}`,
  {
    // headers: {
    //   'Content-Type': 'application/json',
    //   token: store.state.token,
    // }
  }).then(res => {
    imageUrl.value = "http://localhost:8080" + res.data.data.icon;
    newiconURL = res.data.data.icon;
    form.appName = res.data.data.appName;
    form.version = res.data.data.version;
    form.index = res.data.data.index;
    value.value = optionsForm[res.data.data.tag - 1];
    form.size = parseFloat(res.data.data.size).toFixed(2);
    form.corp = res.data.data.corp;
    // options.push({
    //   value: res.data.tag,
    //   label: optionsForm[res.data.tag -1]
    // });
  })

axios.post(`/api/getAppScore?appId=${store.state.appID}`,
  {
    // headers: {
    //   'Content-Type': 'application/json',
    //   token: store.state.token,
    // }
  }).then(res => {
    form.score = parseFloat(res.data.data).toFixed(1);
    // options.push({
    //   value: res.data.tag,
    //   label: optionsForm[res.data.tag -1]
    // });
  })

axios.post(`/api/getAppScoreNum?appId=${store.state.appID}`,
  {
    // headers: {
    //   'Content-Type': 'application/json',
    //   token: store.state.token,
    // }
  }).then(res => {
    form.num = res.data.data;
    // options.push({
    //   value: res.data.tag,
    //   label: optionsForm[res.data.tag -1]
    // });
  })


const form = reactive({
  appName: '',
  version: '',
  index: '',
  num: '',
  score: '',
  size: '',
  corp: '',
})

const triggerFilePicker = () => {
  const filePicker = document.getElementById('file-picker') as HTMLInputElement;
  if (filePicker) {
    filePicker.click();
  }
};

const handleFileChange = (event: Event) => {
  const input = event.target as HTMLInputElement;
  const files = input.files;
  const uploadList = document.getElementById('upload-list');

  if (files && files.length > 0) {
    const file = files[0];

    if (uploadList) {
      uploadList.innerHTML = '';  // Clear previous uploads
    }

    fileName = file.name;
    size = file.size / 1024 / 1024
    uploadFile(file);
  }
};

const uploadFile = (file: File) => {
  const formData = new FormData();
  formData.append('file', file);

  axios.post('/api/app/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }).then(res => {
    console.log(res);
    if (res.data.code === 200) {
      const uploadList = document.getElementById('upload-list');
      if (uploadList) {
        const item = document.createElement('div');
        item.className = 'item';
        item.innerHTML = `<h4 class="info">${file.name}</h4><p class="state">上传成功</p>`;
        uploadList.appendChild(item);
      }
    } else {
      ElMessage.error('上传失败');
    }
  }).catch(err => {
    console.error(err);
    ElMessage.error('上传失败，请重试！');
  });
};

const addapp = reactive({
  appName: form.appName,
  version: form.version,
  index: form.index,
  tag: value.value,
  apk: fileName,
  size: size,
  corp: "1",
  icon: iconURL
})

var cancel = function () {
  // 你的代码
  router.push('/superAppDisplay')
};

const down = () => {

  console.log(store.state.appID)
  axios.post(`/api/delAppById?id=${store.state.appID}`,
    {
      headers: {
        'Content-Type': 'application/json',
        token: store.state.token,
      },
      // id: store.state.appID,
    }).then(res => {
      console.log(res)
      if (res.data.code === 200) {
        ElMessage.success('下架成功')
        router.push('/appDisplay')
      } else if (res.data.code === 400) {
        ElMessage.error('下架失败')
      }
    }).catch(err => {
      console.error(err);
      ElMessage.error('下架失败，请重试！');
    });
};

const add = () => {
  if (form.appName === '' || form.version === '' || form.index === '' || !fileName) {
    ElMessage.error('请完整输入app信息并选择文件！')
  } else {
    axios.post('/api/updateApp',
      {
        headers: {
          'Content-Type': 'application/json',
          token: store.state.token,
        },
        id: store.state.appID,
        appName: form.appName,
        version: form.version,
        index: form.index,
        tag: value.value,
        apk: fileName,
        size: size,
        icon: newiconURL
      }).then(res => {
        console.log(res)
        if (res.data.code === 200) {
          ElMessage.success('添加成功')
          router.push('/superAppDisplay')
        } else if (res.data.code === 400) {
          ElMessage.error('添加失败')
        }
      }).catch(err => {
        console.error(err);
        ElMessage.error('发布失败，请重试！');
      });
  }
};
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