package com.example.hogotaro.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 人（スタッフ・里親）の性別。これはテーブルではなく Java のクラス（取れる値が決まっている enum）。
 * DB には定数名（MALE など）を文字列で保存し、画面には label を出す（JSP: ${x.gender.label}）。
 */
@Getter                    // Lombok: getLabel() を自動で作る
@RequiredArgsConstructor   // Lombok: final フィールド（label）を受け取るコンストラクタを自動で作る。DOG("犬") の "犬" がここに入る
public enum Gender {
    MALE("男性"),
    FEMALE("女性"),
    OTHER("その他");

    private final String label;
}
