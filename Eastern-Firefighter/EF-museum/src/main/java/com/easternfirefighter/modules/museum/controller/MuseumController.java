package com.easternfirefighter.modules.museum.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.common.UserContext;
import com.easternfirefighter.modules.museum.dto.MuseumBookRequest;
import com.easternfirefighter.modules.museum.dto.MuseumPageQuery;
import com.easternfirefighter.modules.museum.entity.Museum;
import com.easternfirefighter.modules.museum.service.MuseumService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/museum")
public class MuseumController {
	private final MuseumService museumService;
	private final com.easternfirefighter.modules.museum.repository.mapper.MuseumMapper museumMapper;

	public MuseumController(MuseumService museumService, com.easternfirefighter.modules.museum.repository.mapper.MuseumMapper museumMapper) {
		this.museumService = museumService;
		this.museumMapper = museumMapper;
	}

	@GetMapping("/list")
	public ApiResponse<Page<Museum>> page(@RequestParam(required = false) String city,
	                                     @RequestParam(required = false) String theme,
	                                     @RequestParam(defaultValue = "1") int page,
	                                     @RequestParam(defaultValue = "10") int size) {
		MuseumPageQuery q = new MuseumPageQuery();
		q.setCity(city);
		q.setTheme(theme);
		q.setPage(page);
		q.setSize(size);
		return ApiResponse.success(museumService.page(q));
	}

	@GetMapping("/{id}")
	public ApiResponse<Museum> detail(@PathVariable Long id) {
		Museum m = museumService.detail(id);
		return m == null ? ApiResponse.fail(404, "展馆不存在或未上架") : ApiResponse.success(m);
	}

	@PostMapping("/book")
	public ApiResponse<Boolean> book(@Valid @RequestBody MuseumBookRequest req) {
		Long uid = UserContext.getUserId();
		boolean ok = museumService.book(uid, req.getMuseumId(), LocalDate.parse(req.getDate()), req.getSlot(), req.getPeople());
		return ApiResponse.success(ok);
	}

	@PostMapping("/dev/seed")
	public ApiResponse<Integer> seed() {
		int n = 0;
		for (int i = 1; i <= 5; i++) {
			com.easternfirefighter.modules.museum.entity.Museum m = new com.easternfirefighter.modules.museum.entity.Museum();
			m.setName("应急主题展馆" + i);
			m.setCity(i % 2 == 0 ? "上海" : "杭州");
			m.setTheme(i % 2 == 0 ? "fire" : "firstaid");
			m.setThemeName(i % 2 == 0 ? "消防安全" : "急救科普");
			m.setCoverUrl("/images/placeholders/museum-" + ((i % 2) + 1) + ".svg");
			m.setSummary("沉浸式安全教育，体验式应急演练。");
			m.setContentHtml("<p>展馆内容即将上线。</p>");
			m.setStatus(1);
			n += museumMapper.insert(m);
		}
		return ApiResponse.success(n);
	}
} 