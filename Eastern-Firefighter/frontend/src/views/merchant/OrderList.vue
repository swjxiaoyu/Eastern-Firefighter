<template>
	<section class="container">
		<h1>商家订单</h1>
		<div class="toolbar">
			<select v-model.number="status" class="select" @change="load">
				<option :value="undefined">全部状态</option>
				<option :value="0">待支付</option>
				<option :value="1">已支付</option>
				<option :value="2">已发货</option>
				<option :value="3">已完成</option>
				<option :value="4">退款中</option>
			</select>
			<button class="btn" @click="load">刷新</button>
			<router-link class="btn" to="/merchant">返回</router-link>
		</div>
		<div class="grid">
			<article class="card" v-for="o in list" :key="o.orderNo">
				<div class="head">
					<b>订单号</b> {{ o.orderNo }}
					<span class="badge">{{ o.status }}</span>
				</div>
				<div class="items">
					<div v-for="it in o.items" :key="it.skuId" class="item">
						<img :src="it.coverUrl" class="thumb" />
						<div class="title">{{ it.productName }} × {{ it.quantity }}</div>
						<div class="price">￥{{ Number(it.amount||0).toFixed(2) }}</div>
					</div>
				</div>
			</article>
		</div>
	</section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { merchantApi } from '@/api/merchant'

const list = ref<any[]>([])
const status = ref<number | undefined>(undefined)

async function load(){
	const { data } = await merchantApi.listOrders({ status: status.value, page:1, size:20 })
	list.value = data?.records || data?.data?.records || []
}

onMounted(load)
</script>

<style scoped>
.grid{ display:grid; grid-template-columns:repeat(auto-fill,minmax(320px,1fr)); gap:12px }
.head{ display:flex; justify-content:space-between; align-items:center; margin-bottom:8px }
.items{ display:grid; gap:8px }
.item{ display:grid; grid-template-columns:56px 1fr auto; gap:8px; align-items:center }
.thumb{ width:56px; height:56px; object-fit:cover; border-radius:6px }
.price{ color:#b91c1c; font-weight:700 }
.toolbar{ display:flex; gap:8px; margin:12px 0 }
</style> 