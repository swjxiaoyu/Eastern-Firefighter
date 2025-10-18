
import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import { createPinia } from 'pinia'
import router from './router'
import { setupGlobalErrorHandler } from '@/utils/errorHandler'

const app = createApp(App)
const pinia = createPinia()
app.use(pinia)

// 启动时刷新角色
import { useAuthStore } from '@/stores/auth'
const auth = useAuthStore()
if (auth.token) auth.refreshProfile()

// 设置全局错误处理
setupGlobalErrorHandler()

app.use(router)
app.mount('#app')

