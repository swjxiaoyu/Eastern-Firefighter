<template>
	<div v-if="hasError" class="error-boundary">
		<div class="error-content">
			<div class="error-icon">
				<span class="icon">💥</span>
			</div>
			<h2 class="error-title">出现了一些问题</h2>
			<p class="error-description">
				应用程序遇到了意外错误，我们正在努力修复中。
			</p>
			<div class="error-actions">
				<button class="btn primary" @click="retry">重试</button>
				<button class="btn secondary" @click="report">报告问题</button>
			</div>
			<details v-if="showDetails" class="error-details">
				<summary>错误详情</summary>
				<pre class="error-stack">{{ error?.stack }}</pre>
			</details>
		</div>
	</div>
	<slot v-else />
</template>

<script setup lang="ts">
import { ref, onErrorCaptured, provide, inject } from 'vue';

interface ErrorInfo {
	error: Error | null;
	errorInfo: any;
}

const hasError = ref(false);
const error = ref<Error | null>(null);
const showDetails = ref(false);

// 捕获子组件错误
onErrorCaptured((err: Error, instance, info: string) => {
	console.error('ErrorBoundary caught error:', err, info);
	error.value = err;
	hasError.value = true;
	return false; // 阻止错误继续传播
});

function retry(): void {
	hasError.value = false;
	error.value = null;
	window.location.reload();
}

function report(): void {
	// 这里可以集成错误报告服务
	const errorReport = {
		message: error.value?.message,
		stack: error.value?.stack,
		url: window.location.href,
		timestamp: new Date().toISOString(),
		userAgent: navigator.userAgent
	};
	
	console.log('Error report:', errorReport);
	alert('错误报告已生成，请联系技术支持');
}

// 提供错误处理方法给子组件
provide('errorHandler', {
	handleError: (err: Error) => {
		error.value = err;
		hasError.value = true;
	},
	clearError: () => {
		hasError.value = false;
		error.value = null;
	}
});
</script>

<style scoped>
.error-boundary {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
	padding: 20px;
}

.error-content {
	text-align: center;
	max-width: 600px;
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
	font-size: 32px;
	font-weight: 700;
	color: #dc2626;
	margin: 0 0 16px;
}

.error-description {
	font-size: 16px;
	color: #7f1d1d;
	margin: 0 0 32px;
	line-height: 1.6;
}

.error-actions {
	display: flex;
	gap: 12px;
	justify-content: center;
	flex-wrap: wrap;
	margin-bottom: 24px;
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
	background: linear-gradient(135deg, #dc2626, #b91c1c);
	color: #fff;
	font-weight: 700;
}

.btn.primary:hover {
	transform: translateY(-1px);
	box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
}

.btn.secondary {
	background: #fff;
	color: #7f1d1d;
	border-color: #fca5a5;
}

.btn.secondary:hover {
	background: #fef2f2;
	border-color: #f87171;
}

.error-details {
	margin-top: 24px;
	text-align: left;
	background: #fff;
	border-radius: 8px;
	padding: 16px;
	border: 1px solid #fca5a5;
}

.error-details summary {
	cursor: pointer;
	font-weight: 600;
	color: #7f1d1d;
	margin-bottom: 12px;
}

.error-stack {
	font-family: 'Courier New', monospace;
	font-size: 12px;
	color: #374151;
	background: #f9fafb;
	padding: 12px;
	border-radius: 4px;
	overflow-x: auto;
	white-space: pre-wrap;
}

@media (max-width: 640px) {
	.error-title {
		font-size: 24px;
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
