package com.easternfirefighter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.easternfirefighter")
public class EasternFirefighterApplication {
	public static void main(String[] args) {
		SpringApplication.run(EasternFirefighterApplication.class, args);
	}
} 