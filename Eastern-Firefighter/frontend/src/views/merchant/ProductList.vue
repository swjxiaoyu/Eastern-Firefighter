<template>
	<section class="container">
		<h1>商家商品</h1>
		<div class="toolbar">
			<input v-model="keyword" class="input" placeholder="搜索商品" @keyup.enter="load" />
			<button class="btn" @click="load">查询</button>
			<router-link class="btn primary" to="/merchant/products/create">新建商品</router-link>
			<router-link class="btn" to="/merchant">返回</router-link>
		</div>
		<div class="grid">
			<article class="card" v-for="p in list" :key="p.id">
				<img :src="p.coverUrl" class="thumb" />
				<div class="title">{{ p.name }}</div>
				<div class="meta">价格：￥{{ Number(p.price||0).toFixed(2) }}｜状态：{{ p.status===1 ? '上架' : '下架' }}</div>
				<div class="actions">
					<button class="btn" @click="online(p.id)" :disabled="p.status===1">上架</button>
					<button class="btn" @click="offline(p.id)" :disabled="p.status===0">下架</button>
					<router-link class="btn" :to="`/merchant/products/${p.id}/edit`">编辑</router-link>
				</div>
			</article>
		</div>
	</section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { merchantApi } from '@/api/merchant'

const list = ref<any[]>([])
const keyword = ref('')

async function load(){
	const { data } = await merchantApi.listProducts({ keyword: keyword.value, page:1, size:20 })
	list.value = data?.records || data?.data?.records || []
}
async function online(id:number){ await merchantApi.onlineProduct(id); await load() }
async function offline(id:number){ await merchantApi.offlineProduct(id); await load() }

onMounted(load)
</script>

<style scoped>
.grid{ display:grid; grid-template-columns:repeat(auto-fill,minmax(220px,1fr)); gap:12px }
.thumb{ width:100%; height:140px; object-fit:cover; border-radius:8px }
.toolbar{ display:flex; gap:8px; margin:12px 0 }
.actions{ display:flex; gap:8px; margin-top:8px }
.primary{ background:#ef4444; color:#fff }
</style> 