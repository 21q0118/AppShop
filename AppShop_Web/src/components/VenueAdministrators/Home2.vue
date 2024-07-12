<template>
  <div>
    <el-container class="layout-container">
      <Venueanimationheader ref="myHeader" />
      <el-main style="height: 100vh;">
        <div class="welcome" style="width: 100% ;height: 100%">
          <div class="welcome1">
            场馆预约管理端
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
        <div class="museum">
          <el-card :body-style="{ padding: '0px' }" style="border-radius: 0;margin-top: 0px;height: auto">
            <div class="imgc" style="position: relative">
              <img
                alt="加载错误"
                class="image"
                :src="museum_info.src"
                style="height: auto;width: 100%"
              />
              <div
                style=" position: absolute;font-family: 'MiSans';font-weight: bold;font-size: 60px;color: #ffffff;text-align: center;left: 50%; top: 90%; transform: translate(-50%,-50%)">
                <el-tooltip content="场馆名称" effect="light">
                  {{ museum_info.name }}
                </el-tooltip>
                <el-tooltip content="编辑场馆" effect="light">
                  <el-icon class="editl" color="rgb(255,255,255)" size="20" @click="gethall">
                    <Edit />
                  </el-icon>
                </el-tooltip>
              </div>
            </div>

            <div class="bottom" style="padding: 14px; ">
              <el-tooltip content="查看位置" effect="light">
                <div class="location" @click.native.stop="tomap()">
                  <el-icon color="rgb(191,169,192)" size="20">
                    <location />
                  </el-icon>
                  <p style="font-size: 15px">{{ museum_info.location }}</p>
                </div>
              </el-tooltip>
              <el-tooltip content="联系方式" effect="light">
                <div class="tel">
                  <el-icon color="rgb(191,169,192)" size="20">
                    <phone />
                  </el-icon>
                  <p style="font-size: 15px">{{ museum_info.tel }}</p>
                </div>
              </el-tooltip>
              <el-tooltip content="开放时间" effect="light">
                <div class="time">
                  <el-icon color="rgb(191,169,192)" size="20">
                    <clock />
                  </el-icon>
                  <p style="font-size: 15px">{{ museum_info.begintime }}-{{ museum_info.endtime }}</p>
                </div>
              </el-tooltip>
              <el-tooltip content="预约人数" effect="light">
                <div class="accessnum">
                  <el-icon color="rgb(191,169,192)" size="20">
                    <user />
                  </el-icon>
                  <p style="font-size: 15px">{{ museum_info.accessnum }}</p>
                </div>
              </el-tooltip>
            </div>
            <el-divider />
            <el-tooltip content="场馆简介" effect="light">
              <div class="intro" style="padding: 14px">
                <span
                  style="font-family: 'MiSans';font-weight: 300;text-align: center;display:block;font-size: 15px;color: #a1a1a1">{{
                    museum_info.intro
                  }}</span>
              </div>
            </el-tooltip>

          </el-card>
        </div>
        <div class="event">
          <div class="title"
               style="text-align: center;font-size: 40px;width:100%;z-index: 10;font-family: 'MiSans';background: #ecdcec">
            活动管理
          </div>
          <div style="margin-top: 15px">
            <el-row gutter="20" style="margin-left: 10px;margin-right: 10px">
              <el-col
                v-for="(item,index) in yuyue_info"
                :key="index"
                :span="8"
              >
                <div v-if="item.id >= 0" class="con">
                  <el-card :body-style="{ padding: '0px' }" shadow="hover"
                           style="  margin-bottom: 20px;height: auto" @click="toreshow(item)">
                    <img
                      alt="加载错误"
                      class="image"
                      :src="item.imageurl"
                      style="max-width: 100%;height: auto;min-height: 400px;max-height: 400px"
                    />
                    <div style="padding: 14px">

                  <span
                    style="font-family: 'MiSans';word-break: break-all;;text-align: center;display:block;font-size: 20px">{{
                      item.activityname
                    }}
                    <el-icon class="dele" color="rgb(139,135,135)" size="15"><delete
                      @click.native.stop="ctrlz(item.id)" /></el-icon></span>
                      <el-divider />
                      <div class="bottom">
                        <el-tooltip content="活动状态" effect="light">


                          <div class="status">
                            <el-icon color="rgb(191,169,192)" size="17">
                              <Stopwatch />
                            </el-icon>
                            <p style="font-size: 13px">{{ item.status }}</p>
                          </div>
                        </el-tooltip>
                        <el-tooltip content="设计展厅" effect="light">
                          <div class="room">
                            <el-icon color="rgb(191,169,192)" size="17">
                              <Location />
                            </el-icon>
                            <p style="font-size: 13px">{{ item.roomname }}</p>
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
                        <el-tooltip content="预约人数" effect="light">
                          <div class="num">
                            <el-icon color="rgb(191,169,192)" size="17">
                              <User />
                            </el-icon>
                            <p style="font-size: 13px;">{{ item.accessnum }}</p>
                          </div>
                        </el-tooltip>
                      </div>
                    </div>
                  </el-card>
                </div>
                <div v-else-if="item.id<0" class="con2" style="align-content: center;"
                     @click="drawer2=true">
                  <el-link :underline="false"
                           style="font-family: 'MiSans ';font-size: 100px;display: flex;margin-top: 30%">+
                  </el-link>
                </div>
              </el-col>
            </el-row>
          </div>
        </div>
        <el-drawer
          v-model="drawer"
          :direction="'rtl'"
          append-to-body
          size="700"

        >
          <template #header>
            <el-text style="font-size: 40px;font-family: MiSans">场馆信息编辑</el-text>
          </template>
          <el-form label-position="top" label-width="auto" size="large">
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
              <el-input v-model="form.stadiumName" />
            </el-form-item>
            <el-form-item label="场馆地点">
              <el-input v-model="form.position" />
            </el-form-item>
            <el-form-item label="开放时间">
              <el-time-picker
                v-model="formtemp.beginTime"
                placeholder="选择开放时间"
                style="width: 100%"
                format="HH:mm:ss"
                value-format="HH:mm:ss"
              />
            </el-form-item>
            <el-form-item label="闭馆时间">
              <el-time-picker
                v-model="formtemp.endTime"
                placeholder="选择闭馆时间"
                style="width: 100%"
                format="HH:mm:ss"
                value-format="HH:mm:ss"
              />
            </el-form-item>
            <el-form-item label="联系方式">
              <el-input v-model="form.telephone" />
            </el-form-item>
            <el-form-item label="场馆简介">
              <el-input v-model="form.introduction" :autosize="{ minRows: 8, maxRows: 10 }" type="textarea" />
            </el-form-item>
            <el-form-item>
              <el-table :data="hallformtemp">
                <el-table-column label="展厅名" prop="hallName" />
                <el-table-column label="操作" width="100">
                  <template #header>
                    <el-button size="small" type="success" @click="addhall">新建</el-button>
                  </template>
                  <template v-slot="s">
                    <el-button size="small" type="primary" @click="edithall(s.row)">编辑</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="musesub">确定</el-button>
              <el-button @click="drawer=false">取消</el-button>
            </el-form-item>
            <el-drawer v-model="halldia" append-to-body direction="rtl" size="400">
              <template #header>
                <el-text style="font-size: 30px;">添加展厅</el-text>
              </template>
              <el-form label-position="top">
                <el-form-item label="添加展厅名称">
                  <el-input v-model="hallname"></el-input>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="addhallsub">确定</el-button>
                </el-form-item>
              </el-form>
            </el-drawer>
            <el-drawer v-model="halldia1" append-to-body direction="rtl" size="400">
              <template #header>
                <el-text style="font-size: 30px;">编辑展厅</el-text>
              </template>
              <el-form label-position="top">
                <el-form-item label="编辑展厅名称">
                  <el-input v-model="hallname1"></el-input>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="edithallsub">确定</el-button>
                </el-form-item>
              </el-form>
            </el-drawer>
          </el-form>
        </el-drawer>
        <el-drawer
          v-model="drawer2"
          append-to-body
          direction="rtl"
          size="600"
          custom-class="adrawer"
        >
          <template #header>
            <el-text style="font-size: 40px; font-family: MiSans">新增活动</el-text>
          </template>
          <el-form label-position="top" size="large">
            <el-upload
              :auto-upload="true"
              :file-list="fileListact"
              :multiple="false"
              :on-change="beforeUploadact"
              :show-file-list="false"
              action="#"
            >
              <el-button type="primary">上传活动图片</el-button>
            </el-upload>

            <el-form-item label="活动名" style="margin-top: 20px">
              <el-input v-model="actform.activityName" />
            </el-form-item>
            <el-form-item label="活动展厅">
              <el-select
                v-model="selecthall"
                multiple="true"
                placeholder="选择展厅"
                size="large"
                style="width: 240px"
              >
                <el-option
                  v-for="item in hallform"
                  :key="item.id"
                  :label="item.hallName"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="开放时间">
              <el-time-picker
                v-model="actformtime.beginTime"
                placeholder="选择开始时间"
                style="width: 100%"
                format="HH:mm:ss"
                value-format="HH:mm:ss"
              />
            </el-form-item>
            <el-form-item label="结束时间">
              <el-time-picker
                v-model="actformtime.endTime"
                placeholder="选择结束时间"
                style="width: 100%"
                format="HH:mm:ss"
                value-format="HH:mm:ss"
              />
            </el-form-item>
            <el-form-item label="可预约人数">
              <el-input v-model="actform.accessNum" type="number" />
            </el-form-item>
            <el-form-item label="活动简介">
              <el-input v-model="actform.introduction" :autosize="{ minRows: 2, maxRows: 4 }" type="textarea" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="addact">确定</el-button>
              <el-button @click="drawer2=false">取消</el-button>
            </el-form-item>
          </el-form>
        </el-drawer>
        <el-dialog v-model="dialog">
          <template #header>
            <el-text style="font-family: MiSans;font-size: 30px">撤销活动</el-text>
          </template>
          <el-form label-position="top" size="large">
            <el-form-item label="撤销理由">
              <el-input v-model="ctrlzform.reason" :autosize="{minRows:10,maxRows:20}" placeholder="输入撤销理由"
                        type="textarea"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="ctrlzsub">确定</el-button>
              <el-button @click="dialog=false">取消</el-button>
            </el-form-item>
          </el-form>
        </el-dialog>
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

