<template>
	<!-- 顶部品牌横幅（渐变背景） -->
	<section class="hero-band">
		<div class="wrap hero-grid">
			<div class="hero-copy">
				<h1 class="hero-title">守护城市安全的每一件装备</h1>
				<p class="hero-sub">专业消防装备与培训 · 一站式新零售体验</p>
				<div class="kpis">
					<div class="kpi"><b>1,200+</b><span>精选SKU</span></div>
					<div class="kpi"><b>48h</b><span>快速发货</span></div>
					<div class="kpi"><b>7×12</b><span>专属客服</span></div>
				</div>
				<div class="cta-row">
					<button class="btn primary" @click="toShop">立即选购</button>
					<button class="btn secondary" @click="toCourses">培训课程</button>
				</div>
			</div>
			<div class="hero-media">
				<div class="carousel" @mouseenter="pauseCarousel" @mouseleave="resumeCarousel">
					<div class="slides" :style="slideStyle">
						<div class="slide" v-for="(s, i) in slides" :key="i">
							<img :src="s" :alt="`slide-${i+1}`" @error="onImgErr(i, $event)" />
						</div>
					</div>
					<div class="nav">
						<button class="nav-btn" aria-label="prev" @click="prev">‹</button>
						<button class="nav-btn" aria-label="next" @click="next">›</button>
					</div>
					<div class="dots" role="tablist" aria-label="carousel indicators">
						<button v-for="(s, i) in slides" :key="`dot-${i}`" class="dot" :class="{ on: i === index }" role="tab" :aria-selected="i === index" @click="go(i)"/>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- 粘性类目导航（淘宝风） -->
	<div class="cate-bar" role="navigation">
		<div class="wrap rail">
			<router-link class="pill" to="/products?categoryId=1">🧯 灭火器</router-link>
			<router-link class="pill" to="/products?categoryId=2">🪖 防护服</router-link>
			<router-link class="pill" to="/products?categoryId=3">🧰 工具</router-link>
			<router-link class="pill" to="/products?categoryId=4">🧪 侦检</router-link>
			<router-link class="pill" to="/museums">🏛️ 展馆</router-link>
			<router-link class="pill" to="/courses">📚 课程</router-link>
		</div>
	</div>

	<!-- 优惠券条（淘宝风） -->
	<section class="section">
		<div class="wrap coupons">
			<div class="coupon">
				<div class="cut">￥300</div>
				<div class="cmeta"><b>满299可用</b><span>消防服/头盔专享</span></div>
				<router-link class="btn claim" to="/products">领券</router-link>
			</div>
			<div class="coupon hot">
				<div class="cut">￥600</div>
				<div class="cmeta"><b>满599可用</b><span>应急工具通用</span></div>
				<router-link class="btn claim" to="/products">领券</router-link>
			</div>
			<div class="coupon">
				<div class="cut">9折</div>
				<div class="cmeta"><b>新客礼遇</b><span>全场一次性折扣</span></div>
				<router-link class="btn claim" to="/products">领取</router-link>
			</div>
		</div>
	</section>

	<!-- 限时抢购（倒计时） -->
	<section class="section">
		<div class="wrap">
			<div class="sec-head">
				<h2 class="sec-title fire">限时抢购</h2>
				<div class="countdown" aria-live="polite">距结束 {{ remain }}</div>
			</div>
			<div class="flash-rail">
				<div v-for="p in flashProducts" :key="p.id" class="flash-item card">
					<img v-if="p.coverUrl" :src="p.coverUrl" :alt="p.name" loading="lazy" @error="onProdErr($event)" />
					<div class="f-title">{{ p.name }}</div>
					<div class="f-price">
						<span class="now">￥{{ p.price || p.minPrice || 0 }}</span>
						<span class="old" v-if="p.price">￥{{ ((p.price||0)*1.2).toFixed(0) }}</span>
					</div>
					<router-link class="btn grab" :to="`/products/${p.id}`">去抢购</router-link>
				</div>
			</div>
		</div>
	</section>

	<!-- 热销推荐 -->
	<section class="section">
		<div class="wrap">
			<div class="sec-head">
				<h2 class="sec-title">热销推荐</h2>
				<router-link class="more" to="/products">全部商品 →</router-link>
			</div>
			<div v-if="prodLoading" class="skeleton-grid">
				<div v-for="i in 8" :key="i" class="card skeleton" style="height:280px;border-radius:12px;" />
			</div>
			<div v-else class="product-grid tb">
				<div v-for="p in topProducts" :key="p.id" class="card product-card">
					<div class="badge" v-if="p.sales">热销</div>
					<img v-if="p.coverUrl" :src="p.coverUrl" :alt="p.name" loading="lazy" @error="onProdErr($event)" />
					<div class="title">{{ p.name }}</div>
					<div class="meta">
						<div class="price"><b class="yen">￥</b><b class="num">{{ p.price || p.minPrice || 0 }}</b></div>
						<router-link class="btn buy" :to="`/products/${p.id}`">马上抢</router-link>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- 场景 CTA 双卡 -->
	<section class="section">
		<div class="wrap cta-grid">
			<div class="cta-card museum">
				<h3>走进消防展馆</h3>
				<p>沉浸式了解消防历史与装备演进，支持在线预约</p>
				<router-link class="btn outline" to="/museums">去预约</router-link>
			</div>
			<div class="cta-card course">
				<h3>专业培训课程</h3>
				<p>体系化实操课程，提升企业与个人应急能力</p>
				<router-link class="btn primary" to="/courses">查看课程</router-link>
			</div>
		</div>
	</section>

	<!-- 服务保障 -->
	<section class="section">
		<div class="wrap service-grid">
			<div class="service-item">
				<div class="ico">🚚</div>
				<div>
					<p class="tit">全场满额包邮</p>
					<p class="txt">快速发货，物流可视</p>
				</div>
			</div>
			<div class="service-item">
				<div class="ico">🛡️</div>
				<div>
					<p class="tit">正品保障</p>
					<p class="txt">品牌直供，售后可溯</p>
				</div>
			</div>
			<div class="service-item">
				<div class="ico">📞</div>
				<div>
					<p class="tit">7×12 专属客服</p>
					<p class="txt">专业导购与技术咨询</p>
				</div>
			</div>
		</div>
	</section>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import http from '@/api/http'

