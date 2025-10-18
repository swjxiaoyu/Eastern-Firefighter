<template>
	<section class="container">
		<h1>商家中心</h1>
		<div class="grid">
			<router-link class="card link" to="/merchant/products">商品管理</router-link>
			<router-link class="card link" to="/merchant/orders">订单管理</router-link>
			<router-link class="card link" to="/merchant/refunds">售后管理</router-link>
		</div>
	</section>
</template>

<script setup lang="ts">
</script>

<style scoped>
.grid{ display:grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap:12px }
.link{ display:flex; align-items:center; justify-content:center; height:120px; text-decoration:none }
</style> 