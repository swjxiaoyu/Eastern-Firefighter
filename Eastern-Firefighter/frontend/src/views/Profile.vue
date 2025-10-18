<template>
  <div class="profile-page-wrapper">
    <div class="profile-container">
      <!-- 页面标题 -->
      <div class="page-header">
        <h1 class="page-title">个人资料</h1>
        <p class="page-subtitle">管理您的个人信息和账户设置</p>
      </div>

      <!-- 加载状态 -->
      <div v-if="loading" class="loading-state">
        <div class="loading-spinner"></div>
        <p>正在加载个人资料...</p>
      </div>

      <!-- 错误状态 -->
      <div v-else-if="error" class="error-state">
        <div class="error-icon">⚠️</div>
        <h3>加载失败</h3>
        <p>{{ error }}</p>
        <div class="error-actions">
          <button @click="retry" class="btn primary">重试</button>
          <a href="/login" class="btn secondary">去登录</a>
        </div>
      </div>

      <!-- 主要内容 -->
      <div v-else class="profile-content">
        <!-- 欢迎卡片 -->
        <div class="welcome-card fade-in">
          <div class="avatar-section">
            <div class="avatar-container">
              <img :src="avatarUrl || '/images/avatar-default.svg'" @error="onAvatarErr" alt="头像" />
            </div>
            <div class="welcome-text">
              <h3 class="welcome-title">{{ realName || '欢迎来到个人中心' }}</h3>
              <p class="welcome-subtitle">建议使用正方形头像，≤480×480 像素</p>
            </div>
          </div>
        </div>

        <!-- 个人信息表单 -->
        <div class="form-card fade-in delay-1">
          <div class="card-header">
            <h3 class="card-title">个人信息</h3>
            <p class="card-subtitle">完善您的基本信息</p>
          </div>
          <div class="form-content">
            <div class="form-group">
              <label class="form-label">真实姓名</label>
              <input 
                class="form-input" 
                v-model="realName" 
                placeholder="请输入您的真实姓名"
                type="text"
              />
            </div>
            
            <div class="form-group">
              <label class="form-label">性别</label>
              <select class="form-select" v-model="gender">
                <option value="">请选择性别</option>
                <option value="0">男</option>
                <option value="1">女</option>
                <option value="2">其他</option>
              </select>
            </div>
            
            <div class="form-group">
              <label class="form-label">生日</label>
              <input 
                class="form-input" 
                v-model="birthday" 
                type="date"
                placeholder="请选择您的生日"
              />
            </div>
            
            <div class="form-group">
              <label class="form-label">头像链接</label>
              <input 
                class="form-input" 
                v-model="avatarUrl" 
                placeholder="粘贴头像图片 URL（≤480×480）"
                type="url"
              />
            </div>
            
            <div class="form-actions">
              <button class="btn primary" @click="save">
                <span class="btn-icon">💾</span>
                保存信息
              </button>
            </div>
          </div>
        </div>

        <!-- 密码设置 -->
        <div class="password-card fade-in delay-2">
          <div class="card-header">
            <h3 class="card-title">密码设置</h3>
            <p class="card-subtitle">保护您的账户安全</p>
          </div>
          <div class="form-content">
            <div v-if="!hasPassword" class="password-form">
              <div class="form-group">
                <label class="form-label">新密码</label>
                <input 
                  class="form-input" 
                  v-model="newPassword" 
                  type="password" 
                  placeholder="请输入新密码"
                />
              </div>
              <div class="form-actions">
                <button class="btn primary" @click="setPwd">
                  <span class="btn-icon">🔒</span>
                  设置密码
                </button>
              </div>
            </div>
            
            <div v-else class="password-form">
              <div class="form-group">
                <label class="form-label">原密码</label>
                <input 
                  class="form-input" 
                  v-model="oldPassword" 
                  type="password" 
                  placeholder="请输入原密码"
                />
              </div>
              <div class="form-group">
                <label class="form-label">新密码</label>
                <input 
                  class="form-input" 
                  v-model="newPassword" 
                  type="password" 
                  placeholder="请输入新密码"
                />
              </div>
              <div class="form-actions">
                <button class="btn primary" @click="changePwd">
                  <span class="btn-icon">🔄</span>
                  修改密码
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { UserService } from '@/api/services';
import type { UserProfile } from '@/types/api';

const me = ref<UserProfile | null>(null);
const realName = ref<string>('');
const gender = ref<number | undefined>(undefined);
const birthday = ref<string>('');
const avatarUrl = ref<string>('');
const oldPassword = ref<string>('');
const newPassword = ref<string>('');
const loading = ref<boolean>(true);
const error = ref<string>('');
const hasPassword = ref<boolean>(false); // 假设用户已设置密码，实际应该从API获取

function randomAvatarUrl(): string {
	return `https://i.pravatar.cc/240?u=${Date.now()}-${Math.random().toString(36).slice(2)}`;
}

