package com.easternfirefighter.config;

import jakarta.annotation.PostConstruct;
import org.flywaydb.core.Flyway;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FlywayConfig {
	private final Flyway flyway;

	public FlywayConfig(Flyway flyway) {
		this.flyway = flyway;
	}

	@PostConstruct
	public void migrate() {
		flyway.repair();
		flyway.migrate();
	}
} 