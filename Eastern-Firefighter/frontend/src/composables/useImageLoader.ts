import { ref, computed, watch } from 'vue';
import { isValidImageUrl, getPlaceholderUrl, type PlaceholderType } from '@/utils/imageUtils';

/**
 * 图片加载状态
 */
export interface ImageLoadState {
  loading: boolean;
  error: boolean;
  loaded: boolean;
}

/**
 * 图片加载器配置
 */
export interface ImageLoaderConfig {
  placeholder?: PlaceholderType;
  customPlaceholder?: string;
  lazy?: boolean;
  retryCount?: number;
  retryDelay?: number;
}

/**
 * 图片加载器组合式函数
 */
export function useImageLoader(
  initialSrc: string | null = null,
  config: ImageLoaderConfig = {}
) {
  const {
    placeholder = 'product',
    customPlaceholder,
    lazy = true,
    retryCount = 3,
    retryDelay = 1000
  } = config;

  const src = ref(initialSrc);
  const loading = ref(true);
  const error = ref(false);
  const retryAttempts = ref(0);

  // 计算属性
  const loaded = computed(() => !loading.value && !error.value);
  const placeholderUrl = computed(() => 
    getPlaceholderUrl(placeholder, customPlaceholder)
  );
  const shouldLoad = computed(() => 
    isValidImageUrl(src.value) && (lazy ? true : true)
  );

  // 状态对象
  const state = computed<ImageLoadState>(() => ({
    loading: loading.value,
    error: error.value,
    loaded: loaded.value
  }));

  /**
   * 加载图片
   */
  function loadImage(url: string): Promise<void> {
    return new Promise((resolve, reject) => {
      const img = new Image();
      
      img.onload = () => {
        loading.value = false;
        error.value = false;
        retryAttempts.value = 0;
        resolve();
      };
      
      img.onerror = () => {
        loading.value = false;
        error.value = true;
        reject(new Error(`图片加载失败: ${url}`));
      };
      
      img.src = url;
    });
  }

  /**
   * 重试加载
   */
  async function retryLoad(): Promise<void> {
    if (retryAttempts.value >= retryCount) {
      error.value = true;
      return;
    }

    retryAttempts.value++;
    loading.value = true;
    error.value = false;

    try {
      await new Promise(resolve => setTimeout(resolve, retryDelay));
      if (src.value) {
        await loadImage(src.value);
      }
    } catch (err) {
      console.warn(`图片加载重试失败 (${retryAttempts.value}/${retryCount}):`, err);
      if (retryAttempts.value >= retryCount) {
        error.value = true;
      }
    }
  }

  /**
   * 重置状态
   */
  function reset(): void {
    loading.value = true;
    error.value = false;
    retryAttempts.value = 0;
  }

  /**
   * 设置新的图片源
   */
  async function setSrc(newSrc: string | null): Promise<void> {
    src.value = newSrc;
    reset();
    
    if (newSrc && isValidImageUrl(newSrc)) {
      try {
        await loadImage(newSrc);
      } catch (err) {
        console.error('图片加载失败:', err);
        error.value = true;
      }
    } else {
      loading.value = false;
      error.value = true;
    }
  }

  // 监听src变化
  watch(src, (newSrc) => {
    if (newSrc && isValidImageUrl(newSrc)) {
      reset();
      loadImage(newSrc).catch(() => {
        error.value = true;
      });
    }
  });

  return {
    // 状态
    src,
    loading,
    error,
    loaded,
    state,
    retryAttempts,
    
    // 计算属性
    placeholderUrl,
    shouldLoad,
    
    // 方法
    loadImage,
    retryLoad,
    reset,
    setSrc
  };
}