.bottom {
  margin-top: 13px;
  line-height: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 2s;
}

.dele :hover {
  color: #c05f6c;
}

.welcome1 {
  position: absolute;
  font-family: "MiSans";
  font-weight: bold;
  font-size: 60px;
  color: #ffffff;
  text-align: center;
  left: 50%;
  margin-left: -220px;
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

.location {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
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

.time {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
}

.intro {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
}

.accessnum {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
}

.visnum {
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

.image2 {
  width: 100%;
  height: 100%;
  display: block;
  transform: scale(0.5);
  border: rgba(237, 237, 255, 0);
}

.num {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
}

.editl:hover {
  color: #c05f6c;
}

.room {
  font-size: 12px;
  font-family: "MiSans";
  color: #999;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 300;
}

.status {
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

.el-input {
  --el-input-focus-border-color: #c05f6c;
}
</style>
<script lang="ts" setup>
import { onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import Venueanimationheader from '@/components/VenueAdministrators/header/Venueanimationheader.vue'
import { Clock, Delete, Edit, Location, Phone, User } from '@element-plus/icons-vue'
import axios from 'axios'
import store from '@/stores'
import router from '@/router'
import { ElMessage } from 'element-plus'


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

const halldia = ref(false)
const hallformtemp = reactive([])
const hallname = ref('')
const form = reactive({
  beginTime: '0000-00-00 ',
  endTime: '4000-00-00 ',
  halls: [],
  imageURL: '',
  introduction: '',
  position: '',
  stadiumId: '',
  stadiumName: '',
  managerId: store.state.id,
  telephone: ''
})
const dialog = ref(false)
const museum_info = reactive(
  {
    name: '',
    location: '',
    tel: '',
    begintime: '',
    endtime: '',
    accessnum: '0',
    intro: '',
    src: '',
    id: ''
  }
)
const yuyue_info = reactive([])

const drawer = ref(false)
const drawer2 = ref(false)
const ctrlzform = reactive({
  activityId: '',
  reason: ''
})
const ctrlz = (id) => {
  dialog.value = true
  ctrlzform.activityId = id
}
const ctrlzsub = () => {
  if (ctrlzform.reason != '') {
    axios.get('/api/abc/managers/reverseActivity', {
      params: {
        activityId: ctrlzform.activityId,
        reason: ctrlzform.reason
      },
      headers: {
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
const hallform = reactive([])
axios.get('/api/abc/managers/getHomeInf', {
  params: {
    managerId: store.state.id
  },
  headers: {
    token: store.state.token
  }
}).then(res => {
  console.log(res)
  museum_info.name = res.data.data.stadiumDto.stadiumName
  museum_info.location = res.data.data.stadiumDto.position
  museum_info.tel = res.data.data.stadiumDto.telephone
  museum_info.begintime = res.data.data.stadiumDto.beginTime.split(' ')[1].split(':')[0] + ':' + res.data.data.stadiumDto.beginTime.split(' ')[1].split(':')[1]
  museum_info.endtime = res.data.data.stadiumDto.endTime.split(' ')[1].split(':')[0] + ':' + res.data.data.stadiumDto.endTime.split(' ')[1].split(':')[1]
  museum_info.src = res.data.data.stadiumDto.imageURL
  museum_info.id = res.data.data.stadiumDto.id
  for (let i = 0; i < res.data.data.activityDtos.length; i++) {
    museum_info.accessnum = String(parseInt(res.data.data.activityDtos[i].accessNum) + parseInt(museum_info.accessnum))
  }
  museum_info.intro = res.data.data.stadiumDto.introduction

  for (let i = 0; i < res.data.data.stadiumDto.hallDtos.length; i++) {
    hallform.push({
      id: res.data.data.stadiumDto.hallDtos[i].id,
      hallName: res.data.data.stadiumDto.hallDtos[i].hallName
    })
  }
  console.log(hallform)
})
axios.get('/api/abc/managers/selectActivityByName', {
  params: {
    activityName: store.state.muble_search,
    managerId: store.state.id
  },
  headers: {
    token: store.state.token
  }
}).then(res => {
  console.log(res.data.data)
  for (let i = 0; i < res.data.data.length; i++) {
    yuyue_info.push({
      id: 6,
      activityname: res.data.data[i].activityName,
      begintime: res.data.data[i].beginTime.split(' ')[1].split(':')[0] + ':' + res.data.data[i].beginTime.split(' ')[1].split(':')[1],
      endtime: res.data.data[i].endTime.split(' ')[1].split(':')[0] + ':' + res.data.data[i].endTime.split(' ')[1].split(':')[1],
      accessnum: res.data.data[i].accessNum,
      imageurl: res.data.data[i].imageURL,
      roomname: res.data.data[i].hallNames,
      status: res.data.data[i].status
    })
  }
  yuyue_info.push({
    id: -1,
    activityname: '',
    begintime: '',
    endtime: '',
    accessnum: -1,
    imageurl: '',
    roomname: '',
    status: ''
  })
})
const formtemp = reactive({
  url: '',
  beginTime: '',
  endTime: ''
})
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
    formtemp.url = res.data.data
  })
}

const musesub = () => {
  if (formtemp.url != '') {
    form.imageURL = formtemp.url
  } else
    form.imageURL = museum_info.src
  form.beginTime = '0000-00-00 ' + formtemp.beginTime
  form.endTime = '3000-00-00 ' + formtemp.endTime
  form.stadiumId = museum_info.id
  for (let i = 0; i < hallformtemp.length; i++) {
    form.halls.pop()
  }
  for (let i = 0; i < hallformtemp.length; i++) {
    form.halls.push({
      id: hallformtemp[i].id,
      stadiumId: hallformtemp[i].stadiumId,
      hallName: hallformtemp[i].hallName
    })
  }
  if (form.imageURL != '' && form.introduction != '' && form.position != '' && form.stadiumName != '' && form.telephone != '') {
    axios.post('/api/abc/managers/updateStadium', JSON.stringify(form), {
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
    ElMessage.error('请完整输入!')
  }
}
const toreshow = (data: any) => {
  store.dispatch('user_home_card_id_save', data.id)
  router.push('/reshow')
}
const seform = reactive({
  co: ''
})

const selecthall = ref('')

const fileListact = ref([])
const acturl = reactive({
  url: ''
})
const beforeUploadact = (file, fileList1) => {
  fileListact.value = fileList1
  let fd = new FormData()
  fileListact.value.forEach(item => {
    fd.append('multipartFile', item.raw)
    console.log(item.raw)
  })
  axios.post(`/api/abc/uploadfile/managerImageSaveOrUpdate?managerId=${store.state.id}`, fd, {
    headers: {
      'Content-Type': 'multipart/form-data',
      token: store.state.token
    }
  }).then(res => {
    acturl.url = res.data.data
  })
}
const actformtime = reactive({
  beginTime: '',
  endTime: ''
})
const actform = reactive({
  accessNum: '',
  activityName: '',
  beginTime: '2000-00-00 ',
  endTime: '3000-00-00 ',
  hallIdList: [],
  imageURL: acturl.url,
  introduction: '',
  managerId: store.state.id
})
const addact = () => {
  actform.hallIdList = []
  for (let i = 0; i < selecthall.value.length; i++) {
    actform.hallIdList.push(selecthall.value[i])
  }
  actform.beginTime = actform.beginTime + actformtime.beginTime
  actform.endTime = actform.endTime + actformtime.endTime
  actform.imageURL = acturl.url
  if (actform.imageURL != '' && actform.hallIdList.length != 0 && actform.beginTime != '2000-00-00 ' && actform.endTime != '3000-00-00 ' && actform.introduction != '' && actform.activityName != '' && actform.accessNum != '') {
    axios.post('/api/abc/managers/addActivity', JSON.stringify(actform), {
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
const gethall = () => {
  drawer.value = true
  form.stadiumName = museum_info.name
  formtemp.beginTime = museum_info.begintime + ':00'
  formtemp.endTime = museum_info.endtime + ':00'
  form.telephone = museum_info.tel
  form.imageURL = museum_info.src
  form.beginTime = museum_info.begintime
  form.telephone = museum_info.tel
  form.introduction = museum_info.intro
  form.position = museum_info.location
  form.stadiumId = museum_info.id
  console.log(form)
  axios.get('/api/abc/managers/getHalls', {
    params: {
      stadiumId: museum_info.id
    },
    headers: {
      token: store.state.token
    }
  }).then(res => {
    for (let i = 0; i < res.data.data.length; i++) {
      hallformtemp.pop()
    }
    for (let i = 0; i < res.data.data.length; i++) {
      hallformtemp.push({
        id: res.data.data[i].id,
        stadiumId: res.data.data[i].stadiumId,
        hallName: res.data.data[i].hallName
      })
    }
  })
}
const halldia1 = ref(false)
const hallname1 = ref('')
const formedithall = reactive({
  hallName: '',
  id: '',
  stadiumId: museum_info.id
})
const edithall = (row) => {
  halldia1.value = true
  formedithall.id = row.id
}
const edithallsub = () => {
  const forme = reactive({
    beginTime: '0000-00-00 ' + museum_info.begintime + ':00',
    endTime: '4000-00-00 ' + museum_info.endtime + ':00',
    halls: [],
    imageURL: museum_info.src,
    introduction: museum_info.intro,
    position: museum_info.location,
    stadiumId: museum_info.id,
    stadiumName: museum_info.name,
    managerId: store.state.id,
    telephone: museum_info.tel
  })

  formedithall.hallName = hallname1.value
  for (let i = 0; i < hallformtemp.length; i++) {
    if (hallformtemp[i].id == formedithall.id) {
      hallformtemp[i].id = formedithall.id
      hallformtemp[i].hallName = formedithall.hallName
      hallformtemp[i].stadiumId = museum_info.id
    }
  }
  for (let i = 0; i < hallformtemp.length; i++) {
    forme.halls.push({
      id: hallformtemp[i].id,
      stadiumId: museum_info.id,
      hallName: hallformtemp[i].hallName
    })
  }
  if (hallname1.value != '') {
    axios.post('/api/abc/managers/updateStadium', JSON.stringify(forme), {
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
    ElMessage.error('请完整输入')
  }

}
const addhall = () => {
  halldia.value = true
}
const addhallsub = () => {
  const formadd = reactive({
    beginTime: '0000-00-00 ' + museum_info.begintime + ':00',
    endTime: '4000-00-00 ' + museum_info.endtime + ':00',
    halls: [],
    imageURL: museum_info.src,
    introduction: museum_info.intro,
    position: museum_info.location,
    stadiumId: museum_info.id,
    stadiumName: museum_info.name,
    managerId: store.state.id,
    telephone: museum_info.tel
  })

  for (let i = 0; i < hallformtemp.length; i++) {
    formadd.halls.push({
      id: hallformtemp[i].id,
      stadiumId: museum_info.id,
      hallName: hallformtemp[i].hallName
    })
  }
  formadd.halls.push({
    id: '',
    stadiumId: '',
    hallName: hallname.value
  })
  if (hallname.value != '') {
    axios.post('/api/abc/managers/updateStadium', JSON.stringify(formadd), {
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
    ElMessage.error('请完整输入')
  }

}
const tomap = () => {
  router.push({
    path: '/mapven',
    query: {
      location: museum_info.location
    }
  })
}
</script>