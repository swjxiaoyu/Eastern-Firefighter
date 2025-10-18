
<template>
	<div class="container">
		<!-- 加载状态 -->
		<div v-if="loading" class="loading">
			<p>正在加载商品详情...</p>
		</div>
		
		<!-- 错误状态 -->
		<div v-else-if="error" class="error">
			<p>{{ error }}</p>
			<button @click="retry" class="btn primary">重试</button>
		</div>
		
		<!-- 商品详情 -->
		<div v-else-if="product" class="detail">
			<div class="gallery card">
				<LazyImage 
					:src="''" 
					:width="520" 
					:height="420" 
					placeholder="product"
					:product-name="product.name"
					:fit="'cover'"
					:radius="8"
					class="main"
					alt="商品主图"
				/>
				<div class="thumbs">
					<LazyImage 
						v-for="index in 3" 
						:key="index" 
						:src="''" 
						:width="88" 
						:height="88" 
						placeholder="product"
						:product-name="product.name"
						:fit="'cover'"
						:radius="8"
						alt="商品缩略图"
					/>
				</div>
			</div>
			<div class="info card">
				<h2>{{ product.name }}</h2>
				<p class="muted" v-if="product.subtitle">{{ product.subtitle }}</p>
				<div class="price">￥{{ currentPrice }}</div>
				<div class="row">
					<label>规格</label>
					<div class="sku-opts">
						<button v-for="s in skus" :key="s.id" :class="['chip', { on: s.id===skuId }]" @click="selectSku(s)">
							{{ getSkuDisplayText(s) }}
						</button>
						<div v-if="skus.length === 0" class="no-skus">
							暂无规格选项
						</div>
					</div>
				</div>
				<div class="row">
					<label class="label">数量</label>
					<div class="quantity-selector">
						<button class="qty-btn" @click="quantity = Math.max(1, quantity - 1)">-</button>
						<input v-model.number="quantity" type="number" min="1" class="qty-input" />
						<button class="qty-btn" @click="quantity++">+</button>
					</div>
				</div>
				<div class="actions">
					<button class="btn primary" @click="addToCart">
						<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
							<path d="M7 4V2C7 1.45 7.45 1 8 1H16C16.55 1 17 1.45 17 2V4H20C20.55 4 21 4.45 21 5S20.55 6 20 6H19V19C19 20.1 18.1 21 17 21H7C5.9 21 5 20.1 5 19V6H4C3.45 6 3 5.55 3 5S3.45 4 4 4H7ZM9 3V4H15V3H9ZM7 6V19H17V6H7Z"/>
						</svg>
						加入购物车
					</button>
					<router-link class="btn secondary" to="/cart">
						<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
							<path d="M7 4V2C7 1.45 7.45 1 8 1H16C16.55 1 17 1.45 17 2V4H20C20.55 4 21 4.45 21 5S20.55 6 20 6H19V19C19 20.1 18.1 21 17 21H7C5.9 21 5 20.1 5 19V6H4C3.45 6 3 5.55 3 5S3.45 4 4 4H7ZM9 3V4H15V3H9ZM7 6V19H17V6H7Z"/>
						</svg>
						去购物车
					</router-link>
				</div>
			</div>
		</div>
		
		<!-- 无数据状态 -->
		<div v-else class="no-data">
			<p>商品不存在或已被删除</p>
		</div>
	</div>
</template>

