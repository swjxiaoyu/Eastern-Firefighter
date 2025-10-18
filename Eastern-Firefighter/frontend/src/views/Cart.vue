<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import http from '@/api/http'
import LazyImage from '@/components/LazyImage.vue'

const list = ref<any[]>([])
const loading = ref(true)
const errorMsg = ref('')
const selectedItems = ref<Set<string>>(new Set())
const isSelectAll = ref(false)

async function fetchCart() {
  loading.value = true
  try {
    console.log('[FRONTEND] 开始获取购物车列表')
    const { data } = await http.get('/user/cart')
    console.log('[FRONTEND] 购物车API响应:', data)
    list.value = data?.data || []
    console.log('[FRONTEND] 购物车商品列表:', list.value)
    // 清空选择状态
    selectedItems.value.clear()
    isSelectAll.value = false
  } catch (e: any) {
    console.error('[FRONTEND] 获取购物车失败:', e)
    errorMsg.value = e?.response?.data?.message || '加载失败'
  } finally {
    loading.value = false
  }
}

async function updateQty(item: any, qty: number) {
  const normalized = Math.max(1, Number(qty) || 1)
  const old = Number(item.quantity) || 1
  cancelDebounce(item)
  const key = String(item.id)
  if (!itemUpdateState.has(key)) {
    itemUpdateState.set(key, { inFlight: false, pending: null as number | null })
  }
  const state = itemUpdateState.get(key)!
  // 若正在更新，则合并为待处理的最终数量
  if (state.inFlight) {
    state.pending = normalized
    return
  }
  state.inFlight = true
  state.pending = null
  item.quantity = normalized
  try {
    await http.post('/user/cart/update', { id: item.id, quantity: normalized })
    await fetchCart()
  } catch (e: any) {
    item.quantity = old
    errorMsg.value = e?.response?.data?.message || '更新失败'
  } finally {
    state.inFlight = false
    if (state.pending != null && state.pending !== normalized) {
      const next = state.pending
      state.pending = null
      // 递归执行最新一次
      await updateQty(item, next as number)
    }
  }
}

function stepQty(item: any, delta: number){
  cancelDebounce(item)
  const next = Math.max(1, Number(item.quantity) + delta)
  const key = String(item.id)
  if (!itemUpdateState.has(key)) {
    itemUpdateState.set(key, { inFlight: false, pending: null as number | null })
  }
  const state = itemUpdateState.get(key)!
  if (state.inFlight) {
    state.pending = next
    item.quantity = next
    return
  }
  updateQty(item, next)
}

const itemUpdateState = new Map<string, { inFlight: boolean; pending: number | null }>()

const debounceTimers = new Map<string, number>()
function onQtyInput(item: any) {
  const key = String(item.id)
  if (debounceTimers.has(key)) {
    clearTimeout(debounceTimers.get(key) as number)
  }
  debounceTimers.set(key, window.setTimeout(() => updateQty(item, item.quantity), 400))
}

function cancelDebounce(item: any){
  const key = String(item.id)
  if (debounceTimers.has(key)) {
    clearTimeout(debounceTimers.get(key) as number)
    debounceTimers.delete(key)
  }
}

const totalCount = computed(() => list.value.reduce((sum, it) => sum + (Number(it.quantity) || 0), 0))
const totalAmount = computed(() => list.value.reduce((sum, it) => sum + (Number(it.price) || 0) * (Number(it.quantity) || 0), 0))

function fmt(n: number){ return (Number(n) || 0).toFixed(2) }

async function removeItem(item: any) {
  if (!confirm(`确定要删除"${item.productName}"吗？`)) {
    return
  }
  
  try {
    console.log('[FRONTEND] 单个删除请求: itemId=' + item.id + ' (类型: ' + typeof item.id + ')')
    await http.post(`/user/cart/${item.id}/delete`)
    await fetchCart()
  } catch (e: any) {
    console.error('[FRONTEND] 单个删除失败:', e)
    errorMsg.value = e?.response?.data?.message || '删除失败'
  }
}

// 选择/取消选择单个商品
function toggleSelect(item: any) {
  const itemId = String(item.id)
  if (selectedItems.value.has(itemId)) {
    selectedItems.value.delete(itemId)
  } else {
    selectedItems.value.add(itemId)
  }
  updateSelectAllState()
}

