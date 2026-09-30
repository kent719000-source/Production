package com.example.hogotaro.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.*;

/**
 * breeds テーブル 1 行。
 * アノテーションの無いフィールドは、フィールド名を snake_case にした列に自動で対応する（phoneNumber → phone_number）。
 * Entity には @Data を付けない。@Data が作る equals / hashCode / toString が @ManyToOne の相手を辿り、
 * 無限ループや余計な SELECT の原因になるため。getter / setter だけ欲しいので @Getter @Setter にしている。
 */
@Entity                                                         // このクラスは DB のテーブル 1 行を表す、という印（JPA が管理する対象になる）
@Table(name = "breeds")                                         // 対応するテーブル名。無いとクラス名 Breed からテーブル「breed」を探してしまう（テーブルは複数形なので必須）
@Getter                                                         // Lombok: 全フィールドの getXxx() を自動で作る
@Setter                                                         // Lombok: 全フィールドの setXxx() を自動で作る
public class Breed {

    @Id                                                         // 主キー（PK）の印。この列で 1 行を区別する
    @GeneratedValue(strategy = GenerationType.IDENTITY)         // id は MySQL の AUTO_INCREMENT が決める。save() した後にこのフィールドへ入る
    private Integer id;

    @Enumerated(EnumType.STRING)                                // enum を定数名の文字列（"DOG" など）で保存する。無いと 0,1,2 の番号で保存され、定数の順番を変えた瞬間にデータが壊れる
    private Species species;

    private String name;

}
