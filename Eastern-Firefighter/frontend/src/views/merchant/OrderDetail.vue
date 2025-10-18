<template>
	<section class="container" v-if="order">
		<h1>订单详情（商家）</h1>
		<div class="head">
			<div>订单号：<b>{{ order.orderNo }}</b></div>
			<div class="badge">{{ order.status }}</div>
		</div>
		<div class="grid">
			<div class="panel">
				<h3>商品明细</h3>
				<div class="items">
					<div v-for="it in order.items" :key="it.skuId" class="item">
						<img :src="it.coverUrl" class="thumb" />
						<div class="title">{{ it.productName }} × {{ it.quantity }}</div>
						<div class="price">￥{{ Number(it.amount||0).toFixed(2) }}</div>
					</div>
				</div>
				<div class="total">合计：<b>￥{{ Number(order.payAmount||0).toFixed(2) }}</b></div>
			</div>
			<div class="panel">
				<h3>发货</h3>
				<div class="form">
					<input v-model="shippingCompany" class="input" placeholder="物流公司" />
					<input v-model="trackingNo" class="input" placeholder="运单号" />
					<button class="btn" :disabled="submitting" @click="ship">{{ submitting ? '提交中...' : '确认发货' }}</button>
				</div>
			</div>
		</div>
	</section>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { merchantApi } from '@/api/merchant'

const route = useRoute()
const router = useRouter()

const order = ref<any>(null)
const shippingCompany = ref('')
const trackingNo = ref('')
const submitting = ref(false)

async function load(){
	const orderNo = String(route.params.orderNo)
	const { data } = await merchantApi.getOrder(orderNo)
	order.value = data?.data || data
}

async function ship(){
	if (!shippingCompany.value || !trackingNo.value) return alert('请填写物流公司和运单号')
	if (submitting.value) return
	submitting.value = true
	try{
		const orderNo = String(route.params.orderNo)
		await merchantApi.shipOrder(orderNo, { shippingCompany: shippingCompany.value, trackingNo: trackingNo.value })
		alert('已标记发货')
		await load()
	}catch(e:any){
		alert(e?.response?.data?.message || '发货失败')
	} finally { submitting.value = false }
}

onMounted(load)
</script>

<style scoped>
.head{ display:flex; gap:12px; align-items:center; margin:8px 0 }
.badge{ padding:2px 8px; border-radius:12px; font-size:12px; background:#eef2ff; color:#4338ca }
.grid{ display:grid; grid-template-columns: 1fr 1fr; gap:12px }
.panel{ background:#fff; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,.05); padding:12px }
.items{ display:grid; gap:8px }
.item{ display:grid; grid-template-columns:56px 1fr auto; gap:8px; align-items:center }
.thumb{ width:56px; height:56px; object-fit:cover; border-radius:6px }
.price{ color:#b91c1c; font-weight:700 }
.total{ text-align:right; margin-top:8px }
@media (max-width: 900px){ .grid{ grid-template-columns:1fr } }
</style> 