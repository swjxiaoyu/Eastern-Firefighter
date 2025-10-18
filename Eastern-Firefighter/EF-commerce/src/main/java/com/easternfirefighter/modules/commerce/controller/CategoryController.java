package com.easternfirefighter.modules.commerce.controller; // 包：电商-类目

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper; // 条件构造
import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.modules.commerce.entity.Category; // 类目实体
import com.easternfirefighter.modules.commerce.repository.mapper.CategoryMapper; // 类目Mapper
import org.springframework.web.bind.annotation.GetMapping; // GET
import org.springframework.web.bind.annotation.RequestMapping; // 前缀
import org.springframework.web.bind.annotation.RequestParam; // 参数
import org.springframework.web.bind.annotation.RestController; // 控制器

import java.util.List; // 集合

@RestController // 控制器
@RequestMapping("/api/commerce/categories") // 前缀
public class CategoryController { // 类目控制器
	private final CategoryMapper categoryMapper; // Mapper

	public CategoryController(CategoryMapper categoryMapper) { // 构造注入
		this.categoryMapper = categoryMapper; // 赋值
	}

	@GetMapping // 列表
	public ApiResponse<List<Category>> list(@RequestParam(required = false) Long parentId) { // 可筛选父类目
		LambdaQueryWrapper<Category> qw = new LambdaQueryWrapper<>(); // 构造器
		qw.eq(parentId != null, Category::getParentId, parentId).eq(Category::getStatus, 1).eq(Category::getDeleted, 0).orderByAsc(Category::getSort); // 条件
		return ApiResponse.success(categoryMapper.selectList(qw)); // 查询并返回
	}
} // 类结束 