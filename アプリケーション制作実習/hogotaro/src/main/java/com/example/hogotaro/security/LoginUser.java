package com.example.hogotaro.security;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.example.hogotaro.entity.Staff;
import com.example.hogotaro.repository.StaffRepository;

import lombok.RequiredArgsConstructor;

/**
 * 「今ログインしている人」の窓口【Security 導入後】版。
 * Controller / Service に注入して loginUser.getOrganizationId() / getStaffId() で使う。
 * 認証そのものは Spring Security 標準の User クラス（LoginUserDetailsService が作る）に任せ、
 * ここではログイン ID から staff を引き直して団体 ID などを返す。
 * Security 導入前は _before_security 版（固定値を返す）。メソッド名は同じなので呼び出し側は無変更。
 */
@Component
@RequiredArgsConstructor
public class LoginUser {

    private final StaffRepository staffRepository;

    private Authentication auth() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth instanceof AnonymousAuthenticationToken) {
            return null;
        }
        return auth;
    }

    /** ログイン中の staff。1 回呼ぶごとに SELECT が 1 回走る（この規模では気にしなくてよい） */
    private Staff staff() {
        Authentication auth = auth();
        if (auth == null) {
            throw new IllegalStateException("ログインしていません");
        }
        return staffRepository.findByLoginId(auth.getName()).orElseThrow();
    }

    public boolean isLoggedIn() {
        return auth() != null;
    }

    /** ログイン中のスタッフの団体 ID。Repository の絞り込みは必ずこれを使う */
    public Integer getOrganizationId() {
        return staff().getOrganization().getId();
    }

    public String getOrganizationName() {
        return staff().getOrganization().getName();
    }

    /** ログイン中のスタッフ ID。イベント完了の「対応スタッフ」などに使う */
    public Integer getStaffId() {
        return staff().getId();
    }

    public String getName() {
        return staff().getName();
    }

    /** ADMIN / STAFF / VOLUNTEER（user_types.code） */
    public String getRole() {
        return staff().getUserType().getCode();
    }

    /** 管理ユーザー / 常勤スタッフ / ボランティア（user_types.name）。ヘッダーの右上に出す */
    public String getUserTypeName() {
        return staff().getUserType().getName();
    }
}