<template>
  <div class="merchant-apply-wrapper">
    <div class="merchant-apply-container">
      <!-- 页面标题 -->
      <div class="page-header">
        <h1 class="page-title">商家入驻</h1>
        <p class="page-subtitle">加入东方灭火侠平台，开启您的应急装备销售之旅</p>
      </div>

      <!-- 申请表单 -->
      <div class="form-card fade-in">
        <div class="card-header">
          <h3 class="card-title">商家信息</h3>
          <p class="card-subtitle">请填写您的商家基本信息</p>
        </div>
        
        <div class="form-content">
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">商家名称 <span class="required">*</span></label>
              <input 
                v-model="form.merchantName" 
                class="form-input" 
                placeholder="请输入公司或门店名称"
                type="text"
                :disabled="submitting"
              />
            </div>
            
            <div class="form-group">
              <label class="form-label">联系人 <span class="required">*</span></label>
              <input 
                v-model="form.contactPerson" 
                class="form-input" 
                placeholder="请输入联系人姓名"
                type="text"
                :disabled="submitting"
              />
            </div>
            
            <div class="form-group">
              <label class="form-label">联系电话 <span class="required">*</span></label>
              <input 
                v-model="form.contactPhone" 
                class="form-input" 
                placeholder="请输入手机或座机号码"
                type="tel"
                :disabled="submitting"
              />
            </div>
            
            <div class="form-group full-width">
              <label class="form-label">营业执照</label>
              <input 
                v-model="form.businessLicense" 
                class="form-input" 
                placeholder="营业执照号或链接（可选）"
                type="text"
                :disabled="submitting"
              />
            </div>
            
            <div class="form-group full-width">
              <label class="form-label">经营地址</label>
              <input 
                v-model="form.businessAddress" 
                class="form-input" 
                placeholder="省市区 + 详细地址（可选）"
                type="text"
                :disabled="submitting"
              />
            </div>
          </div>
          
          <div class="form-actions">
            <button 
              class="btn primary" 
              :disabled="submitting || !isFormValid" 
              @click="submit"
            >
              <span v-if="submitting" class="btn-spinner"></span>
              <span class="btn-icon" v-if="!submitting">🚀</span>
              {{ submitting ? '提交中...' : '提交入驻申请' }}
            </button>
          </div>
          
          <div class="form-hint">
            <div class="hint-icon">💡</div>
            <p>提交后预计1-2个工作日完成审核，审核通过后请重新登录即可看到「商家中心」。</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, computed } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const auth = useAuthStore()

const form = reactive({
	merchantName: '',
	contactPerson: '',
	contactPhone: '',
	businessLicense: '',
	businessAddress: ''
})
const submitting = ref(false)

// 表单验证
const isFormValid = computed(() => {
	return form.merchantName.trim() !== '' && 
	       form.contactPerson.trim() !== '' && 
	       form.contactPhone.trim() !== ''
})

async function submit(){
	if (!isFormValid.value) {
		return alert('请完整填写商家名称、联系人、联系电话')
	}
	if (submitting.value) return
	submitting.value = true
	try{
		await axios.post('/api/user/merchant/apply', form)
		await auth.refreshProfile()
		alert('申请已提交，已自动开通商家权限，正在进入商家中心')
		router.push('/merchant')
	}catch(e:any){
		alert(e?.response?.data?.message || '提交失败')
	} finally {
		submitting.value = false
	}
}
</script>

<style scoped>
/* 全屏背景包装器 */
.merchant-apply-wrapper {
  background: #ffffff;
  min-height: 100vh;
  width: 100%;
  padding: 40px 0;
  margin: 0;
}

/* 商家入驻容器 */
.merchant-apply-container {
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

/* 表单卡片 */
.form-card {
  background: #ffffff;
  border-radius: 20px;
  padding: 32px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #fafafa;
  transition: all 0.3s ease;
  max-width: 800px;
  margin: 0 auto;
}

.form-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.card-header {
  margin-bottom: 32px;
  padding-bottom: 20px;
  border-bottom: 1px solid #f5f5f5;
  text-align: center;
}

.card-title {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 8px;
}

.card-subtitle {
  font-size: 16px;
  color: #6b7280;
  margin: 0;
}

/* 表单内容 */
.form-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group.full-width {
  grid-column: span 2;
}

.form-label {
  font-size: 14px;
  font-weight: 600;
  color: #374151;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 4px;
}

.required {
  color: #ef3a2d;
  font-weight: 700;
}

.form-input {
  width: 100%;
  height: 48px;
  padding: 0 16px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  background: #fff;
  font-size: 14px;
  color: #374151;
  transition: all 0.3s ease;
}

.form-input:focus {
  outline: none;
  border-color: #ef3a2d;
  box-shadow: 0 0 0 3px rgba(239, 58, 45, 0.1);
}

.form-input:disabled {
  background: #f9fafb;
  color: #9ca3af;
  cursor: not-allowed;
}

.form-input::placeholder {
  color: #9ca3af;
}

/* 表单操作 */
.form-actions {
  display: flex;
  justify-content: center;
  margin-top: 8px;
}

.btn {
  height: 52px;
  padding: 0 32px;
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
  min-width: 180px;
  position: relative;
}

.btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.btn.primary {
  background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
  color: #fff;
  font-weight: 700;
  box-shadow: 0 4px 15px rgba(239, 58, 45, 0.3);
}

.btn.primary:hover:not(:disabled) {
  background: linear-gradient(135deg, #dc2626, #ea580c);
  box-shadow: 0 6px 20px rgba(239, 58, 45, 0.4);
}

.btn:disabled {
  background: #f3f4f6;
  color: #9ca3af;
  border-color: #e5e7eb;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.btn-icon {
  font-size: 18px;
}

.btn-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid transparent;
  border-top: 2px solid currentColor;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 提示信息 */
.form-hint {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 16px;
  background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
  border: 1px solid #bae6fd;
  border-radius: 12px;
  margin-top: 8px;
}

.hint-icon {
  font-size: 20px;
  flex-shrink: 0;
  margin-top: 2px;
}

.form-hint p {
  color: #0369a1;
  font-size: 14px;
  line-height: 1.5;
  margin: 0;
}

/* 动画效果 */
.fade-in {
  animation: fadeIn 0.6s ease-out both;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .merchant-apply-container {
    max-width: 1000px;
    padding: 0 20px;
  }
}

@media (max-width: 768px) {
  .merchant-apply-wrapper {
    padding: 20px 0;
  }
  
  .merchant-apply-container {
    max-width: 100%;
    padding: 0 16px;
  }
  
  .page-title {
    font-size: 28px;
  }
  
  .form-card {
    padding: 24px;
  }
  
  .form-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .form-group.full-width {
    grid-column: span 1;
  }
  
  .btn {
    width: 100%;
    min-width: auto;
  }
  
  .form-hint {
    flex-direction: column;
    gap: 8px;
  }
  
  .hint-icon {
    align-self: flex-start;
  }
}

@media (max-width: 480px) {
  .merchant-apply-container {
    padding: 0 12px;
  }
  
  .form-card {
    padding: 20px;
  }
  
  .card-title {
    font-size: 20px;
  }
  
  .form-input {
    height: 44px;
  }
  
  .btn {
    height: 48px;
    font-size: 14px;
  }
}

/* 大屏幕优化 */
@media (min-width: 1400px) {
  .merchant-apply-container {
    max-width: 1400px;
  }
}
</style> 