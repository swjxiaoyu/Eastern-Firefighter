<template>
  <section class="container" v-if="order">
    <h1>订单详情</h1>
    <div class="head">
      <div>订单号：<b>{{ order.orderNo }}</b></div>
      <div class="badge" :class="statusClass(order.status)">{{ statusText(order.status) }}</div>
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
        <h3>物流/进度</h3>
        <ol class="timeline">
          <li v-for="(n,i) in order.timeline || []" :key="i">
            <span class="time">{{ new Date(n.time).toLocaleString() }}</span>
            <span class="text">{{ n.text }}</span>
          </li>
        </ol>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const order = ref<any>(null)

function statusText(s: number|string){
  const map: any = { 0:'待支付', 1:'已支付', 2:'已发货', 3:'已完成', 4:'退款中' }
  const n = typeof s === 'string' ? Number(s) : s
  return map[n] ?? s
}
function statusClass(s: number|string){
  const map: any = { 0:'pending', 1:'paid', 2:'shipped', 3:'finished', 4:'refunding' }
  const n = typeof s === 'string' ? Number(s) : s
  return map[n] ?? ''
}

async function load(){
  const orderNo = route.params.orderNo
  const { data } = await http.get(`/user/orders/${orderNo}`)
  order.value = data?.data
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
.title{ font-size:13px; color:#334155 }
.price{ color:#b91c1c; font-weight:700 }
.total{ text-align:right; margin-top:8px }
.timeline{ margin:0; padding-left:18px }
.timeline li{ margin:6px 0; color:#475569 }
@media (max-width: 900px){ .grid{ grid-template-columns:1fr } }
</style> 
