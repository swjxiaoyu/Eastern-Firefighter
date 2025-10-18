<template>
  <section class="page">
    <div class="hero">
      <h1>安全培训课程</h1>
      <p class="sub">系统化学习消防应急知识，拿证更高效</p>
      <div class="filters">
        <input v-model="keyword" class="input" placeholder="搜索课程/讲师" @keyup.enter="load" />
        <select v-model="level" class="select" @change="load">
          <option value="">全部难度</option>
          <option value="beginner">入门</option>
          <option value="intermediate">进阶</option>
          <option value="advanced">高级</option>
        </select>
      </div>
    </div>

    <div v-if="error" class="error">
      加载失败：{{ error }}
      <button class="btn outline" @click="load">重试</button>
    </div>
    <div v-else-if="loading" class="grid">
      <div class="card skeleton" v-for="i in 6" :key="i" style="height:220px"></div>
    </div>
    <div v-else class="grid">
      <article v-for="c in list" :key="c.id" class="card" @click="$router.push(`/courses/${c.id}`)">
        <img :src="c.coverUrl || fallback" class="cover" loading="lazy" @error="onImgErr" />
        <div class="body">
          <h3 class="title">{{ c.title }}</h3>
          <p class="meta">
            <span>{{ labelOf(c.level) }}</span>
            <span>· {{ c.duration }} 学时</span>
            <span>· {{ c.lecturer }}</span>
          </p>
          <p class="desc">{{ c.summary }}</p>
        </div>
      </article>
      <div v-if="!list.length" class="empty">暂无课程</div>
    </div>
  </section>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { ref, onMounted } from 'vue'

interface Course { id:number; title:string; coverUrl:string; summary:string; level:string; duration:number; lecturer:string }

const list = ref<Course[]>([])
const keyword = ref('')
const level = ref('')
const loading = ref(false)
const error = ref('')
const fallback = '/images/img_1.png'

function onImgErr(e: Event){ const el = e.target as HTMLImageElement; el.src = fallback; el.onerror = null }

async function load(){
  loading.value = true; error.value=''
  try{
    const params:any = { page:1, size:100 }
    if (keyword.value.trim()) params.keyword = keyword.value.trim()
    if (level.value) params.level = level.value
    const { data } = await http.get('/training/courses', { params })
    list.value = data?.data?.records || []
  }catch(e:any){
    error.value = e?.message || '服务器错误'
    list.value = []
  }finally{
    loading.value = false
  }
}

function labelOf(lv:string){
  return ({ beginner:'入门', intermediate:'进阶', advanced:'高级' } as any)[lv] || lv
}

onMounted(load)
</script>

<style scoped>
.page{ padding:16px }
.hero{ text-align:center; margin:16px 0 8px }
.sub{ color:var(--muted); margin:0 }
.filters{ display:flex; gap:8px; justify-content:center; margin:12px 0 }
.input, .select{ padding:10px 12px; border:1px solid #e5e7eb; border-radius:8px; min-width:240px }
.grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(260px,1fr)); gap:14px; }
.card{ background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 4px 18px rgba(0,0,0,.06); cursor:pointer; transition:.2s }
.card:hover{ transform:translateY(-2px); box-shadow:0 10px 24px rgba(0,0,0,.08) }
.cover{ width:100%; height:150px; object-fit:cover }
.body{ padding:12px }
.title{ margin:0 0 6px; font-size:16px }
.meta{ margin:0; color:var(--muted); font-size:12px; display:flex; gap:6px; flex-wrap:wrap }
.desc{ margin:8px 0 0; color:#475569; font-size:13px; line-height:1.6; height:42px; overflow:hidden }
.empty{ grid-column:1/-1; text-align:center; color:var(--muted); padding:20px 0 }
@media (min-width: 1024px){ .cover{ height:180px } }
</style> 