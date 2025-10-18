<template>
  <div class="image-demo">
    <div class="container">
      <h1>图片加载演示</h1>
      <p>使用应急产业主题的占位图片</p>
      
      <!-- 应急装备图片演示 -->
      <section class="demo-section">
        <h2>应急装备图片演示</h2>
        <div class="demo-grid">
          <div class="demo-item">
            <h3>消防装备缩略图 (88x88)</h3>
            <LazyImage 
              src=""
              :width="88" 
              :height="88" 
              placeholder="product"
              alt="消防装备缩略图" 
            />
          </div>
          
          <div class="demo-item">
            <h3>应急装备卡片 (200x200)</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="200" 
              placeholder="product"
              alt="应急装备卡片" 
            />
          </div>
          
          <div class="demo-item">
            <h3>安全装备详情 (520x420)</h3>
            <LazyImage 
              src=""
              :width="520" 
              :height="420" 
              placeholder="product"
              alt="安全装备详情" 
            />
          </div>
        </div>
      </section>
      
      <!-- 头像演示 -->
      <section class="demo-section">
        <h2>头像演示</h2>
        <div class="demo-grid">
          <div class="demo-item">
            <h3>小头像 (32x32)</h3>
            <LazyImage 
              src="https://picsum.photos/seed/avatar-small/32/32"
              :width="32" 
              :height="32" 
              placeholder="avatar"
              :radius="50"
              alt="小头像" 
            />
          </div>
          
          <div class="demo-item">
            <h3>中等头像 (64x64)</h3>
            <LazyImage 
              src="https://picsum.photos/seed/avatar-medium/64/64"
              :width="64" 
              :height="64" 
              placeholder="avatar"
              :radius="50"
              alt="中等头像" 
            />
          </div>
          
          <div class="demo-item">
            <h3>大头像 (100x100)</h3>
            <LazyImage 
              src="https://picsum.photos/seed/avatar-large/100/100"
              :width="100" 
              :height="100" 
              placeholder="avatar"
              :radius="50"
              alt="大头像" 
            />
          </div>
        </div>
      </section>
      
      <!-- 懒加载演示 -->
      <section class="demo-section">
        <h2>懒加载演示</h2>
        <p>滚动页面查看懒加载效果</p>
        <div class="lazy-demo">
          <div v-for="i in 10" :key="i" class="lazy-item">
            <LazyImage 
              :src="`https://picsum.photos/seed/lazy-${i}/300/200`"
              :width="300" 
              :height="200" 
              placeholder="product"
              :lazy="true"
              :alt="`懒加载图片 ${i}`"
            />
            <p>懒加载图片 {{ i }}</p>
          </div>
        </div>
      </section>
      
      <!-- 错误处理演示 -->
      <section class="demo-section">
        <h2>错误处理演示</h2>
        <div class="demo-grid">
          <div class="demo-item">
            <h3>无效URL</h3>
            <LazyImage 
              src="https://invalid-url.com/image.jpg"
              :width="200" 
              :height="150" 
              placeholder="product"
              alt="错误图片" 
            />
          </div>
          
          <div class="demo-item">
            <h3>空URL</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              alt="空图片" 
            />
          </div>
        </div>
      </section>
      
      <!-- 智能占位图演示 -->
      <section class="demo-section">
        <h2>智能占位图演示</h2>
        <div class="demo-grid">
          <div class="demo-item">
            <h3>消防装备</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="消防战斗服"
              alt="消防装备" 
            />
          </div>
          
          <div class="demo-item">
            <h3>应急装备</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="应急救援包"
              alt="应急装备" 
            />
          </div>
          
          <div class="demo-item">
            <h3>安全防护</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="安全防护手套"
              alt="安全防护" 
            />
          </div>
          
          <div class="demo-item">
            <h3>医疗急救</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="医疗急救包"
              alt="医疗急救" 
            />
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import LazyImage from '@/components/LazyImage.vue';
</script>

<style scoped>
.image-demo {
  padding: 20px 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

h1 {
  text-align: center;
  margin-bottom: 10px;
  color: #333;
}

p {
  text-align: center;
  color: #666;
  margin-bottom: 40px;
}

.demo-section {
  margin-bottom: 60px;
}

.demo-section h2 {
  border-bottom: 2px solid #e2e8f0;
  padding-bottom: 10px;
  margin-bottom: 30px;
  color: #374151;
}

.demo-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 30px;
  margin-bottom: 30px;
}

.demo-item {
  text-align: center;
  padding: 20px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.demo-item h3 {
  margin-bottom: 15px;
  color: #374151;
  font-size: 14px;
  font-weight: 600;
}

.lazy-demo {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.lazy-item {
  text-align: center;
  padding: 20px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.lazy-item p {
  margin-top: 10px;
  color: #666;
  font-size: 14px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .demo-grid {
    grid-template-columns: 1fr;
  }
  
  .lazy-demo {
    grid-template-columns: 1fr;
  }
}
</style>
