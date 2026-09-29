package com.example.hogotaro.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/** 個体の保護状況。DB には定数名（SHELTERED など）を保存し、画面には label を出す（JSP: ${x.status.label}） */
@Getter
@RequiredArgsConstructor
public enum Status {
    SHELTERED("保護中"),
    TRIAL("トライアル中"),
    ADOPTED("譲渡済"),
    DECEASED("死亡");

    private final String label;
}
