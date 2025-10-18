package com.easternfirefighter.util;

import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;
import java.util.concurrent.ThreadLocalRandom;

public class OrderNoUtils {
	public static String newOrderNo() {
		String ts = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));
		int rand = ThreadLocalRandom.current().nextInt(100000, 999999);
		return ts + rand;
	}
} 