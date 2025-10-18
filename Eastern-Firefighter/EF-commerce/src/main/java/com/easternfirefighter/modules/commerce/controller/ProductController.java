package com.easternfirefighter.modules.commerce.controller; // 包：电商-商品

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper; // 条件构造
import com.baomidou.mybatisplus.extension.plugins.pagination.Page; // 分页
import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.modules.commerce.entity.Product; // 商品实体
import com.easternfirefighter.modules.commerce.entity.ProductSku; // SKU 实体
import com.easternfirefighter.modules.commerce.repository.mapper.ProductMapper; // 商品Mapper
import com.easternfirefighter.modules.commerce.repository.mapper.ProductSkuMapper; // SKU Mapper
import com.easternfirefighter.modules.commerce.service.ProductQueryService; // 商品查询服务
import org.springframework.web.bind.annotation.GetMapping; // GET
import org.springframework.web.bind.annotation.PathVariable; // 路径参数
import org.springframework.web.bind.annotation.PostMapping; // POST
import org.springframework.web.bind.annotation.RequestMapping; // 前缀
import org.springframework.web.bind.annotation.RequestParam; // 查询参数
import org.springframework.web.bind.annotation.RestController; // 控制器

import java.time.LocalDateTime; // 时间
import java.util.List; // 集合

@RestController // 控制器
@RequestMapping("/api/commerce/products") // 前缀
public class ProductController { // 商品控制器
	private final ProductQueryService productService; // 查询服务
	private final ProductSkuMapper productSkuMapper; // SKU Mapper
	private final ProductMapper productMapper; // 商品Mapper

	public ProductController(ProductQueryService productService, ProductSkuMapper productSkuMapper, ProductMapper productMapper) { // 构造注入
		this.productService = productService; // 赋值
		this.productSkuMapper = productSkuMapper; // 赋值
		this.productMapper = productMapper; // 赋值
	}

	@GetMapping // 商品分页
	public ApiResponse<Page<Product>> page(@RequestParam(required = false) String keyword,
											 @RequestParam(required = false) Long categoryId,
											 @RequestParam(defaultValue = "1") int page,
											 @RequestParam(defaultValue = "10") int size) { // 条件+分页
		return ApiResponse.success(productService.page(keyword, categoryId, page, size)); // 调服务
	}

	@GetMapping("/{id}") // 商品详情
	public ApiResponse<Product> detail(@PathVariable Long id) { // 路径参数
		return ApiResponse.success(productService.detail(id)); // 调服务
	}

	@GetMapping("/{id}/skus") // 商品SKU列表
	public ApiResponse<java.util.List<ProductSku>> skus(@PathVariable Long id) { // 路径参数
		var list = this.productSkuMapper.selectList(new LambdaQueryWrapper<ProductSku>() // 查询
			.eq(ProductSku::getProductId, id) // 归属
			.eq(ProductSku::getStatus, 1) // 上架
			.eq(ProductSku::getDeleted, 0) // 未删除
		); // end wrapper
		return ApiResponse.success(list); // 返回
	}

	@PostMapping("/dev/assign-images") // 开发工具：为缺封面商品分配图
	public ApiResponse<Integer> devAssignImages() { // 无参
		// 仅为缺少封面图的商品分配图片 URL
		List<Product> pending = productMapper.selectList(new LambdaQueryWrapper<Product>() // 查询
			.isNull(Product::getCoverUrl) // 封面为空
			.or(w -> w.eq(Product::getCoverUrl, "")) // 或空串
		); // end wrapper
		String[] candidates = new String[] { // 候选图
			"https://images.unsplash.com/photo-1519681393784-d120267933ba", // gear
			"https://images.unsplash.com/photo-1512295767273-ac109ac3acfa", // safety
			"https://images.unsplash.com/photo-1520697222860-6d1d3ff72aa6", // toolbox
			"https://images.unsplash.com/photo-1521737604893-d14cc237f11d", // training
			"https://images.unsplash.com/photo-1483721310020-03333e577078", // emergency
		};
		int updated = 0; // 计数
		for (Product p : pending) { // 遍历
			long seed = (p.getId() != null ? p.getId() : 0L); // 种子
			String base = candidates[(int) (Math.abs(seed) % candidates.length)]; // 选图
			String url = base + "?q=80&w=800&auto=format&fit=crop"; // 参数
			p.setCoverUrl(url); // 赋值
			p.setUpdatedAt(LocalDateTime.now()); // 更新时间
			updated += productMapper.updateById(p); // 更新
		}
		return ApiResponse.success(updated); // 返回
	}

	@PostMapping("/dev/set-cover-all") // 设置统一封面
	public ApiResponse<Integer> devSetCoverAll(@RequestParam(required = false) String url) { // 可指定URL
		String target = (url != null && !url.isBlank())
			? url
			: "https://images.unsplash.com/photo-1525610553991-2bede1a236e2?q=80&w=800&auto=format&fit=crop"; // 默认
		List<Product> all = productMapper.selectList(new LambdaQueryWrapper<>()); // 全量
		int updated = 0; // 计数
		for (Product p : all) { // 遍历
			p.setCoverUrl(target); // 设置
			p.setUpdatedAt(LocalDateTime.now()); // 更新时间
			updated += productMapper.updateById(p); // 更新
		}
		return ApiResponse.success(updated); // 返回
	}