// 全选/取消全选
function toggleSelectAll() {
  if (isSelectAll.value) {
    selectedItems.value.clear()
    isSelectAll.value = false
  } else {
    list.value.forEach(item => {
      selectedItems.value.add(String(item.id))
    })
    isSelectAll.value = true
  }
}

// 更新全选状态
function updateSelectAllState() {
  isSelectAll.value = list.value.length > 0 && selectedItems.value.size === list.value.length
}

// 批量删除选中的商品
async function batchDelete() {
  if (selectedItems.value.size === 0) {
    alert('请先选择要删除的商品')
    return
  }
  
  const selectedCount = selectedItems.value.size
  if (!confirm(`确定要删除选中的 ${selectedCount} 件商品吗？`)) {
    return
  }
  
  try {
    // 直接使用字符串ID，避免JavaScript精度问题
    const ids = Array.from(selectedItems.value)
    console.log('[FRONTEND] 批量删除请求 (字符串ID):', ids)
    console.log('[FRONTEND] 删除前购物车商品数量:', list.value.length)
    
    const response = await http.post('/user/cart/batch-delete', ids)
    console.log('[FRONTEND] 批量删除响应:', response)
    
    // 清空选择状态
    selectedItems.value.clear()
    isSelectAll.value = false
    
    // 强制刷新购物车列表
    console.log('[FRONTEND] 开始刷新购物车列表')
    await fetchCart()
    console.log('[FRONTEND] 删除后购物车商品数量:', list.value.length)
    
    // 验证删除是否成功
    const remainingIds = list.value.map(item => String(item.id))
    const deletedIds = ids.map(id => String(id))
    const stillExists = deletedIds.some(id => remainingIds.includes(id))
    
    if (stillExists) {
      console.warn('[FRONTEND] 警告: 部分商品可能没有成功删除')
      if (confirm('删除操作完成，但部分商品可能仍显示在购物车中。是否刷新页面查看最新状态？')) {
        window.location.reload()
      }
    } else {
      alert(`成功删除 ${selectedCount} 件商品`)
    }
  } catch (e: any) {
    console.error('[FRONTEND] 批量删除失败:', e)
    errorMsg.value = e?.response?.data?.message || '批量删除失败'
  }
}

// 清空购物车
async function clearCart() {
  if (list.value.length === 0) {
    alert('购物车已经是空的')
    return
  }
  
  if (!confirm(`确定要清空购物车吗？这将删除所有 ${list.value.length} 件商品`)) {
    return
  }
  
  try {
    await http.post('/user/cart/clear')
    await fetchCart()
    alert('购物车已清空')
  } catch (e: any) {
    errorMsg.value = e?.response?.data?.message || '清空购物车失败'
  }
}

onMounted(fetchCart)
</script>

