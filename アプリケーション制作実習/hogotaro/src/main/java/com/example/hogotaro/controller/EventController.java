package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.hogotaro.dto.EventCalendar;
import com.example.hogotaro.entity.Event;
import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.EventService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;
    private final LoginUser loginUser;

    @GetMapping("/event")
    public String list(
            @RequestParam(name = "year", required = false) Integer year,
            @RequestParam(name = "month", required = false) Integer month,
            Model model) {

        EventCalendar calendar = eventService.search(
                loginUser.getOrganizationId(),
                year,
                month);

        model.addAttribute("calendar", calendar);

        return "event/calendar";
    }
    
    @PostMapping("/event/{id}/complete")
    public String complete(
            @PathVariable("id") Integer id) {

        // 1. Serviceに「この予定を完了にして」とお願いする
        Event event = eventService.complete(
                id,
                loginUser.getOrganizationId(),
                loginUser.getStaffId());

        // 2. 完了した予定の日付から、年と月を取り出す
        int year = event.getEventDate().getYear();
        int month = event.getEventDate().getMonthValue();

        // 3. その年月のカレンダーに戻る
        return "redirect:/event?year=" + year + "&month=" + month;
    }
}