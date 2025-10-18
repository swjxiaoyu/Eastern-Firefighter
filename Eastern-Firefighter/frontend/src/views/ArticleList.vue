<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { contentApi } from '@/api/http'
import { useRouter } from 'vue-router'

const router = useRouter()
const list = ref<any[]>([])
const total = ref(0)
const page = ref(1)
const size = ref(10)
const loading = ref(true)
const errorMsg = ref('')

async function fetchList(){
	loading.value = true
	try{
		const { data } = await contentApi.listArticles({ page: page.value, size: size.value })
		const p = data?.data
		list.value = p?.records || []
		total.value = p?.total || 0
	} catch(e:any){
		errorMsg.value = e?.response?.data?.message || '加载失败'
	} finally {
		loading.value = false
	}
}

function openDetail(slug: string){
	router.push(`/articles/${slug}`)
}

function next(){ if(page.value * size.value < total.value){ page.value++; fetchList() } }
function prev(){ if(page.value > 1){ page.value--; fetchList() } }

onMounted(fetchList)
</script>

<template>
  <div class="container">
    <h1>安全科普</h1>
    <p v-if="errorMsg" class="error">{{ errorMsg }}</p>
    <div v-if="loading">加载中...</div>
    <div class="list" v-else>
      <div v-for="it in list" :key="it.id" class="item card" @click="openDetail(it.slug)">
        <img class="cover" :src="it.coverUrl || 'https://source.unsplash.com/280x160/?safety'" alt=""/>
        <div class="info">
          <h3 class="title">{{ it.title }}</h3>
          <p class="summary">{{ it.summary }}</p>
        </div>
      </div>
    </div>
    <div class="pager" v-if="total>size">
      <button class="btn" @click="prev" :disabled="page<=1">上一页</button>
      <span>{{ page }} / {{ Math.max(1, Math.ceil(total/size)) }}</span>
      <button class="btn" @click="next" :disabled="page*size>=total">下一页</button>
    </div>
  </div>
</template>

<style scoped>
.list{ display:grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap:12px; }
.item{ display:grid; grid-template-columns: 180px 1fr; gap:12px; padding:12px; cursor:pointer; }
.cover{ width:180px; height:120px; object-fit:cover; border-radius:8px; }
.title{ margin:0 0 6px; font-size:16px; }
.summary{ margin:0; color:#6b7280; line-height:1.5; height:3em; overflow:hidden; }
.pager{ display:flex; align-items:center; gap:10px; justify-content:center; margin-top:16px; }
.error{ color:#dc2626; }
@media (max-width: 640px){
	.item{ grid-template-columns: 1fr; }
	.cover{ width:100%; height:160px; }
}
</style> 