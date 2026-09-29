package com.example.hogotaro.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/** 個体の性別。DB には定数名（MALE など）を保存し、画面には label を出す（JSP: ${x.sex.label}） */
@Getter
@RequiredArgsConstructor
public enum Sex {
    MALE("オス"),
    FEMALE("メス"),
    UNKNOWN("不明");

    private final String label;
}
