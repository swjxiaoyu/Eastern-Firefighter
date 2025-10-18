package com.easternfirefighter.modules.content.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.modules.content.dto.ArticleCreateRequest;
import com.easternfirefighter.modules.content.dto.ArticleUpdateRequest;
import com.easternfirefighter.modules.content.entity.Article;
import com.easternfirefighter.modules.content.service.ArticleService;
import com.easternfirefighter.modules.content.vo.ArticleAdminVO;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/articles")
public class ArticleAdminController {
    private static final Logger log = LoggerFactory.getLogger(ArticleAdminController.class);
    private final ArticleService articleService;
    
    // 图片上传目录
    private static final String UPLOAD_DIR = "uploads/articles/";
    
    public ArticleAdminController(ArticleService articleService) {
        this.articleService = articleService;
    }
    
    /**
     * 分页查询文章列表（管理端）
     */
    @GetMapping
    public ApiResponse<Page<ArticleAdminVO>> list(
            @RequestParam(value = "channel", required = false) String channel,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        log.info("[ARTICLE_ADMIN] list channel={} keyword={} page={} size={}", channel, keyword, page, size);
        Page<Article> result = articleService.pageForAdmin(channel, keyword, page, size);
        Page<ArticleAdminVO> vo = new Page<>(result.getCurrent(), result.getSize(), result.getTotal());
        vo.setRecords(result.getRecords().stream().map(a -> {
            ArticleAdminVO v = new ArticleAdminVO();
            v.setId(String.valueOf(a.getId()));
            v.setTitle(a.getTitle());
            v.setChannel(a.getChannel());
            v.setStatus(a.getStatus());
            v.setSummary(a.getSummary());
            v.setCoverUrl(a.getCoverUrl());
            v.setPublishedAt(a.getPublishedAt());
            v.setUpdatedAt(a.getUpdatedAt());
            return v;
        }).toList());
        return ApiResponse.success(vo);
    }
    
    /**
     * 获取文章详情
     */
    @GetMapping("/{id}")
    public ApiResponse<Article> detail(@PathVariable Long id) {
        log.info("[ARTICLE_ADMIN] detail id={}", id);
        Article article = articleService.getById(id);
        if (article == null || article.getDeleted() == 1) {
            return ApiResponse.fail(404, "文章不存在");
        }
        return ApiResponse.success(article);
    }
    
    /**
     * 创建文章
     */
    @PostMapping
    public ApiResponse<Long> create(@Valid @RequestBody ArticleCreateRequest req) {
        log.info("[ARTICLE_ADMIN] create title={} channel={}", req.getTitle(), req.getChannel());
        try {
            Long id = articleService.create(req);
            return ApiResponse.success(id);
        } catch (Exception e) {
            log.error("[ARTICLE_ADMIN] create failed", e);
            return ApiResponse.fail(500, "创建失败：" + e.getMessage());
        }
    }
    
    /**
     * 更新文章
     */
    @PutMapping("/{id}")
    public ApiResponse<Boolean> update(@PathVariable Long id, @Valid @RequestBody ArticleUpdateRequest req) {
        log.info("[ARTICLE_ADMIN] update id={} title={}", id, req.getTitle());
        req.setId(id);
        try {
            articleService.update(req);
            return ApiResponse.success(true);
        } catch (Exception e) {
            log.error("[ARTICLE_ADMIN] update failed", e);
            return ApiResponse.fail(500, "更新失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除文章
     */
    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        log.info("[ARTICLE_ADMIN] delete id={}", id);
        try {
            articleService.delete(id);
            return ApiResponse.success(true);
        } catch (Exception e) {
            log.error("[ARTICLE_ADMIN] delete failed", e);
            return ApiResponse.fail(500, "删除失败：" + e.getMessage());
        }
    }
    
    /**
     * 发布文章
     */
    @PostMapping("/{id}/publish")
    public ApiResponse<Boolean> publish(@PathVariable Long id) {
        log.info("[ARTICLE_ADMIN] publish id={}", id);
        try {
            articleService.publish(id);
            return ApiResponse.success(true);
        } catch (Exception e) {
            log.error("[ARTICLE_ADMIN] publish failed", e);
            return ApiResponse.fail(500, "发布失败：" + e.getMessage());
        }
    }
    
    /**
     * 取消发布文章
     */
    @PostMapping("/{id}/unpublish")
    public ApiResponse<Boolean> unpublish(@PathVariable Long id) {
        log.info("[ARTICLE_ADMIN] unpublish id={}", id);
        try {
            articleService.unpublish(id);
            return ApiResponse.success(true);
        } catch (Exception e) {
            log.error("[ARTICLE_ADMIN] unpublish failed", e);
            return ApiResponse.fail(500, "取消发布失败：" + e.getMessage());
        }
    }
    
    /**
     * 上传图片
     */
    @PostMapping("/upload/image")
    public ApiResponse<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file) {
        log.info("[ARTICLE_ADMIN] uploadImage filename={} size={}", file.getOriginalFilename(), file.getSize());
        
        if (file.isEmpty()) {
            return ApiResponse.fail(400, "请选择要上传的图片");
        }
        
        // 检查文件类型
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return ApiResponse.fail(400, "只能上传图片文件");
        }
        
        // 检查文件大小（5MB限制）
        if (file.getSize() > 5 * 1024 * 1024) {
            return ApiResponse.fail(400, "图片文件不能超过5MB");
        }
        
        try {
            // 创建上传目录
            String dateDir = LocalDate.now().toString(); // 2025-09-10
            Path uploadPath = Paths.get(UPLOAD_DIR + dateDir);
            Files.createDirectories(uploadPath);
            
            // 生成唯一文件名
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".") 
                ? originalFilename.substring(originalFilename.lastIndexOf(".")) 
                : ".jpg";
            String filename = UUID.randomUUID().toString() + extension;
            
            // 保存文件
            Path filePath = uploadPath.resolve(filename);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
            
            // 返回访问URL
            String url = "/" + UPLOAD_DIR + dateDir + "/" + filename;
            
            Map<String, String> result = new HashMap<>();
            result.put("url", url);
            result.put("filename", filename);
            
            log.info("[ARTICLE_ADMIN] uploadImage success url={}", url);
            return ApiResponse.success(result);
            
        } catch (IOException e) {
            log.error("[ARTICLE_ADMIN] uploadImage failed", e);
            return ApiResponse.fail(500, "上传失败：" + e.getMessage());
        }
    }
} 