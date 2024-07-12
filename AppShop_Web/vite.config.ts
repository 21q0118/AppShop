import { fileURLToPath, URL } from 'node:url'
import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'

import path from 'path'
import fs from 'fs'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueJsx()
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    open: true,
    https: {
      // ��Ҫ���������е������ļ�����Ҫ�������� fs �� path ��������
      cert: fs.readFileSync(path.join(__dirname, 'src/ssl/cert.crt')),
      key: fs.readFileSync(path.join(__dirname, 'src/ssl/cert.key'))
    },
    proxy: {
      '/api': {
        target: loadEnv('', process.cwd()).VITE_API_URL,
        secure: false,
        changeOrigin: true,
        rewrite: path => path.replace(/^\/api/, '')
      }
    }
  }
})