<template>
  <div class="cart-page-wrapper">
    <div class="cart-container">
      <!-- 页面标题 -->
      <div class="page-header">
        <h1 class="page-title">购物车</h1>
        <p class="page-subtitle">管理您的应急装备订单</p>
      </div>

    <!-- 加载状态 -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>正在加载购物车...</p>
    </div>

    <!-- 错误状态 -->
    <div v-if="errorMsg" class="error-state">
      <div class="error-icon">⚠️</div>
      <p>{{ errorMsg }}</p>
      <button @click="fetchCart" class="btn retry-btn">重试</button>
    </div>

    <!-- 空购物车状态 -->
    <div v-if="!loading && list.length === 0" class="empty-state">
      <div class="empty-icon">🛒</div>
      <h3>购物车空空如也</h3>
      <p>快去挑选心仪的应急装备吧</p>
      <router-link to="/" class="btn primary">去购物</router-link>
    </div>

    <!-- 购物车商品列表 -->
    <div v-if="!loading && list.length > 0" class="cart-content">
      <!-- 批量操作工具栏 -->
      <div class="batch-toolbar">
        <div class="select-all-section">
          <label class="select-all-checkbox">
            <input 
              type="checkbox" 
              :checked="isSelectAll" 
              @change="toggleSelectAll"
            />
            <span class="checkbox-label">全选</span>
          </label>
          <span class="selected-count" v-if="selectedItems.size > 0">
            已选择 {{ selectedItems.size }} 件商品
          </span>
        </div>
        
        <div class="batch-actions">
          <button 
            class="btn batch-delete-btn" 
            @click="batchDelete"
            :disabled="selectedItems.size === 0"
            :class="{ disabled: selectedItems.size === 0 }"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19 4h-3.5l-1-1h-5l-1 1H5v2h14V4zM6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM8 9h8v10H8V9z"/>
            </svg>
            删除选中
          </button>
          
          <button 
            class="btn clear-cart-btn" 
            @click="clearCart"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
            </svg>
            清空购物车
          </button>
        </div>
      </div>
      
      <div class="cart-items">
        <div v-for="item in list" :key="item.id" class="cart-item">
          <!-- 商品选择框 -->
          <div class="item-select">
            <label class="item-checkbox">
              <input 
                type="checkbox" 
                :checked="selectedItems.has(String(item.id))"
                @change="toggleSelect(item)"
              />
              <span class="checkbox-custom"></span>
            </label>
          </div>
          <div class="item-image">
        <LazyImage 
          :src="''" 
          :width="120" 
              :height="120" 
          placeholder="product"
          :product-name="item.productName"
          :fit="'cover'"
              :radius="12"
          alt="商品图片" 
        />
          </div>
          
          <div class="item-info">
            <h3 class="item-title">{{ item.productName }}</h3>
            <p class="item-price">单价 ￥{{ fmt(item.price) }}</p>
          </div>
          
          <div class="item-quantity">
            <div class="quantity-selector">
              <button 
                class="qty-btn minus-btn" 
                @click="stepQty(item, -1)" 
                :disabled="item.quantity<=1"
                :class="{ disabled: item.quantity<=1 }"
                title="减少数量"
              >
                −
              </button>
              <input 
                class="qty-input" 
                type="number" 
                min="1" 
                step="1" 
                inputmode="numeric" 
                v-model.number="item.quantity" 
                @input="onQtyInput(item)" 
              />
              <button 
                class="qty-btn plus-btn" 
                @click="stepQty(item, 1)"
                title="增加数量"
              >
                +
              </button>
            </div>
          </div>
          
          <div class="item-total">
            <div class="total-price">￥{{ fmt((Number(item.price)||0) * (Number(item.quantity)||0)) }}</div>
          </div>
          
          <div class="item-actions">
            <button 
              class="delete-btn" 
              @click="removeItem(item)"
              title="删除商品"
            >
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19 4h-3.5l-1-1h-5l-1 1H5v2h14V4zM6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM8 9h8v10H8V9z"/>
              </svg>
              删除
            </button>
          </div>
        </div>
      </div>

      <!-- 结算区域 -->
      <div class="checkout-section">
        <div class="checkout-summary">
          <div class="summary-row">
            <span class="summary-label">商品总数</span>
            <span class="summary-value">{{ totalCount }} 件</span>
          </div>
          <div class="summary-row total-row">
            <span class="summary-label">合计金额</span>
            <span class="summary-value total-amount">￥{{ fmt(totalAmount) }}</span>
          </div>
        </div>
        
        <div class="checkout-actions">
          <router-link to="/" class="btn secondary">继续购物</router-link>
          <router-link to="/checkout" class="btn primary checkout-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M7 4V2C7 1.45 7.45 1 8 1H16C16.55 1 17 1.45 17 2V4H20C20.55 4 21 4.45 21 5S20.55 6 20 6H19V19C19 20.1 18.1 21 17 21H7C5.9 21 5 20.1 5 19V6H4C3.45 6 3 5.55 3 5S3.45 4 4 4H7ZM9 3V4H15V3H9ZM7 6V19H17V6H7Z"/>
            </svg>
            去结算
          </router-link>
        </div>
      </div>
    </div>
    </div>
  </div>
</template>

<style scoped>
/* 确保页面背景 */
:deep(body) {
  background: #ffffff !important;
}

:deep(html) {
  background: #ffffff !important;
}
/* 全屏背景包装器 */
.cart-page-wrapper {
  background: #ffffff;
  min-height: 100vh;
  width: 100%;
  padding: 40px 0;
  margin: 0;
}

