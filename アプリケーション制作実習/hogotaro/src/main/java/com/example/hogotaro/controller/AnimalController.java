package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.AnimalService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AnimalController {
	
	private final AnimalService animalService;
    private final LoginUser loginUser;        // ← これ 1 行だけ。@RequiredArgsConstructor が注入する
    

    @GetMapping("/animal")
    public String list(Model model) {
        model.addAttribute("animalList", animalService.findAll(loginUser.getOrganizationId()));
        return "animal/list";
    }
    
    @GetMapping("/animal/{id}")
    public String detail(@PathVariable Integer id, Model model) {
    	
    	return "animal/detail";
    }

}

