<template>
  <div>
    <el-container class="layout-container">
      <Sysanimationheader ref="myHeader" />
      <el-main style="height: 100vh;">

        <div class="welcome" style="width: 100% ;height: 100%">
          <div class="welcome1">
            场馆预约系统管理端
          </div>
          <div class="welcome2">
            欢迎使用
          </div>
          <div class="font" @click="scroll">
            <div class="down">
              向下滑动
            </div>
            <div class="down1">
              查看更多内容
            </div>
            <div class="downsvg">
              <img src="../../assets/down.png" style="width: 40px;height: 20px">
            </div>
          </div>
        </div>
      </el-main>
      <el-footer style="height: auto;background: rgb(250,250,250);padding: 0;z-index: 8">

        <div class="title"
             style="text-align: center;font-size: 40px;width:100%;z-index: 10;font-family: 'MiSans';background: #ecdcec">
          场馆信息Museum Information
        </div>
        <div style="margin-top: 15px">
          <el-row gutter="20" style="margin-left: 10px;margin-right: 10px">
            <el-col
              v-for="(item,index) in card_info"
              :key="index"
              :span="8"
            >
              <div v-if="item.card_index>=0">
                <el-card :body-style="{ padding: '0px' }" shadow="hover" style="margin-bottom: 20px;height: auto"
                         @click="toac(item)">
                  <img
                    alt="加载错误"
                    class="image"
                    :src="item.src"
                    style="max-width: 100%;height: auto;min-height: 400px;max-height: 400px"
                  />

                  <div style="padding: 14px">
                    <el-tooltip content="场馆名称" effect="light">
                      <span style="font-family: 'MiSans';text-align: center;display:block;font-size: 20px">{{
                          item.name
                        }}</span>
                    </el-tooltip>
                    <el-divider />
                    <div class="bottom">
                      <el-tooltip content="查看位置" effect="light">
                        <div class="location" @click.native.stop="tosysmap(item.location)">
                        <el-icon color="rgb(191,169,192)" size="17">
                          <Location />
                        </el-icon>
                        <p style="font-size: 13px">{{ item.location }}</p>
                      </div>
                      </el-tooltip>
                      <el-tooltip content="开放时间" effect="light">
                      <div class="time">
                        <el-icon color="rgb(191,169,192)" size="17">
                          <Clock />
                        </el-icon>
                        <p style="font-size: 13px">{{ item.begintime }}-{{ item.endtime }}</p>
                      </div>
                      </el-tooltip>
                      <el-tooltip content="联系方式" effect="light">
                      <div class="tel">
                        <el-icon color="rgb(191,169,192)" size="17">
                          <Phone />
                        </el-icon>
                        <p style="font-size: 13px">{{ item.tel }}</p>
                      </div>
                      </el-tooltip>
                    </div>
                  </div>
                </el-card>
              </div>
              <div v-else-if="item.card_index<0" class="con2" style="align-content: center;"
                   @click="drawer=true">
                <el-link :underline="false"
                         style="font-family: 'MiSans ';font-size: 100px;display: flex;margin-top: 30%">+
                </el-link>
              </div>
            </el-col>
          </el-row>
        </div>
        <el-drawer
          v-model="drawer"
          :direction="'rtl'"
          size="500"
          append-to-body
        >
          <template #header>
            <el-text style="font-size: 40px;font-family: MiSans">新增场馆</el-text>
          </template>
          <el-form label-position="top" size="large">
            <el-upload
              :auto-upload="true"
              :file-list="fileList"
              :multiple="false"
              :on-change="beforeUpload"
              :show-file-list="false"
              action="#"
            >
              <el-button type="primary">上传场馆图片</el-button>
            </el-upload>

            <el-form-item label="场馆名" style="margin-top: 20px">
              <el-input v-model="addform.stadiumName" />
            </el-form-item>
            <el-form-item label="场馆地点">
              <el-input v-model="addform.position" />
            </el-form-item>
            <el-form-item label="联系方式">
              <el-input v-model="addform.telephone" />
            </el-form-item>
            <el-form-item label="涉及展厅">
              <el-input v-model="addtemp.halls" placeholder="输入展厅名，以中文逗号分割" />
            </el-form-item>
            <el-form-item label="开放时间">
              <el-time-picker
                v-model="addtemp.bt"
                placeholder="选择开放时间"
                style="width: 100%"
                format="HH:mm:ss"
                value-format="HH:mm:ss"
              />
            </el-form-item>
            <el-form-item label="结束时间">
              <el-time-picker
                v-model="addtemp.et"
                placeholder="选择闭馆时间"
                style="width: 100%"
                format="HH:mm:ss"
                value-format="HH:mm:ss"
              />
            </el-form-item>
            <el-form-item label="场馆名管理员账号" style="margin-top: 20px">
              <el-input v-model="addform.manager.managerUserName" />
            </el-form-item>
            <el-form-item label="场馆简介">
              <el-input v-model="addform.introduction" :autosize="{ minRows: 2, maxRows: 4 }" type="textarea" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="addmu">确定</el-button>
              <el-button @click="drawer=false">取消</el-button>
            </el-form-item>
          </el-form>
        </el-drawer>
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
  left: 50%;
  margin-left: -270px;
  top: 50%;
  margin-top: -72.67px;
}

.welcome2 {
  position: absolute;
  font-family: "MiSans";
  font-weight: normal;
  font-size: 50px;
  color: #ffffff;
  text-align: center;
  left: 50%;
  margin-left: -100px;
  top: 55%;
  margin-top: -33px;
}

