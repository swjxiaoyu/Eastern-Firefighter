<!--
  项目：Eastern-Firefighter
  文件：Eastern-Firefighter\frontend\src\views\components\HomeCard.vue
  说明：自动添加的文件头注释。
  创建日期：2025-09-09
-->
<template>
	<div class="card product-card">
		<img v-if="img" :src="img" :alt="title" loading="lazy" decoding="async" width="800" height="500" sizes="(max-width:768px) 100vw, (max-width:1024px) 50vw, 25vw" />
		<div class="title">{{ title }}</div>
		<div class="meta">
			<div class="price">￥{{ price }}</div>
			<router-link class="btn" :to="{ path: '/products', query: { keyword: title } }">去选购</router-link>
		</div>
	</div>
</template>

<script setup lang="ts">
interface Props { title: string; price: string | number; img?: string }
const props = withDefaults(defineProps<Props>(), { img: '' });
const { title, price, img } = props as any;
</script>

<style scoped>
/* 使用全局的 .product-card 样式 */
</style> 
