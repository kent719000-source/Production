package com.example.hogotaro.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 個体の避妊去勢（3 択）。これはテーブルではなく Java のクラス（取れる値が決まっている enum）。
 * ワクチンは済 / 未の 2 択なので BOOLEAN だが、避妊去勢は保護した時点で分からないことがあるので「不明」を足して enum にした（決定 2-2）。
 * DB の animals.neutered には定数名（DONE など）を文字列で保存し、画面には label を出す（JSP: ${a.neutered.label}）。
 */
@Getter                    // Lombok: getLabel() を自動で作る
@RequiredArgsConstructor   // Lombok: final フィールド（label）を受け取るコンストラクタを自動で作る。DONE("済") の "済" がここに入る
public enum NeuterStatus {
    DONE("済"),
    NOT_DONE("未"),
    UNKNOWN("不明");

    private final String label;
}
