package com.easternfirefighter.modules.user.controller;

import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.common.UserContext;
import com.easternfirefighter.modules.commerce.dto.CartAddRequest;
import com.easternfirefighter.modules.commerce.dto.CartUpdateRequest;
import com.easternfirefighter.modules.commerce.service.CartService;
import com.easternfirefighter.modules.commerce.vo.CartItemVO;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user/cart")
public class UserCartController {
	private final CartService cartService;

	public UserCartController(CartService cartService) {
		this.cartService = cartService;
	}

	@GetMapping
	public ApiResponse<List<CartItemVO>> list() {
		Long uid = UserContext.getUserId();
		return ApiResponse.success(cartService.list(uid));
	}

	@PostMapping("/add")
	public ApiResponse<Boolean> add(@Valid @RequestBody CartAddRequest req) {
		Long uid = UserContext.getUserId();
		cartService.add(uid, req);
		return ApiResponse.success(true);
	}

	@PostMapping("/update")
	public ApiResponse<Integer> update(@Valid @RequestBody CartUpdateRequest req) {
		Long uid = UserContext.getUserId();
		int affected = cartService.updateQty(uid, req);
		return ApiResponse.success(affected);
	}

	@PostMapping("/{id}/delete")
	public ApiResponse<Boolean> delete(@PathVariable Long id) {
		Long uid = UserContext.getUserId();
		System.out.println("[USER_CART] 删除购物车项: userId=" + uid + ", itemId=" + id);
		cartService.remove(uid, id);
		System.out.println("[USER_CART] 删除完成");
		return ApiResponse.success(true);
	}

	@PostMapping("/batch-delete")
	public ApiResponse<Boolean> batchDelete(@RequestBody List<String> ids) {
		Long uid = UserContext.getUserId();
		System.out.println("[USER_CART] 批量删除购物车项: userId=" + uid + ", ids=" + ids);
		
		// 将字符串ID转换为Long类型
		List<Long> longIds = ids.stream()
			.map(String::trim)
			.filter(id -> !id.isEmpty())
			.map(Long::valueOf)
			.collect(java.util.stream.Collectors.toList());
		
		System.out.println("[USER_CART] 转换后的Long ID: " + longIds);
		cartService.removeBatch(uid, longIds);
		System.out.println("[USER_CART] 批量删除完成");
		return ApiResponse.success(true);
	}

	@PostMapping("/clear")
	public ApiResponse<Boolean> clear() {
		Long uid = UserContext.getUserId();
		System.out.println("[USER_CART] 清空购物车: userId=" + uid);
		cartService.clear(uid);
		System.out.println("[USER_CART] 清空购物车完成");
		return ApiResponse.success(true);
	}
} 