.down {
  position: absolute;
  font-family: "MiSans";
  font-weight: normal;
  font-size: 20px;
  color: #ffffff;
  text-align: center;
  left: 50%;
  margin-left: -40px;
  top: 87%;
}

.down1 {
  position: absolute;
  font-family: "MiSans";
  font-weight: normal;
  font-size: 20px;
  color: #ffffff;
  text-align: center;
  left: 50%;
  margin-left: -60px;
  top: 90%;
}

.downsvg {
  position: absolute;
  color: #ffffff;
  text-align: center;
  left: 50%;
  top: 94%;
  margin-left: -22px;
}

.downsvg:hover {
  position: absolute;
  color: #ffffff;
  text-align: center;
  left: 50%;
  top: 93%;
  margin-left: -22px;
  transition: all .4s;
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

.el-input {
  --el-input-focus-border-color: #c05f6c;
}
.image {
  width: 100%;
  height: 310px;
  display: block;
  border: rgba(237, 237, 255, 0);
}
</style>
<script lang="ts" setup>
import { onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import Sysanimationheader from '@/components/SystemAdminintrators/header/Sysanimationheader.vue'
import axios from 'axios'
import store from '@/stores'
import router from '@/router'
import { ElMessage } from 'element-plus'

const addform = reactive({
  beginTime: '0000-00-00 ',
  endTime: '3000-00-00 ',
  halls: [],
  imageURL: '',
  introduction: '',
  manager: {
    managerUserName: ''
  },
  position: '',
  stadiumName: '',
  telephone: ''
})
const addtemp = reactive({
  bt: '',
  et: '',
  halls: ''
})

const myHeader = ref<any>(null)

const scrollTop = ref<number>(0) // 记录当前的滚动距离
const scrollHandle = () => {
  scrollTop.value = window.scrollY	//滚动条距离浏览器顶部高度
}

onMounted(() => {
    window.addEventListener('scroll', scrollHandle)
  }
)
onBeforeUnmount(() => {
  window.removeEventListener('scroll', scrollHandle)
})

watch(
  () => scrollTop.value,
  () => {
    let i = scrollTop.value
    //调用子组件 header.vue 中的方法setBgColor，设置背景色
    if (i / 1000 > 1) {
      myHeader.value.setBgColor(1)
    } else {
      myHeader.value.setBgColor(i / 900)
    }
  }
)
const scroll = () => {
  window.scrollTo({
    top: window.innerHeight - 60,
    behavior: 'smooth'
  })
}
const card_info = reactive([])

const drawer = ref(false)
axios.get('/api/abc/superManager/selectStadiumByName', {
  params: {
    stadiumName: store.state.muble_search
  },
  headers: {
    token: store.state.token
  }
}).then(res => {
  for (let i = 0; i < res.data.data.length; i++) {
    card_info.push({
      card_index: res.data.data[i].id,
      src: res.data.data[i].imageURL,
      name: res.data.data[i].stadiumName,
      location: res.data.data[i].position,
      tel: res.data.data[i].telephone,
      begintime: res.data.data[i].beginTime.split(' ')[1].split(':')[0] + ':' + res.data.data[i].beginTime.split(' ')[1].split(':')[1],
      endtime: res.data.data[i].endTime.split(' ')[1].split(':')[0] + ':' + res.data.data[i].endTime.split(' ')[1].split(':')[1],
      score: res.data.data[i].score
    })
  }
  card_info.push({
    card_index: -1,
    src: '',
    name: '',
    location: '',
    tel: '',
    begintime: '',
    endtime: ''
  })
})
const toac = (data: any) => {
  store.dispatch('user_home_card_id_save', data.card_index)
  router.push('/sysactmanage')
}
const seform = reactive({
  co: ''
})
const searchsta = () => {
  if (seform.co != '') {
    store.dispatch('muble_save', seform.co)
    router.push('/syshome2')
  } else {
    ElMessage.error('请完整输入')
  }
}
const fileList = ref([])
const beforeUpload = (file, fileList1) => {
  fileList.value = fileList1
  let fd = new FormData()
  fileList.value.forEach(item => {
    fd.append('multipartFile', item.raw)
  })
  axios.post(`/api/abc/uploadfile/managerImageSaveOrUpdate?managerId=${store.state.id}`, fd
    , {
      headers: {
        'Content-Type': 'multipart/form-data',
        token: store.state.token
      }
    }).then(res => {
    addform.imageURL = res.data.data
  })
}
const addmu = () => {
  addform.beginTime = addform.beginTime + addtemp.bt
  addform.endTime = addform.endTime + addtemp.et
  const temphall = addtemp.halls.split('，')
  for (let i = 0; i < temphall.length; i++) {
    addform.halls.push(
      temphall[i]
    )
  }
  if (addform.introduction != '' && addform.endTime != '3000-00-00 ' && addform.beginTime != '0000-00-00 ' && addform.imageURL != '' && addform.manager.managerUserName != '' && addform.position != '' && addform.telephone != '' && addform.stadiumName != '' && addform.halls.length != 0) {
    axios.post('/api/abc/superManager/addStadium', JSON.stringify(addform), {
      headers: {
        'Content-Type': 'application/json',
        token: store.state.token
      }
    }).then(res => {
      if (res.data.code == 400) {
        ElMessage.error(res.data.msg)
      } else if (res.data.code == 200) {
        ElMessage.success(res.data.data)
        setTimeout(() => location.reload(), 600)
      }
    })
  } else {
    ElMessage.error('请完整填写')
  }

}
const tosysmap = (lo) => {
  router.push({
    path: '/mapsys',
    query: {
      location: lo
    }
  })
}

</script>