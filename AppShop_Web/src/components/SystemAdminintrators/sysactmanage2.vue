<template>
  <div>
    <el-container class="layout-container">
      <Sysstaticheader />
      <el-main style="height: 100vh;background: rgb(250,250,250);padding: 0;z-index: 8;margin-top: 60px">
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
                {{
                  museum_info.name
                }}
                <el-icon class="edit1" color="rgb(255,255,255)" size="20" @click="openedit">
                  <Edit />
                </el-icon>
                <el-icon class="edit1" color="rgb(255,255,255)" size="20" style="margin-left: 5px" @click="toactnotice">
                  <Bell />
                </el-icon>
              </div>
            </div>
            <div class="bottom" style="padding: 20px">
              <el-tooltip content="查看位置" effect="light">


                <div class="location" @click.native.stop="tosysmap">
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


            <div style="padding: 14px">
              <span
                style="font-family: 'MiSans';font-weight: 300;text-align: center;display:block;font-size: 15px;line-height: 20px;color: #a1a1a1">{{
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
                <el-card :body-style="{ padding: '0px' }" shadow="hover"
                         style="  margin-bottom: 20px;height: auto" @click="tocom(item)">
                  <div v-if="item.id >= 0" class="con">
                    <img
                      alt="加载错误"
                      class="image"
                      :src="item.imageurl"
                      style="max-width: 100%;height: auto;min-height: 400px;max-height: 400px"
                    />
                    <div style="padding: 14px">
                      <el-tooltip content="活动名称" effect="light">
                  <span
                    style="font-family: 'MiSans';word-break: break-all;;text-align: center;display:block;font-size: 20px">{{
                      item.activityname
                    }}</span>
                      </el-tooltip>
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
                        <el-tooltip content="涉及展厅" effect="light">
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
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </div>
        </div>
        <el-drawer
          v-model="drawer"
          :direction="'rtl'"
          append-to-body
          size="600"
        >
          <template #header>
            <el-text style="font-size: 40px;">编辑场馆信息</el-text>
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
              <el-input v-model="form.stadiumName" />
            </el-form-item>
            <el-form-item label="场馆地点">
              <el-input v-model="form.position" />
            </el-form-item>
            <el-form-item label="联系方式">
              <el-input v-model="form.telephone" />
            </el-form-item>
            <el-form-item label="开放时间">
              <el-time-picker
                v-model="timetemp.bt"
                placeholder="选择开放时间"
                style="width: 100%"
                format="HH:mm:ss"
                value-format="HH:mm:ss"
              />
            </el-form-item>
            <el-form-item label="结束时间">
              <el-time-picker
                v-model="timetemp.et"
                placeholder="选择闭馆时间"
                style="width: 100%"
                format="HH:mm:ss"
                value-format="HH:mm:ss"
              />
            </el-form-item>
            <el-form-item label="场馆简介">
              <el-input v-model="form.introduction" :autosize="{ minRows: 10, maxRows: 20 }" type="textarea" />
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
              <el-button type="primary" @click="allsub">确定</el-button>
              <el-button @click="drawer=false">取消</el-button>
            </el-form-item>
          </el-form>
        </el-drawer>
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
      </el-main>
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

.edit1:hover {
  color: #c05f6c;
}
.bottom {
  margin-top: 13px;
  line-height: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 2s;
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
import { Clock, Edit, Location, Phone, User } from '@element-plus/icons-vue'
import Sysstaticheader from '@/components/SystemAdminintrators/header/Sysstaticheader.vue'
import axios from 'axios'
import store from '@/stores'
import router from '@/router'
import { ElMessage } from 'element-plus'

const textarea1 = ref('')
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

axios.get('/api/abc/superManager/getSingleStadiumInf', {
  params: {
    managerId: store.state.id,
    stadiumId: store.state.user_home_card_id
  },
  headers: {
    token: store.state.token
  }
}).then(res => {
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

})
axios.get('/api/abc/superManager/selectActivityByName', {
  params: {
    activityName: store.state.muble_search,
    stadiumId: store.state.user_home_card_id
  },
  headers: {
    token: store.state.token
  }
}).then(res => {
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
})
const tocom = (item: any) => {
  store.dispatch('user_event_card_id_save', item.id)
  router.push('sysreshow')
}
const seform = reactive({
  co: ''
})
const searchsta = () => {
  if (seform.co != '') {
    store.dispatch('muble_save', seform.co)
    router.push('/sysactmanage2')
  } else {
    ElMessage.error('请完整输入')
  }

}
const toactnotice = () => {
  router.push('/sysactrelease')
}
const form = reactive({
  beginTime: '',
  endTime: '',
  halls: [],
  imageURL: '',
  introduction: '',
  position: '',
  stadiumId: store.state.user_home_card_id,
  stadiumName: '',
  superManagerId: store.state.id,
  telephone: ''
})
const timetemp = reactive({
  bt: '',
  et: '',
  url: ''
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
    timetemp.url = res.data.data
  })
}
const hallformtemp = reactive([])
axios.get('/api/abc/superManager/getHalls', {
  params: {
    stadiumId: store.state.user_home_card_id
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
const halldia = ref(false)
const addhall = () => {
  halldia.value = true
}
const openedit = () => {
  drawer.value = true
  form.introduction = museum_info.intro
  timetemp.bt = museum_info.begintime + ':00'
  timetemp.et = museum_info.endtime + ':00'
  form.telephone = museum_info.tel
  form.stadiumName = museum_info.name
  form.position = museum_info.location
}
const hallname = ref('')
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
    superManagerId: store.state.id,
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
    axios.post('/api/abc/superManager/updateStadium', JSON.stringify(formadd), {
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
const halldia1 = ref(false)
const addhall1 = reactive({
  id: '',
  hallName: '',
  stadiumId: museum_info.id
})
const edithall = (row) => {
  halldia1.value = true
  addhall1.id = row.id
}
const hallname1 = ref('')
const edithallsub = () => {
  const formadd = reactive({
    beginTime: '0000-00-00 ' + museum_info.begintime + ':00',
    endTime: '4000-00-00 ' + museum_info.endtime + ':00',
    halls: [],
    imageURL: museum_info.src,
    introduction: museum_info.intro,
    position: museum_info.location,
    stadiumId: museum_info.id,
    stadiumName: museum_info.name,
    superManagerId: store.state.id,
    telephone: museum_info.tel
  })
  for (let i = 0; i < hallformtemp.length; i++) {
    if (addhall1.id == hallformtemp[i].id) {
      hallformtemp[i].id = addhall1.id
      hallformtemp[i].stadiumId = addhall1.stadiumId
      hallformtemp[i].hallName = hallname1.value
    }
  }
  for (let i = 0; i < hallformtemp.length; i++) {
    formadd.halls.push({
      id: hallformtemp[i].id,
      stadiumId: store.state.user_home_card_id,
      hallName: hallformtemp[i].hallName
    })
  }
  if (hallname1.value != '') {
    axios.post('/api/abc/superManager/updateStadium', JSON.stringify(formadd), {
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
const allsub = () => {
  if (timetemp.url != '') {
    form.imageURL = timetemp.url
  } else {
    form.imageURL = museum_info.src
  }
  form.beginTime = '0000-00-00 ' + timetemp.bt
  form.endTime = '3000-00-00 ' + timetemp.et
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
  if (form.halls.length > 0 && form.imageURL != '' && form.introduction != '' && form.position != '' && form.stadiumName != '' && form.telephone != '') {
    axios.post('/api/abc/superManager/updateStadium', JSON.stringify(form), {
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
const tosysmap = () => {
  router.push({
    path: '/mapsys',
    query: {
      location: museum_info.location
    }
  })
}
</script>