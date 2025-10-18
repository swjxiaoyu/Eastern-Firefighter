package com.easternfirefighter.modules.commerce.repository.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.easternfirefighter.modules.commerce.entity.CartItem;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface CartItemMapper extends BaseMapper<CartItem> {
	@Insert("INSERT INTO cart_item (user_id, sku_id, quantity, selected, created_at, updated_at, deleted) VALUES (#{userId}, #{skuId}, #{quantity}, 1, NOW(3), NOW(3), 0) ON DUPLICATE KEY UPDATE deleted=0, quantity=VALUES(quantity), selected=1, updated_at=VALUES(updated_at)")
	int upsertAdd(@Param("userId") Long userId, @Param("skuId") Long skuId, @Param("quantity") Integer quantity);
} 