const router = useRouter()
const slides = ref<string[]>([
	'/images/img.png',
	'/images/img_1.png',
	'/images/img.png',
	'/images/img_1.png'
])

const index = ref(0)
let timer: number | null = null
const INTERVAL = 4000

const slideStyle = computed(() => ({
	transform: 'translateX(-' + (index.value * 100) + '%)'
}))

function next() { index.value = (index.value + 1) % slides.value.length }
function prev() { index.value = (index.value - 1 + slides.value.length) % slides.value.length }
function go(i: number) { index.value = i }
function startAuto() { if (!timer) timer = window.setInterval(() => next(), INTERVAL) }
function stopAuto() { if (timer) { clearInterval(timer); timer = null } }
function pauseCarousel() { stopAuto() }
function resumeCarousel() { startAuto() }
function onImgErr(i: number, e: any) { const t = e?.target as HTMLImageElement; if (t && t.src !== '/images/img_1.png') t.src = '/images/img_1.png' }
function toShop() { router.push('/products') }
function toCourses() { router.push('/courses') }

// 热销商品
const topProducts = ref<any[]>([])
const prodLoading = ref(true)
function onProdErr(e: any){ const t = e?.target as HTMLImageElement; if (t && t.src !== '/images/img_1.png') t.src = '/images/img_1.png' }

async function loadTopProducts(){
    prodLoading.value = true
    try{
        const { data } = await http.get('/user/products', { params: { page:1, size:12 } })
        let pageData:any = (data && (data as any).records) ? data : ((data?.data?.records) ? data.data : null)
        let list:any[] = pageData?.records || []
        if (!list || list.length === 0){
            try{
                const res2 = await http.get('/commerce/products', { params: { page:1, size:12 } })
                const page2:any = res2.data?.data?.records ? res2.data.data : (res2.data?.records ? res2.data : null)
                list = page2?.records || []
            }catch{ /* ignore */ }
        }
        topProducts.value = list
    } finally { prodLoading.value = false }
}

// 限时抢购（从热销中截取部分）
const flashProducts = computed(() => topProducts.value.slice(0, 8))
const remain = ref('00:00:00')
let saleTimer: number | null = null
function startSaleCountdown(hours = 2){
	const end = Date.now() + hours * 3600 * 1000
	if (saleTimer) clearInterval(saleTimer)
	saleTimer = window.setInterval(() => {
		const left = Math.max(0, end - Date.now())
		const h = String(Math.floor(left / 3600000)).padStart(2,'0')
		const m = String(Math.floor((left % 3600000)/60000)).padStart(2,'0')
		const s = String(Math.floor((left % 60000)/1000)).padStart(2,'0')
		remain.value = `${h}:${m}:${s}`
		if (left <= 0) { clearInterval(saleTimer!); saleTimer = null }
	}, 1000)
}

