/**
 * 占位图选择器
 * 根据商品类型自动选择合适的占位图
 */

/**
 * 商品类型枚举
 */
export enum ProductType {
  FIRE_SAFETY = 'fire_safety',      // 消防安全
  EMERGENCY = 'emergency',          // 应急装备
  SAFETY_GEAR = 'safety_gear',     // 安全防护
  MEDICAL = 'medical',             // 医疗急救
  COMMUNICATION = 'communication',  // 通信设备
  GENERAL = 'general'              // 通用商品
}

/**
 * 占位图映射配置
 */
export const PLACEHOLDER_MAPPING: Record<ProductType, string> = {
  [ProductType.FIRE_SAFETY]: '/images/placeholders/fire-safety-product.svg',
  [ProductType.EMERGENCY]: '/images/placeholders/emergency-equipment.svg',
  [ProductType.SAFETY_GEAR]: '/images/placeholders/safety-gear.svg',
  [ProductType.MEDICAL]: '/images/placeholders/emergency-equipment.svg',
  [ProductType.COMMUNICATION]: '/images/placeholders/emergency-equipment.svg',
  [ProductType.GENERAL]: '/images/placeholders/fire-safety-product.svg'
};

/**
 * 根据商品类型获取占位图URL
 */
export function getPlaceholderByProductType(type: ProductType): string {
  return PLACEHOLDER_MAPPING[type] || PLACEHOLDER_MAPPING[ProductType.GENERAL];
}

/**
 * 根据商品名称智能选择占位图
 */
export function getSmartPlaceholder(productName: string): string {
  const name = productName.toLowerCase();
  
  // 消防安全相关
  if (name.includes('消防') || name.includes('灭火') || name.includes('防火') || 
      name.includes('fire') || name.includes('extinguisher')) {
    return PLACEHOLDER_MAPPING[ProductType.FIRE_SAFETY];
  }
  
  // 应急装备相关
  if (name.includes('应急') || name.includes('救援') || name.includes('emergency') || 
      name.includes('rescue')) {
    return PLACEHOLDER_MAPPING[ProductType.EMERGENCY];
  }
  
  // 安全防护相关
  if (name.includes('安全') || name.includes('防护') || name.includes('手套') || 
      name.includes('头盔') || name.includes('safety') || name.includes('helmet') || 
      name.includes('glove')) {
    return PLACEHOLDER_MAPPING[ProductType.SAFETY_GEAR];
  }
  
  // 医疗急救相关
  if (name.includes('医疗') || name.includes('急救') || name.includes('医疗包') || 
      name.includes('medical') || name.includes('first aid')) {
    return PLACEHOLDER_MAPPING[ProductType.MEDICAL];
  }
  
  // 通信设备相关
  if (name.includes('通信') || name.includes('对讲机') || name.includes('radio') || 
      name.includes('communication')) {
    return PLACEHOLDER_MAPPING[ProductType.COMMUNICATION];
  }
  
  // 默认使用通用占位图
  return PLACEHOLDER_MAPPING[ProductType.GENERAL];
}

/**
 * 根据商品分类获取占位图
 */
export function getPlaceholderByCategory(category: string): string {
  const cat = category.toLowerCase();
  
  if (cat.includes('消防') || cat.includes('fire')) {
    return PLACEHOLDER_MAPPING[ProductType.FIRE_SAFETY];
  }
  
  if (cat.includes('应急') || cat.includes('emergency')) {
    return PLACEHOLDER_MAPPING[ProductType.EMERGENCY];
  }
  
  if (cat.includes('安全') || cat.includes('防护') || cat.includes('safety')) {
    return PLACEHOLDER_MAPPING[ProductType.SAFETY_GEAR];
  }
  
  if (cat.includes('医疗') || cat.includes('medical')) {
    return PLACEHOLDER_MAPPING[ProductType.MEDICAL];
  }
  
  if (cat.includes('通信') || cat.includes('communication')) {
    return PLACEHOLDER_MAPPING[ProductType.COMMUNICATION];
  }
  
  return PLACEHOLDER_MAPPING[ProductType.GENERAL];
}

/**
 * 获取所有可用的占位图类型
 */
export function getAvailablePlaceholders(): Array<{type: ProductType, url: string, name: string}> {
  return [
    { type: ProductType.FIRE_SAFETY, url: PLACEHOLDER_MAPPING[ProductType.FIRE_SAFETY], name: '消防装备' },
    { type: ProductType.EMERGENCY, url: PLACEHOLDER_MAPPING[ProductType.EMERGENCY], name: '应急装备' },
    { type: ProductType.SAFETY_GEAR, url: PLACEHOLDER_MAPPING[ProductType.SAFETY_GEAR], name: '安全防护' },
    { type: ProductType.MEDICAL, url: PLACEHOLDER_MAPPING[ProductType.MEDICAL], name: '医疗急救' },
    { type: ProductType.COMMUNICATION, url: PLACEHOLDER_MAPPING[ProductType.COMMUNICATION], name: '通信设备' },
    { type: ProductType.GENERAL, url: PLACEHOLDER_MAPPING[ProductType.GENERAL], name: '通用商品' }
  ];
}
