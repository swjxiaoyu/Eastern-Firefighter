<template>
  <section class="page" v-if="course">
    <div class="top">
      <img :src="course.coverUrl" class="cover" />
      <div class="info">
        <h1>{{ course.title }}</h1>
        <p class="meta">{{ labelOf(course.level) }} · {{ course.duration }} 学时 · 讲师 {{ course.lecturer }}</p>
        <p class="desc">{{ course.summary }}</p>
        <div class="actions">
          <button class="btn primary" @click="enroll">立即报名</button>
          <button class="btn" @click="$router.back()">返回</button>
        </div>
      </div>
    </div>

    <div class="section">
      <h2>课程大纲</h2>
      <ol class="outline">
        <li v-for="(s, i) in (course.outline||[])" :key="i">{{ i+1 }}. {{ s }}</li>
      </ol>
    </div>

    <div class="section">
      <h2>适合人群</h2>
      <p class="desc">{{ course.forPeople || '适合企业/学校/社区安全负责人及有志提升应急处置能力的人群。' }}</p>
    </div>
  </section>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const course = ref<any>(null)

async function load(){
  const id = route.params.id || 1
  const { data } = await http.get(`/training/courses/${id}`)
  course.value = data?.data
}

function labelOf(lv:string){
  return ({ beginner:'入门', intermediate:'进阶', advanced:'高级' } as any)[lv] || lv
}

async function enroll(){
  const realName = prompt('请输入报名姓名：')?.trim()
  const phone = prompt('请输入手机号：')?.trim()
  if (!realName || !phone) return alert('请填写姓名与手机号')
  try{
    await http.post('/training/courses/enroll', { courseId: Number(route.params.id), realName, phone })
    alert('报名成功，我们将尽快与您联系确认。')
  }catch(e:any){
    alert(e?.response?.data?.message || '报名失败')
  }
}

onMounted(load)
</script>

<style scoped>
.page{ padding:16px; }
.top{ display:grid; grid-template-columns:320px 1fr; gap:16px; align-items:center; }
.cover{ width:100%; height:220px; object-fit:cover; border-radius:12px }
.info h1{ margin:0 0 6px }
.meta{ color:var(--muted); margin:0 0 10px }
.desc{ color:#475569 }
.actions{ display:flex; gap:10px; margin-top:12px }
.btn{ padding:10px 16px; border:1px solid #e5e7eb; border-radius:8px; background:#fff; cursor:pointer }
.btn.primary{ background:#ef4444; color:#fff; border-color:#ef4444 }
.section{ background:#fff; padding:16px; margin-top:16px; border-radius:12px; box-shadow:0 4px 18px rgba(0,0,0,.06) }
.outline{ margin:0; padding-left:18px; line-height:1.9 }
@media (max-width: 768px){ .top{ grid-template-columns:1fr } .cover{ height:180px } }
</style> 