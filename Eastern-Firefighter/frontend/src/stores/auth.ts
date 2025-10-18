/**
 * 项目：Eastern-Firefighter
 * 文件：Eastern-Firefighter\frontend\src\stores\auth.ts
 * 说明：自动添加的文件头注释。
 * 创建日期：2025-09-09
 */
import { defineStore } from 'pinia'

interface AuthState {
  token: string | null
  role: string | null
  profile: any | null
}

export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({
    token: localStorage.getItem('token'),
    role: (localStorage.getItem('role') as string) || null,
    profile: null,
  }),
  actions: {
    setToken(token: string) {
      this.token = token
      localStorage.setItem('token', token)
    },
    setRole(role: string | null){
      this.role = role
      if (role) localStorage.setItem('role', role); else localStorage.removeItem('role')
    },
    async refreshProfile(){
      if (!this.token) { this.profile = null; this.setRole(null); return }
      try{
        const res = await (await import('@/api/http')).default.get('/auth/profile/me')
        this.profile = res.data?.data || null
        const r = this.profile?.role ? String(this.profile.role).toUpperCase() : null
        this.setRole(r)
      }catch{
        this.profile = null
        this.setRole(null)
      }
    },
    logout() {
      this.token = null
      this.profile = null
      this.setRole(null)
      localStorage.removeItem('token')
      location.href = '/login'
    },
  },
}) 
