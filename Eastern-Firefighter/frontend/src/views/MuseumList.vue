<template>
  <section class="page">
    <div class="hero">
      <h1>应急安全主题展馆</h1>
      <p class="sub">选择城市与主题，预约沉浸式体验</p>
      <div class="filters">
        <input v-model="city" class="input" placeholder="城市（如：上海）" @keyup.enter="load" />
        <select v-model="theme" class="select" @change="load">
          <option value="">全部主题</option>
          <option value="fire">消防安全</option>
          <option value="earthquake">地震避险</option>
          <option value="firstaid">急救科普</option>
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
      <article v-for="m in list" :key="m.id" class="card" @click="$router.push(`/museums/${m.id}`)">
        <img :src="m.coverUrl || fallback" class="cover" @error="onImgErr" />
        <div class="body">
          <h3 class="title">{{ m.name }}</h3>
          <p class="meta">{{ m.city }} · {{ m.themeName }} · 可预约</p>
          <p class="desc">{{ m.summary }}</p>
        </div>
      </article>
      <div v-if="!list.length" class="empty">暂无展馆</div>
    </div>
  </section>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { ref, onMounted } from 'vue'

const list = ref<any[]>([])
const city = ref('')
const theme = ref('')
const loading = ref(false)
const error = ref('')
const fallback = '/images/img_1.png'

function onImgErr(e: Event){ const el = e.target as HTMLImageElement; el.src = fallback; el.onerror = null }

async function load(){
  loading.value = true; error.value=''
  try{
    const params:any = { page:1, size:100 }
    if (city.value.trim()) params.city = city.value.trim()
    if (theme.value) params.theme = theme.value
    const { data } = await http.get('/museum/list', { params })
    list.value = data?.data?.records || []
  }catch(e:any){
    error.value = e?.message || '服务器错误'
    list.value = []
  }finally{
    loading.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.page{ padding:16px }
.hero{ text-align:center; margin:16px 0 }
.sub{ color:var(--muted) }
.filters{ display:flex; gap:8px; justify-content:center; margin:12px 0 }
.input, .select{ padding:10px 12px; border:1px solid #e5e7eb; border-radius:8px; min-width:220px }
.grid{ display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:14px }
.card{ background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 4px 18px rgba(0,0,0,.06); cursor:pointer; transition:.2s }
.card:hover{ transform:translateY(-2px) }
.cover{ width:100%; height:150px; object-fit:cover }
.body{ padding:12px }
.title{ margin:0 0 6px }
.meta{ margin:0; color:var(--muted); font-size:12px }
.desc{ margin:8px 0 0; color:#475569; height:42px; overflow:hidden }
.empty{ grid-column:1/-1; text-align:center; color:var(--muted); padding:20px 0 }
</style> 