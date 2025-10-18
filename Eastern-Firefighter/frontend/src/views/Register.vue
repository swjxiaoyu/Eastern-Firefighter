<template>
	<div class="page">
		<div class="card register-card">
			<h2>注册</h2>
			<form @submit.prevent="onRegister">
				<input class="input" v-model="phone" placeholder="手机号" />
				<div class="row">
					<input class="input" v-model="smsCode" placeholder="验证码" />
					<button class="btn secondary" type="button" :disabled="!isValidPhone || sending || cooldown>0" @click="sendCode">
						{{ cooldown>0 ? `${cooldown}s` : (sending ? '发送中...' : '发送验证码') }}
					</button>
				</div>
				<input class="input" v-model="password" placeholder="设置密码（可选）" type="password" />
				<button class="btn primary" type="submit">注册并登录</button>
			</form>
			<p class="footer-text">
				已有账号？<router-link to="/login">去登录</router-link>
			</p>
		</div>
	</div>
</template>

<script setup lang="ts">
import http from '@/api/http';
import { useAuthStore } from '@/stores/auth';
import { useRouter } from 'vue-router';
import { ref, computed, onUnmounted } from 'vue';

const router = useRouter();
const auth = useAuthStore();
const phone = ref('');
const smsCode = ref('');
const password = ref('');

const sending = ref(false)
const cooldown = ref(0)
let timer: any = null
const isValidPhone = computed(() => /^1[3-9]\d{9}$/.test(phone.value))

function startCountdown() {
	cooldown.value = 60
	if (timer) clearInterval(timer)
	timer = setInterval(() => {
		cooldown.value--
		if (cooldown.value <= 0) {
			clearInterval(timer)
			timer = null
		}
	}, 1000)
}

onUnmounted(() => { if (timer) clearInterval(timer) })

async function sendCode() {
	if (!isValidPhone.value) {
		alert('请输入正确的11位手机号')
		return
	}
	try {
		sending.value = true
		await http.post('/auth/sms/send', { phone: phone.value, scene: 'register' })
		alert('验证码已发送')
		startCountdown()
	} catch (e: any) {
		alert(e?.response?.data?.message || e?.message || '发送失败，请稍后重试')
	} finally {
		sending.value = false
	}
}

async function onRegister() {
	const { data } = await http.post('/auth/register', {
		phone: phone.value,
		code: smsCode.value,
		password: password.value,
		deviceInfo: 'web'
	});
	auth.setToken(data.data.token);
	router.push('/products');
}
</script>

<style scoped>
.page {
	min-height: calc(100vh - 120px);
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 40px 16px;
}
.register-card {
	width: 100%;
	max-width: 420px;
	padding: 32px 24px;
	border-radius: 14px;
}
.register-card h2 {
	margin: 0 0 20px;
	font-size: 24px;
	font-weight: 800;
	text-align: center;
}
form {
	display: flex;
	flex-direction: column;
	gap: 12px;
}
.input {
	padding: 12px;
	border: 1px solid #e5e7eb;
	border-radius: 8px;
	font-size: 14px;
	transition: border-color 0.2s;
}
.input:focus {
	outline: none;
	border-color: #ff8f1f;
}
.row {
	display: grid;
	grid-template-columns: 1fr auto;
	gap: 8px;
}
.footer-text {
	margin: 16px 0 0;
	text-align: center;
	color: #6b7280;
	font-size: 14px;
}
.footer-text a {
	color: #ff6a00;
	text-decoration: none;
}
.footer-text a:hover {
	text-decoration: underline;
}
.btn {
	height: 40px;
	padding: 0 16px;
	border-radius: 8px;
	border: 1px solid transparent;
	cursor: pointer;
	font-weight: 500;
	transition: all 0.2s;
}
.btn.primary {
	background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
	color: #fff;
	font-weight: 700;
}
.btn.secondary {
	background: #fff;
	color: #0a3d62;
	border-color: #0a3d62;
}
.btn:disabled {
	opacity: 0.6;
	cursor: not-allowed;
}
</style> 
