<template>
  <div class="placeholder-test">
    <div class="container">
      <h1>占位图测试</h1>
      <p>测试智能占位图选择功能</p>
      
      <!-- 消防相关商品测试 -->
      <section class="test-section">
        <h2>消防相关商品测试</h2>
        <div class="test-grid">
          <div class="test-item">
            <h3>防火手套</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="防火手套"
              alt="防火手套" 
            />
            <p>预期：消防装备占位图</p>
          </div>
          
          <div class="test-item">
            <h3>消防战斗服</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="消防战斗服"
              alt="消防战斗服" 
            />
            <p>预期：消防装备占位图</p>
          </div>
          
          <div class="test-item">
            <h3>灭火器</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="灭火器"
              alt="灭火器" 
            />
            <p>预期：消防装备占位图</p>
          </div>
        </div>
      </section>
      
      <!-- 安全防护商品测试 -->
      <section class="test-section">
        <h2>安全防护商品测试</h2>
        <div class="test-grid">
          <div class="test-item">
            <h3>安全头盔</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="安全头盔"
              alt="安全头盔" 
            />
            <p>预期：安全防护占位图</p>
          </div>
          
          <div class="test-item">
            <h3>防护手套</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="防护手套"
              alt="防护手套" 
            />
            <p>预期：安全防护占位图</p>
          </div>
        </div>
      </section>
      
      <!-- 应急装备商品测试 -->
      <section class="test-section">
        <h2>应急装备商品测试</h2>
        <div class="test-grid">
          <div class="test-item">
            <h3>应急救援包</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="应急救援包"
              alt="应急救援包" 
            />
            <p>预期：应急装备占位图</p>
          </div>
          
          <div class="test-item">
            <h3>救援设备</h3>
            <LazyImage 
              src=""
              :width="200" 
              :height="150" 
              placeholder="product"
              product-name="救援设备"
              alt="救援设备" 
            />
            <p>预期：应急装备占位图</p>
          </div>
        </div>
      </section>
      
      <!-- 调试信息 -->
      <section class="debug-section">
        <h2>调试信息</h2>
        <div class="debug-info">
          <p><strong>当前商品名称:</strong> {{ currentProductName }}</p>
          <p><strong>选择的占位图:</strong> {{ selectedPlaceholder }}</p>
          <p><strong>占位图URL:</strong> {{ placeholderUrl }}</p>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import LazyImage from '@/components/LazyImage.vue';
import { getSmartPlaceholder } from '@/utils/placeholderSelector';

const currentProductName = ref('防火手套');
const selectedPlaceholder = computed(() => getSmartPlaceholder(currentProductName.value));
const placeholderUrl = computed(() => {
  const placeholder = getSmartPlaceholder(currentProductName.value);
  return placeholder;
});
</script>

<style scoped>
.placeholder-test {
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

.test-section {
  margin-bottom: 60px;
}

.test-section h2 {
  border-bottom: 2px solid #e2e8f0;
  padding-bottom: 10px;
  margin-bottom: 30px;
  color: #374151;
}

.test-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 30px;
  margin-bottom: 30px;
}

.test-item {
  text-align: center;
  padding: 20px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.test-item h3 {
  margin-bottom: 15px;
  color: #374151;
  font-size: 16px;
  font-weight: 600;
}

.test-item p {
  margin-top: 10px;
  color: #666;
  font-size: 12px;
  font-style: italic;
}

.debug-section {
  margin-top: 40px;
  padding: 20px;
  background: #f8fafc;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
}

.debug-info p {
  margin: 10px 0;
  text-align: left;
  color: #374151;
}

.debug-info strong {
  color: #1f2937;
}
</style>
