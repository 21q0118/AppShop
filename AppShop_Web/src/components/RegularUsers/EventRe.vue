<template>
  <div>
    <el-container class="layout-container">
      <staticheader />
      <el-main style="height: 100vh;background: rgb(255,255,255);padding: 0;z-index: 8">
        <div class="museum">
          <el-card :body-style="{ padding: '0px' }" style="border-radius: 0;margin-top: 60px;height: auto">
            <div class="imgc" style="position: relative">
              <img
                :src="yuyue_info.imageurl"
                alt="加载错误"
                class="image"
                style="height: auto;width: 100%"
              />
              <el-tooltip content="活动名称" effect="light">
              <div
                style=" position: absolute;font-family: 'MiSans';font-weight: bold;font-size: 60px;color: #ffffff;text-align: center;left: 50%; top: 90%; transform: translate(-50%,-50%)">
                {{ yuyue_info.name }}
              </div>
              </el-tooltip>
            </div>
            <div class="bottom" style="padding: 14px; ">
              <el-tooltip content="活动简介" effect="light">
              <span
                style="font-family: 'MiSans';height: auto;font-weight: 300;text-align: center;font-size: 15px;color: #a1a1a1">{{ yuyue_info.intro
                }}</span>
              </el-tooltip>
            </div>
          </el-card>
        </div>
        <div class="title"
             style="text-align: center;font-size: 40px;width:100%;z-index: 10;font-family: 'MiSans';background: #ecdcec">
          预约申请Reservationrequest
        </div>
        <div style="margin-top: 15px">
        </div>
        <el-form :model="form" label-position="left" label-width="120px" style="font-family: 'MiSans '">
          <el-form-item label="预约日期"
                        style="width: 600px; margin-bottom: 1%;margin-left: 30px;font-family: 'MiSans '">
            <el-date-picker
              clearable
              v-model="form.date"
              :disabled-date="disabledDate"
              placeholder="预约日期"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
            />
          </el-form-item>
          <el-divider />
          <el-form-item label="预约人选择" style="margin-left: 30px">
            <div style="text-align: center;">
              <el-transfer
                v-model="value"
                :data="data"
                :titles="['现有预约人', '本次预约人']"
              >
              </el-transfer>
            </div>
          </el-form-item>
          <el-form-item style="margin-top: -90px;margin-left: 30px">
            <el-button color="" type="primary" @click="onSubmit">提交</el-button>
            <el-button type="primary" @click="drawer=true">新增</el-button>
          </el-form-item>
        </el-form>
        <el-drawer
          v-model="drawer"
          :direction="'rtl'"
          style="height: 100%"
          append-to-body
        >
          <template #header>
            <el-text style="font-family: MiSans;font-size: 40px">新增预约人</el-text>
          </template>
          <el-form label-position="top" size="large">
            <el-form-item label="姓名">
              <el-input v-model="addform.realName" clearable />
            </el-form-item>
            <el-form-item label="电话">
              <el-input v-model="addform.telephone" clearable />
            </el-form-item>
            <el-form-item label="身份证号">
              <el-input v-model="addform.identificationNum" clearable />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="add">确定</el-button>
              <el-button @click="cancle">取消</el-button>
            </el-form-item>
          </el-form>
        </el-drawer>
      </el-main>
    </el-container>
  </div>
</template>
<style scoped>
.layout-container .el-main {
  padding: 0;
}

.bottom {
  margin-top: 13px;
  line-height: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 2s;
}
.layout-container .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 20px;
}

.header {
  z-index: 10;
  text-align: right;
  font-size: 12px;
  position: fixed;
  width: 100%;
  box-shadow: 0px 1px 5px rgba(138, 134, 134, 0.87);
}

:deep(.el-form-item__label) {
  display: block;
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
import store from '@/stores'
import { ElMessage } from 'element-plus'

const data = ref([])
const value = ref([])

const person = reactive([])

axios.get('/api/abc/users/getAllVisitors', {
  headers: {
    token: store.state.token
  },
  params: {
    userId: store.state.id
  }
}).then(res => {
  for (let i = 0; i < res.data.data.length; i++) {
    person.push({
      key: i,
      name: res.data.data[i].realName,
      idnum: res.data.data[i].identificationNum,
      id: res.data.data[i].id
    })
  }
  data.value = generateData()
})

const generateData = () => {
  const states = person.map((i) => ({
    label: i.name + ' ' + i.idnum,
    key: i.key,
    id: i.id
  }))
  return states
}
const drawer = ref(false)
const yuyue_info = reactive(
  {
    imageurl: '',
    intro: '',
    name: ''
  }
)

axios.get('/api/abc/users/searchActivity', {
  headers: {
    token: store.state.token
  },
  params: {
    activityId: store.state.user_event_card_id
  }
}).then(res => {
  yuyue_info.imageurl = res.data.data.imageURL
  yuyue_info.intro = res.data.data.introduction
  yuyue_info.name = res.data.data.activityName
})
const form = reactive({
  name: '',
  tel: '',
  id: '',
  date: '',
  time: ''
})


const onSubmit = () => {
  const rightvalue = reactive([])
  for (let i = 0; i < value.value.length; i++) {
    rightvalue.push({
      id: person[value.value[i]].id
    })
  }
  console.log(rightvalue)
  const form1 = reactive({
    activityId: store.state.user_event_card_id,
    reserveBegTime: form.date + ' ' + '08:00:00',
    reserveEndTime: form.date + ' ' + '20:00:00',
    userId: store.state.id,
    visitorIds: []
  })
  for (let i = 0; i < rightvalue.length; i++) {
    form1.visitorIds.push(rightvalue[i].id)
  }
  if (form1.reserveBegTime == ' 08:00:00' || form1.reserveEndTime == ' 20:00:00')
  {
    ElMessage.error('请完整选择时间！')
  }
  else if(form1.visitorIds.length == 0)
  {
    ElMessage.error('请选择预约人！')
  }else{

    axios.post('/api/abc/users/reserve', JSON.stringify(form1), {
    headers: {
      'Content-Type': 'application/json',
      token: store.state.token
    }
  }).then(res => {
    if (res.data.code == 400) {
      ElMessage.error(res.data.msg)
    } else if (res.data.code == 200) {
      ElMessage.success('预约成功')
      setTimeout(() => location.reload(), 600)
    }
  })
  }
  
}


const addform = reactive({
  identificationNum: '',
  realName: '',
  telephone: '',
  userId: store.state.id
})
const add = () => {
  if (addform.telephone != '' && addform.realName != '' && addform.identificationNum != '') {
    axios.post('/api/abc/users/addVisitor', JSON.stringify(addform), {
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
    ElMessage.error('请填入完整信息')
  }
}

const cancle = () => {
  drawer.value = false
}
</script>