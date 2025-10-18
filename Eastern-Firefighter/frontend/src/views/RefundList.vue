<template>
  <section class="container">
    <h1>退换/售后</h1>

    <div class="filters">
      <button class="btn" @click="load">刷新</button>
    </div>

    <div v-if="loading">加载中...</div>
    <div v-else-if="list.length===0" class="empty">暂无退款记录</div>

    <div class="grid">
      <article v-for="r in list" :key="r.id" class="card">
        <div class="row"><b>订单号：</b>{{ r.orderNo }}</div>
        <div class="row"><b>条目：</b>{{ r.orderItemId ? ('#'+r.orderItemId) : '整单' }}</div>
        <div class="row"><b>金额：</b>￥{{ Number(r.amount||0).toFixed(2) }}</div>
        <div class="row"><b>状态：</b>{{ statusText(r.status) }}</div>
        <div class="row"><b>原因：</b>{{ r.reason }}</div>
        <div class="row muted">{{ new Date(r.createdAt).toLocaleString() }}</div>
      </article>
    </div>

    <div class="actions">
      <button class="btn primary" @click="openApply">申请退款</button>
    </div>

    <div v-if="show" class="modal-overlay" @click="show=false">
      <div class="modal" @click.stop>
        <h3>申请退款</h3>
        <label>订单号<input v-model="form.orderNo" class="input" placeholder="请输入订单号" /></label>
        <label>订单项ID（可空）<input v-model="form.orderItemId" class="input" placeholder="单项退款填此项" /></label>
        <label>金额<input v-model.number="form.amount" type="number" min="0.01" step="0.01" class="input" /></label>
        <label>原因<input v-model="form.reason" class="input" placeholder="请输入退款原因" /></label>
        <div class="modal-actions">
          <button class="btn" @click="show=false">取消</button>
          <button class="btn primary" @click="apply">提交</button>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { ref, onMounted } from 'vue'

const list = ref<any[]>([])
const loading = ref(false)

const show = ref(false)
const form = ref<any>({ orderNo:'', orderItemId:'', amount:0, reason:'' })

function statusText(s:number){
  const map:any = { 0:'申请中', 1:'已同意', 2:'已拒绝', 3:'已关闭' }
  return map[s] ?? s
}

async function load(){
  loading.value = true
  try{
    const { data } = await http.get('/user/refunds', { params: { page:1, size:20 }})
    list.value = data?.data?.records || []
  }finally{ loading.value = false }
}

function openApply(){ show.value = true }

async function apply(){
  if (!form.value.orderNo || !form.value.amount || !form.value.reason) return alert('请完整填写订单号、金额、原因')
  const payload:any = { orderNo: String(form.value.orderNo).trim(), amount: Number(form.value.amount), reason: String(form.value.reason).trim() }
  if (String(form.value.orderItemId).trim()) payload.orderItemId = Number(form.value.orderItemId)
  try{
    await http.post('/user/refunds/apply', payload)
    alert('已提交退款申请')
    show.value = false
    form.value = { orderNo:'', orderItemId:'', amount:0, reason:'' }
    await load()
  }catch(e:any){
    alert(e?.response?.data?.message || '申请失败')
  }
}

onMounted(load)
</script>

<style scoped>
.filters{ display:flex; gap:8px; margin:12px 0 }
.grid{ display:grid; grid-template-columns:repeat(auto-fill,minmax(320px,1fr)); gap:12px }
.card{ background:#fff; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,.05); padding:12px }
.row{ margin:4px 0 }
.muted{ color:#64748b; font-size:12px }
.actions{ margin:16px 0 }
.btn{ padding:8px 12px; border:1px solid #e5e7eb; border-radius:8px; background:#fff; cursor:pointer }
.btn.primary{ background:#ef4444; color:#fff; border-color:#ef4444 }
.modal-overlay{ position:fixed; inset:0; background:rgba(0,0,0,.5); display:flex; align-items:center; justify-content:center }
.modal{ background:#fff; border-radius:10px; padding:16px; width:420px; max-width:90vw; display:grid; gap:10px }
.input{ padding:8px 10px; border:1px solid #e5e7eb; border-radius:8px }
.modal-actions{ display:flex; gap:8px; justify-content:flex-end }
.empty{ color:#64748b }
</style> 
