# 图片加载策略指南

## 概述

本项目实现了统一的图片加载策略，包括懒加载、占位图、错误处理和性能优化。

## 核心组件

### LazyImage 组件

统一的图片加载组件，支持懒加载、占位图、错误重试等功能。

#### 基本用法

```vue
<template>
  <!-- 基本用法 -->
  <LazyImage 
    src="/path/to/image.jpg" 
    alt="图片描述" 
  />
  
  <!-- 指定尺寸 -->
  <LazyImage 
    src="/path/to/image.jpg" 
    :width="200" 
    :height="150" 
    alt="图片描述" 
  />
  
  <!-- 商品图片 -->
  <LazyImage 
    src="/path/to/product.jpg" 
    :width="520" 
    :height="420" 
    placeholder="product"
    :fit="'cover'"
    :radius="8"
    alt="商品图片" 
  />
  
  <!-- 头像 -->
  <LazyImage 
    src="/path/to/avatar.jpg" 
    :width="64" 
    :height="64" 
    placeholder="avatar"
    :fit="'cover'"
    :radius="50"
    alt="用户头像" 
  />
</template>
```

#### 属性说明

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `src` | `string` | - | 图片源地址 |
| `alt` | `string` | `''` | 图片描述 |
| `width` | `number \| string` | - | 图片宽度 |
| `height` | `number \| string` | - | 图片高度 |
| `lazy` | `boolean` | `true` | 是否启用懒加载 |
| `placeholder` | `'product' \| 'avatar' \| 'custom'` | `'product'` | 占位符类型 |
| `customPlaceholder` | `string` | - | 自定义占位符URL |
| `showSpinner` | `boolean` | `true` | 是否显示加载动画 |
| `placeholderText` | `string` | - | 占位符文本 |
| `fit` | `'cover' \| 'contain' \| 'fill' \| 'scale-down' \| 'none'` | `'cover'` | 图片适应方式 |
| `radius` | `number \| string` | `0` | 圆角半径 |
| `class` | `string` | - | 自定义CSS类 |

## 工具函数

### useImageLoader 组合式函数

用于管理单个图片的加载状态。

```typescript
import { useImageLoader } from '@/composables/useImageLoader';

const {
  src,
  loading,
  error,
  loaded,
  state,
  loadImage,
  retryLoad,
  setSrc
} = useImageLoader('/path/to/image.jpg', {
  placeholder: 'product',
  lazy: true,
  retryCount: 3
});

// 监听状态变化
watch(state, (newState) => {
  console.log('图片状态:', newState);
});
```

### useBatchImageLoader 组合式函数

用于管理多个图片的批量加载。

```typescript
import { useBatchImageLoader } from '@/composables/useImageLoader';

const {
  loaders,
  allLoaded,
  anyError,
  loadingCount,
  errorCount,
  retryAll,
  preloadAll
} = useBatchImageLoader([
  '/path/to/image1.jpg',
  '/path/to/image2.jpg',
  '/path/to/image3.jpg'
]);

// 检查所有图片是否加载完成
watch(allLoaded, (loaded) => {
  if (loaded) {
    console.log('所有图片加载完成');
  }
});
```

## 图片工具函数

### 基本工具函数

```typescript
import {
  isValidImageUrl,
  getPlaceholderUrl,
  preloadImage,
  preloadImages,
  compressImage
} from '@/utils/imageUtils';

// 检查图片URL是否有效
const isValid = isValidImageUrl('/path/to/image.jpg');

// 获取占位符URL
const placeholderUrl = getPlaceholderUrl('product');

// 预加载单个图片
const img = await preloadImage('/path/to/image.jpg');

// 预加载多个图片
const images = await preloadImages([
  '/path/to/image1.jpg',
  '/path/to/image2.jpg'
]);

// 压缩图片
const compressedBlob = await compressImage(file, {
  maxWidth: 800,
  maxHeight: 600,
  quality: 0.8
});
```

## 配置管理

### 全局配置

```typescript
import { 
  getImageConfig, 
  updateImageConfig, 
  resetImageConfig 
} from '@/config/imageConfig';

// 获取当前配置
const config = getImageConfig();

// 更新配置
updateImageConfig({
  lazy: {
    enabled: true,
    threshold: 0.1,
    rootMargin: '50px'
  },
  retry: {
    maxAttempts: 5,
    delay: 2000
  }
});

// 重置为默认配置
resetImageConfig();
```

### 预设尺寸

```typescript
import { IMAGE_PRESETS } from '@/config/imageConfig';

// 使用预设尺寸
const productSize = IMAGE_PRESETS.product.detail; // { width: 520, height: 420 }
const avatarSize = IMAGE_PRESETS.avatar.medium; // { width: 64, height: 64 }
```

## 最佳实践

### 1. 选择合适的占位符