/* 购物车容器 */
.cart-container {
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

/* 错误状态 */
.error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid #fafafa;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
}

.error-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.error-state p {
  color: #dc2626;
  font-size: 16px;
  margin-bottom: 16px;
}

.retry-btn {
  background: #dc2626;
  color: #fff;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.retry-btn:hover {
  background: #b91c1c;
  transform: translateY(-1px);
}

/* 空购物车状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #fafafa;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 24px;
  opacity: 0.6;
}

.empty-state h3 {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 12px;
}

.empty-state p {
  color: #6b7280;
  font-size: 16px;
  margin: 0 0 24px;
}

/* 购物车内容 */
.cart-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 批量操作工具栏 */
.batch-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #fafafa;
  margin-bottom: 16px;
}

.select-all-section {
  display: flex;
  align-items: center;
  gap: 16px;
}

.select-all-checkbox {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  font-weight: 500;
  color: #374151;
}

.select-all-checkbox input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.checkbox-label {
  font-size: 16px;
  font-weight: 600;
}

.selected-count {
  color: #ef3a2d;
  font-size: 14px;
  font-weight: 500;
}

.batch-actions {
  display: flex;
  gap: 12px;
}

.batch-delete-btn {
  background: #fef2f2;
  color: #dc2626;
  border: 1px solid #fecaca;
  font-size: 14px;
  padding: 8px 16px;
  height: 36px;
}

.batch-delete-btn:hover:not(.disabled) {
  background: #dc2626;
  color: #fff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
}

.batch-delete-btn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background: #f3f4f6;
  color: #9ca3af;
  border-color: #e5e7eb;
}

.clear-cart-btn {
  background: #fef2f2;
  color: #dc2626;
  border: 1px solid #fecaca;
  font-size: 14px;
  padding: 8px 16px;
  height: 36px;
}

.clear-cart-btn:hover {
  background: #dc2626;
  color: #fff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
}

/* 商品选择框 */
.item-select {
  display: flex;
  align-items: center;
  justify-content: center;
}

.item-checkbox {
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  position: relative;
}

.item-checkbox input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
  opacity: 0;
  position: absolute;
  z-index: 1;
}

