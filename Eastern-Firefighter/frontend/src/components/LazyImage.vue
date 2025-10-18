<template>
  <div class="lazy-image-container" :style="containerStyle">
    <!-- 直接显示占位图进行测试 -->
    <div class="placeholder-display" :class="placeholderClass">
      <img 
        :src="placeholderUrl" 
        :alt="placeholderText" 
        class="placeholder-image"
        @load="onPlaceholderLoad"
        @error="onPlaceholderError"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
import { getSmartPlaceholder, getPlaceholderByCategory } from '@/utils/placeholderSelector';

interface Props {
  src?: string;
  alt?: string;
  width?: number | string;
  height?: number | string;
  lazy?: boolean;
  placeholder?: 'product' | 'avatar' | 'custom';
  customPlaceholder?: string;
  showSpinner?: boolean;
  placeholderText?: string;
  fit?: 'cover' | 'contain' | 'fill' | 'scale-down' | 'none';
  radius?: number | string;
  class?: string;
  productType?: string;  // 商品类型，用于智能选择占位图
  productName?: string;  // 商品名称，用于智能选择占位图
}

const props = withDefaults(defineProps<Props>(), {
  alt: '',
  lazy: true,
  placeholder: 'product',
  showSpinner: true,
  placeholderText: '',
  fit: 'cover',
  radius: 0,
  class: ''
});

const loading = ref(false);
const error = ref(false);
const inView = ref(false);

// 占位图URL映射
const getPlaceholderUrl = (type: string, custom?: string) => {
  console.log('getPlaceholderUrl called:', { type, custom, productName: props.productName, productType: props.productType });
  
  // 如果有自定义占位图，直接使用
  if (custom) {
    console.log('Using custom placeholder:', custom);
    return custom;
  }
  
  // 如果是商品类型，尝试智能选择占位图
  if (type === 'product' && (props.productName || props.productType)) {
    if (props.productName) {
      const smartUrl = getSmartPlaceholder(props.productName);
      console.log('Using smart placeholder for product:', props.productName, '->', smartUrl);
      return smartUrl;
    }
    if (props.productType) {
      const categoryUrl = getPlaceholderByCategory(props.productType);
      console.log('Using category placeholder for type:', props.productType, '->', categoryUrl);
      return categoryUrl;
    }
  }
  
  const urls = {
    product: '/images/placeholders/fire-safety-product.svg',
    avatar: '/images/placeholders/avatar-default.svg',
    custom: custom || '/images/placeholders/fire-safety-product.svg'
  };
  const defaultUrl = urls[type as keyof typeof urls] || urls.product;
  console.log('Using default placeholder:', defaultUrl);
  
  return defaultUrl;
};

// 占位图URL
const placeholderUrl = computed(() => {
  // 直接使用消防占位图进行测试
  const url = '/images/placeholders/fire-safety-product.svg';
  console.log('Computed placeholder URL:', url);
  return url;
});

// 初始化时设置加载状态
loading.value = false;

// 容器样式
const containerStyle = computed(() => {
  const style: Record<string, string> = {};
  if (props.width) style.width = typeof props.width === 'number' ? `${props.width}px` : props.width;
  if (props.height) style.height = typeof props.height === 'number' ? `${props.height}px` : props.height;
  if (props.radius) style.borderRadius = typeof props.radius === 'number' ? `${props.radius}px` : props.radius;
  return style;
});

// 图片样式
const imageStyle = computed(() => {
  return {
    objectFit: props.fit,
    borderRadius: typeof props.radius === 'number' ? `${props.radius}px` : props.radius
  };
});

// 占位图类名
const placeholderClass = computed(() => {
  const classes = ['lazy-image-placeholder'];
  if (props.class) classes.push(props.class);
  return classes.join(' ');
});

// 图片类名
const imageClass = computed(() => {
  const classes = ['lazy-image'];
  if (props.class) classes.push(props.class);
  return classes.join(' ');
});

// 占位图文本
const placeholderText = computed(() => {
  if (props.placeholderText) return props.placeholderText;
  switch (props.placeholder) {
    case 'avatar': return '头像';
    case 'product': return '商品图片';
    default: return '图片';
  }
});

// 图片加载成功
function onLoad() {
  loading.value = false;
  error.value = false;
}

// 图片加载失败
function onError() {
  loading.value = false;
  error.value = true;
}

// 占位图加载完成
function onPlaceholderLoad() {
  console.log('Placeholder image loaded successfully');
}

// 占位图加载失败
function onPlaceholderError() {
  console.error('Placeholder image failed to load');
}

// 懒加载逻辑
let observer: IntersectionObserver | null = null;

onMounted(() => {
  if (!props.lazy) {
    inView.value = true;
    return;
  }

  const element = document.querySelector('.lazy-image-container');
  if (!element) return;

  observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          inView.value = true;
          observer?.disconnect();
        }
      });
    },
    { threshold: 0.1 }
  );

  observer.observe(element);
});

onUnmounted(() => {
  if (observer) {
    observer.disconnect();
  }
});

// 监听src变化，重置状态
watch(() => props.src, () => {
  if (props.src) {
    loading.value = true;
    error.value = false;
  }
});
</script>

<style scoped>
.lazy-image-container {
  position: relative;
  display: block;
  overflow: hidden;
  width: 100%;
  height: 100%;
  max-width: 100%;
  max-height: 100%;
  box-sizing: border-box;
}

.lazy-image {
  width: 100%;
  height: 100%;
  display: block;
  transition: opacity 0.3s ease;
}

.lazy-image-placeholder,
.placeholder-display {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  border: 1px solid #e2e8f0;
}

.placeholder-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  max-width: 100%;
  max-height: 100%;
  position: absolute;
  top: 0;
  left: 0;
}

.loading-placeholder {
  background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
}

.error-placeholder {
  background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
  border-color: #fecaca;
}

.placeholder-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: #64748b;
}

.placeholder-icon {
  font-size: 24px;
  margin-bottom: 8px;
  opacity: 0.6;
}

.placeholder-text {
  font-size: 12px;
  font-weight: 500;
  opacity: 0.8;
}

.spinner {
  width: 24px;
  height: 24px;
  animation: spin 1s linear infinite;
}

.placeholder-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: inherit;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* 响应式设计 */
@media (max-width: 640px) {
  .placeholder-icon {
    font-size: 20px;
  }
  
  .placeholder-text {
    font-size: 10px;
  }
}
</style>
