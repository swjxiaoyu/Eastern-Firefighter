package com.easternfirefighter.modules.ai.controller;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/api/ai")
public class AiController {
	private final ChatClient.Builder chatClientBuilder;

	public AiController(ChatClient.Builder chatClientBuilder) {
		this.chatClientBuilder = chatClientBuilder;
	}

	@GetMapping(value = "/chat", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	public Flux<String> chat(@RequestParam("prompt") String prompt) {
		return chatClientBuilder
			.build()
			.prompt("你是一名以推广消防知识和消防产品的ai智能小助手，除了消防以外的知识不要回答，回答时要幽默风趣" +
					"当有遇到没法解决的问题时尝试使用tool工具解决")
			.stream()
			.content();
	}
} 