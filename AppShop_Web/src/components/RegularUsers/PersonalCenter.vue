<template>
  <div>
    <el-container class="layout-container">
      <staticheader />
      <el-main style="height: 100vh;background: rgb(255,255,255);padding: 0;z-index: 8;margin-top: 60px;">
        <div class="title"
             style="text-align: center;font-size: 40px;width:100%;z-index: 10;font-family: 'MiSans';background: #ecdcec">
          个人中心
        </div>
        <div class="demo-basic--circle" style="box-shadow: 0 2px 5px rgba(192,192,192,1);height: 180px">
          <div class="block">
            <el-row gutter="20">
              <el-col span="10">
                <el-upload
                  :auto-upload="true"
                  :file-list="fileList"
                  :multiple="false"
                  :on-change="beforeUpload"
                  :show-file-list="false"
                  action="#"
                >
                  <el-avatar :size="100" :src="personalinfo.head" shape="square"
                             style="margin-top: 50px;margin-left: 50px" />
                </el-upload>
              </el-col>
              <el-col span="10" style="margin-top: 102px">
                <el-text v-if="!show" style="font-family: 'MiSans ';font-size: 40px;margin-left: 20px;"
                         @click="show=true">{{ personalinfo.name }}
                </el-text>
                <div v-if="show">
                  <el-row gutter="10">
                    <el-col span="30">
                      <el-input v-model="usernamef.userName" placeholder="修改用户名" style="height: 40px"></el-input>
                    </el-col>
                    <el-col span="10">
                      <el-button-group>
                        <el-button style="height: 40px" type="primary" @click="sub">确定</el-button>
                        <el-button style="height: 40px" @click="show=false;">取消</el-button>
                      </el-button-group>
                    </el-col>
                  </el-row>
                </div>
              </el-col>
            </el-row>
          </div>
        </div>

        <div style="margin-top: 15px;width: 96%">
          <el-descriptions
            :column="2"
            :size="'large'"
            border
            class="margin-top"
            direction="vertical"
            style="margin-left: 50px;margin-top: 80px"
            title="用户信息"

          >
            <el-descriptions-item>
              <template #label>
                <div class="cell-item">
                  <el-icon :style="iconStyle">
                    <user />
                  </el-icon>
                  真实姓名
                </div>
              </template>
              {{ personalinfo.realName }}
            </el-descriptions-item>
            <el-descriptions-item>
              <template #label>
                <div class="cell-item">
                  <el-icon :style="iconStyle">
                    <iphone />
                  </el-icon>
                  电话
        </div>
              </template>
              {{ personalinfo.telephone }}
            </el-descriptions-item>
            <el-descriptions-item>
              <template #label>
                <div class="cell-item">
                  <el-icon :style="iconStyle">
                    <Postcard />
                  </el-icon>
                  身份证号码
                </div>
              </template>
              {{ personalinfo.identificationNum }}
            </el-descriptions-item>
            <el-descriptions-item>
              <template #label>
                <div class="cell-item">
                  <el-icon :style="iconStyle">
                    <tickets />
                  </el-icon>
                  类型
        </div>
              </template>
              <el-tag size="small">{{ personalinfo.type }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item>
              <template #label>
                <div class="cell-item">
                  <el-icon :style="iconStyle">
                    <Star />
                  </el-icon>
                  信誉分
                </div>
              </template>
              <el-rate
                v-model="value"
                disabled
                score-template="{value} 分"
                show-score
                text-color="#ff9900"
              />
            </el-descriptions-item>
            <el-descriptions-item>
              <template #label>
                <div class="cell-item">
                  <el-icon :style="iconStyle">
                    <Message />
                  </el-icon>
                  邮箱
                </div>
              </template>
              {{ personalinfo.email }}
            </el-descriptions-item>
          </el-descriptions>
        </div>
        <el-dialog
          v-model="drawer"
          title="编辑用户名"
        >
          <el-form>
            <el-row gutter="20">
              <el-col span="20">
                <el-form-item label="用户名">
                  <el-input v-model="usernamef.userName" placeholder="输入用户名" style="width: 500px" />
                </el-form-item>

              </el-col>
            </el-row>

            <el-form-item>
              <el-button type="primary" @click="submit">确定</el-button>
              <el-button @click="drawer=false">取消</el-button>
            </el-form-item>
          </el-form>
        </el-dialog>
      </el-main>
    </el-container>
  </div>
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

.demo-basic {
  text-align: center;
}

.demo-basic .sub-title {
  margin-bottom: 10px;
  font-size: 14px;
  color: var(--el-text-color-secondary);
}

.demo-basic .demo-basic--circle,
.demo-basic .demo-basic--square {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.demo-basic .block:not(:last-child) {
  border-right: 1px solid var(--el-border-color);
}

.demo-basic .block {
  flex: 1;
}

.demo-basic .el-col:not(:last-child) {
  border-right: 1px solid var(--el-border-color);
}

.el-descriptions {
  margin-top: 20px;
}

.el-input {
  --el-input-focus-border-color: #c05f6c;
}

.cell-item {
  display: flex;
  align-items: center;
}

.margin-top {
  margin-top: 20px;
}
</style>
<script lang="ts" setup>
import { computed, reactive, ref } from 'vue'
import Staticheader from '@/components/RegularUsers/header/staticheader.vue'
import axios from 'axios'
import store from '@/stores'
import { Iphone, Tickets, User } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

const show = ref(false)
const size = ref('')
const iconStyle = computed(() => {
  const marginMap = {
    large: '8px',
    default: '6px',
    small: '4px'
  }
  return {
    marginRight: marginMap[size.value] || marginMap.default
  }
})
const blockMargin = computed(() => {
  const marginMap = {
    large: '32px',
    default: '28px',
    small: '24px'
  }
  return {
    marginTop: marginMap[size.value] || marginMap.default
  }
})
const fileList = ref([])
const beforeUpload = (file, fileList1) => {
  fileList.value = fileList1
  let fd = new FormData()
  fileList.value.forEach(item => {
    fd.append('multipartFile', item.raw)
    console.log(item.raw)
  })
  axios.post(`/api/abc/uploadfile/userImageSaveOrUpdate?userId=${store.state.id}`, fd, {
    headers: {
      'Content-Type': 'multipart/form-data',
      token: store.state.token
    }
  }).then(res => {
    if (res.data.code == 400) {
      ElMessage.error(res.data.msg)
    } else if (res.data.code == 200) {
      ElMessage.success('更改成功')
      setTimeout(() => location.reload(), 500)
    }
  })
}
const usernamef = reactive({
  userName: ''
})
const drawer = ref(false)
const personalinfo = reactive(
  {
    head: '',
    name: '',
    email: '',
    identificationNum: '',
    realName: '',
    score: '',
    telephone: '',
    type: ''
  }
)
axios.get('api/abc/users/getHomeInf', {
  headers: {
    token: store.state.token
  },
  params: {
    userId: store.state.id
  }
}).then(res => {
  console.log(res.data)
  personalinfo.head = res.data.data.userDto.imageURL
  personalinfo.name = res.data.data.userDto.userName
  personalinfo.email = res.data.data.userDto.email
  personalinfo.type = store.state.type
  personalinfo.telephone = res.data.data.userDto.telephone
  personalinfo.realName = res.data.data.userDto.realName
  personalinfo.identificationNum = res.data.data.userDto.identificationNum
  personalinfo.score = res.data.data.userDto.score
  value.value = res.data.data.userDto.score
})
const value = ref('')

const sub = () => {
  if (usernamef.userName != '') {
    axios.get('/api/abc/users/updateUserName', {
      params: {
        userId: store.state.id,
        userName: usernamef.userName
      },
      headers: {
        token: store.state.token
      }
    }).then(res => {
      if (res.data.code == 400) {
        ElMessage.error(res.data.msg)
      } else if (res.data.code == 200) {
        ElMessage.success('修改成功')
        setTimeout(() => location.reload(), 500)
      }
    })
    show.value = false
  } else {
    ElMessage.error('请完整填写')
  }

}
</script>