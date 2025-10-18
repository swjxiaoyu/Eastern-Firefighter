<template>
	<section class="hero demo-remove">
		<div class="inner">
			<h1>应急物资平台</h1>
			<p>面向安全应急的一体化平台，融合电商、内容与培训。</p>
			<div class="actions">
				<button class="btn" @click="$router.push('/products')">立即选购</button>
				<button class="btn outline" @click="$router.push('/articles')">查看资讯</button>
			</div>
		</div>
	</section>
</template>

<script setup lang="ts">
// DEMO 组件：后续删除
</script>

<style scoped>
.hero{position:relative; padding:80px 16px; border-radius:16px; overflow:hidden; background:
	linear-gradient(135deg, rgba(30,58,138,.9), rgba(37,99,235,.85), rgba(96,165,250,.8)),
	url('/images/hero.svg') center/cover no-repeat; color:#fff; box-shadow: var(--shadow);}
.hero:before{content:""; position:absolute; inset:-20%; background:radial-gradient(closest-side,rgba(255,255,255,.25),transparent 70%); transform:translate(-10%,-10%);} 
.inner{position:relative; z-index:1; max-width:1080px; margin:0 auto;}
.actions{display:flex; gap:12px; margin-top:16px;}
.btn.outline{background:transparent; border:1px solid rgba(255,255,255,.7);}
</style> 
