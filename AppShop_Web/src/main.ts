import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'
import 'animate.css/animate.min.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import store from './stores/index'
import echarts from '@/echarts'

const app = createApp(App)

app.use(ElementPlus, {
  locale: zhCn
})

app.use(store)
app.use(createPinia())

app.use(router)
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
app.use(echarts)
app.mount('#app')
