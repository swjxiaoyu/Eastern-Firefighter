<template>
	<div class="error-page">
		<div class="error-content">
			<div class="error-icon">
				<span class="icon">🔍</span>
			</div>
			<h1 class="error-title">404</h1>
			<h2 class="error-subtitle">页面未找到</h2>
			<p class="error-description">
				抱歉，您访问的页面不存在或已被删除。
			</p>
			<div class="error-actions">
				<button class="btn primary" @click="goHome">返回首页</button>
				<button class="btn secondary" @click="goBack">返回上页</button>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';

const router = useRouter();

function goHome(): void {
	router.push('/');
}

function goBack(): void {
	if (window.history.length > 1) {
		router.go(-1);
	} else {
		router.push('/');
	}
}
</script>

<style scoped>
.error-page {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
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
	font-size: 72px;
	font-weight: 800;
	color: #1e293b;
	margin: 0 0 16px;
	line-height: 1;
}

.error-subtitle {
	font-size: 24px;
	font-weight: 600;
	color: #475569;
	margin: 0 0 16px;
}

.error-description {
	font-size: 16px;
	color: #64748b;
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
	background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
	color: #fff;
	font-weight: 700;
}

.btn.primary:hover {
	transform: translateY(-1px);
	box-shadow: 0 4px 12px rgba(239, 58, 45, 0.3);
}

.btn.secondary {
	background: #fff;
	color: #475569;
	border-color: #d1d5db;
}

.btn.secondary:hover {
	background: #f8fafc;
	border-color: #9ca3af;
}

@media (max-width: 640px) {
	.error-title {
		font-size: 48px;
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
