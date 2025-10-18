package com.easternfirefighter.modules.content.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ArticleUpdateRequest {
    @NotNull(message = "文章ID不能为空")
    private Long id;
    
    @NotBlank(message = "标题不能为空")
    @Size(max = 200, message = "标题长度不能超过200字符")
    private String title;
    
    @NotBlank(message = "频道不能为空")
    @Size(max = 50, message = "频道长度不能超过50字符")
    private String channel;
    
    @NotBlank(message = "URL别名不能为空")
    @Size(max = 100, message = "URL别名长度不能超过100字符")
    private String slug;
    
    @Size(max = 500, message = "摘要长度不能超过500字符")
    private String summary;
    
    @NotBlank(message = "文章内容不能为空")
    private String contentHtml;
    
    @Size(max = 500, message = "封面图片URL长度不能超过500字符")
    private String coverUrl;
    
    private String seoJson; // SEO信息的JSON字符串
    
    private Integer status; // 发布状态：1-发布，0-草稿
} 