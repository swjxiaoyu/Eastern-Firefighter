
<template>
	<header class="header">
		<div class="wrap container">
			<div class="logo"><router-link to="/">东方灭火侠</router-link></div>
			<div class="search">
				<input v-model="keyword" class="input" placeholder="搜索应急装备/灭火器/应急箱.." @keyup.enter="goSearch" />
				<button class="btn" @click="goSearch">搜索</button>
			</div>
			<div class="right">
				<router-link to="/courses">培训</router-link>
				<router-link to="/museums">展馆</router-link>
				<router-link to="/articles">文章</router-link>
				<router-link to="/cart">购物车</router-link>
				<router-link to="/orders">订单</router-link>
				<router-link to="/profile">我的</router-link>
				<router-link v-if="isMerchant" to="/merchant">商家中心</router-link>
				<router-link v-else-if="token" to="/merchant/apply">商家入驻</router-link>
				<template v-if="token">
					<router-link to="/admin/articles" class="admin-link">管理</router-link>
					<button @click="logout">退出</button>
				</template>
				<template v-else>
					<router-link to="/login">登录</router-link>
					<router-link to="/register">注册</router-link>
				</template>
				<button class="avatar" @click="goProfile" :title="me?.realName || '个人中心'">
					<img :src="avatarSrc" @error="onAvatarErr" alt="avatar" />
				</button>
			</div>
		</div>
		<div class="tags container">
			<span class="tag">灭火设备</span>
			<span class="tag">灭火器</span>
			<span class="tag">应急箱</span>
			<span class="tag">安全资讯</span>
			<span class="tag">科普培训</span>
			<span class="tag">应急工具</span>
		</div>
	</header>
</template>

<script setup lang="ts">
import { computed, ref, onMounted } from 'vue';
import { useAuthStore } from '@/stores/auth';
import { useRouter } from 'vue-router';
const router = useRouter();
const auth = useAuthStore();
const token = computed(() => auth.token);
const me = ref<any>(null);
const isMerchant = computed(() => {
	const r = String(auth.role || '').toUpperCase();
	return r === 'MERCHANT' || r === 'ADMIN';
});

onMounted(async () => { 
	if (auth.token){
		await auth.refreshProfile();
		try{ me.value = (await (await fetch('/api/auth/profile/me')).json()).data }catch{}
	}
});
function logout() { auth.logout(); }
const keyword = ref('');
function goSearch(){ router.push({ path: '/products', query: { keyword: keyword.value } }); }
function goProfile(){ router.push('/profile') }

const avatarSrc = computed(() => {
	return (me.value && me.value.avatarUrl) || (auth.profile && (auth.profile as any).avatarUrl) || '/images/avatar-default.svg'
});
function onAvatarErr(e: Event){
	const t = e?.target as HTMLImageElement | null;
	if (t && t.src !== location.origin + '/images/avatar-default.svg') t.src = '/images/avatar-default.svg'
}
</script>

<style scoped>
a, :deep(a) { color: #fff; text-decoration: none; }
.right { display:flex; gap:12px; align-items:center; }
.avatar{ width:48px; height:48px; padding:0; border:1px solid #ffffff33; border-radius:50% !important; overflow:hidden; background:transparent; cursor:pointer }
.avatar img{ width:100%; height:100%; object-fit:cover; display:block; border-radius:50% }
.tags{ margin-top:-6px; padding-bottom:8px }
.logo { font-size:18px; }
.logo a{ white-space:nowrap }
.admin-link { 
	background: rgba(255,255,255,0.2); 
	padding: 4px 8px; 
	border-radius: 4px; 
	font-size: 12px;
}
.admin-link:hover { background: rgba(255,255,255,0.3); }
</style> 
