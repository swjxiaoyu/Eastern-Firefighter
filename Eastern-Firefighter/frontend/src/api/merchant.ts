import http from './http'

export const merchantApi = {
  // 商品
  listProducts(params: { keyword?: string; categoryId?: number; page?: number; size?: number } = {}) {
    return http.get('/merchant/products', { params })
  },
  getProduct(id: number){
    return http.get(`/merchant/products/${id}`)
  },
  createProduct(payload: any){
    return http.post('/merchant/products', payload)
  },
  updateProduct(id: number, payload: any){
    return http.put(`/merchant/products/${id}`, payload)
  },
  onlineProduct(id: number){
    return http.post(`/merchant/products/${id}/online`)
  },
  offlineProduct(id: number){
    return http.post(`/merchant/products/${id}/offline`)
  },

  // 订单
  listOrders(params: { status?: number; page?: number; size?: number } = {}){
    return http.get('/merchant/orders', { params })
  },
  getOrder(orderNo: string){
    return http.get(`/merchant/orders/${orderNo}`)
  },
  shipOrder(orderNo: string, payload: { shippingCompany: string; trackingNo: string }){
    return http.post(`/merchant/orders/${orderNo}/ship`, payload)
  },

  // 售后
  listRefunds(params: { page?: number; size?: number } = {}){
    return http.get('/merchant/refunds', { params })
  },
} 