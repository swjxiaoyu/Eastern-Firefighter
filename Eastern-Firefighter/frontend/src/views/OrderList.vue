<template>
  <div class="order-page-wrapper">
    <div class="order-container">
      <!-- 页面标题 -->
      <div class="page-header">
        <h1 class="page-title">我的订单</h1>
        <p class="page-subtitle">管理您的应急装备订单</p>
      </div>

      <!-- 筛选器 -->
      <div class="filters-section">
        <div class="filters-card">
          <select v-model="status" class="status-select" @change="load">
            <option value="">全部状态</option>
            <option value="0">待支付</option>
            <option value="1">已支付</option>
            <option value="2">已发货</option>
            <option value="3">已完成</option>
            <option value="4">退款中</option>
          </select>
        </div>
      </div>

      <!-- 加载状态 -->
      <div v-if="loading" class="loading-state">
        <div class="loading-spinner"></div>
        <p>正在加载订单...</p>
      </div>

      <!-- 空状态 -->
      <div v-else-if="list.length===0" class="empty-state">
        <div class="empty-icon">📦</div>
        <h3>暂无订单</h3>
        <p>快去挑选心仪的应急装备吧</p>
        <router-link to="/products" class="btn primary">去购物</router-link>
      </div>

      <!-- 订单列表 -->
      <div v-else class="orders-grid">
        <article v-for="o in list" :key="o.orderNo" class="order-card" @click="$router.push(`/orders/${o.orderNo}`)">
          <div class="order-header">
            <div class="order-info">
              <span class="order-label">订单号</span>
              <span class="order-number">{{ o.orderNo }}</span>
            </div>
            <span :class="['status-badge', statusClass(o.status)]">{{ statusText(o.status) }}</span>
          </div>
          
          <div class="order-items">
            <div v-for="it in o.items" :key="it.skuId" class="order-item">
              <div class="item-image">
                <img :src="it.coverUrl" :alt="it.productName" />
              </div>
              <div class="item-info">
                <div class="item-name">{{ it.productName }}</div>
                <div class="item-quantity">× {{ it.quantity }}</div>
              </div>
              <div class="item-price">￥{{ Number(it.amount||0).toFixed(2) }}</div>
            </div>
          </div>
          
          <div class="order-footer">
            <div class="order-total">
              <span class="total-label">合计：</span>
              <span class="total-amount">￥{{ Number(o.payAmount||0).toFixed(2) }}</span>
            </div>
            <div class="order-date">{{ new Date(o.createdAt).toLocaleString() }}</div>
          </div>
        </article>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import http from '@/api/http'
import { ref, onMounted } from 'vue'

const list = ref<any[]>([])
const loading = ref(false)
const status = ref('')

async function load(){
  loading.value = true
  try {
    const params: any = { page: 1, size: 20 }
    if (status.value !== '') params.status = Number(status.value)
    const { data } = await http.get('/user/orders', { params })
    list.value = data?.data?.records || []
  } finally {
    loading.value = false
  }
}

function statusText(s: number|string){
  const map: any = { 0:'待支付', 1:'已支付', 2:'已发货', 3:'已完成', 4:'退款中' }
  const n = typeof s === 'string' ? Number(s) : s
  return map[n] ?? s
}
function statusClass(s: number|string){
  const map: any = { 0:'pending', 1:'paid', 2:'shipped', 3:'finished', 4:'refunding' }
  const n = typeof s === 'string' ? Number(s) : s
  return map[n] ?? ''
}

onMounted(load)
</script>

<style scoped>
/* 全屏背景包装器 */
.order-page-wrapper {
  background: #ffffff;
  min-height: 100vh;
  width: 100%;
  padding: 40px 0;
  margin: 0;
}

/* 订单容器 */
.order-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
  min-height: auto;
  width: 100%;
}

/* 页面标题 */
.page-header {
  text-align: center;
  margin-bottom: 32px;
  padding: 24px 0;
}

.page-title {
  font-size: 32px;
  font-weight: 800;
  color: #1a1a1a;
  margin: 0 0 8px;
  background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-subtitle {
  color: #6b7280;
  font-size: 16px;
  margin: 0;
}

/* 筛选器区域 */
.filters-section {
  margin-bottom: 24px;
}

.filters-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 20px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #fafafa;
}

.status-select {
  width: 200px;
  height: 40px;
  padding: 0 16px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  background: #fff;
  font-size: 14px;
  color: #374151;
  cursor: pointer;
  transition: all 0.3s ease;
}

