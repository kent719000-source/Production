package com.example.hogotaro.security;

import com.example.hogotaro.repository.StaffRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * ログイン ID から staff を引いて、Spring Security 標準の User を返す。Spring Security がログイン時に呼ぶ。
 * 自作の UserDetails クラスは作らない。団体 ID などは LoginUser（窓口）が staff から引き直す。
 */
@Service
@RequiredArgsConstructor
public class LoginUserDetailsService implements UserDetailsService {

    private final StaffRepository staffRepository;

    @Override
    public UserDetails loadUserByUsername(String loginId) throws UsernameNotFoundException {
        return staffRepository.findByLoginId(loginId)
                .map(staff -> User.withUsername(staff.getLoginId())
                        .password(staff.getPasswordHash())
                        // roles("ADMIN") が "ROLE_ADMIN" にしてくれる。自分で ROLE_ を付けると ROLE_ROLE_ADMIN になって全員 403
                        .roles(staff.getUserType().getCode())
                        .build())
                .orElseThrow(() -> new UsernameNotFoundException(loginId));
    }
}
