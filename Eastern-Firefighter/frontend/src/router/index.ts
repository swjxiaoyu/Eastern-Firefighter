
import { createRouter, createWebHistory } from 'vue-router';
import type { RouteRecordRaw } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

const routes: RouteRecordRaw[] = [
	{ path: '/', component: () => import('@/views/Home.vue') },
	{ path: '/login', component: () => import('@/views/Login.vue') },
	{ path: '/register', component: () => import('@/views/Register.vue') },
	{ path: '/products', component: () => import('@/views/ProductList.vue') },
	{ path: '/products/:id', component: () => import('@/views/ProductDetail.vue') },
	{ path: '/cart', component: () => import('@/views/Cart.vue'), meta: { auth: true } },
	{ path: '/checkout', component: () => import('@/views/Checkout.vue'), meta: { auth: true } },
	{ path: '/orders', component: () => import('@/views/OrderList.vue'), meta: { auth: true } },
	{ path: '/orders/:orderNo', component: () => import('@/views/OrderDetail.vue'), meta: { auth: true } },
	{ path: '/refunds', component: () => import('@/views/RefundList.vue'), meta: { auth: true } },
	{ path: '/articles', component: () => import('@/views/ArticleList.vue') },
	{ path: '/articles/:slug', component: () => import('@/views/ArticleDetail.vue') },
	{ path: '/profile', component: () => import('@/views/Profile.vue'), meta: { auth: true } },
	{ path: '/addresses', component: () => import('@/views/AddressList.vue'), meta: { auth: true } },
	{ path: '/courses', component: () => import('@/views/CourseList.vue') },
	{ path: '/courses/:id', component: () => import('@/views/CourseDetail.vue') },
	{ path: '/museums', component: () => import('@/views/MuseumList.vue') },
	{ path: '/museums/:id', component: () => import('@/views/MuseumDetail.vue') },
	// 管理后台路由
	{ path: '/admin/articles', component: () => import('@/views/admin/ArticleList.vue'), meta: { auth: true, admin: true } },
	{ path: '/admin/articles/create', component: () => import('@/views/admin/ArticleEditor.vue'), meta: { auth: true, admin: true } },
	{ path: '/admin/articles/:id/edit', component: () => import('@/views/admin/ArticleEditor.vue'), meta: { auth: true, admin: true } },
	// 商家中心
	{ path: '/merchant', component: () => import('@/views/merchant/Dashboard.vue'), meta: { auth: true, merchant: true } },
	{ path: '/merchant/products', component: () => import('@/views/merchant/ProductList.vue'), meta: { auth: true, merchant: true } },
	{ path: '/merchant/products/create', component: () => import('@/views/merchant/ProductEditor.vue'), meta: { auth: true, merchant: true } },
	{ path: '/merchant/products/:id/edit', component: () => import('@/views/merchant/ProductEditor.vue'), meta: { auth: true, merchant: true } },
	{ path: '/merchant/orders', component: () => import('@/views/merchant/OrderList.vue'), meta: { auth: true, merchant: true } },
	{ path: '/merchant/orders/:orderNo', component: () => import('@/views/merchant/OrderDetail.vue'), meta: { auth: true, merchant: true } },
	{ path: '/merchant/refunds', component: () => import('@/views/merchant/RefundList.vue'), meta: { auth: true, merchant: true } },
	{ path: '/merchant/apply', component: () => import('@/views/merchant/Apply.vue'), meta: { auth: true } },
	// 智能体管理
	{ path: '/agent', component: () => import('@/views/AgentDashboard.vue'), meta: { auth: true, admin: true } },
  
  // 错误页面
  { path: '/404', component: () => import('@/views/errors/NotFound.vue') },
  { path: '/500', component: () => import('@/views/errors/ServerError.vue') },
  { path: '/403', component: () => import('@/views/errors/Forbidden.vue') },
  { path: '/network-error', component: () => import('@/views/errors/NetworkError.vue') },
	// 404 通配符路由，必须放在最后
	{ path: '/:pathMatch(.*)*', component: () => import('@/views/errors/NotFound.vue') },
];

const router = createRouter({
	history: createWebHistory(),
	routes,
});

router.beforeEach(async (to, from, next) => {
	const auth = useAuthStore();
	
	try {
		// 检查是否需要认证
		if (to.meta.auth) {
			if (!auth.token) {
				// 未登录，重定向到登录页
				return next({ 
					path: '/login', 
					query: { redirect: to.fullPath } 
				});
			}
			
			// 刷新用户信息以确保角色是最新的
			await auth.refreshProfile();
			const userRole = String(auth.role || '').toUpperCase();
			
			// 检查管理员权限
			if (to.meta.admin && userRole !== 'ADMIN') {
				return next({ path: '/403' });
			}
			
			// 检查商家权限
			if (to.meta.merchant) {
				if (userRole !== 'MERCHANT' && userRole !== 'ADMIN') {
					return next({ path: '/403' });
				}
			}
			
			// 已是商家则不允许访问申请页面
			if (to.path === '/merchant/apply') {
				if (userRole === 'MERCHANT' || userRole === 'ADMIN') {
					return next({ path: '/merchant' });
				}
			}
		}
		
		// 已登录用户访问登录/注册页面，重定向到首页
		if ((to.path === '/login' || to.path === '/register') && auth.token) {
			return next({ path: '/' });
		}
		
		next();
	} catch (error) {
		console.error('路由守卫错误:', error);
		// 发生错误时重定向到500页面
		return next({ path: '/500' });
	}
});

// 路由错误处理
router.onError((error) => {
	console.error('路由错误:', error);
	// 可以在这里添加错误报告逻辑
});

export default router; 