<script setup lang="ts">
import { onMounted, ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import http from '@/api/http';
import { ProductService } from '@/api/services';
import type { Product, ProductSku } from '@/types/api';
import LazyImage from '@/components/LazyImage.vue';

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const id = Number(route.params.id);
const product = ref<Product | null>(null);
const skus = ref<ProductSku[]>([]);
const skuId = ref<number>();
const quantity = ref<number>(1);
const images = ref<string[]>([]);
const activeImage = ref<string>('');
const loading = ref<boolean>(true);
const error = ref<string>('');

const currentPrice = computed(() => {
	const s = skus.value.find(x => x.id === skuId.value);
	return s?.price ?? product.value?.price ?? product.value?.originPrice ?? 0;
});

function selectSku(s: ProductSku): void { 
  skuId.value = s.id; 
}

function getSkuDisplayText(sku: ProductSku): string {
  console.log('getSkuDisplayText called with sku:', sku);
  
  // 如果有attrsJson，尝试解析并显示
  if (sku.attrsJson && sku.attrsJson.trim() !== '') {
    console.log('Found attrsJson:', sku.attrsJson);
    try {
      const attrs = JSON.parse(sku.attrsJson);
      console.log('Parsed attrs:', attrs);
      
      // 获取所有键值对并组合显示
      const entries = Object.entries(attrs);
      console.log('Extracted entries:', entries);
      if (entries.length > 0) {
        // 拼接键值对，格式：键：值
        const result = entries.map(([key, value]) => `${key}：${value}`).join(' ');
        console.log('Returning attrs result:', result);
        return result;
      } else {
        // 如果是空对象，显示默认规格
        console.log('Empty attrs object, showing default');
        return '标准规格';
      }
    } catch (e) {
      console.log('Failed to parse attrsJson:', sku.attrsJson, e);
      // JSON解析失败时，尝试直接显示原始字符串
      return sku.attrsJson;
    }
  } else {
    console.log('No attrsJson found for sku:', sku);
  }
  
  // 如果没有规格信息，显示默认规格
  console.log('No specification data available, showing default');
  return '标准规格';
}

// 解析详情对象（兼容裸对象或 { data: {...} }）
// function pickEntity(data: any): any | null {
// 	if (!data) return null
// 	if (data && typeof data === 'object' && !Array.isArray(data) && 'data' in data && data.data && typeof data.data === 'object' && !Array.isArray(data.data)) {
// 		return data.data
// 	}
// 	if (data && typeof data === 'object' && !Array.isArray(data)) return data
// 	return null
// }

// 将可能被拼接的 JSON 文本（...}{...}）解析为对象数组，取第一个对象
// function parseConcatTextToFirst(text: string | null | undefined): any | null {
// 	if (!text) return null
// 	const src = String(text).trim()
// 	try{
// 		const normalized = `[${src.replace(/}\s*\{/g, '},{')}]`
// 		const arr = JSON.parse(normalized)
// 		if (Array.isArray(arr)){
// 			for (const seg of arr){
// 				const ent = pickEntity(seg)
// 				if (ent) return ent
// 			}
// 		}
// 	}catch{}
// 	return null
// }

async function loadProductData(): Promise<void> {
	loading.value = true;
	error.value = '';
	
	console.log('ProductDetail mounted, id:', id);
	
	if (!id || isNaN(id)) {
		console.error('Invalid product id:', route.params.id);
		error.value = '商品ID无效';
		loading.value = false;
		return;
	}

	try {
		console.log('Loading product data...');
		// 暂时回退到直接HTTP调用，避免API服务层问题
	const [pRes, sRes] = await Promise.all([
		http.get(`/user/products/${id}`),
		(async () => {
				try{ 
					console.log('Trying /api/commerce/products/${id}/skus');
					return await http.get(`/commerce/products/${id}/skus`) 
				}catch(e1){ 
					console.log('Failed /api/commerce/products/${id}/skus, trying /commerce/products/${id}/skus');
					try{
						return await http.get(`/commerce/products/${id}/skus`) 
					}catch(e2){
						console.log('Failed /commerce/products/${id}/skus, trying /user/products/${id}/skus');
						return await http.get(`/user/products/${id}/skus`) 
					}
				}
		})()
	]);

		// 解析商品数据
		let productData = pRes.data?.data || pRes.data;
		if (!productData) {
			throw new Error('商品数据格式错误');
		}

		// 解析SKU数据
		console.log('SKU API response:', sRes);
		console.log('SKU response data:', sRes.data);
		
		let skuData = sRes.data?.data || sRes.data;
		console.log('Extracted SKU data:', skuData);
		
		if (!Array.isArray(skuData)) {
			console.log('SKU data is not an array, setting to empty array');
			skuData = [];
		}

		console.log('Product data loaded:', productData);
		console.log('SKU data loaded:', skuData);

		product.value = productData;
		skus.value = skuData;
		
		// 调试SKU数据
		console.log('SKUs array length:', skus.value.length);
		console.log('SKUs details:', skus.value.map(s => ({
			id: s.id,
			skuCode: s.skuCode,
			attrsJson: s.attrsJson,
			price: s.price
		})));
		
		// 详细调试每个SKU的attrsJson
		skus.value.forEach((sku, index) => {
			console.log(`SKU ${index + 1}:`, {
				id: sku.id,
				skuCode: sku.skuCode,
				attrsJson: sku.attrsJson,
				attrsJsonType: typeof sku.attrsJson,
				attrsJsonLength: sku.attrsJson ? sku.attrsJson.length : 0
			});
		});
		
		if (skus.value.length > 0) {
			skuId.value = skus.value[0].id;
			console.log('Using real SKU data from database');
		} else {
			console.log('No SKU data found in database');
		}

	// 组装图片（优先 mediaJson 其次 coverUrl）
	try {
			const media = JSON.parse(product.value?.mediaJson || '[]');
			images.value = (Array.isArray(media) ? media : []).filter(Boolean);
		} catch { 
			images.value = []; 
		}
		
		if (images.value.length === 0) {
			images.value = [product.value?.coverUrl].filter(Boolean) as string[];
		}
		activeImage.value = images.value[0] || '';
		
		// 调试信息
		console.log('Images array:', images.value);
		console.log('Active image:', activeImage.value);
		console.log('Product name:', product.value?.name);
		
		console.log('Product detail loaded successfully');
	} catch (err: any) {
		console.error('加载商品详情失败:', err);
		error.value = err?.response?.data?.message || err?.message || '加载商品详情失败，请稍后重试';
	} finally {
		loading.value = false;
	}
}

function retry(): void {
	loadProductData();
}

onMounted(() => {
	loadProductData();
});

async function addToCart(): Promise<void> {
	if (!auth.token) {
		router.push({ path: '/login', query: { redirect: route.fullPath }});
		return;
	}
	if (!skuId.value) return alert('请选择一个规格');
	try {
		await ProductService.addToCart({ 
			skuId: skuId.value, 
			quantity: quantity.value 
		});
		alert('已加入购物车');
		router.push('/cart');
	} catch (e: any) {
		const msg = e?.response?.data?.message || '加入购物车失败';
		alert(msg);
	}
}
</script>

<style scoped>
.detail{ 
	display: grid; 
	grid-template-columns: minmax(400px, 520px) 1fr; 
	gap: 24px; 
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px;
}

.detail > .gallery {
	max-width: 100%;
	overflow: hidden;
}

.card{ 
	padding: 24px; 
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
	border: 1px solid #f0f0f0;
	transition: all 0.3s ease;
}

.card:hover {
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
	transform: translateY(-2px);
}

.gallery .main{ 
	width: 100%; 
	height: 420px; 
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
	max-width: 100%;
	max-height: 420px;
	display: block;
	box-sizing: border-box;
	position: relative;
}

.thumbs{ 
	display: flex; 
	gap: 12px; 
	margin-top: 16px; 
}

.thumbs .lazy-image-container{ 
	width: 88px; 
	height: 88px; 
	cursor: pointer; 
	opacity: 0.7; 
	border: 2px solid transparent; 
	border-radius: 8px;
	transition: all 0.3s ease;
	overflow: hidden;
}

.thumbs .lazy-image-container:hover {
	opacity: 0.9;
	transform: scale(1.05);
}

.thumbs .lazy-image-container.on{ 
	opacity: 1; 
	border-color: #ef3a2d; 
	box-shadow: 0 0 0 2px rgba(239, 58, 45, 0.2);
}

.info h2{ 
	margin: 0 0 12px; 
	font-size: 28px;
	font-weight: 700;
	color: #1a1a1a;
	line-height: 1.3;
}

.muted{ 
	color: #6b7280; 
	font-size: 14px;
	margin-bottom: 16px;
}

.price{ 
	color: #ef3a2d; 
	font-size: 32px; 
	font-weight: 800; 
	margin: 20px 0; 
	text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.row{ 
	display: flex; 
	align-items: center; 
	gap: 16px; 
	margin: 16px 0; 
	padding: 12px 0;
	border-bottom: 1px solid #f5f5f5;
}

.row:last-child {
	border-bottom: none;
}

.sku-opts{ 
	display: flex; 
	flex-wrap: wrap; 
	gap: 12px; 
	margin: 16px 0;
}

.chip{ 
	padding: 10px 16px; 
	border-radius: 25px; 
	border: 2px solid #e5e7eb; 
	background: #fff; 
	cursor: pointer; 
	transition: all 0.3s ease;
	font-weight: 500;
	font-size: 14px;
}

.chip:hover {
	border-color: #ef3a2d;
	background: #fef2f2;
	transform: translateY(-1px);
}

.chip.on{ 
	border-color: #ef3a2d; 
	color: #ef3a2d; 
	background: #fef2f2;
	box-shadow: 0 2px 8px rgba(239, 58, 45, 0.2);
}

.actions{ 
	display: flex; 
	gap: 16px; 
	margin-top: 24px; 
}

/* 加载和错误状态样式 */
.loading, .error, .no-data {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 60px 20px;
	text-align: center;
}

.loading p {
	font-size: 16px;
	color: #666;
}

.error p {
	font-size: 16px;
	color: #dc2626;
	margin-bottom: 16px;
}

.no-data p {
	font-size: 16px;
	color: #666;
}

.btn {
	height: 48px;
	padding: 0 24px;
	border-radius: 12px;
	border: 1px solid transparent;
	cursor: pointer;
	font-weight: 600;
	font-size: 16px;
	transition: all 0.3s ease;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	text-decoration: none;
	min-width: 120px;
}

.btn:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.btn.primary {
	background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
	color: #fff;
	font-weight: 700;
	box-shadow: 0 4px 15px rgba(239, 58, 45, 0.3);
}

.btn.primary:hover {
	background: linear-gradient(135deg, #dc2626, #ea580c);
	box-shadow: 0 6px 20px rgba(239, 58, 45, 0.4);
}

.btn.secondary {
	background: #fff;
	color: #ef3a2d;
	border: 2px solid #ef3a2d;
}

.btn.secondary:hover {
	background: #fef2f2;
	color: #dc2626;
	border-color: #dc2626;
}

/* 数量选择器样式 */
.label {
	font-weight: 600;
	color: #374151;
	font-size: 16px;
	min-width: 60px;
}

.quantity-selector {
	display: flex;
	align-items: center;
	border: 2px solid #e5e7eb;
	border-radius: 8px;
	overflow: hidden;
	background: #fff;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.qty-btn {
	width: 40px;
	height: 40px;
	border: none;
	background: #f9fafb;
	color: #6b7280;
	font-size: 18px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
	display: flex;
	align-items: center;
	justify-content: center;
}

.qty-btn:hover {
	background: #ef3a2d;
	color: #fff;
}

.qty-btn:active {
	transform: scale(0.95);
}

.qty-input {
	width: 60px;
	height: 40px;
	border: none;
	text-align: center;
	font-size: 16px;
	font-weight: 600;
	color: #374151;
	background: #fff;
	outline: none;
}

.qty-input:focus {
	background: #fef2f2;
}

/* 无规格选项样式 */
.no-skus {
	color: #6b7280;
	font-size: 14px;
	font-style: italic;
	padding: 8px 12px;
	background: #f9fafb;
	border-radius: 6px;
	border: 1px dashed #d1d5db;
}
</style> 
