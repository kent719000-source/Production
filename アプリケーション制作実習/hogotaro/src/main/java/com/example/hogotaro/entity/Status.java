package com.example.hogotaro.entity;

import java.util.List;

/**
 * 個体の保護状況（8 つ）。DB の animals.status には定数名（ADOPTABLE など）を文字列で保存する。
 * これはテーブルではなく Java のクラス。取れる値がこの 8 つに決まっている。
 * 画面には label（日本語）を出す。JSP: ${a.status.label}
 */
public enum Status {
    ADOPTABLE("保護中(譲渡可)"),
    NOT_ADOPTABLE("保護中(譲渡不可)"),
    HOSPITALIZED("入院中"),
    TRIAL("トライアル中"),
    ADOPTED("譲渡済"),
    RETURNED("返還"),
    TRANSFERRED("移管"),
    DECEASED("死亡");

    /** 画面に出す日本語 */
    private final String label;

    Status(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }

    /**
     * 保護頭数に数える 4 つ（団体が今世話をしている子）。
     * トップページの頭数と、個体一覧の絞り込みの初期値は必ずここから取る。リストを別の場所に直接書かない。
     */
    public static List<Status> inCare() {
        return List.of(ADOPTABLE, NOT_ADOPTABLE, HOSPITALIZED, TRIAL);
    }
}