onMounted(() => {
	const reduce = window.matchMedia('(prefers-reduced-motion: reduce)')
	if (!reduce.matches) startAuto()
	loadTopProducts()
	startSaleCountdown(2)
})

onBeforeUnmount(() => { stopAuto(); if (saleTimer) clearInterval(saleTimer) })
</script>

<style scoped>
/* 统一宽度容器 */
.wrap{ max-width: 1200px; margin: 0 auto; padding: 0 16px; }

/* 英雄横幅（保留消防红橙） */
.hero-band{ background: linear-gradient(135deg,#1f2937 0%, #ef3a2d 45%, #ff6a00 80%, #ffb774 100%); color:#fff; padding: 24px 0; border-bottom: 1px solid rgba(255,255,255,.12); }
.hero-grid{ display:grid; grid-template-columns: 1fr; gap:16px; align-items:center; }
.hero-title{ font-size: 36px; font-weight: 900; letter-spacing:.5px; margin:0; }
.hero-sub{ margin: 8px 0 14px; opacity:.9 }
.kpis{ display:flex; gap:16px; margin: 6px 0 14px }
.kpi{ background: rgba(255,255,255,.12); border:1px solid rgba(255,255,255,.18); padding:8px 10px; border-radius:10px; display:flex; align-items:baseline; gap:8px }
.kpi b{ font-size:18px }
.kpi span{ font-size:12px; opacity:.9 }

/* 轮播 */
.hero-media{ width:100%; max-width:1000px; margin:0 auto }
.carousel{ position:relative; width:100%; border-radius:14px; overflow:hidden; background:#111; height:20vh; min-height:160px }
.slides{ display:flex; transition: transform 500ms ease }
.slide{ min-width:100%; height:100%; display:grid; place-items:center; background:#000 }
.slide img{ width:100%; height:100%; object-fit:cover }
.nav{ position:absolute; inset:0; display:flex; align-items:center; justify-content:space-between; pointer-events:none }
.nav-btn{ pointer-events:auto; margin:0 8px; width:38px; height:38px; border-radius:50%; border:none; background: rgba(0,0,0,.35); color:#fff; font-size:20px; cursor:pointer }
.dots{ position:absolute; left:0; right:0; bottom:8px; display:flex; gap:8px; justify-content:center; align-items:center }
.dot{ width:24px; height:4px; border-radius:3px; background:rgba(255,255,255,.5); border:none; cursor:pointer }
.dot.on{ background:#ffd7aa }

/* 粘性类目条（淘宝风 pill） */
.cate-bar{ position: sticky; top: 64px; z-index: 900; background:#fff; border-bottom:1px solid #f1f5f9 }
.rail{ display:flex; gap:10px; overflow:auto; padding: 8px 0 }
.pill{ white-space:nowrap; padding:8px 12px; border-radius:999px; border:1px solid #ffe1cc; background:linear-gradient(135deg,#fff,#fff7f0); color:#ff6a00; text-decoration:none; box-shadow:0 3px 10px rgba(255,106,0,.06) }
.pill:hover{ filter:brightness(1.02); box-shadow:0 6px 16px rgba(255,106,0,.12) }

/* 优惠券条 */
.coupons{ display:grid; grid-template-columns: repeat(3,1fr); gap:12px }
.coupon{ display:flex; align-items:center; gap:10px; padding:12px; border-radius:14px; background:linear-gradient(135deg,#fff,#fff6f0); border:1px dashed #ffc9a1; box-shadow:0 6px 18px rgba(255,106,0,.08) }
.coupon.hot{ background:linear-gradient(135deg,#fff2ec,#fff); border-color:#ffb08a }
.cut{ font-weight:900; font-size:22px; color:#ff4d00 }
.cmeta{ display:flex; flex-direction:column; gap:2px }
.cmeta b{ font-size:14px }
.cmeta span{ font-size:12px; color:#6b7280 }
.claim{ background:linear-gradient(135deg,#ff6a00,#ff8f1f); color:#fff; border:none }

/* 限时抢购（淘宝风横滑） */
.sec-head{ display:flex; align-items:center; justify-content:space-between; margin-bottom:8px }
.sec-title{ margin:0; font-size:20px; font-weight:900 }
.sec-title.fire{ color:#ff4d00 }
.countdown{ color:#ff4d00; font-weight:800 }
.flash-rail{ display:grid; grid-auto-flow:column; grid-auto-columns: 220px; gap:12px; overflow:auto; padding-bottom:4px }
.flash-item{ padding:10px; border-radius:12px }
.flash-item img{ width:100%; height:140px; object-fit:cover; border-radius:8px }
.f-title{ margin:6px 0; font-size:14px; line-height:1.35; height:38px; overflow:hidden }
.f-price{ display:flex; align-items:baseline; gap:8px }
.f-price .now{ color:#ff2a00; font-weight:900; font-size:18px }
.f-price .old{ color:#9ca3af; text-decoration: line-through; font-size:12px }
.grab{ width:100%; margin-top:6px; background:linear-gradient(135deg,#ff4d00,#ff8f1f); color:#fff; border:none }

/* 商品网格（淘宝风价签） */
.product-grid{ display:grid; grid-template-columns: repeat(5, 1fr); gap:12px }
.product-card{ display:grid; grid-template-rows: 160px auto auto }
.product-card img{ width:100%; height:160px; object-fit:cover; border-radius:8px }
.product-grid.tb .product-card{ position:relative }
.product-grid.tb .badge{ position:absolute; left:8px; top:8px; background:linear-gradient(135deg,#ff6a00,#ff2a00); color:#fff; font-size:12px; padding:2px 6px; border-radius:999px }
.product-grid.tb .price{ color:#ff2a00 }
.product-grid.tb .price .yen{ font-weight:700 }
.product-grid.tb .price .num{ font-size:20px; font-weight:900 }
.buy{ background:linear-gradient(135deg,#ff6a00,#ff8f1f); color:#fff; border:none }

/* CTA 双卡 */
.cta-grid{ display:grid; grid-template-columns: 1fr 1fr; gap:12px }
.cta-card{ border-radius:14px; padding:18px; background:#fff; border:1px solid #e5e7eb; box-shadow:0 6px 18px rgba(0,0,0,.06) }
.cta-card h3{ margin:0 0 6px; font-size:18px; font-weight:800 }
.cta-card p{ margin:0 0 12px; color:#6b7280 }
.cta-card.museum{ background:linear-gradient(135deg,#fff, #f8fafc) }
.cta-card.course{ background:linear-gradient(135deg,#fff, #fff3f0) }

/* 服务保障 */
.service-grid{ display:grid; grid-template-columns: repeat(3, 1fr); gap:12px }
.service-item{ display:flex; gap:10px; align-items:flex-start; padding:12px; border:1px solid #e5e7eb; border-radius:12px; background:#fff }
.service-item .ico{ width:36px; height:36px; border-radius:8px; background:linear-gradient(135deg,#ef3a2d,#ff8f1f); color:#fff; display:flex; align-items:center; justify-content:center; box-shadow:0 6px 18px rgba(216,36,36,.20) }
.service-item .tit{ margin:0; font-weight:700 }
.service-item .txt{ margin:4px 0 0; color:#6b7280 }

/* 按钮与响应式 */
.btn{ height:40px; padding:0 16px; border-radius:8px; border:1px solid transparent; cursor:pointer }
.btn.primary{ background:linear-gradient(135deg,#ef3a2d,#ff8f1f); color:#fff; font-weight:700 }
.btn.secondary{ background:#fff; color:#0a3d62; border-color:#0a3d62 }
.btn.outline{ background:#fff; color:#111; border-color:#e5e7eb }

@media (max-width: 1024px){
	.product-grid{ grid-template-columns: repeat(4, 1fr) }
	.coupons{ grid-template-columns: 1fr 1fr }
	.cta-grid{ grid-template-columns: 1fr }
}

@media (min-width: 1024px){
	/* 文字在左，轮播在右，整体视觉更紧凑 */
	.hero-grid{ grid-template-columns: 1.2fr 0.8fr; gap:20px; align-items:center }
	.hero-media{ max-width:560px; justify-self:end }
}

@media (max-width: 768px){
	.hero-grid{ grid-template-columns: 1fr }
	.hero-title{ font-size: 28px }
	.carousel{ height:22vh; min-height:140px }
	.product-grid{ grid-template-columns: repeat(2, 1fr) }
}
</style>