```vue
<!-- 商品图片使用product占位符 -->
<LazyImage 
  src="/product.jpg" 
  placeholder="product"
  :width="200" 
  :height="200" 
/>

<!-- 头像使用avatar占位符 -->
<LazyImage 
  src="/avatar.jpg" 
  placeholder="avatar"
  :width="64" 
  :height="64" 
/>

<!-- 自定义占位符 -->
<LazyImage 
  src="/custom.jpg" 
  placeholder="custom"
  custom-placeholder="/custom-placeholder.svg"
  :width="300" 
  :height="200" 
/>
```

### 2. 合理设置尺寸

```vue
<!-- 商品列表卡片 -->
<LazyImage 
  src="/product.jpg" 
  :width="200" 
  :height="200" 
  placeholder="product"
  fit="cover"
/>

<!-- 商品详情大图 -->
<LazyImage 
  src="/product.jpg" 
  :width="520" 
  :height="420" 
  placeholder="product"
  fit="cover"
/>

<!-- 头像 -->
<LazyImage 
  src="/avatar.jpg" 
  :width="64" 
  :height="64" 
  placeholder="avatar"
  :radius="50"
  fit="cover"
/>
```

### 3. 性能优化

```vue
<template>
  <!-- 关键图片禁用懒加载 -->
  <LazyImage 
    src="/hero-image.jpg" 
    :lazy="false"
    :width="800" 
    :height="400" 
  />
  
  <!-- 非关键图片启用懒加载 -->
  <LazyImage 
    v-for="img in galleryImages" 
    :key="img.id"
    :src="img.url" 
    :width="150" 
    :height="150" 
    :lazy="true"
  />
</template>
```

### 4. 智能占位图选择

```vue
<template>
  <!-- 根据商品名称智能选择占位图 -->
  <LazyImage 
    src=""
    :width="400" 
    :height="300" 
    placeholder="product"
    product-name="消防战斗服"
    alt="消防装备" 
  />
  
  <!-- 根据商品类型选择占位图 -->
  <LazyImage 
    src=""
    :width="200" 
    :height="150" 
    placeholder="product"
    product-type="emergency"
    alt="应急装备" 
  />
  
  <!-- 自定义占位图 -->
  <LazyImage 
    src=""
    :width="300" 
    :height="200" 
    placeholder="custom"
    custom-placeholder="/images/placeholders/safety-gear.svg"
    alt="安全防护" 
  />
</template>
```

### 5. 智能选择规则

系统会根据以下规则自动选择合适的占位图：

- **消防相关**: 包含"消防"、"灭火"、"防火"等关键词
- **应急相关**: 包含"应急"、"救援"等关键词  
- **安全防护**: 包含"安全"、"防护"、"手套"、"头盔"等关键词
- **医疗急救**: 包含"医疗"、"急救"、"医疗包"等关键词
- **通信设备**: 包含"通信"、"对讲机"等关键词

### 4. 错误处理

```vue
<template>
  <LazyImage 
    src="/image.jpg" 
    @error="handleImageError"
    @load="handleImageLoad"
  />
</template>

<script setup>
function handleImageError() {
  console.log('图片加载失败');
  // 可以显示错误提示或使用备用图片
}

function handleImageLoad() {
  console.log('图片加载成功');
  // 可以执行一些成功后的操作
}
</script>
```

## 占位图资源

### 应急产业主题占位图

项目使用符合应急产业主题的占位图：

- **消防装备占位图**: `/images/placeholders/fire-safety-product.svg`
- **应急装备占位图**: `/images/placeholders/emergency-equipment.svg`
- **安全防护占位图**: `/images/placeholders/safety-gear.svg`
- **头像占位图**: `/images/placeholders/avatar-default.svg`
- **加载动画**: `/images/placeholders/loading-spinner.svg`

### 占位图特点

1. **主题一致**: 所有占位图都符合应急产业主题
2. **视觉统一**: 使用一致的设计风格和配色方案
3. **本地资源**: 不依赖外部服务，加载速度快
4. **可定制**: 支持自定义占位图URL
5. **响应式**: 支持不同尺寸的显示需求

## 响应式支持

组件支持响应式设计，可以根据屏幕尺寸自动调整：

```vue
<template>
  <LazyImage 
    src="/image.jpg" 
    :width="responsiveWidth" 
    :height="responsiveHeight" 
  />
</template>

<script setup>
import { computed } from 'vue';
import { getResponsiveImageSize, IMAGE_PRESETS } from '@/config/imageConfig';

const responsiveWidth = computed(() => {
  // 根据屏幕尺寸返回不同宽度
  if (window.innerWidth < 640) return 150;
  if (window.innerWidth < 1024) return 200;
  return 300;
});
</script>
```

## 注意事项

1. **性能考虑**: 大量图片时建议使用懒加载
2. **错误处理**: 始终提供合适的占位图和错误处理
3. **可访问性**: 为所有图片提供有意义的alt属性
4. **缓存策略**: 合理设置图片缓存策略
5. **格式选择**: 优先使用WebP格式以获得更好的压缩率