	@PostMapping("/dev/set-cover-pattern") // 使用模式设置封面
	public ApiResponse<Integer> devSetCoverPattern(@RequestParam String pattern) { // 例如 /images/products/{id}-1.svg
		List<Product> all = productMapper.selectList(new LambdaQueryWrapper<>()); // 全量
		int updated = 0; // 计数
		for (Product p : all) { // 遍历
			String url = pattern.replace("{id}", String.valueOf(p.getId())); // 渲染
			p.setCoverUrl(url); // 设置
			p.setUpdatedAt(LocalDateTime.now()); // 更新时间
			updated += productMapper.updateById(p); // 更新
		}
		return ApiResponse.success(updated); // 返回
	}

	@PostMapping("/dev/set-media-patterns") // 使用模式批量设置多图
	public ApiResponse<Integer> devSetMediaPatterns(@RequestParam(defaultValue = "3") int count,
	                                               @RequestParam String pattern) { // {id}/{n}
		List<Product> all = productMapper.selectList(new LambdaQueryWrapper<>()); // 全量
		int updated = 0; // 计数
		for (Product p : all) { // 遍历
			StringBuilder sb = new StringBuilder(); // 构建JSON数组字符串
			sb.append('[');
			for (int i = 1; i <= count; i++) { // 生成N张
				String url = pattern.replace("{id}", String.valueOf(p.getId()))
					.replace("{n}", String.valueOf(i)); // 渲染
				sb.append('"').append(url).append('"'); // 追加
				if (i < count) sb.append(','); // 逗号
			}
			sb.append(']');
			p.setMediaJson(sb.toString()); // 保存
			p.setUpdatedAt(LocalDateTime.now()); // 更新时间
			updated += productMapper.updateById(p); // 更新
		}
		return ApiResponse.success(updated); // 返回
	}

	@PostMapping("/dev/seed-basic") // 种子数据：基础商品+SKU
	public ApiResponse<Integer> devSeedBasic() { // 无参
		String[] names = new String[] {"应急安全锤","应急医药箱","救援绳索","破拆工具","应急照明灯","逃生面罩","防火靴","防火头盔","防火手套","消防战斗服"}; // 名称
		java.math.BigDecimal[] prices = new java.math.BigDecimal[] { new java.math.BigDecimal("39"), new java.math.BigDecimal("129"), new java.math.BigDecimal("59"), new java.math.BigDecimal("199"), new java.math.BigDecimal("79"), new java.math.BigDecimal("29"), new java.math.BigDecimal("199"), new java.math.BigDecimal("159"), new java.math.BigDecimal("49"), new java.math.BigDecimal("299") }; // 价格
		int created = 0; // 计数
		for (int i = 0; i < names.length; i++) { // 循环
			Product p = new Product(); // 商品
			p.setName(names[i]); // 名称
			p.setSubtitle("演示商品"); // 副标题
			p.setStatus(1); // 上架
			p.setCoverUrl("/images/products/{id}-1.svg"); // 占位
			p.setCreatedAt(LocalDateTime.now()); // 创建时间
			p.setUpdatedAt(LocalDateTime.now()); // 更新时间
			productMapper.insert(p); // 插入
			// 设置本地封面/媒体
			String pattern = "/images/products/{id}-{n}.svg"; // 本地图模式
			String url = pattern.replace("{id}", String.valueOf(p.getId())).replace("{n}", "1"); // 第一张
			p.setCoverUrl(url); // 设置
			String media = "[\"" + pattern.replace("{id}", String.valueOf(p.getId())).replace("{n}", "1") + "\",\"" +
				pattern.replace("{id}", String.valueOf(p.getId())).replace("{n}", "2") + "\",\"" +
				pattern.replace("{id}", String.valueOf(p.getId())).replace("{n}", "3") + "\"]"; // 三张
			p.setMediaJson(media); // 保存
			p.setUpdatedAt(LocalDateTime.now()); // 更新时间
			productMapper.updateById(p); // 更新
			// 插入一个 SKU
			ProductSku sku = new ProductSku(); // SKU
			sku.setProductId(p.getId()); // 归属
			sku.setSkuCode("SKU" + p.getId()); // 编码
			sku.setAttrsJson("{}"); // 属性
			sku.setPrice(prices[i % prices.length]); // 价格
			sku.setOriginPrice(prices[i % prices.length].multiply(new java.math.BigDecimal("1.2"))); // 原价
			sku.setStatus(1); // 上架
			sku.setCreatedAt(LocalDateTime.now()); // 创建时间
			sku.setUpdatedAt(LocalDateTime.now()); // 更新时间
			productSkuMapper.insert(sku); // 插入
			created++; // 计数
		}
		return ApiResponse.success(created); // 返回创建数
	}
} // 类结束 