.checkbox-custom {
  width: 18px;
  height: 18px;
  border: 2px solid #d1d5db;
  border-radius: 4px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.item-checkbox input[type="checkbox"]:checked + .checkbox-custom {
  background: #ef3a2d;
  border-color: #ef3a2d;
}

.item-checkbox input[type="checkbox"]:checked + .checkbox-custom::after {
  content: '✓';
  color: #fff;
  font-size: 12px;
  font-weight: bold;
}

.cart-items {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.cart-item {
  display: grid;
  grid-template-columns: 40px 120px 1fr auto auto auto;
  align-items: center;
  gap: 20px;
  padding: 24px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #fafafa;
  transition: all 0.3s ease;
  position: relative;
  max-width: 100%;
}

.cart-item:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.item-image {
  position: relative;
  overflow: hidden;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.item-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.item-title {
  font-size: 18px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0;
  line-height: 1.4;
}

.item-price {
  color: #6b7280;
  font-size: 14px;
  margin: 0;
}

/* 数量选择器 */
.quantity-selector {
  display: flex;
  align-items: center;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  overflow: hidden;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  min-width: 120px;
}

.qty-btn {
  width: 44px;
  height: 44px;
  border: none;
  background: #f9fafb;
  color: #6b7280;
  font-size: 24px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  border-right: 1px solid #e5e7eb;
  line-height: 1;
}

.qty-btn:last-of-type {
  border-right: none;
  border-left: 1px solid #e5e7eb;
}

.qty-btn:hover:not(.disabled) {
  background: #ef3a2d;
  color: #fff;
  transform: scale(1.05);
}

.qty-btn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background: #f3f4f6;
  color: #9ca3af;
}

.qty-btn.disabled:hover {
  background: #f3f4f6;
  color: #9ca3af;
  transform: none;
}

.qty-btn:active:not(.disabled) {
  transform: scale(0.95);
}

.qty-input {
  width: 60px;
  height: 44px;
  border: none;
  text-align: center;
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  background: #fff;
  outline: none;
  flex: 1;
  min-width: 0;
}

.qty-input:focus {
  background: #fef2f2;
}

/* 按钮特殊样式 */
.minus-btn {
  border-radius: 10px 0 0 10px;
}

.plus-btn {
  border-radius: 0 10px 10px 0;
}

.qty-btn:hover:not(.disabled) {
  transform: scale(1.1);
}

/* 商品总价 */
.item-total {
  text-align: right;
}

.total-price {
  font-size: 20px;
  font-weight: 800;
  color: #ef3a2d;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* 商品操作按钮 */
.item-actions {
  display: flex;
  align-items: center;
  justify-content: center;
}

.delete-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 12px;
  background: #fef2f2;
  color: #dc2626;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.delete-btn:hover {
  background: #dc2626;
  color: #fff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
}

.delete-btn:active {
  transform: translateY(0);
  box-shadow: 0 2px 6px rgba(220, 38, 38, 0.2);
}

.delete-btn svg {
  transition: all 0.2s ease;
}

.delete-btn:hover svg {
  transform: scale(1.1);
}

/* 结算区域 */
.checkout-section {
  background: #ffffff;
  border-radius: 16px;
  padding: 28px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #fafafa;
  position: sticky;
  bottom: 20px;
  max-width: 100%;
}

.checkout-summary {
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 1px solid #f5f5f5;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.summary-row:last-child {
  margin-bottom: 0;
}

.summary-label {
  font-size: 16px;
  color: #6b7280;
  font-weight: 500;
}

.summary-value {
  font-size: 16px;
  color: #1a1a1a;
  font-weight: 600;
}

.total-row {
  padding-top: 12px;
  border-top: 1px solid #f5f5f5;
}

.total-amount {
  font-size: 24px;
  font-weight: 800;
  color: #ef3a2d;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.checkout-actions {
  display: flex;
  gap: 16px;
  justify-content: flex-end;
}

/* 按钮样式 */
.btn {
  height: 48px;
  padding: 0 24px;
  border-radius: 12px;
  border: 1px solid transparent;
  cursor: pointer;
  font-weight: 600;
  font-size: 16px;
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

.btn.secondary {
  background: #fff;
  color: #ef3a2d;
  border: 2px solid #ef3a2d;
}

.btn.secondary:hover {
  background: #fef2f2;
  color: #dc2626;
  border-color: #dc2626;
}

.checkout-btn {
  min-width: 140px;
  font-size: 18px;
  font-weight: 700;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .cart-container {
    max-width: 1000px;
    padding: 0 20px;
  }
}

@media (max-width: 768px) {
  .cart-container {
    max-width: 100%;
    padding: 16px;
  }
  
  .page-title {
    font-size: 28px;
  }
  
  .cart-item {
    grid-template-columns: 40px 100px 1fr;
    grid-template-rows: auto auto auto auto;
    gap: 16px;
    padding: 20px;
  }
  
  .item-quantity,
  .item-total,
  .item-actions {
    grid-column: 2 / -1;
    justify-self: center;
  }
  
  .item-quantity {
    order: 3;
  }
  
  .item-total {
    order: 4;
    text-align: center;
  }
  
  .item-actions {
    order: 5;
  }
  
  .checkout-actions {
    flex-direction: column;
  }
  
  .btn {
    width: 100%;
  }
  
  .batch-toolbar {
    flex-direction: column;
    gap: 16px;
    align-items: stretch;
  }
  
  .select-all-section {
    justify-content: center;
  }
  
  .batch-actions {
    justify-content: center;
  }
  
  .batch-delete-btn,
  .clear-cart-btn {
    flex: 1;
    min-width: 120px;
  }
}

@media (max-width: 480px) {
  .cart-page-wrapper {
    padding: 20px 0;
  }
  
  .cart-container {
    padding: 0 12px;
  }
  
  .cart-item {
    padding: 16px;
    gap: 12px;
  }
  
  .item-image {
    width: 80px;
    height: 80px;
  }
  
  .item-title {
    font-size: 16px;
  }
  
  .total-price {
    font-size: 18px;
  }
  
  .checkout-section {
    padding: 20px;
  }
}

/* 大屏幕优化 */
@media (min-width: 1400px) {
  .cart-container {
    max-width: 1400px;
  }
}
</style> 