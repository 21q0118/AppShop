<template>
  <router-view />
</template>
<style lang="scss">
::-webkit-scrollbar {
  width: 0 !important;
}

::-webkit-scrollbar {
  width: 0 !important;
  height: 0;
}

.el-transfer-panel__list.is-filterable {
  width: 400px !important;
  height: 400px !important;
}

.el-transfer-panel {
  width: 400px !important;
  height: 400px !important;
}

.fade-enter-from,
.fade-leave-to {
  /*定义进入开始和离开结束的透明度为0*/
  opacity: 0;
}

.fade-leave-to {
  transform: translateX(20px);
}

.fade-enter-to {
  transform: translateX(-20px);
}

.fade-enter-to,
.fade-leave-from {
  /*定义进入结束和离开开始的透明度为1*/
  opacity: 1;
}

.fade-leave-active, .fade-enter-active {
  transition: all 0.5s ease-out;
}
</style>

<script lang="ts" setup></script>