package com.easternfirefighter.modules.commerce.controller; // 包：电商-购物车

import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.common.UserContext; // 用户上下文
import com.easternfirefighter.modules.commerce.dto.CartAddRequest; // 加车请求
import com.easternfirefighter.modules.commerce.dto.CartUpdateRequest; // 更新数量请求
import com.easternfirefighter.modules.commerce.service.CartService; // 购物车服务
import com.easternfirefighter.modules.commerce.vo.CartItemVO; // 购物车项VO
import jakarta.validation.Valid; // 校验
import org.slf4j.Logger; // 日志
import org.slf4j.LoggerFactory; // 日志工厂
import org.springframework.web.bind.annotation.*; // Web 注解

import java.util.List; // 集合

@RestController // 控制器
@RequestMapping("/api/commerce/cart") // 前缀
public class CartController { // 购物车控制器
	private static final Logger log = LoggerFactory.getLogger(CartController.class); // 日志实例
	private final CartService cartService; // 服务

	public CartController(CartService cartService) { // 构造注入
		this.cartService = cartService; // 赋值
	}

	@GetMapping // 列表
	public ApiResponse<List<CartItemVO>> list() { // 无参
		Long uid = UserContext.getUserId(); // 用户
		log.info("[CART_CONTROLLER] list userId={}", uid); // 调试
		List<CartItemVO> result = cartService.list(uid); // 查询
		log.info("[CART_CONTROLLER] list result: {} items", result.size()); // 数量
		if (!result.isEmpty()) { // 有数据
			log.info("[CART_CONTROLLER] first item: id={} productName={} quantity={}", 
				result.get(0).getId(), result.get(0).getProductName(), result.get(0).getQuantity()); // 首条
		}
		return ApiResponse.success(result); // 返回
	}

	@PostMapping("/add") // 加入购物车
	public ApiResponse<Boolean> add(@Valid @RequestBody CartAddRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		cartService.add(uid, req); // 执行
		return ApiResponse.success(true); // OK
	}

	@PostMapping("/update") // 更新数量
	public ApiResponse<Integer> update(@Valid @RequestBody CartUpdateRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		log.info("[CART_CONTROLLER] update userId={} req={}", uid, req); // 调试
		int affected = cartService.updateQty(uid, req); // 受影响行数
		log.info("[CART_CONTROLLER] update result: affected={}", affected); // 打印
		return ApiResponse.success(affected); // 返回
	}

	@PostMapping("/{id}/delete") // 删除购物车项
	public ApiResponse<Boolean> delete(@PathVariable Long id) { // 路径参数
		Long uid = UserContext.getUserId(); // 用户
		cartService.remove(uid, id); // 删除
		return ApiResponse.success(true); // OK
	}
} // 类结束 