<template>
  <section class="container">
    <h1>结算中心</h1>

    <div class="grid">
      <div class="panel">
        <h3>收货地址</h3>
        <div v-if="addrLoading">加载地址中...</div>
        <div v-else>
          <div v-if="addresses.length===0" class="muted">暂无地址，请先到“地址管理”添加。</div>
          <ul class="addr-list">
            <li v-for="a in addresses" :key="a.id" :class="['addr', { on: String(a.id)===addressId } ]" @click="addressId=String(a.id)">
              <div>{{ a.contactName }} {{ a.contactPhone }}</div>
              <div class="muted">{{ a.addressLine }}</div>
              <div v-if="a.isDefault===1" class="badge">默认</div>
            </li>
          </ul>
          <router-link to="/addresses" class="btn">管理地址</router-link>
        </div>
      </div>

      <div class="panel">
        <h3>备注</h3>
        <textarea class="input" rows="4" v-model="remark" placeholder="给商家的留言"></textarea>
        <div class="actions">
          <button class="btn primary" :disabled="submitting" @click="submit">{{ submitting ? '提交中...' : '提交订单' }}</button>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const addresses = ref<any[]>([])
const addressId = ref<string>('')
const addrLoading = ref(false)

const remark = ref('')
const submitting = ref(false)

async function loadAddresses(){
  addrLoading.value = true
  try{
    const { data } = await http.get('/auth/profile/addresses', { params: { page:1, size:20 }})
    addresses.value = data?.data?.records || []
    const def = addresses.value.find((x:any) => x.isDefault===1)
    addressId.value = def ? String(def.id) : (addresses.value[0] ? String(addresses.value[0].id) : '')
  } finally { addrLoading.value = false }
}

async function submit(){
  if (!addressId.value) return alert('请选择地址')
  if (submitting.value) return
  submitting.value = true
  try{
    const { data } = await http.post('/user/orders/submit', { addressId: addressId.value, remark: remark.value })
    const orderNo = data?.data?.orderNo
    alert('提交成功')
    router.push(orderNo ? `/orders/${orderNo}` : '/orders')
  }catch(e:any){
    alert(e?.response?.data?.message || '提交失败')
  } finally { submitting.value = false }
}

onMounted(loadAddresses)
</script>

<style scoped>
.grid{ display:grid; grid-template-columns: 1fr 1fr; gap:12px }
.panel{ background:#fff; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,.05); padding:12px; display:grid; gap:10px }
.addr-list{ list-style:none; padding:0; margin:0; display:grid; gap:8px }
.addr{ padding:10px; border:1px solid #e5e7eb; border-radius:8px; cursor:pointer; position:relative }
.addr.on{ border-color:#ef4444; background:#fff7f7 }
.badge{ position:absolute; top:8px; right:8px; background:#ef4444; color:#fff; border-radius:10px; font-size:12px; padding:2px 6px }
.input{ padding:10px 12px; border:1px solid #e5e7eb; border-radius:8px; width:100% }
.actions{ display:flex; justify-content:flex-end }
.btn{ padding:8px 12px; border:1px solid #e5e7eb; border-radius:8px; background:#fff; cursor:pointer }
.btn.primary{ background:#ef4444; color:#fff; border-color:#ef4444 }
.muted{ color:#64748b }
@media (max-width: 900px){ .grid{ grid-template-columns:1fr } }
</style> 
