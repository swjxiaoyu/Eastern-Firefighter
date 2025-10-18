package com.easternfirefighter.modules.content.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.content.dto.ArticleCreateRequest;
import com.easternfirefighter.modules.content.dto.ArticleUpdateRequest;
import com.easternfirefighter.modules.content.entity.Article;

public interface ArticleService {
	Page<Article> pageByChannel(String channel, int pageNo, int pageSize);
	Article getBySlug(String slug);
	
	// 管理功能
	Page<Article> pageForAdmin(String channel, String keyword, int pageNo, int pageSize);
	Article getById(Long id);
	Long create(ArticleCreateRequest req);
	void update(ArticleUpdateRequest req);
	void delete(Long id);
	void publish(Long id);
	void unpublish(Long id);
} 