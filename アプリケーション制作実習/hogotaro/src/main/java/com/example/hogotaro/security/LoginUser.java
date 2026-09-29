package com.example.hogotaro.security;

import org.springframework.stereotype.Component;

@Component
public class LoginUser {
    public Integer getOrganizationId() { return 1; }   // TODO Security 導入後に差し替え
    public Integer getStaffId() { return 1; }
}
