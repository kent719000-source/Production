package com.example.hogotaro.controller;

import java.time.YearMonth;

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
		
		YearMonth ym = YearMonth.now(); // 今月(2026-10)
		model.addAttribute("weeks", topService.buildCalendar(ym)); // 週ごとの日付の表
		model.addAttribute("yearMonth", ym); // 見出しと、当月かどうかの判定に使う
		model.addAttribute("inCare", topService.countInCare(loginUser.getOrganizationId()));
		model.addAttribute("organization",topService.findOrganization(loginUser.getOrganizationId()));
		return "top";
	}

}
