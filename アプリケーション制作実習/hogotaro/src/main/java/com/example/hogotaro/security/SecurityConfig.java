package com.example.hogotaro.security;

import jakarta.servlet.DispatcherType;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * URL ごとの権限（基本設計 3 章の前書き・8 章）とログイン画面の設定。
 * ルールは上から順に評価され、先に書いた方が勝つ。
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /** パスワードは BCrypt。スタッフ登録時は passwordEncoder.encode(平文) を保存する */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                // JSP への forward と /error への転送は認可の対象外にする（無いとログイン画面が無限リダイレクトする）
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                // 誰でも
                .requestMatchers("/login", "/css/**", "/js/**", "/img/**","/images/**").permitAll()
                // ログアウトはログイン済みなら誰でも（POST /** のルールより前に置く）
                .requestMatchers("/logout").authenticated()
                // 管理ユーザーだけ: スタッフの新規登録・編集（GET も POST も）と、全機能の削除（決定 2-14）
                .requestMatchers("/staff/new", "/staff/*/edit", "/*/*/delete").hasRole("ADMIN")
                // 登録・編集フォームは GET でも常勤スタッフ以上（ボランティアが URL を直接開いたら 403）。スタッフの分は上の行が先に当たるので ADMIN のまま
                .requestMatchers("/*/new", "/*/*/edit").hasAnyRole("ADMIN", "STAFF")
                // POST（登録・更新・完了・未対応に戻す）は常勤スタッフ以上
                .requestMatchers(HttpMethod.POST, "/**").hasAnyRole("ADMIN", "STAFF")
                // それ以外（全 GET）はログイン済みなら誰でも
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")             // GET /login は TopController が login.jsp を返す
                .loginProcessingUrl("/login")    // POST /login は Spring Security が処理する
                .usernameParameter("loginId")
                .passwordParameter("password")
                .defaultSuccessUrl("/", true)
                .failureUrl("/login?error")
            )
            .logout(logout -> logout
                .logoutUrl("/logout")            // POST /logout
                .logoutSuccessUrl("/login?logout")
            );
        return http.build();
    }
}
