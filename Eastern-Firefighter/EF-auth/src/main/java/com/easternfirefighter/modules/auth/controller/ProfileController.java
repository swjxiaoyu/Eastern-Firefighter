package com.easternfirefighter.modules.auth.controller; // 包：认证-个人中心

import com.baomidou.mybatisplus.extension.plugins.pagination.Page; // 分页
import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.common.UserContext; // 用户上下文
import com.easternfirefighter.modules.auth.dto.AddressSaveRequest; // 地址保存请求
import com.easternfirefighter.modules.auth.dto.ProfileUpdateRequest; // 资料更新请求
import com.easternfirefighter.modules.auth.dto.SetPasswordRequest; // 设置密码请求
import com.easternfirefighter.modules.auth.dto.ChangePasswordRequest; // 修改密码请求
import com.easternfirefighter.modules.auth.entity.UserAccount; // 用户账户
import com.easternfirefighter.modules.auth.entity.UserAddress; // 用户地址
import com.easternfirefighter.modules.auth.service.AddressService; // 地址服务
import com.easternfirefighter.modules.auth.service.ProfileService; // 资料服务
import com.easternfirefighter.modules.auth.vo.UserAddressVO; // 地址VO
import jakarta.validation.Valid; // 校验
import org.springframework.web.bind.annotation.*; // Web 注解

@RestController // 控制器
@RequestMapping("/api/auth/profile") // 前缀
public class ProfileController { // 个人中心控制器
	private final ProfileService profileService; // 资料服务
	private final AddressService addressService; // 地址服务

	public ProfileController(ProfileService profileService, AddressService addressService) { // 构造注入
		this.profileService = profileService; // 赋值
		this.addressService = addressService; // 赋值
	}

	@GetMapping("/me") // 获取个人信息
	public ApiResponse<UserAccount> me() { // 无参
		Long uid = UserContext.getUserId(); // 当前用户
		return ApiResponse.success(profileService.me(uid)); // 返回
	}

	@PostMapping("/update") // 更新资料
	public ApiResponse<Boolean> update(@Valid @RequestBody ProfileUpdateRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		profileService.update(uid, req); // 更新
		return ApiResponse.success(true); // OK
	}

	@PostMapping("/password/set") // 设置密码
	public ApiResponse<Boolean> setPassword(@Valid @RequestBody SetPasswordRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		profileService.setPassword(uid, req.getNewPassword()); // 设置
		return ApiResponse.success(true); // OK
	}

	@PostMapping("/password/change") // 修改密码
	public ApiResponse<Boolean> changePassword(@Valid @RequestBody ChangePasswordRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		profileService.changePassword(uid, req.getOldPassword(), req.getNewPassword()); // 修改
		return ApiResponse.success(true); // OK
	}

	@GetMapping("/addresses") // 地址分页
	public ApiResponse<Page<UserAddressVO>> addresses(@RequestParam(defaultValue = "1") int page,
														@RequestParam(defaultValue = "10") int size) { // 分页参数
		Long uid = UserContext.getUserId(); // 用户
		Page<UserAddress> po = addressService.page(uid, page, size); // 原始分页
		Page<UserAddressVO> vo = new Page<>(po.getCurrent(), po.getSize(), po.getTotal()); // VO 分页
		vo.setRecords(po.getRecords().stream().map(a -> { // 转换记录
			UserAddressVO v = new UserAddressVO(); // VO
			v.setId(String.valueOf(a.getId())); // ID-string 防精度丢失
			v.setContactName(a.getContactName()); // 姓名
			v.setContactPhone(a.getContactPhone()); // 手机
			v.setAddressLine(a.getAddressLine()); // 详细地址
			v.setIsDefault(a.getIsDefault()); // 默认
			v.setCountry(a.getCountry()); // 国家
			v.setProvince(a.getProvince()); // 省份
			v.setCity(a.getCity()); // 城市
			v.setDistrict(a.getDistrict()); // 区县
			v.setPostalCode(a.getPostalCode()); // 邮编
			return v; // 返回单条
		}).toList()); // 收集
		return ApiResponse.success(vo); // OK
	}

	@PostMapping("/addresses/save") // 保存/更新地址
	public ApiResponse<Boolean> saveAddress(@Valid @RequestBody AddressSaveRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		addressService.saveOrUpdate(uid, req); // 保存
		return ApiResponse.success(true); // OK
	}

	@PostMapping("/addresses/{id}/delete") // 删除地址
	public ApiResponse<Boolean> deleteAddress(@PathVariable Long id) { // 路径参数
		Long uid = UserContext.getUserId(); // 用户
		addressService.remove(uid, id); // 删除
		return ApiResponse.success(true); // OK
	}

	@PostMapping("/addresses/{id}/default") // 设为默认
	public ApiResponse<Boolean> setDefault(@PathVariable Long id) { // 路径参数
		Long uid = UserContext.getUserId(); // 用户
		addressService.setDefault(uid, id); // 设置
		return ApiResponse.success(true); // OK
	}
} // 类结束 