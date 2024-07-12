<template>
  <Sysstaticheader />
  <div class="title"
       style="text-align: center;font-size: 40px;width:100%;z-index: 10;font-family: 'MiSans';background: #ecdcec">
    详细地址
  </div>
  <div>
    <div id="container" ref="amap"></div>
    <div id="panel" style="margin-top: 60px"></div>
  </div>
</template>

<script>
import AMapLoader from '@amap/amap-jsapi-loader'
import axios from 'axios'
import Sysstaticheader from '@/components/SystemAdminintrators/header/Sysstaticheader.vue'
import Staticheader from '@/components/RegularUsers/header/staticheader.vue'

export default {
  components: { Staticheader, Sysstaticheader },
  data() {
    return {
      x: null,
      y: null,
      loaction: this.$route.query.location,
      map: null,
      placeSearch: null,
      mapModule: null // AMap
    }
  },
  beforeMount() {
    axios.get('https://restapi.amap.com/v3/geocode/geo', {
      params: {

        address: this.$route.query.location,
        key: 'd90a5d0c9f5a3365aff129cdd98f51da'
      }
    }).then(res => {
      console.log('axios')
      this.x = res.data.geocodes[0].location.split(',')[0]
      this.y = res.data.geocodes[0].location.split(',')[1]
      this.initAMap()
    })
  },
  mounted() {
    window._AMapSecurityConfig = {
      securityJsCode: 'e96a93dd0691e2fb0ecd0c4362e2927d' // 申请key对应的秘钥 -> 注意了，如果不搭配密钥使用，搜索将没有结果
    }
    // 初始化地图

  },
  destroyed() {
    // 销毁地图
    this.map.destroy()
  },
  methods: {
    // 初始化地图函数
    initAMap() {
      console.log('init')
      const _this = this
      AMapLoader.load({
        key: '35d278230b01f5ef98cf0aaff312aa9b', // 申请好的Web端开发者Key，首次调用 load 时必填
        version: '2.0', // 指定要加载的 JSAPI 的版本，缺省时默认为 1.4.15
        plugins: []
      })
        .then((AMap) => {
          // 保存AMap实例
          _this.mapModule = AMap
          const map = new AMap.Map('container', {
            // 设置地图容器id
            pitch: 50, //地图俯仰角度，有效范围 0 度- 83 度
            viewMode: '3D', //地图模式
            rotateEnable: true, //是否开启地图旋转交互 鼠标右键 + 鼠标画圈移动 或 键盘Ctrl + 鼠标左键画圈移动
            pitchEnable: true, //是否开启地图倾斜交互 鼠标右键 + 鼠标上下移动或键盘Ctrl + 鼠标左键上下移动
            zoom: 17, //初始化地图层级
            rotation: -15, //初始地图顺时针旋转的角度
            zooms: [2, 20], //地图显示的缩放级别范围
            // 可以设置初始化当前位置
            center: [this.x, this.y],
            resizeEnable: true
          })
          // 添加控件
          AMap.plugin(
            [
              'AMap.ElasticMarker',
              'AMap.Scale',
              'AMap.ToolBar',
              'AMap.HawkEye',
              'AMap.MapType',
              'AMap.Geolocation',
              'AMap.AutoComplete',
              'AMap.PlaceSearch'
            ],
            () => {
              map.addControl(new AMap.ElasticMarker())
              map.addControl(new AMap.Scale())
              map.addControl(new AMap.ToolBar())
              map.addControl(new AMap.HawkEye())
              map.addControl(new AMap.MapType())
              map.addControl(new AMap.Geolocation())
            }
          )
          _this.map = map
          // 搜索功能
          _this.toSearch()
        })
        .catch((e) => {
          console.log(e)
        })
    },
    toSearch() {
      const _this = this
      // 实例化AutoComplete
      const autoOptions = {
        // input 为绑定输入提示功能的input的DOM ID,注意这个id要个搜索输入框的id一致
        input: 'tipinput'
      }
      const autoComplete = new _this.mapModule.AutoComplete(autoOptions)
      autoComplete.on('select', _this.select)// 注册监听，当选中某条记录时会触发
    },
    select(e) {
      const _this = this
      // 无需再手动执行search方法，autoComplete会根据传入input对应的DOM动态触发search
      // { map: _this.map } ==> 这个对象是能配置的 --> 根据官方文档配置即可，需要什么配置什么
      const placeSearch = new _this.mapModule.PlaceSearch({
        map: _this.map
      })
      placeSearch.setCity(e.poi.adcode)
      placeSearch.search(e.poi.name) // 关键字查询查询
    }

  }
}


</script>
<style lang='less' scoped>
#container {
  padding: 0px;
  margin: 0px;
  width: 100%;
  height: 1300px;
}
</style>