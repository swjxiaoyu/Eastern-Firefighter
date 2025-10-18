<template>
  <section class="page" v-if="museum">
    <div class="hero-fire" :style="`background-image:url('${museum.coverUrl}')`">
      <div class="overlay"></div>
      <div class="wrap">
        <div class="badges">
          <span class="badge">{{ museum.themeName }}</span>
          <span class="badge secondary">{{ museum.city }}</span>
        </div>
        <h1 class="title">{{ museum.name }}</h1>
        <p class="desc">{{ museum.summary }}</p>
        <div class="cta">
          <button class="btn primary" @click="book">快速预约</button>
        </div>
      </div>
    </div>

    <div class="layout">
      <div class="panel">
        <h2>预约参观</h2>
        <div class="form">
          <label>日期</label>
          <input type="date" class="input" v-model="form.date" />
          <label>时段</label>
          <select class="input" v-model="form.slot">
            <option value="morning">上午 09:00-11:30</option>
            <option value="afternoon">下午 14:00-16:30</option>
          </select>
          <label>人数</label>
          <input type="number" class="input" min="1" v-model.number="form.people" />
          <button class="btn primary" @click="book">提交预约</button>
        </div>
      </div>
      <div class="panel">
        <h2>展馆介绍</h2>
        <div v-html="museum.contentHtml"></div>
      </div>
    </div>
  </section>
  <section class="page" v-else>
    <div class="hero-skeleton skeleton" style="height:260px; border-radius:12px;"></div>
    <div class="layout">
      <div class="panel">
        <div class="skeleton" style="height:200px; border-radius:8px;"></div>
      </div>
      <div class="panel">
        <div class="skeleton" style="height:200px; border-radius:8px;"></div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
const route = useRoute()

const museum = ref<any>(null)
const form = ref({ date:'', slot:'morning', people:1 })

async function load(){
  const id = route.params.id || 1
  try {
    const { data } = await http.get(`/museum/${id}`)
    museum.value = data?.data
  } catch (e:any) {
    try {
      const listRes = await fetch('/mock/museums.json')
      const arr = await listRes.json()
      const item = (arr || []).find((x: any) => String(x.id) === String(id))
      museum.value = item ? { ...item, contentHtml: '<p>更多展馆内容即将上线，敬请期待。</p>' } : {
        id,
        name: '应急主题展馆', city: '', themeName: '综合', summary: '敬请期待',
        coverUrl: '/images/placeholders/museum-1.svg', contentHtml: '<p>更多展馆内容即将上线，敬请期待。</p>'
      }
    } catch {
      museum.value = {
        id,
        name: '应急主题展馆', city: '', themeName: '综合', summary: '敬请期待',
        coverUrl: '/images/placeholders/museum-1.svg', contentHtml: '<p>更多展馆内容即将上线，敬请期待。</p>'
      }
    }
  }
}

async function book(){
  if (!form.value.date) return alert('请选择预约日期')
  try{
    await http.post('/museum/book', { museumId: Number(route.params.id), date: form.value.date, slot: form.value.slot, people: form.value.people })
    alert('预约成功，我们将尽快与您联系确认。')
  }catch(e:any){
    alert(e?.response?.data?.message || '预约失败，请稍后再试')
  }
}

onMounted(load)
</script>

<style scoped>
.page{ padding:16px }

/* Hero - Fire Theme */
.hero-fire{ position:relative; min-height:260px; border-radius:12px; background-size:cover; background-position:center; color:#fff; overflow:hidden }
.hero-fire .overlay{ position:absolute; inset:0; background:
  radial-gradient(1200px 400px at 20% -10%, rgba(249,115,22,.35), transparent),
  radial-gradient(800px 300px at 80% 0%, rgba(220,38,38,.35), transparent),
  linear-gradient(180deg, rgba(0,0,0,.35), rgba(0,0,0,.65)) }
.hero-fire .wrap{ position:relative; z-index:1; padding:24px; display:flex; flex-direction:column; gap:8px }
.hero-fire .title{ margin:0; font-size:28px; line-height:1.25; text-shadow:0 6px 18px rgba(0,0,0,.35) }
.hero-fire .desc{ margin:0; opacity:.95 }
.badges{ display:flex; gap:8px; flex-wrap:wrap }
.badge{ display:inline-flex; align-items:center; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:700; border:1px solid rgba(220,38,38,.25); color:#fff; background:rgba(220,38,38,.35) }
.badge.secondary{ border-color:rgba(249,115,22,.25); background:rgba(249,115,22,.25) }
.cta{ margin-top:8px }

/* Skeleton */
.skeleton{ position:relative; overflow:hidden; background:#e5e7eb }
.skeleton::after{ content:''; position:absolute; inset:0; transform:translateX(-100%);
  background:linear-gradient(90deg, transparent, rgba(255,255,255,.35), transparent); animation:shimmer 1.2s infinite }
@keyframes shimmer{ 100%{ transform:translateX(100%) } }

/* Layout & Panels */
.layout{ display:grid; grid-template-columns: 360px 1fr; gap:16px; margin-top:16px }
.panel{ background:#fff; padding:16px; border-radius:12px; box-shadow:0 4px 18px rgba(0,0,0,.06) }
.form{ display:grid; gap:10px }
.input{ padding:10px 12px; border:1px solid #e5e7eb; border-radius:8px }
.btn{ padding:10px 16px; border-radius:8px; border:1px solid #e5e7eb; background:#fff; cursor:pointer }
.btn.primary{ background:#ef4444; border-color:#ef4444; color:#fff }

@media (max-width: 900px){ .layout{ grid-template-columns:1fr } }
</style> 