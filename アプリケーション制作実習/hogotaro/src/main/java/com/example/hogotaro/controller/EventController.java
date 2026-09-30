package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.EventService;

import lombok.RequiredArgsConstructor;

@Controller //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
public class EventController {

	private final EventService eventService; //Springが管理しているEventService(の参照値)を受け取る(自分でnewしない)
	private final LoginUser loginUser; //同上

	@GetMapping("/event") //URLでlocalhost:8080/eventをリクエストすると呼ばれる
	public String list(Model model) { //Model: JSPに渡すデータを入れる箱。引数に書くだけでSpringが用意して渡してくれる(自分でnewしない)
		model.addAttribute("eventList", eventService.findAll(loginUser.getOrganizationId())); //JSPにeventListという名前で渡す。JSPでは${eventList}で読む
		return "event/calendar"; // /WEB-INF/jsp/event/calendar.jspを表示する
	}

}
