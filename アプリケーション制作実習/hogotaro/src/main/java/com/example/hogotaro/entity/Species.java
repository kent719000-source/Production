package com.example.hogotaro.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 犬猫。これはテーブルではなく Java のクラス（取れる値が決まっている enum）。
 * DB には定数名（DOG など）を文字列で保存し、画面には label を出す（JSP: ${x.species.label}）。
 */
@Getter                    // Lombok: getLabel() を自動で作る
@RequiredArgsConstructor   // Lombok: final フィールド（label）を受け取るコンストラクタを自動で作る。DOG("犬") の "犬" がここに入る
public enum Species {
    DOG("犬"),
    CAT("猫");

    private final String label;
}
