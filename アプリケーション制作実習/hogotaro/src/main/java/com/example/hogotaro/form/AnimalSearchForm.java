package com.example.hogotaro.form;

import com.example.hogotaro.entity.Species;
import com.example.hogotaro.entity.Status;
import lombok.Data;

import java.util.List;

/**
 * 個体一覧（S-03 / F-05）の絞り込み条件。GET /animal?species=DOG&statuses=ADOPTABLE&name=ポ の形で届く。
 * 画面のチェックボックス・入力欄の name と、このフィールド名を同じにする（Spring が自動で詰める）。
 * 検索条件は全部任意なので、入力チェックのアノテーション（@NotBlank など）は付けていない。
 */
@Data   // Lombok: getter / setter / toString / equals / hashCode をまとめて作る。Form は DB と関係ないので @Data でよい（Entity には付けない）
public class AnimalSearchForm {

    /** 犬猫（チェックボックス、複数選択） */
    private List<Species> species;

    /** 保護状況（チェックボックス、複数選択）。初期値は Status.inCare() */
    private List<Status> statuses;

    /** 名前（部分一致）。空なら名前では絞らない */
    private String name;
}
