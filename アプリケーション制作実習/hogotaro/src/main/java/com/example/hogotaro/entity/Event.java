package com.example.hogotaro.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.*;

/**
 * events テーブル 1 行。
 * アノテーションの無いフィールドは、フィールド名を snake_case にした列に自動で対応する（phoneNumber → phone_number）。
 * Entity には @Data を付けない。@Data が作る equals / hashCode / toString が @ManyToOne の相手を辿り、
 * 無限ループや余計な SELECT の原因になるため。getter / setter だけ欲しいので @Getter @Setter にしている。
 */
@Entity                                                         // このクラスは DB のテーブル 1 行を表す、という印（JPA が管理する対象になる）
@Table(name = "events")                                         // 対応するテーブル名。無いとクラス名 Event からテーブル「event」を探してしまう（テーブルは複数形なので必須）
@Getter                                                         // Lombok: 全フィールドの getXxx() を自動で作る
@Setter                                                         // Lombok: 全フィールドの setXxx() を自動で作る
public class Event {

    @Id                                                         // 主キー（PK）の印。この列で 1 行を区別する
    @GeneratedValue(strategy = GenerationType.IDENTITY)         // id は MySQL の AUTO_INCREMENT が決める。save() した後にこのフィールドへ入る
    private Integer id;

    @ManyToOne                                                  // 多対一の関連（多くの行が相手 1 件を指す）。相手の Entity 型で持つので JSP で ${x.相手.name} と辿れる
    @JoinColumn(name = "organization_id", nullable = false)     // 外部キーの列名。nullable = false は NOT NULL（必ず相手がいる）の意味
    private Organization organization;

    @ManyToOne                                                  // 多対一の関連（多くの行が相手 1 件を指す）。相手の Entity 型で持つので JSP で ${x.相手.name} と辿れる
    @JoinColumn(name = "event_type_id", nullable = false)       // 外部キーの列名。nullable = false は NOT NULL（必ず相手がいる）の意味
    private EventType eventType;

    @ManyToOne                                                  // 多対一の関連（多くの行が相手 1 件を指す）。相手の Entity 型で持つので JSP で ${x.相手.name} と辿れる
    @JoinColumn(name = "animal_id", nullable = false)           // 外部キーの列名。nullable = false は NOT NULL（必ず相手がいる）の意味
    private Animal animal;

    @ManyToOne                                                  // 多対一の関連（多くの行が相手 1 件を指す）。相手の Entity 型で持つので JSP で ${x.相手.name} と辿れる
    @JoinColumn(name = "adopter_id")                            // 外部キーの列名。NULL 可（相手がいなければ null）
    private Adopter adopter;

    @ManyToOne                                                  // 多対一の関連（多くの行が相手 1 件を指す）。相手の Entity 型で持つので JSP で ${x.相手.name} と辿れる
    @JoinColumn(name = "staff_id")                              // 外部キーの列名。NULL 可（相手がいなければ null）
    private Staff staff;

    private LocalDate eventDate;

    private LocalTime eventTime;

    private String place;

    private Boolean done;

    private Integer cost;

    @Column(columnDefinition = "TEXT")                          // この列の型は TEXT だと伝える。無いと VARCHAR(255) とみなされ、長い特記事項で食い違う
    private String notes;

    @Column(name = "created_at", insertable = false, updatable = false)  // Java からは書き込まない（INSERT / UPDATE に含めない）。値は MySQL の DEFAULT / ON UPDATE が入れる
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)  // Java からは書き込まない（INSERT / UPDATE に含めない）。値は MySQL の DEFAULT / ON UPDATE が入れる
    private LocalDateTime updatedAt;

}
