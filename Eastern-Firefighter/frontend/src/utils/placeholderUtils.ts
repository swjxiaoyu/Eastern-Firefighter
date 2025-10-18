/**
 * 占位图工具函数
 * 用于开发阶段的占位图片生成
 */

/**
 * 生成Lorem Picsum占位图URL
 */
export function generatePicsumUrl(
  width: number, 
  height: number, 
  seed?: string, 
  grayscale: boolean = false,
  blur: number = 0
): string {
  let url = `https://picsum.photos/${width}/${height}`;
  
  if (seed) {
    url = `https://picsum.photos/seed/${seed}/${width}/${height}`;
  }
  
  const params = new URLSearchParams();
  if (grayscale) params.append('grayscale', 'true');
  if (blur > 0) params.append('blur', blur.toString());
  
  const queryString = params.toString();
  return queryString ? `${url}?${queryString}` : url;
}

/**
 * 预设的占位图生成器
 */
export const PLACEHOLDER_GENERATORS = {
  // 商品相关
  product: {
    thumb: (seed?: string) => generatePicsumUrl(88, 88, seed || 'product-thumb'),
    card: (seed?: string) => generatePicsumUrl(200, 200, seed || 'product-card'),
    detail: (seed?: string) => generatePicsumUrl(520, 420, seed || 'product-detail'),
    gallery: (seed?: string) => generatePicsumUrl(400, 300, seed || 'product-gallery'),
    hero: (seed?: string) => generatePicsumUrl(800, 400, seed || 'product-hero')
  },
  
  // 头像相关
  avatar: {
    small: (seed?: string) => generatePicsumUrl(32, 32, seed || 'avatar-small'),
    medium: (seed?: string) => generatePicsumUrl(64, 64, seed || 'avatar-medium'),
    large: (seed?: string) => generatePicsumUrl(100, 100, seed || 'avatar-large'),
    profile: (seed?: string) => generatePicsumUrl(150, 150, seed || 'avatar-profile')
  },
  
  // 通用尺寸
  common: {
    thumbnail: (seed?: string) => generatePicsumUrl(150, 150, seed || 'thumb'),
    medium: (seed?: string) => generatePicsumUrl(300, 200, seed || 'medium'),
    large: (seed?: string) => generatePicsumUrl(600, 400, seed || 'large'),
    banner: (seed?: string) => generatePicsumUrl(1200, 300, seed || 'banner')
  }
} as const;

/**
 * 根据类型和尺寸生成占位图URL
 */
export function getPlaceholderByType(
  type: 'product' | 'avatar' | 'common',
  size: string,
  seed?: string
): string {
  const generator = PLACEHOLDER_GENERATORS[type] as any;
  if (generator && generator[size]) {
    return generator[size](seed);
  }
  
  // 默认返回通用中等尺寸
  return PLACEHOLDER_GENERATORS.common.medium(seed);
}

/**
 * 生成随机种子
 */
export function generateRandomSeed(): string {
  return Math.random().toString(36).substring(2, 15);
}

/**
 * 根据内容生成确定性种子
 */
export function generateContentSeed(content: string): string {
  // 简单的哈希函数生成确定性种子
  let hash = 0;
  for (let i = 0; i < content.length; i++) {
    const char = content.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash; // 转换为32位整数
  }
  return Math.abs(hash).toString(36);
}

/**
 * 开发环境占位图配置
 */
export const DEV_PLACEHOLDER_CONFIG = {
  // 是否启用Lorem Picsum
  enabled: true,
  
  // 默认种子
  defaultSeeds: {
    product: 'eastern-firefighter-product',
    avatar: 'eastern-firefighter-avatar',
    banner: 'eastern-firefighter-banner'
  },
  
  // 图片质量设置
  quality: {
    grayscale: false,
    blur: 0
  },
  
  // 缓存设置
  cache: {
    enabled: true,
    ttl: 24 * 60 * 60 * 1000 // 24小时
  }
} as const;

/**
 * 获取开发环境占位图URL
 */
export function getDevPlaceholderUrl(
  type: 'product' | 'avatar' | 'common',
  size: string,
  customSeed?: string
): string {
  if (!DEV_PLACEHOLDER_CONFIG.enabled) {
    // 如果禁用，返回本地占位图
    return `/images/placeholders/${type}-default.svg`;
  }
  
  const seed = customSeed || DEV_PLACEHOLDER_CONFIG.defaultSeeds[type as keyof typeof DEV_PLACEHOLDER_CONFIG.defaultSeeds] || 'default';
  return getPlaceholderByType(type, size, seed);
}

/**
 * 预生成常用占位图URL
 */
export function pregeneratePlaceholders(): Record<string, string> {
  return {
    // 商品占位图
    'product-thumb': PLACEHOLDER_GENERATORS.product.thumb(),
    'product-card': PLACEHOLDER_GENERATORS.product.card(),
    'product-detail': PLACEHOLDER_GENERATORS.product.detail(),
    'product-gallery': PLACEHOLDER_GENERATORS.product.gallery(),
    
    // 头像占位图
    'avatar-small': PLACEHOLDER_GENERATORS.avatar.small(),
    'avatar-medium': PLACEHOLDER_GENERATORS.avatar.medium(),
    'avatar-large': PLACEHOLDER_GENERATORS.avatar.large(),
    
    // 通用占位图
    'banner': PLACEHOLDER_GENERATORS.common.banner(),
    'hero': PLACEHOLDER_GENERATORS.product.hero()
  };
}
