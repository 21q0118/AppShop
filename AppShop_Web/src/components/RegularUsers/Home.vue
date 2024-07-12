<template>
  <div>
    <el-container class="layout-container">
      <animationheader ref="myHeader" />
      <el-main style="height: 100vh;">
        <div class="welcome" style="width: 100% ;height: 100%">
          <div class="welcome1">
            场馆预约系统
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
        <div v-if="card_info.length==0" style="margin-top: 50px;text-align: center">
          <el-text style="font-size: 20px">暂无场馆</el-text>
        </div>
        <div v-if="card_info.length!=0" style="margin-top: 15px">
          <el-row gutter="20" style="margin-left: 10px;margin-right: 10px">
            <el-col
              v-for="(item,index) in card_info"
              :key="index"
              :span="8"
            >

              <el-card :body-style="{ padding: '0px' }" shadow="hover"
                       style="margin-bottom: 20px;background: rgba(255,255,255,70%)"
                       @click="card(item)">
                <img
                  :src="item.src"
                  alt="加载错误"
                  class="image"
                  style="max-width: 100%;height: auto;min-height: 400px;max-height: 400px"
                />
                <div style="padding: 14px">
                  <el-tooltip content="场馆名称" effect="light">
                      <span style="font-family: 'MiSans';text-align: center;display:block;font-size: 20px">{{
                          item.name
                        }} </span>
                  </el-tooltip>

                  <el-divider />
                  <div class="bottom">
                    <el-tooltip content="查看位置" effect="light">
                      <div class="location" @click.native.stop="tomap(item.location)">
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
                    <el-tooltip content="推荐场馆" effect="light">
                    <div v-if="index<3" class="tel">
                      <img src="@/assets/good.png" style="width: 25px;height: 25px">
                    </div>
                    </el-tooltip>
                  </div>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </div>
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
  margin-left: -180px;
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

.el-input {
  --el-input-focus-border-color: #c05f6c;
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

.image {
  width: 100%;
  height: 310px;
  display: block;
  border: rgba(237, 237, 255, 0);
}
</style>
<script lang="ts" setup>
import { onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import Animationheader from '@/components/RegularUsers/header/animationheader.vue'
import axios from 'axios'
import { useStore } from 'vuex'
import router from '@/router'

const store = useStore()


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
const isnull = ref(false)
const scroll = () => {
  window.scrollTo({
    top: window.innerHeight - 60,
    behavior: 'smooth'
  })
}
const card_info = reactive([])

axios.get('/api/abc/users/getHomeInf', {
  headers: {
    token: store.state.token
  },
  params: {
    userId: store.state.id
  }
}).then(res => {
  if (res.data.data.stadiumDtos.length != 0) {
    for (let i = 0; i < res.data.data.stadiumDtos.length; i++) {
      card_info.push({
        id: res.data.data.stadiumDtos[i].id,
        src: res.data.data.stadiumDtos[i].imageURL,
        name: res.data.data.stadiumDtos[i].stadiumName,
        location: res.data.data.stadiumDtos[i].position,
        tel: res.data.data.stadiumDtos[i].telephone,
        begintime: res.data.data.stadiumDtos[i].beginTime.split(' ')[1].split(':')[0] + ':' + res.data.data.stadiumDtos[i].beginTime.split(' ')[1].split(':')[1],
        endtime: res.data.data.stadiumDtos[i].endTime.split(' ')[1].split(':')[0] + ':' + res.data.data.stadiumDtos[i].endTime.split(' ')[1].split(':')[1]
      })
    }
  }
})
const card = (item: any) => {
  store.dispatch('user_home_card_id_save', item.id)
  console.log(store.state.user_home_card_id)
  router.push('/EventInfo')
}
const tomap = (lo) => {
  router.push({
    path: '/mapuser',
    query: {
      location: lo
    }
  })
}
</script>