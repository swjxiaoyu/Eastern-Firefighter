package com.easternfirefighter.modules.training.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.common.UserContext;
import com.easternfirefighter.modules.training.dto.CourseEnrollRequest;
import com.easternfirefighter.modules.training.dto.CoursePageQuery;
import com.easternfirefighter.modules.training.entity.Course;
import com.easternfirefighter.modules.training.service.CourseService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/training/courses")
public class CourseController {
	private final CourseService courseService;
	private final com.easternfirefighter.modules.training.repository.mapper.CourseMapper courseMapper;

	public CourseController(CourseService courseService, com.easternfirefighter.modules.training.repository.mapper.CourseMapper courseMapper) {
		this.courseService = courseService;
		this.courseMapper = courseMapper;
	}

	@GetMapping
	public ApiResponse<Page<Course>> page(@RequestParam(required = false) String keyword,
	                                     @RequestParam(required = false) String level,
	                                     @RequestParam(defaultValue = "1") int page,
	                                     @RequestParam(defaultValue = "10") int size) {
		CoursePageQuery q = new CoursePageQuery();
		q.setKeyword(keyword);
		q.setLevel(level);
		q.setPage(page);
		q.setSize(size);
		return ApiResponse.success(courseService.page(q));
	}

	@GetMapping("/{id}")
	public ApiResponse<Course> detail(@PathVariable Long id) {
		Course c = courseService.detail(id);
		return c == null ? ApiResponse.fail(404, "课程不存在或未上架") : ApiResponse.success(c);
	}

	@PostMapping("/enroll")
	public ApiResponse<Boolean> enroll(@Valid @RequestBody CourseEnrollRequest req) {
		Long uid = UserContext.getUserId();
		boolean ok = courseService.enroll(uid, req.getCourseId(), req.getRealName(), req.getPhone());
		return ApiResponse.success(ok);
	}

	@PostMapping("/dev/seed")
	public ApiResponse<Integer> seed() {
		int n = 0;
		for (int i = 1; i <= 6; i++) {
			com.easternfirefighter.modules.training.entity.Course c = new com.easternfirefighter.modules.training.entity.Course();
			c.setTitle("消防安全基础" + i);
			c.setCoverUrl("/images/placeholders/course-" + ((i % 3) + 1) + ".svg");
			c.setSummary("系统学习消防应急基础知识与实操演练，提升自我保护与组织能力。");
			c.setLevel(i % 3 == 0 ? "advanced" : i % 3 == 1 ? "beginner" : "intermediate");
			c.setDuration(12 + i);
			c.setLecturer("讲师" + i);
			c.setContentHtml("<p>课程内容即将上线。</p>");
			c.setStatus(1);
			n += courseMapper.insert(c);
		}
		return ApiResponse.success(n);
	}
} 