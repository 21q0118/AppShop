<template>
  <el-container class="layout-container">
    <sysstaticheader />
    <el-main style="height: 100vh;background: rgb(255,255,255);padding: 0;z-index: 8">
      <div class="title"
           style="text-align: center;font-size: 40px;width:100%;z-index: 10;margin-top: 60px;font-family: 'MiSans';background: #ecdcec">
        活动评价
      </div>
      <div style="margin-top: 15px">
        <el-table v-loading :cell-style="{ textAlign: 'center' }"
                  :data="filterTableData"
                  :default-sort="{ prop: 'time', order: 'ascending' }" :header-cell-style="{ 'text-align': 'center' }"
                  lazy
                  max-height="85vh"
                  style="width: 100%;"
        >
          <el-table-column label="序号" type="index" width="100" />
          <el-table-column label="评论人" prop="userName" />
          <el-table-column label="分数" prop="score">
            <template v-slot="act">
              <el-rate
                v-model="act.row.score"
                disabled
                score-template="{value} 分"
                show-score
                text-color="#ff9900" />
            </template>
          </el-table-column>
          <el-table-column label="内容" prop="content" />
          <el-table-column label="时间" prop="commentTime" />
          <el-table-column width="200">
            <template #header>
              <el-text>平均分数</el-text>
              <el-rate
                v-model="avgscoreform.average"
                disabled
                score-template="{value} 分"
                show-score
                text-color="#ff9900"></el-rate>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-main>
  </el-container>
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

.el-input {
  --el-input-focus-border-color: #c05f6c;
}
</style>
<script lang="ts" setup>
import { computed, reactive, ref } from 'vue'
import axios from 'axios'
import store from '@/stores'
import Sysstaticheader from '@/components/SystemAdminintrators/header/Sysstaticheader.vue'

const Tdata = reactive({
  tableData: []
})
const search = ref('')
const filterTableData = computed(() =>
  Tdata.tableData.filter(
    (data) =>
      !search.value ||
      data.name.toLowerCase().includes(search.value.toLowerCase())
  )
)
const avgscoreform = reactive({
  average: ''
})
axios.get('/api/abc/superManager/getCommentByActivity', {
  params: {
    activityId: store.state.user_event_card_id
  },
  headers: {
    token: store.state.token
  }
}).then(res => {
  avgscoreform.average = res.data.data.averageScore.toFixed(1)
  for (let i = 0; i < res.data.data.commentDtos.length; i++) {
    Tdata.tableData.push({
      userName: res.data.data.commentDtos[i].userName,
      score: parseInt(res.data.data.commentDtos[i].score),
      content: res.data.data.commentDtos[i].content,
      commentTime: res.data.data.commentDtos[i].commentTime
    })
  }
})
</script>