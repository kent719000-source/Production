package com.example.hogotaro.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.*;

/**
 * user_types テーブル 1 行。
 * アノテーションの無いフィールドは、フィールド名を snake_case にした列に自動で対応する（phoneNumber → phone_number）。
 * Entity には @Data を付けない。@Data が作る equals / hashCode / toString が @ManyToOne の相手を辿り、
 * 無限ループや余計な SELECT の原因になるため。getter / setter だけ欲しいので @Getter @Setter にしている。
 */
@Entity                                                         // このクラスは DB のテーブル 1 行を表す、という印（JPA が管理する対象になる）
@Table(name = "user_types")                                     // 対応するテーブル名。無いとクラス名 UserType からテーブル「userType」を探してしまう（テーブルは複数形なので必須）
@Getter                                                         // Lombok: 全フィールドの getXxx() を自動で作る
@Setter                                                         // Lombok: 全フィールドの setXxx() を自動で作る
public class UserType {

    @Id                                                         // 主キー（PK）の印。この列で 1 行を区別する
    @GeneratedValue(strategy = GenerationType.IDENTITY)         // id は MySQL の AUTO_INCREMENT が決める。save() した後にこのフィールドへ入る
    private Integer id;

    private String code;

    private String name;

}
