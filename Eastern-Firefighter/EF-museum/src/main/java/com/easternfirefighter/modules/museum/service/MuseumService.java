package com.easternfirefighter.modules.museum.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.museum.dto.MuseumPageQuery;
import com.easternfirefighter.modules.museum.entity.Museum;

public interface MuseumService {
	Page<Museum> page(MuseumPageQuery q);
	Museum detail(Long id);
	boolean book(Long userId, Long museumId, java.time.LocalDate date, String slot, int people);
} 