package com.easternfirefighter.modules.content.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.modules.content.entity.Article;
import com.easternfirefighter.modules.content.service.ArticleService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/content/articles")
public class ArticleController {
	private final ArticleService articleService;

	public ArticleController(ArticleService articleService) {
		this.articleService = articleService;
	}

	@GetMapping
	public ApiResponse<Page<Article>> page(
			@RequestParam(value = "channel", required = false) String channel,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "10") int size) {
		Page<Article> result = articleService.pageByChannel(channel, page, size);
		return ApiResponse.success(result);
	}

	@GetMapping("/{slug}")
	public ApiResponse<Article> detail(@PathVariable("slug") String slug) {
		Article one = articleService.getBySlug(slug);
		return ApiResponse.success(one);
	}
} 