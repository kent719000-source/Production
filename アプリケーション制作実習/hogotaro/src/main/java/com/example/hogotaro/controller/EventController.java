package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.hogotaro.dto.EventCalendar;
import com.example.hogotaro.entity.Event;
import com.example.hogotaro.form.EventForm;
import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.EventService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;
    private final LoginUser loginUser;
    
    //イベントカレンダーの表示
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
    
    //概要ペイン上でイベントを対応済にする
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
    
    //イベント詳細画面の取得
    @GetMapping("/event/{id}")
    public String detail(
            @PathVariable("id") Integer id,
            Model model) {

        // イベントIDと、ログイン中の人の団体IDで1件取得する
        Event event = eventService.findbyId(
                id,
                loginUser.getOrganizationId());

        // 取得したイベントを、JSPに「event」という名前で渡す
        model.addAttribute("event", event);

        // イベント詳細画面を表示する
        return "event/detail";
    }
    
    //イベント詳細画面から対応済を未対応に戻す受付
    @PostMapping("/event/{id}/uncomplete")
    public String uncomplete(@PathVariable("id") Integer id) {

        // Serviceに、未対応へ戻す処理をお願いする
        Event event = eventService.uncomplete(
                id,
                loginUser.getOrganizationId());

        // イベントの年月を取り出す
        int year = event.getEventDate().getYear();
        int month = event.getEventDate().getMonthValue();

        // その月のカレンダーに戻る
        return "redirect:/event?year=" + year + "&month=" + month;
    }
    
 // 現在値入りの編集画面を表示する
    @GetMapping("/event/{id}/edit")
    public String editForm(
            @PathVariable("id") Integer id,
            Model model) {

        Integer organizationId = loginUser.getOrganizationId();

        EventForm form = eventService.getEditForm(id, organizationId);

        model.addAttribute("eventForm", form);

        setEditModel(id, organizationId, model);

        return "event/form";
    }

    // 編集フォームから送られた内容を更新する
    @PostMapping("/event/{id}/edit")
    public String update(
            @PathVariable("id") Integer id,
            @Validated @ModelAttribute("eventForm") EventForm form,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        Integer organizationId = loginUser.getOrganizationId();

        eventService.update(id, form, result, organizationId);

        if (result.hasErrors()) {
            // 入力値は残したまま、選択肢を用意し直す
            setEditModel(id, organizationId, model);
            return "event/form";
        }

        redirectAttributes.addFlashAttribute(
                "message", "イベントを編集しました");

        return "redirect:/event/" + id;
    }

    // 編集画面の表示に必要な、ID・モード・選択肢を用意する
    private void setEditModel(
            Integer id, Integer organizationId, Model model) {

        Event event = eventService.findbyId(id, organizationId);

        model.addAttribute("eventId", id);
        model.addAttribute("mode", "edit");

        model.addAttribute("animalList",
                eventService.findAnimalList(
                        organizationId, event.getAnimal().getId()));

        model.addAttribute("eventTypeList",
                eventService.findEventTypeList());

        model.addAttribute("adopterList",
                eventService.findAdopterList(organizationId));
    }
}