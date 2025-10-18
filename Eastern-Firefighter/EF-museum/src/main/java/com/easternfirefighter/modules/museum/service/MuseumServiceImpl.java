package com.easternfirefighter.modules.museum.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.museum.dto.MuseumPageQuery;
import com.easternfirefighter.modules.museum.entity.Museum;
import com.easternfirefighter.modules.museum.entity.MuseumBooking;
import com.easternfirefighter.modules.museum.repository.mapper.MuseumBookingMapper;
import com.easternfirefighter.modules.museum.repository.mapper.MuseumMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
public class MuseumServiceImpl implements MuseumService {
	private final MuseumMapper museumMapper;
	private final MuseumBookingMapper bookingMapper;

	public MuseumServiceImpl(MuseumMapper museumMapper, MuseumBookingMapper bookingMapper) {
		this.museumMapper = museumMapper;
		this.bookingMapper = bookingMapper;
	}

	@Override
	public Page<Museum> page(MuseumPageQuery q) {
		LambdaQueryWrapper<Museum> qw = new LambdaQueryWrapper<Museum>()
			.eq(Museum::getDeleted, 0)
			.eq(Museum::getStatus, 1)
			.like(q.getCity() != null && !q.getCity().isBlank(), Museum::getCity, q.getCity())
			.orderByDesc(Museum::getCreatedAt);
		return museumMapper.selectPage(Page.of(q.getPage(), q.getSize()), qw);
	}

	@Override
	public Museum detail(Long id) {
		Museum m = museumMapper.selectById(id);
		if (m == null || (m.getDeleted() != null && m.getDeleted() == 1) || (m.getStatus() != null && m.getStatus() == 0)) return null;
		return m;
	}

	@Override
	public boolean book(Long userId, Long museumId, LocalDate date, String slot, int people) {
		MuseumBooking b = new MuseumBooking();
		b.setMuseumId(museumId);
		b.setUserId(userId);
		b.setDate(date);
		b.setSlot(slot);
		b.setPeople(people);
		b.setStatus(0);
		b.setCreatedAt(LocalDateTime.now());
		return bookingMapper.insert(b) > 0;
	}
} 