package com.easternfirefighter.common;

/**
 * 每请求线程的用户上下文。
 * <p>
 * 使用 {@link ThreadLocal} 保存当前线程绑定的用户标识、角色、商家ID，
 * 便于在无显式参数传递的场景中获取当前登录用户信息与权限。
 * </p>
 */
public class UserContext {
	private static final ThreadLocal<Long> USER_ID_HOLDER = new ThreadLocal<>();
	private static final ThreadLocal<String> ROLE_HOLDER = new ThreadLocal<>();
	private static final ThreadLocal<Long> MERCHANT_ID_HOLDER = new ThreadLocal<>();

	public static void setUserId(Long userId) {
		USER_ID_HOLDER.set(userId);
	}

	public static Long getUserId() {
		return USER_ID_HOLDER.get();
	}

	public static void setRole(String role) {
		ROLE_HOLDER.set(role);
	}

	public static String getRole() {
		return ROLE_HOLDER.get();
	}

	public static void setMerchantId(Long merchantId) {
		MERCHANT_ID_HOLDER.set(merchantId);
	}

	public static Long getMerchantId() {
		return MERCHANT_ID_HOLDER.get();
	}

	public static void clear() {
		USER_ID_HOLDER.remove();
		ROLE_HOLDER.remove();
		MERCHANT_ID_HOLDER.remove();
	}
} 