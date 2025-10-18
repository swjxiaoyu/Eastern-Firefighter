import axios from 'axios'

const http = axios.create({
  baseURL: '/api',
  timeout: 90000,
})

http.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers = config.headers ?? {}
    ;(config.headers as any).Authorization = `Bearer ${token}`
  }
  // 添加调试日志
  console.log('发送请求:', config.method?.toUpperCase(), config.url, config.data)
  return config
})

http.interceptors.response.use(
    (res) => {
      // 添加响应日志
      console.log('收到响应:', res.status, res.config.url, res.data)
      return res
    },
    (err) => {
      // 添加错误日志
      console.error('请求错误:', err.response?.status, err.config?.url, err.message)
      
      // 处理不同类型的错误
      if (err.code === 'NETWORK_ERROR' || !err.response) {
        // 网络错误
        console.error('网络连接失败')
        if (location.pathname !== '/network-error') {
          location.href = '/network-error'
        }
      } else if (err.response?.status === 401) {
        // 未授权
        localStorage.removeItem('token')
        if (location.pathname !== '/login') {
          location.href = '/login'
        }
      } else if (err.response?.status === 403) {
        // 权限不足
        if (location.pathname !== '/403') {
          location.href = '/403'
        }
      } else if (err.response?.status === 404) {
        // 资源不存在
        if (location.pathname !== '/404') {
          location.href = '/404'
        }
      } else if (err.response?.status >= 500) {
        // 服务器错误
        if (location.pathname !== '/500') {
          location.href = '/500'
        }
      }
      
      return Promise.reject(err)
    },
)

export default http

export const contentApi = {
  listArticles(params: { channel?: string; page?: number; size?: number } = {}) {
    return http.get('/content/articles', { params })
  },
  getArticle(slug: string) {
    return http.get(`/content/articles/${slug}`)
  },
} 