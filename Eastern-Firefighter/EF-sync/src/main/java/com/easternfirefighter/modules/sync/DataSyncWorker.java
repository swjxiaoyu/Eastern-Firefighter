package com.easternfirefighter.modules.sync;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.sync.repository.mapper.DataSyncLogMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
public class DataSyncWorker {
	private static final Logger log = LoggerFactory.getLogger(DataSyncWorker.class);
	private final DataSyncLogMapper dataSyncLogMapper;
	private final StringRedisTemplate stringRedisTemplate;

	public DataSyncWorker(DataSyncLogMapper dataSyncLogMapper, StringRedisTemplate stringRedisTemplate) {
		this.dataSyncLogMapper = dataSyncLogMapper;
		this.stringRedisTemplate = stringRedisTemplate;
	}

	@Scheduled(fixedDelay = 2000, initialDelay = 3000)
	public void pollAndPublish() {
		Page<DataSyncLog> page = dataSyncLogMapper.selectPage(Page.of(1, 100),
			new LambdaQueryWrapper<DataSyncLog>()
				.eq(DataSyncLog::getSyncStatus, 0)
				.orderByAsc(DataSyncLog::getId));
		List<DataSyncLog> list = page.getRecords();
		if (list.isEmpty()) return;
		for (DataSyncLog logItem : list) {
			try {
				publishEvent(logItem);
				dataSyncLogMapper.update(null, new LambdaUpdateWrapper<DataSyncLog>()
					.eq(DataSyncLog::getId, logItem.getId())
					.set(DataSyncLog::getSyncStatus, 1)
					.set(DataSyncLog::getUpdatedAt, LocalDateTime.now()));
			} catch (Exception ex) {
				log.warn("sync failed id={}", logItem.getId(), ex);
				dataSyncLogMapper.update(null, new LambdaUpdateWrapper<DataSyncLog>()
					.eq(DataSyncLog::getId, logItem.getId())
					.set(DataSyncLog::getSyncStatus, 2)
					.set(DataSyncLog::getErrorMessage, ex.getMessage())
					.set(DataSyncLog::getUpdatedAt, LocalDateTime.now()));
			}
		}
	}

	private void publishEvent(DataSyncLog item) {
		String channel = null;
		if ("product".equalsIgnoreCase(item.getTableName())) {
			channel = "product.changed";
		}
		if (channel != null) {
			String payload = item.getSyncData() != null ? item.getSyncData() : ("{\"id\":" + item.getRecordId() + ",\"op\":\"" + item.getOperation() + "\"}");
			stringRedisTemplate.convertAndSend(channel, payload);
		}
		log.info("publish {} change id={} op={}", item.getTableName(), item.getRecordId(), item.getOperation());
	}
} 