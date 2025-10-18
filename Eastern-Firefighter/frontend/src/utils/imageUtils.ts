/**
 * 图片处理工具函数
 */

/**
 * 图片占位符类型
 */
export type PlaceholderType = 'product' | 'avatar' | 'custom';

/**
 * 图片尺寸配置
 */
export interface ImageSize {
  width: number;
  height: number;
}

/**
 * 预定义的图片尺寸
 */
export const IMAGE_SIZES = {
  // 商品相关
  productThumb: { width: 88, height: 88 },
  productCard: { width: 200, height: 200 },
  productDetail: { width: 520, height: 420 },
  productGallery: { width: 400, height: 300 },
  
  // 头像相关
  avatarSmall: { width: 32, height: 32 },
  avatarMedium: { width: 64, height: 64 },
  avatarLarge: { width: 100, height: 100 },
  
  // 通用尺寸
  thumbnail: { width: 150, height: 150 },
  medium: { width: 300, height: 200 },
  large: { width: 600, height: 400 }
} as const;

/**
 * 占位图URL映射
 */
export const PLACEHOLDER_URLS = {
  product: '/images/placeholders/fire-safety-product.svg',
  avatar: '/images/placeholders/avatar-default.svg',
  spinner: '/images/placeholders/loading-spinner.svg'
} as const;

/**
 * 检查图片URL是否有效
 */
export function isValidImageUrl(url: string | null | undefined): boolean {
  if (!url || typeof url !== 'string') return false;
  
  // 检查是否是有效的URL格式
  try {
    new URL(url);
    return true;
  } catch {
    // 检查是否是相对路径
    return url.startsWith('/') || url.startsWith('./') || url.startsWith('../');
  }
}

/**
 * 获取图片占位符URL
 */
export function getPlaceholderUrl(type: PlaceholderType = 'product', customUrl?: string): string {
  if (type === 'custom' && customUrl) {
    return customUrl;
  }
  return PLACEHOLDER_URLS[type as keyof typeof PLACEHOLDER_URLS] || PLACEHOLDER_URLS.product;
}

/**
 * 生成响应式图片URL（如果有图片服务支持）
 */
export function generateResponsiveImageUrl(
  baseUrl: string, 
  _size: ImageSize, 
  _quality: number = 80
): string {
  if (!isValidImageUrl(baseUrl)) {
    return getPlaceholderUrl('product');
  }
  
  // 这里可以集成图片服务，如 Cloudinary、阿里云OSS等
  // 示例：return `${baseUrl}?w=${size.width}&h=${size.height}&q=${quality}`;
  return baseUrl;
}

/**
 * 预加载图片
 */
export function preloadImage(url: string): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve(img);
    img.onerror = reject;
    img.src = url;
  });
}

/**
 * 批量预加载图片
 */
export async function preloadImages(urls: string[]): Promise<HTMLImageElement[]> {
  const promises = urls.map(url => preloadImage(url));
  return Promise.all(promises);
}

/**
 * 获取图片的宽高比
 */
export function getImageAspectRatio(width: number, height: number): number {
  return width / height;
}

/**
 * 根据容器尺寸计算图片显示尺寸
 */
export function calculateImageDisplaySize(
  containerSize: ImageSize,
  imageSize: ImageSize,
  fit: 'cover' | 'contain' | 'fill' = 'cover'
): ImageSize {
  const containerRatio = getImageAspectRatio(containerSize.width, containerSize.height);
  const imageRatio = getImageAspectRatio(imageSize.width, imageSize.height);
  
  switch (fit) {
    case 'contain':
      if (imageRatio > containerRatio) {
        return {
          width: containerSize.width,
          height: containerSize.width / imageRatio
        };
      } else {
        return {
          width: containerSize.height * imageRatio,
          height: containerSize.height
        };
      }
    case 'cover':
      if (imageRatio > containerRatio) {
        return {
          width: containerSize.height * imageRatio,
          height: containerSize.height
        };
      } else {
        return {
          width: containerSize.width,
          height: containerSize.width / imageRatio
        };
      }
    case 'fill':
    default:
      return containerSize;
  }
}

/**
 * 生成图片懒加载的占位符
 */
export function generateLazyPlaceholder(
  type: PlaceholderType = 'product',
  size: ImageSize = IMAGE_SIZES.thumbnail
): string {
  const baseUrl = getPlaceholderUrl(type);
  return `${baseUrl}?w=${size.width}&h=${size.height}`;
}

/**
 * 图片压缩配置
 */
export interface ImageCompressOptions {
  maxWidth?: number;
  maxHeight?: number;
  quality?: number;
  format?: 'jpeg' | 'png' | 'webp';
}

/**
 * 压缩图片（客户端压缩）
 */
export function compressImage(
  file: File,
  options: ImageCompressOptions = {}
): Promise<Blob> {
  const {
    maxWidth = 1920,
    maxHeight = 1080,
    quality = 0.8,
    format = 'jpeg'
  } = options;
  
  return new Promise((resolve, reject) => {
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    const img = new Image();
    
    img.onload = () => {
      // 计算压缩后的尺寸
      let { width, height } = img;
      
      if (width > maxWidth || height > maxHeight) {
        const ratio = Math.min(maxWidth / width, maxHeight / height);
        width *= ratio;
        height *= ratio;
      }
      
      canvas.width = width;
      canvas.height = height;
      
      // 绘制压缩后的图片
      ctx?.drawImage(img, 0, 0, width, height);
      
      canvas.toBlob(
        (blob) => {
          if (blob) {
            resolve(blob);
          } else {
            reject(new Error('图片压缩失败'));
          }
        },
        `image/${format}`,
        quality
      );
    };
    
    img.onerror = () => reject(new Error('图片加载失败'));
    img.src = URL.createObjectURL(file);
  });
}

/**
 * 图片格式检测
 */
export function getImageFormat(url: string): string {
  const extension = url.split('.').pop()?.toLowerCase();
  const formatMap: Record<string, string> = {
    'jpg': 'jpeg',
    'jpeg': 'jpeg',
    'png': 'png',
    'gif': 'gif',
    'webp': 'webp',
    'svg': 'svg'
  };
  return formatMap[extension || ''] || 'unknown';
}

/**
 * 检查浏览器是否支持WebP格式
 */
export function supportsWebP(): Promise<boolean> {
  return new Promise((resolve) => {
    const webP = new Image();
    webP.onload = webP.onerror = () => {
      resolve(webP.height === 2);
    };
    webP.src = 'data:image/webp;base64,UklGRjoAAABXRUJQVlA4IC4AAACyAgCdASoCAAIALmk0mk0iIiIiIgBoSygABc6WWgAA/veff/0PP8bA//LwYAAA';
  });
}
