<template>
	<section class="container">
		<h1>商家售后</h1>
		<div class="toolbar">
			<button class="btn" @click="load">刷新</button>
			<router-link class="btn" to="/merchant">返回</router-link>
		</div>
		<div class="grid">
			<article class="card" v-for="r in list" :key="r.id">
				<div class="row"><b>订单号：</b>{{ r.orderNo }}</div>
				<div class="row"><b>条目：</b>{{ r.orderItemId ? ('#'+r.orderItemId) : '整单' }}</div>
				<div class="row"><b>金额：</b>￥{{ Number(r.amount||0).toFixed(2) }}</div>
				<div class="row"><b>状态：</b>{{ r.status }}</div>
				<div class="row"><b>原因：</b>{{ r.reason }}</div>
			</article>
		</div>
	</section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { merchantApi } from '@/api/merchant'

const list = ref<any[]>([])

async function load(){
	const { data } = await merchantApi.listRefunds({ page:1, size:20 })
	list.value = data?.records || data?.data?.records || []
}

onMounted(load)
</script>

<style scoped>
.grid{ display:grid; grid-template-columns:repeat(auto-fill,minmax(320px,1fr)); gap:12px }
.row{ margin:4px 0 }
.toolbar{ display:flex; gap:8px; margin:12px 0 }
</style> 