.status-select:focus {
  outline: none;
  border-color: #ef3a2d;
  box-shadow: 0 0 0 3px rgba(239, 58, 45, 0.1);
}

/* 加载状态 */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f4f6;
  border-top: 4px solid #ef3a2d;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-state p {
  color: #6b7280;
  font-size: 16px;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
  background: #ffffff;
  border-radius: 16px;
  border: 1px solid #fafafa;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 16px;
  opacity: 0.6;
}

.empty-state h3 {
  color: #1a1a1a;
  font-size: 20px;
  font-weight: 700;
  margin: 0 0 8px;
}

.empty-state p {
  color: #6b7280;
  font-size: 16px;
  margin: 0 0 24px;
}

/* 订单网格 */
.orders-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 20px;
}

/* 订单卡片 */
.order-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #fafafa;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}

.order-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

/* 订单头部 */
.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 1px solid #f5f5f5;
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.order-label {
  font-size: 12px;
  color: #6b7280;
  font-weight: 500;
}

.order-number {
  font-size: 16px;
  color: #1a1a1a;
  font-weight: 600;
  font-family: 'Courier New', monospace;
}

/* 状态标签 */
.status-badge {
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-badge.pending {
  background: linear-gradient(135deg, #fef3c7, #fde68a);
  color: #b45309;
}

.status-badge.paid {
  background: linear-gradient(135deg, #dcfce7, #bbf7d0);
  color: #166534;
}

.status-badge.shipped {
  background: linear-gradient(135deg, #e0f2fe, #bae6fd);
  color: #075985;
}

.status-badge.finished {
  background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
  color: #334155;
}

.status-badge.refunding {
  background: linear-gradient(135deg, #fee2e2, #fecaca);
  color: #b91c1c;
}

/* 订单商品 */
.order-items {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 20px;
}

.order-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: #f8fafc;
  border-radius: 12px;
  border: 1px solid #f1f5f9;
}

.item-image {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  flex-shrink: 0;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.item-name {
  font-size: 14px;
  color: #1a1a1a;
  font-weight: 600;
  line-height: 1.4;
}

.item-quantity {
  font-size: 12px;
  color: #6b7280;
}

.item-price {
  font-size: 16px;
  color: #ef3a2d;
  font-weight: 700;
  flex-shrink: 0;
}

/* 订单底部 */
.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16px;
  border-top: 1px solid #f5f5f5;
}

.order-total {
  display: flex;
  align-items: baseline;
  gap: 8px;
}

.total-label {
  font-size: 14px;
  color: #6b7280;
  font-weight: 500;
}

.total-amount {
  font-size: 20px;
  color: #ef3a2d;
  font-weight: 800;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.order-date {
  font-size: 12px;
  color: #9ca3af;
}

/* 按钮样式 */
.btn {
  height: 40px;
  padding: 0 20px;
  border-radius: 12px;
  border: 1px solid transparent;
  cursor: pointer;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  text-decoration: none;
  min-width: 120px;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.btn.primary {
  background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
  color: #fff;
  font-weight: 700;
  box-shadow: 0 4px 15px rgba(239, 58, 45, 0.3);
}

.btn.primary:hover {
  background: linear-gradient(135deg, #dc2626, #ea580c);
  box-shadow: 0 6px 20px rgba(239, 58, 45, 0.4);
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .order-container {
    max-width: 1000px;
    padding: 0 20px;
  }
  
  .orders-grid {
    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
    gap: 16px;
  }
}

@media (max-width: 768px) {
  .order-page-wrapper {
    padding: 20px 0;
  }
  
  .order-container {
    max-width: 100%;
    padding: 0 16px;
  }
  
  .page-title {
    font-size: 28px;
  }
  
  .orders-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .order-card {
    padding: 20px;
  }
  
  .order-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }
  
  .order-footer {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .btn {
    width: 100%;
  }
}

@media (max-width: 480px) {
  .order-container {
    padding: 0 12px;
  }
  
  .order-card {
    padding: 16px;
  }
  
  .item-image {
    width: 50px;
    height: 50px;
  }
  
  .item-name {
    font-size: 13px;
  }
  
  .total-amount {
    font-size: 18px;
  }
}

/* 大屏幕优化 */
@media (min-width: 1400px) {
  .order-container {
    max-width: 1400px;
  }
}
</style> 
