package com.easternfirefighter.modules.user.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.common.UserContext;
import com.easternfirefighter.modules.commerce.dto.RefundApplyRequest;
import com.easternfirefighter.modules.commerce.entity.Refund;
import com.easternfirefighter.modules.commerce.service.RefundService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user/refunds")
public class UserRefundController {
	private final RefundService refundService;

	public UserRefundController(RefundService refundService) {
		this.refundService = refundService;
	}

	@PostMapping("/apply")
	public ApiResponse<Refund> apply(@Valid @RequestBody RefundApplyRequest req) {
		Long uid = UserContext.getUserId();
		return ApiResponse.success(refundService.apply(uid, req));
	}

	@GetMapping
	public ApiResponse<Page<Refund>> page(@RequestParam(defaultValue = "1") int page,
	                                     @RequestParam(defaultValue = "10") int size) {
		Long uid = UserContext.getUserId();
		return ApiResponse.success(refundService.page(uid, page, size));
	}
} 