<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { contentApi } from '@/api/http'

const route = useRoute()
const slug = route.params.slug as string
const loading = ref(true)
const errorMsg = ref('')
const article = ref<any>(null)

async function fetchDetail(){
	loading.value = true
	try{
		const { data } = await contentApi.getArticle(slug)
		article.value = data?.data
	} catch(e:any){
		errorMsg.value = e?.response?.data?.message || '加载失败'
	} finally {
		loading.value = false
	}
}

onMounted(fetchDetail)
</script>

<template>
  <div class="container">
    <div v-if="loading">加载中...</div>
    <p v-if="errorMsg" class="error">{{ errorMsg }}</p>
    <article v-if="!loading && article" class="card" style="padding:16px;">
      <h1 style="margin:0 0 6px;">{{ article.title }}</h1>
      <p class="muted" style="margin:0 0 12px;">发布时间：{{ article.publishedAt || article.createdAt }}</p>
      <img v-if="article.coverUrl" :src="article.coverUrl" class="cover" alt="cover" />
      <div class="content" v-html="article.contentHtml"></div>
    </article>
  </div>
</template>

<style scoped>
.cover{ width:100%; max-height:360px; object-fit:cover; border-radius:8px; margin: 8px 0 12px; }
.error{ color:#dc2626; }
.muted{ color:#6b7280; }
.content :deep(img){ max-width:100%; height:auto; }
.content :deep(h2){ margin-top:1.2em; }
</style> 