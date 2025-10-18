<template>
	<div class="container">
		<div class="toolbar card" style="padding:12px; margin-bottom:12px; display:flex; gap:8px; align-items:center;">
			<select v-model.number="categoryId" class="select" @change="reload">
				<option :value="undefined">全部分类</option>
				<option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
			</select>
			<input v-model="keyword" class="input" placeholder="搜索应急装备..." @keyup.enter="reload" />
			<button class="btn" @click="reload">筛选</button>
		</div>

		<div class="product-grid">
			<div v-if="!loading && products.length===0" class="card" style="grid-column:1/-1; padding:24px; text-align:center; color:#6b7280;">
				暂无商品，换个关键词或分类试试～
			</div>
			<div v-for="p in products" :key="p.id" class="card product-card">
				<img :src="p.coverUrl || '/images/img.png'" alt="cover" loading="lazy" @error="onImgErr($event)" />
				<div class="title">{{ p.name }}</div>
				<div class="meta">
					<div class="price">￥{{ p.price || p.minPrice || 0 }}</div>
					<router-link class="btn" :to="`/products/${p.id}`">查看</router-link>
				</div>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const categories = ref<any[]>([])
const products = ref<any[]>([])
const categoryId = ref<number | undefined>(undefined)
const keyword = ref<string>('')
const loading = ref<boolean>(false)

function onImgErr(e:any){ const t = e?.target as HTMLImageElement; if (t && t.src !== '/images/img_1.png') t.src = '/images/img_1.png' }

// 解析各种返回形态为列表
function pickList(data:any): any[] {
	if (!data) return []
	// 1) 裸分页 { records: [...] }
	if (Array.isArray((data as any).records)) return (data as any).records
	// 2) 包装分页 { data: { records: [...] } }
	if (Array.isArray((data as any)?.data?.records)) return (data as any).data.records
	// 3) 直接数组 { data: [...] } 或 [...]
	if (Array.isArray((data as any).data)) return (data as any).data
	if (Array.isArray(data)) return data
	return []
}

// 将可能被拼接的 JSON 文本解析为多个对象，并抽取列表
function parseTextToList(text: string | null | undefined): any[] {
	if (!text) return []
	const src = String(text).trim()
	// 尝试规范化：把 `}{` 变成 `},{`，整体包成数组再 JSON.parse
	try{
		const normalized = `[${src.replace(/}\s*\{/g, '},{')}]`
		const arr = JSON.parse(normalized)
		let out: any[] = []
		for (const seg of Array.isArray(arr) ? arr : []){
			const list = pickList(seg)
			if (list.length) out = out.concat(list)
			else if (seg && typeof seg === 'object' && 'id' in seg) out.push(seg)
		}
		return out
	}catch{ /* ignore */ }
	return []
}

// 将对象转为查询串
function toQuery(params: Record<string, any>): string {
	const usp = new URLSearchParams()
	Object.entries(params || {}).forEach(([k,v]) => {
		if (v === undefined || v === null || v === '') return
		usp.append(k, String(v))
	})
	return usp.toString()
}

async function loadCategories(){
	try {
		const { data } = await http.get('/commerce/categories')
		categories.value = data?.data || []
	} catch {
		// 兜底静态分类，避免下拉为空
		categories.value = [
			{ id: 1, name: '灭火器' },
			{ id: 2, name: '防护服' },
			{ id: 3, name: '工具' },
			{ id: 4, name: '侦检' },
		]
	}
}

async function loadProducts(){
	loading.value = true
	try {
		// 1) 优先 /user/products
		let list:any[] = []
		try{
			const r1 = await http.get('/user/products', { params: { categoryId: categoryId.value, keyword: keyword.value, page:1, size:20 }})
			list = pickList(r1.data)
			// 若服务端错误地把多个 JSON 拼在一起（见用户抓包），尝试按文本兜底解析
			if (!list.length && typeof (r1 as any).request?.responseText === 'string'){
				list = parseTextToList((r1 as any).request.responseText)
			}
		}catch{}
		// 2) 兜底 /commerce/products
		if (!list || list.length===0){
			try{
				const r2 = await http.get('/commerce/products', { params: { categoryId: categoryId.value, keyword: keyword.value, page:1, size:20 }})
				list = pickList(r2.data)
				if (!list.length && typeof (r2 as any).request?.responseText === 'string'){
					list = parseTextToList((r2 as any).request.responseText)
				}
			}catch{}
		}
		// 3) 开发模式演示数据
		if ((!list || list.length===0) && import.meta.env.DEV){
			list = Array.from({ length: 10 }).map((_, i) => ({
				id: 10000 + i,
				name: `演示商品 #${i+1}`,
				price: Math.floor(99 + Math.random()*200),
				coverUrl: '/images/img.png',
			}))
		}
		products.value = list
	} catch {
		products.value = []
	} finally {
		loading.value = false
	}
}

function reload(){ loadProducts() }

onMounted(async () => {
	await loadCategories()
	keyword.value = String(route.query.keyword || '')
	const qCat = Number(route.query.categoryId)
	categoryId.value = Number.isFinite(qCat) && qCat > 0 ? qCat : undefined
	await loadProducts()
})

watch(() => route.query.keyword, (k) => { keyword.value = String(k || ''); loadProducts() })
watch(() => route.query.categoryId, (v) => {
	const qCat = Number(v)
	categoryId.value = Number.isFinite(qCat) && qCat > 0 ? qCat : undefined
	loadProducts()
})
watch(categoryId, () => { loadProducts() })
</script>

<style scoped>
.product-grid{ display:grid; grid-template-columns: repeat(5, 1fr); gap:12px; margin-top: 12px; }
.product-card{ display:grid; grid-template-rows: 160px auto auto; }
.product-card img{ width:100%; height:160px; object-fit:cover; border-radius:8px; }
@media (max-width: 1024px){ .product-grid{ grid-template-columns: repeat(4, 1fr) } }
@media (max-width: 768px){ .product-grid{ grid-template-columns: repeat(2, 1fr) } }
</style> 