async function loadProfile(): Promise<void> {
	loading.value = true;
	error.value = '';
	try{
		const profileData = await UserService.getProfile();
		me.value = profileData;
		realName.value = profileData?.realName || '';
		gender.value = profileData?.gender ?? undefined;
		birthday.value = profileData?.birthday || '';
		avatarUrl.value = profileData?.avatarUrl || randomAvatarUrl();
	}catch(e){
		error.value = '未能加载个人资料，请登录或稍后重试';
		me.value = null;
	}finally{
		loading.value = false;
	}
}

function retry(): void {
	loadProfile();
}

onMounted(loadProfile);

async function save(): Promise<void> {
	await UserService.updateProfile({ 
		realName: realName.value, 
		gender: gender.value, 
		birthday: birthday.value, 
		avatarUrl: avatarUrl.value 
	});
	alert('已保存');
}

async function setPwd(): Promise<void> {
	await UserService.setPassword({ 
		newPassword: newPassword.value 
	});
	alert('已设置密码');
}

async function changePwd(): Promise<void> {
	await UserService.changePassword({ 
		oldPassword: oldPassword.value, 
		newPassword: newPassword.value 
	});
	alert('已修改密码');
}

function onAvatarErr(e: Event): void {
	const t = e?.target as HTMLImageElement | null;
	if (t && t.src !== location.origin + '/images/avatar-default.svg') t.src = '/images/avatar-default.svg';
}
</script>

<style scoped>
/* 全屏背景包装器 */
.profile-page-wrapper {
  background: #ffffff;
  min-height: 100vh;
  width: 100%;
  padding: 40px 0;
  margin: 0;
}

/* 个人资料容器 */
.profile-container {
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
  border-radius: 16px;
  border: 1px solid #fafafa;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
}

.error-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.error-state h3 {
  color: #dc2626;
  font-size: 20px;
  font-weight: 700;
  margin: 0 0 8px;
}

.error-state p {
  color: #6b7280;
  font-size: 16px;
  margin: 0 0 24px;
}

.error-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
}

/* 主要内容区域 */
.profile-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 欢迎卡片 */
.welcome-card {
  background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
  border-radius: 20px;
  padding: 32px;
  color: #fff;
  box-shadow: 0 8px 30px rgba(239, 58, 45, 0.25);
  position: relative;
  overflow: hidden;
}

.welcome-card::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px) rotate(0deg); }
  50% { transform: translateY(-10px) rotate(5deg); }
}

.avatar-section {
  display: flex;
  align-items: center;
  gap: 24px;
  position: relative;
  z-index: 1;
}

.avatar-container {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  border: 4px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  flex-shrink: 0;
}

.avatar-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.welcome-text {
  flex: 1;
}

.welcome-title {
  font-size: 24px;
  font-weight: 800;
  margin: 0 0 8px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.welcome-subtitle {
  font-size: 14px;
  opacity: 0.9;
  margin: 0;
}

/* 卡片通用样式 */
.form-card,
.password-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 28px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #fafafa;
  transition: all 0.3s ease;
}

.form-card:hover,
.password-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.card-header {
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid #f5f5f5;
}

.card-title {
  font-size: 20px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 4px;
}

.card-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

/* 表单样式 */
.form-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label {
  font-size: 14px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.form-input,
.form-select {
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

.form-input:focus,
.form-select:focus {
  outline: none;
  border-color: #ef3a2d;
  box-shadow: 0 0 0 3px rgba(239, 58, 45, 0.1);
}

.form-input::placeholder {
  color: #9ca3af;
}

.form-actions {
  display: flex;
  justify-content: flex-start;
  margin-top: 8px;
}

/* 按钮样式 */
.btn {
  height: 48px;
  padding: 0 24px;
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

.btn-icon {
  font-size: 16px;
}

/* 动画效果 */
.fade-in {
  animation: fadeIn 0.6s ease-out both;
}

.delay-1 {
  animation-delay: 0.1s;
}

.delay-2 {
  animation-delay: 0.2s;
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
  .profile-container {
    max-width: 1000px;
    padding: 0 20px;
  }
}

@media (max-width: 768px) {
  .profile-page-wrapper {
    padding: 20px 0;
  }
  
  .profile-container {
    max-width: 100%;
    padding: 0 16px;
  }
  
  .page-title {
    font-size: 28px;
  }
  
  .welcome-card {
    padding: 24px;
  }
  
  .avatar-section {
    flex-direction: column;
    text-align: center;
    gap: 16px;
  }
  
  .avatar-container {
    width: 100px;
    height: 100px;
  }
  
  .welcome-title {
    font-size: 20px;
  }
  
  .form-card,
  .password-card {
    padding: 20px;
  }
  
  .form-actions {
    justify-content: center;
  }
  
  .btn {
    width: 100%;
  }
}

@media (max-width: 480px) {
  .profile-container {
    padding: 0 12px;
  }
  
  .welcome-card {
    padding: 20px;
  }
  
  .avatar-container {
    width: 80px;
    height: 80px;
  }
  
  .welcome-title {
    font-size: 18px;
  }
  
  .form-card,
  .password-card {
    padding: 16px;
  }
  
  .card-title {
    font-size: 18px;
  }
}

/* 大屏幕优化 */
@media (min-width: 1400px) {
  .profile-container {
    max-width: 1400px;
  }
}
</style> 
