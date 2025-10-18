package com.easternfirefighter.modules.training.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.training.dto.CoursePageQuery;
import com.easternfirefighter.modules.training.entity.Course;

public interface CourseService {
	Page<Course> page(CoursePageQuery q);
	Course detail(Long id);
	boolean enroll(Long userId, Long courseId, String realName, String phone);
} 