package com.example.hogotaro.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.*;

/**
 * staff テーブル 1 行。
 * アノテーションの無いフィールドは、フィールド名を snake_case にした列に自動で対応する（phoneNumber → phone_number）。
 * Entity には @Data を付けない。@Data が作る equals / hashCode / toString が @ManyToOne の相手を辿り、
 * 無限ループや余計な SELECT の原因になるため。getter / setter だけ欲しいので @Getter @Setter にしている。
 */
@Entity                                                         // このクラスは DB のテーブル 1 行を表す、という印（JPA が管理する対象になる）
@Table(name = "staff")                                          // 対応するテーブル名。無いとクラス名 Staff からテーブル「staff」を探してしまう（テーブルは複数形なので必須）
@Getter                                                         // Lombok: 全フィールドの getXxx() を自動で作る
@Setter                                                         // Lombok: 全フィールドの setXxx() を自動で作る
public class Staff {

    @Id                                                         // 主キー（PK）の印。この列で 1 行を区別する
    @GeneratedValue(strategy = GenerationType.IDENTITY)         // id は MySQL の AUTO_INCREMENT が決める。save() した後にこのフィールドへ入る
    private Integer id;

    @ManyToOne                                                  // 多対一の関連（多くの行が相手 1 件を指す）。相手の Entity 型で持つので JSP で ${x.相手.name} と辿れる
    @JoinColumn(name = "organization_id", nullable = false)     // 外部キーの列名。nullable = false は NOT NULL（必ず相手がいる）の意味
    private Organization organization;

    private String loginId;

    private String passwordHash;

    @ManyToOne                                                  // 多対一の関連（多くの行が相手 1 件を指す）。相手の Entity 型で持つので JSP で ${x.相手.name} と辿れる
    @JoinColumn(name = "user_type_id", nullable = false)        // 外部キーの列名。nullable = false は NOT NULL（必ず相手がいる）の意味
    private UserType userType;

    private String name;

    @Enumerated(EnumType.STRING)                                // enum を定数名の文字列（"DOG" など）で保存する。無いと 0,1,2 の番号で保存され、定数の順番を変えた瞬間にデータが壊れる
    private Gender gender;

    private LocalDate birthday;

    private LocalDate joinedDate;

    private String address;

    private String phoneNumber;

    private String email;

    @Column(columnDefinition = "TEXT")                          // この列の型は TEXT だと伝える。無いと VARCHAR(255) とみなされ、長い特記事項で食い違う
    private String notes;

    @Column(name = "created_at", insertable = false, updatable = false)  // Java からは書き込まない（INSERT / UPDATE に含めない）。値は MySQL の DEFAULT / ON UPDATE が入れる
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)  // Java からは書き込まない（INSERT / UPDATE に含めない）。値は MySQL の DEFAULT / ON UPDATE が入れる
    private LocalDateTime updatedAt;


    /**
     * 年齢。DB には保存せず生年月日から計算する。生年月日が無ければ null。JSP では ${a.age} で読める。
     * @Transient は「DB の列ではない」という印。このクラスはフィールドにアノテーションを付ける書き方なので、
     * 無くても列だとは思われないが、計算で出す値だと読む人に分かるように付けている。
     */
    @Transient
    public Integer getAge() {
        if (birthday == null) return null;
        return Period.between(birthday, LocalDate.now()).getYears();
    }

}
