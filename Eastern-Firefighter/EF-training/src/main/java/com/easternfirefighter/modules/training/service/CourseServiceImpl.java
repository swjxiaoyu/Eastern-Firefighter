package com.easternfirefighter.modules.training.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.training.dto.CoursePageQuery;
import com.easternfirefighter.modules.training.entity.Course;
import com.easternfirefighter.modules.training.entity.CourseEnrollment;
import com.easternfirefighter.modules.training.repository.mapper.CourseEnrollmentMapper;
import com.easternfirefighter.modules.training.repository.mapper.CourseMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class CourseServiceImpl implements CourseService {
	private final CourseMapper courseMapper;
	private final CourseEnrollmentMapper enrollmentMapper;

	public CourseServiceImpl(CourseMapper courseMapper, CourseEnrollmentMapper enrollmentMapper) {
		this.courseMapper = courseMapper;
		this.enrollmentMapper = enrollmentMapper;
	}

	@Override
	public Page<Course> page(CoursePageQuery q) {
		LambdaQueryWrapper<Course> qw = new LambdaQueryWrapper<Course>()
			.eq(Course::getDeleted, 0)
			.eq(Course::getStatus, 1)
			.like(q.getKeyword() != null && !q.getKeyword().isBlank(), Course::getTitle, q.getKeyword())
			.eq(q.getLevel() != null && !q.getLevel().isBlank(), Course::getLevel, q.getLevel())
			.orderByDesc(Course::getCreatedAt);
		return courseMapper.selectPage(Page.of(q.getPage(), q.getSize()), qw);
	}

	@Override
	public Course detail(Long id) {
		Course c = courseMapper.selectById(id);
		if (c == null || c.getDeleted() != null && c.getDeleted() == 1 || c.getStatus() != null && c.getStatus() == 0) return null;
		return c;
	}

	@Override
	public boolean enroll(Long userId, Long courseId, String realName, String phone) {
		CourseEnrollment e = new CourseEnrollment();
		e.setCourseId(courseId);
		e.setUserId(userId);
		e.setRealName(realName);
		e.setPhone(phone);
		e.setStatus(0);
		e.setCreatedAt(LocalDateTime.now());
		return enrollmentMapper.insert(e) > 0;
	}
} 