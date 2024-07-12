<template>
  <div id="app">
    <button @click="pickFile">选择文件</button>
    <input type="file" ref="fileInput" style="display: none" @change="onFileChange">
    <p v-if="uploadStatus">{{ uploadStatus }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      uploadStatus: ''
    };
  },
  methods: {
    pickFile() {
      this.$refs.fileInput.click();
    },
    onFileChange(event) {
      const file = event.target.files[0];
      if (file) {
        this.uploadFile(file);
      }
    },
    async uploadFile(file) {
      const formData = new FormData();
      formData.append('file', file);

      try {
        const response = await fetch('/api/upload', {
          method: 'POST',
          body: formData
        });

        if (response.ok) {
          this.uploadStatus = '上传成功';
        } else {
          this.uploadStatus = '上传失败';
        }
      } catch (error) {
        this.uploadStatus = '上传失败';
      }
    }
  }
};
</script>

<style scoped>
#app {
  text-align: center;
}
</style>
