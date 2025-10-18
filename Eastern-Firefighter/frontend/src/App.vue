
<template>
	<ErrorBoundary>
		<NavBar />
		<div class="container-fluid">
			<router-view />
		</div>
		<DraggableAssistant @open="open = true" />
		<AiAssistant v-if="open" @close="open = false" />
		<footer class="footer">
			<div class="wrap container">
				<div>
							<h4>关于我们</h4>
				<p>东方灭火侠专注应急与安全产业，提供专业装备与服务。             服务支持  售后政策  配送说明  常见问题  联系我们</p>
				</div>
				<div>
							<h4></h4>
				<p><a href="#"></a></p>
				<p><a href="#"></a></p>
				<p><a href="#"></a></p>
				</div>
				<div>
							<h4></h4>
				<p>客服热线：400-119-119  邮箱：support@e-fire.cn</p>
				<p></p>
				</div>
			</div>
			<small class="container">Copyright © 东方灭火侠</small>
		</footer>
	</ErrorBoundary>
</template>

<script setup lang="ts">
import NavBar from '@/components/NavBar.vue';
import AiAssistant from '@/components/AiAssistant.vue';
import DraggableAssistant from '@/components/DraggableAssistant.vue';
import ErrorBoundary from '@/components/ErrorBoundary.vue';
import { ref } from 'vue';
import '@/assets/theme.css';
const open = ref(false)
</script>

<style>
html, body, #app { height: 100%; margin: 0; }
* { box-sizing: border-box; }

/* 旧的助手按钮样式已移除，现在使用 DraggableAssistant 组件 */
</style> 
