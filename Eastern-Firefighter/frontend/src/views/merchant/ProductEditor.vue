<template>
	<section class="container">
		<h1>{{ isEdit ? '编辑商品' : '新建商品' }}</h1>
		<div class="card">
			<div class="grid">
				<div class="col-2">
					<label class="lbl">商品名称</label>
					<input v-model="form.name" class="input" placeholder="请输入商品名称" />
				</div>
				<div>
					<label class="lbl">价格(元)</label>
					<input v-model.number="form.price" type="number" min="0" class="input" placeholder="0.00" />
				</div>
				<div>
					<label class="lbl">库存</label>
					<input v-model.number="form.stock" type="number" min="0" class="input" placeholder="0" />
				</div>
				<div class="col-2">
					<label class="lbl">主图URL</label>
					<input v-model="form.coverUrl" class="input" placeholder="https://..." />
				</div>
				<div class="col-2">
					<label class="lbl">描述</label>
					<textarea v-model="form.description" class="input" rows="4" placeholder="简要描述"></textarea>
				</div>
			</div>
			<div class="actions">
				<button class="btn" :disabled="submitting" @click="submit">{{ submitting ? '提交中...' : '保存' }}</button>
				<router-link class="btn" to="/merchant/products">返回</router-link>
			</div>
		</div>
	</section>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { merchantApi } from '@/api/merchant'

const route = useRoute()
const router = useRouter()
const isEdit = ref(false)
const submitting = ref(false)

const form = reactive<any>({ name:'', price:0, stock:0, coverUrl:'', description:'' })

async function load(){
	const id = Number(route.params.id)
	if (!id) return
	const { data } = await merchantApi.getProduct(id)
	const p = data?.data || data
	Object.assign(form, {
		name: p?.name || '',
		price: p?.price || 0,
		stock: p?.stock || 0,
		coverUrl: p?.coverUrl || '',
		description: p?.description || ''
	})
}

async function submit(){
	if (!form.name) return alert('请输入商品名称')
	if (submitting.value) return
	submitting.value = true
	try{
		const id = Number(route.params.id)
		if (isEdit.value && id) {
			await merchantApi.updateProduct(id, form)
		} else {
			await merchantApi.createProduct(form)
		}
		alert('保存成功')
		router.push('/merchant/products')
	}catch(e:any){
		alert(e?.response?.data?.message || '保存失败')
	} finally { submitting.value = false }
}

onMounted(() => {
	const id = Number(route.params.id)
	isEdit.value = !!id
	if (isEdit.value) load()
})
</script>

<style scoped>
.card{ background:#fff; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,.05); padding:12px }
.grid{ display:grid; grid-template-columns: 1fr 1fr; gap:12px }
.col-2{ grid-column: span 2 }
.lbl{ display:block; margin-bottom:6px; color:#555 }
.actions{ margin-top:12px; display:flex; gap:8px }
@media (max-width: 900px){ .grid{ grid-template-columns:1fr } .col-2{ grid-column: span 1 } }
</style> 