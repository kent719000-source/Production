package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.hogotaro.dto.EventCalendar;
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
}