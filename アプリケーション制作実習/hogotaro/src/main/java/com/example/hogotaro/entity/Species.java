package com.example.hogotaro.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/** 犬猫。DB には定数名（DOG など）を保存し、画面には label を出す（JSP: ${x.species.label}） */
@Getter
@RequiredArgsConstructor
public enum Species {
    DOG("犬"),
    CAT("猫");

    private final String label;
}
