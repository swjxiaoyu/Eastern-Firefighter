<template>
	<div class="error-page">
		<div class="error-content">
			<div class="error-icon">
				<span class="icon">🌐</span>
			</div>
			<h1 class="error-title">网络错误</h1>
			<h2 class="error-subtitle">连接失败</h2>
			<p class="error-description">
				网络连接异常，请检查您的网络设置后重试。
			</p>
			<div class="error-actions">
				<button class="btn primary" @click="retry">重试</button>
				<button class="btn secondary" @click="goHome">返回首页</button>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';

const router = useRouter();

function retry(): void {
	window.location.reload();
}

function goHome(): void {
	router.push('/');
}
</script>

<style scoped>
.error-page {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
	padding: 20px;
}

.error-content {
	text-align: center;
	max-width: 500px;
	width: 100%;
}

.error-icon {
	margin-bottom: 24px;
}

.error-icon .icon {
	font-size: 80px;
	display: block;
}

.error-title {
	font-size: 48px;
	font-weight: 800;
	color: #0369a1;
	margin: 0 0 16px;
	line-height: 1;
}

.error-subtitle {
	font-size: 24px;
	font-weight: 600;
	color: #0c4a6e;
	margin: 0 0 16px;
}

.error-description {
	font-size: 16px;
	color: #075985;
	margin: 0 0 32px;
	line-height: 1.6;
}

.error-actions {
	display: flex;
	gap: 12px;
	justify-content: center;
	flex-wrap: wrap;
}

.btn {
	height: 44px;
	padding: 0 24px;
	border-radius: 8px;
	border: 1px solid transparent;
	cursor: pointer;
	font-weight: 500;
	transition: all 0.2s;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	justify-content: center;
}

.btn.primary {
	background: linear-gradient(135deg, #0369a1, #0284c7);
	color: #fff;
	font-weight: 700;
}

.btn.primary:hover {
	transform: translateY(-1px);
	box-shadow: 0 4px 12px rgba(3, 105, 161, 0.3);
}

.btn.secondary {
	background: #fff;
	color: #075985;
	border-color: #7dd3fc;
}

.btn.secondary:hover {
	background: #f0f9ff;
	border-color: #38bdf8;
}

@media (max-width: 640px) {
	.error-title {
		font-size: 36px;
	}
	
	.error-subtitle {
		font-size: 20px;
	}
	
	.error-actions {
		flex-direction: column;
		align-items: center;
	}
	
	.btn {
		width: 100%;
		max-width: 200px;
	}
}
</style>