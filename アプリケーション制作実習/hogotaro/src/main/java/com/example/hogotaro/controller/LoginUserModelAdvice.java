package com.example.hogotaro.controller;

import com.example.hogotaro.security.LoginUser;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * 全画面の JSP から ${loginUser.name} ${loginUser.organizationName} ${loginUser.role} を読めるようにする。
 * header.jspf の右上（団体名・名前）用。各 Controller に何も足さなくてよい。
 */
@ControllerAdvice
@RequiredArgsConstructor
public class LoginUserModelAdvice {

    private final LoginUser loginUser;

    @ModelAttribute("loginUser")
    public LoginUser loginUser() {
        return loginUser;
    }
}
