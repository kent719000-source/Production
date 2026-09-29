package com.example.hogotaro.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/** 人（スタッフ・里親）の性別。DB には定数名（MALE など）を保存し、画面には label を出す（JSP: ${x.gender.label}） */
@Getter
@RequiredArgsConstructor
public enum Gender {
    MALE("男性"),
    FEMALE("女性"),
    OTHER("その他");

    private final String label;
}
