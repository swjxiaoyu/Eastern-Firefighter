package com.easternfirefighter.modules.content.service;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.easternfirefighter.modules.content.dto.ArticleCreateRequest;
import com.easternfirefighter.modules.content.dto.ArticleUpdateRequest;
import com.easternfirefighter.modules.content.entity.Article;
import com.easternfirefighter.modules.content.repository.mapper.ArticleMapper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;

@Service
public class ArticleServiceImpl extends ServiceImpl<ArticleMapper, Article> implements com.easternfirefighter.modules.content.service.ArticleService {
	@Override
	public Page<Article> pageByChannel(String channel, int pageNo, int pageSize) {
		LambdaQueryWrapper<Article> qw = new LambdaQueryWrapper<>();
		qw.eq(StringUtils.hasText(channel), Article::getChannel, channel)
			.eq(Article::getStatus, 1)
			.eq(Article::getDeleted, 0)
			.orderByDesc(Article::getPublishedAt)
			.orderByDesc(Article::getCreatedAt);
		return this.page(Page.of(pageNo, pageSize), qw);
	}

	@Override
	public Article getBySlug(String slug) {
		LambdaQueryWrapper<Article> qw = new LambdaQueryWrapper<>();
		qw.eq(Article::getSlug, slug).eq(Article::getStatus, 1).eq(Article::getDeleted, 0);
		return this.getOne(qw);
	}

	@Override
	public Page<Article> pageForAdmin(String channel, String keyword, int pageNo, int pageSize) {
		LambdaQueryWrapper<Article> qw = new LambdaQueryWrapper<>();
		qw.eq(StringUtils.hasText(channel), Article::getChannel, channel)
			.and(StringUtils.hasText(keyword), wrapper -> 
				wrapper.like(Article::getTitle, keyword)
					.or().like(Article::getSummary, keyword))
			.eq(Article::getDeleted, 0)
			.orderByDesc(Article::getUpdatedAt)
			.orderByDesc(Article::getCreatedAt);
		return this.page(Page.of(pageNo, pageSize), qw);
	}

	@Override
	public Article getById(Long id) {
		return super.getById(id);
	}

	@Override
	public Long create(ArticleCreateRequest req) {
		Article article = new Article();
		article.setTitle(req.getTitle());
		article.setChannel(req.getChannel());
		article.setSlug(req.getSlug());
		article.setSummary(req.getSummary());
		article.setContentHtml(req.getContentHtml());
		article.setCoverUrl(req.getCoverUrl());
		article.setSeoJson(req.getSeoJson());
		article.setStatus(req.getStatus());
		article.setCreatedAt(LocalDateTime.now());
		article.setUpdatedAt(LocalDateTime.now());
		article.setDeleted(0);
		
		if (req.getStatus() == 1) {
			article.setPublishedAt(LocalDateTime.now());
		}
		
		this.save(article);
		return article.getId();
	}

	@Override
	public void update(ArticleUpdateRequest req) {
		Article article = this.getById(req.getId());
		if (article == null || article.getDeleted() == 1) {
			throw new IllegalArgumentException("文章不存在");
		}
		
		article.setTitle(req.getTitle());
		article.setChannel(req.getChannel());
		article.setSlug(req.getSlug());
		article.setSummary(req.getSummary());
		article.setContentHtml(req.getContentHtml());
		article.setCoverUrl(req.getCoverUrl());
		article.setSeoJson(req.getSeoJson());
		article.setUpdatedAt(LocalDateTime.now());
		
		// 如果状态发生变化
		if (req.getStatus() != null && !req.getStatus().equals(article.getStatus())) {
			article.setStatus(req.getStatus());
			if (req.getStatus() == 1 && article.getPublishedAt() == null) {
				article.setPublishedAt(LocalDateTime.now());
			}
		}
		
		this.updateById(article);
	}

	@Override
	public void delete(Long id) {
		Article article = this.getById(id);
		if (article == null || article.getDeleted() == 1) {
			throw new IllegalArgumentException("文章不存在");
		}
		
		article.setDeleted(1);
		article.setUpdatedAt(LocalDateTime.now());
		this.updateById(article);
	}

	@Override
	public void publish(Long id) {
		Article article = this.getById(id);
		if (article == null || article.getDeleted() == 1) {
			throw new IllegalArgumentException("文章不存在");
		}
		
		article.setStatus(1);
		if (article.getPublishedAt() == null) {
			article.setPublishedAt(LocalDateTime.now());
		}
		article.setUpdatedAt(LocalDateTime.now());
		this.updateById(article);
	}

	@Override
	public void unpublish(Long id) {
		Article article = this.getById(id);
		if (article == null || article.getDeleted() == 1) {
			throw new IllegalArgumentException("文章不存在");
		}
		
		article.setStatus(0);
		article.setUpdatedAt(LocalDateTime.now());
		this.updateById(article);
	}
} 