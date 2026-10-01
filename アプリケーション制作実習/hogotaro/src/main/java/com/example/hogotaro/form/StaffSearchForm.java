package com.example.hogotaro.form;

import lombok.Data;

/**
 * スタッフ管理一覧（F-27）のキーワード検索の条件。GET /staff?name=中村&phoneNumber=0801 の形で届く。
 * 画面の入力欄の name と、このフィールド名を同じにする（Spring が自動で詰める）。
 * 検索条件は全部任意なので、入力チェックのアノテーション（@NotBlank など）は付けていない。
 */
@Data   // Lombok: getter / setter / toString / equals / hashCode をまとめて作る。Form は DB と関係ないので @Data でよい（Entity には付けない）
public class StaffSearchForm {

    /** 名前（部分一致）。空なら名前では絞らない */
    private String name;

    /** 電話番号（部分一致、ハイフンは無視）。空なら電話番号では絞らない */
    private String phoneNumber;
}
