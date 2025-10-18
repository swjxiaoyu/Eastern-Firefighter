/**
 * 图片加载全局配置
 */

import type { ImageSize, PlaceholderType } from '@/utils/imageUtils';

/**
 * 图片加载配置
 */
export interface ImageConfig {
  // 默认占位符类型
  defaultPlaceholder: PlaceholderType;
  
  // 懒加载配置
  lazy: {
    enabled: boolean;
    threshold: number;
    rootMargin: string;
  };
  
  // 重试配置
  retry: {
    maxAttempts: number;
    delay: number;
  };
  
  // 预加载配置
  preload: {
    enabled: boolean;
    maxConcurrent: number;
  };
  
  // 压缩配置
  compression: {
    enabled: boolean;
    maxWidth: number;
    maxHeight: number;
    quality: number;
  };
  
  // 缓存配置
  cache: {
    enabled: boolean;
    maxSize: number;
    ttl: number;
  };
}

/**
 * 默认配置
 */
export const defaultImageConfig: ImageConfig = {
  defaultPlaceholder: 'product',
  
  lazy: {
    enabled: true,
    threshold: 0.1,
    rootMargin: '50px'
  },
  
  retry: {
    maxAttempts: 3,
    delay: 1000
  },
  
  preload: {
    enabled: true,
    maxConcurrent: 5
  },
  
  compression: {
    enabled: false,
    maxWidth: 1920,
    maxHeight: 1080,
    quality: 0.8
  },
  
  cache: {
    enabled: true,
    maxSize: 50, // MB
    ttl: 24 * 60 * 60 * 1000 // 24小时
  }
};

/**
 * 图片尺寸预设
 */
export const IMAGE_PRESETS = {
  // 商品相关
  product: {
    thumb: { width: 88, height: 88 },
    card: { width: 200, height: 200 },
    detail: { width: 520, height: 420 },
    gallery: { width: 400, height: 300 }
  },
  
  // 头像相关
  avatar: {
    small: { width: 32, height: 32 },
    medium: { width: 64, height: 64 },
    large: { width: 100, height: 100 }
  },
  
  // 通用尺寸
  common: {
    thumbnail: { width: 150, height: 150 },
    medium: { width: 300, height: 200 },
    large: { width: 600, height: 400 }
  }
} as const;

/**
 * 占位符配置
 */
export const PLACEHOLDER_CONFIG = {
  product: {
    url: '/images/placeholders/fire-safety-product.svg',
    text: '消防装备',
    icon: '🔥'
  },
  avatar: {
    url: '/images/placeholders/avatar-default.svg',
    text: '头像',
    icon: '👤'
  },
  custom: {
    url: '/images/placeholders/fire-safety-product.svg',
    text: '应急装备',
    icon: '🛡️'
  }
} as const;

/**
 * 图片格式支持检测
 */
export const SUPPORTED_FORMATS = [
  'jpeg',
  'jpg', 
  'png',
  'gif',
  'webp',
  'svg'
] as const;

/**
 * 响应式断点配置
 */
export const RESPONSIVE_BREAKPOINTS = {
  xs: 0,
  sm: 640,
  md: 768,
  lg: 1024,
  xl: 1280,
  '2xl': 1536
} as const;

/**
 * 获取响应式图片尺寸
 */
export function getResponsiveImageSize(
  baseSize: ImageSize,
  breakpoint: keyof typeof RESPONSIVE_BREAKPOINTS
): ImageSize {
  const multipliers = {
    xs: 0.5,
    sm: 0.75,
    md: 1,
    lg: 1.25,
    xl: 1.5,
    '2xl': 2
  };
  
  const multiplier = multipliers[breakpoint] || 1;
  
  return {
    width: Math.round(baseSize.width * multiplier),
    height: Math.round(baseSize.height * multiplier)
  };
}

/**
 * 图片质量配置
 */
export const QUALITY_PRESETS = {
  low: 0.6,
  medium: 0.8,
  high: 0.9,
  original: 1.0
} as const;

/**
 * 获取当前配置
 */
let currentConfig: ImageConfig = { ...defaultImageConfig };

export function getImageConfig(): ImageConfig {
  return currentConfig;
}

/**
 * 更新配置
 */
export function updateImageConfig(newConfig: Partial<ImageConfig>): void {
  currentConfig = { ...currentConfig, ...newConfig };
}

/**
 * 重置为默认配置
 */
export function resetImageConfig(): void {
  currentConfig = { ...defaultImageConfig };
}
