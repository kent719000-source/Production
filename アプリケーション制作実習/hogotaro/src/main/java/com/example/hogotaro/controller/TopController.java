package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.EventService;
import com.example.hogotaro.service.TopService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class TopController {
	
	private final LoginUser loginUser;
	private final TopService topService;
	private final EventService eventService;
	

	
	@GetMapping("/")
	public String top(Model model) {
		Integer organizationId = loginUser.getOrganizationId();
		
		// 現在の保護頭数と団体の保護上限表示のための団体
		model.addAttribute("inCare", topService.countInCare(loginUser.getOrganizationId()));
		model.addAttribute("organization",topService.findOrganization(loginUser.getOrganizationId()));	
		// カレンダー
		model.addAttribute("calendar", eventService.search(organizationId,null, null));

		return "top";
	}
	
	// F-02 ログイン画面（S-01）。ログイン済みならトップへ。POST /login は Spring Security が処理するので書かない
	@GetMapping("/login")
	public String login() {
		if (loginUser.isLoggedIn()) {
			return "redirect:/";
		}
		return "login";
	}

}
