<template>
  <div>
    <el-container class="layout-container">
      <staticheader />
      <el-main style="height: 100vh;background: rgb(250,250,250);padding: 0;z-index: 8">
        <div class="museum">
          <el-card :body-style="{ padding: '0px' }" style="border-radius: 0;margin-top: 60px;height: auto">
            <div class="imgc" style="position: relative">
              <img
                :src="museum_info.src"
                alt="加载错误"
                class="image"
                style="height: auto;width: 100%"
              />
              <el-tooltip content="场馆名称" effect="light">
                <div
                  style=" position: absolute;font-family: 'MiSans';font-weight: bold;font-size: 60px;color: #ffffff;text-align: center;left: 50%; top: 90%; transform: translate(-50%,-50%)">
                  {{ museum_info.name }}
                </div>
              </el-tooltip>
            </div>
            <div class="bottom" style="padding: 14px; ">
              <el-tooltip content="场馆简介" effect="light">
              <span
                style="font-family: 'MiSans';height: auto;font-weight: 300;text-align: center;font-size: 15px;color: #a1a1a1">{{ museum_info.intro
                }}</span>
              </el-tooltip>
            </div>
          </el-card>
        </div>
        <div class="title"
             style="text-align: center;font-size: 40px;width:100%;z-index: 10;font-family: 'MiSans'; background: #ecdcec">
          活动预约EventReservation
        </div>
        <div v-if="yuyue_info.length==0" style="margin-top: 50px;text-align: center">
          <el-text style="font-size: 20px">暂无进行中或即将开始的活动</el-text>
        </div>
        <div v-if="yuyue_info.length!=0" style="margin-top: 15px">
          <el-row gutter="20" style="margin-left: 10px;margin-right: 10px">
            <el-col
              v-for="(item,index) in yuyue_info"
              :key="index"
              :span="8"
            >
              <el-card :body-style="{ padding: '0px' }" shadow="hover" style="margin-bottom: 20px;height: auto"
                       @click=event(item)>
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
                    <el-tooltip content="活动展厅" effect="light">
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
                    <el-tooltip content="推荐活动" effect="light">
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

.bottom {
  margin-top: 13px;
  line-height: 20px;
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

.el-input {
  --el-input-focus-border-color: #c05f6c;
}
</style>
<script lang="ts" setup>
import { reactive, ref } from 'vue'
import Staticheader from '@/components/RegularUsers/header/staticheader.vue'
import axios from 'axios'
import { useStore } from 'vuex'
import router from '@/router'

const store = useStore()


const museum_info = reactive(
  {
    src: '',
    intro: '',
    name: ''
  }
)
const isnull = ref(false)
const yuyue_info = reactive([])
axios.get('/api/abc/users/getSingleStadiumInf', {
  headers: {
    token: store.state.token
  },
  params: {
    stadiumId: store.state.user_home_card_id
  }
}).then(res => {
  museum_info.src = res.data.data.stadiumDto.imageURL
  museum_info.intro = res.data.data.stadiumDto.introduction
  museum_info.name = res.data.data.stadiumDto.stadiumName
  for (let i = 0; i < res.data.data.activityDtos.length; i++) {
    if (res.data.data.activityDtos.length != 0) {
      yuyue_info.push({
        id: res.data.data.activityDtos[i].id,
        activityname: res.data.data.activityDtos[i].activityName,
        begintime: res.data.data.activityDtos[i].beginTime.split(' ')[1].split(':')[0] + ':' + res.data.data.activityDtos[i].beginTime.split(' ')[1].split(':')[1],
        endtime: res.data.data.activityDtos[i].endTime.split(' ')[1].split(':')[0] + ':' + res.data.data.activityDtos[i].endTime.split(' ')[1].split(':')[1],
        accessnum: res.data.data.activityDtos[i].accessNum,
        imageurl: res.data.data.activityDtos[i].imageURL,
        roomname: res.data.data.activityDtos[i].hallNames,
        status: res.data.data.activityDtos[i].status
      })
    }
  }
})
const event = (data: any) => {
  store.dispatch('user_event_card_id_save', data.id)
  console.log(store.state.user_event_card_id)
  router.push('/EventR')
}
</script>