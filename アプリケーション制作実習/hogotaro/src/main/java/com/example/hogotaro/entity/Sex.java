package com.example.hogotaro.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 個体の性別。これはテーブルではなく Java のクラス（取れる値が決まっている enum）。
 * DB には定数名（MALE など）を文字列で保存し、画面には label を出す（JSP: ${x.sex.label}）。
 */
@Getter                    // Lombok: getLabel() を自動で作る
@RequiredArgsConstructor   // Lombok: final フィールド（label）を受け取るコンストラクタを自動で作る。DOG("犬") の "犬" がここに入る
public enum Sex {
    MALE("オス"),
    FEMALE("メス"),
    UNKNOWN("不明");

    private final String label;
}
