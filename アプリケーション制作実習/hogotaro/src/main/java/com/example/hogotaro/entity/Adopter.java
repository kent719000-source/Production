package com.example.hogotaro.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.*;

/** adopters テーブル 1 行。Entity には @Data を付けない（equals/hashCode/toString が関連を辿って事故る）ので @Getter @Setter だけ */
@Entity
@Table(name = "adopters")
@Getter
@Setter
public class Adopter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "organization_id", nullable = false)
    private Organization organization;

    private String name;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    private LocalDate birthday;

    private String address;

    private String phoneNumber;

    private String email;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;


    /** 年齢。DB には保存せず生年月日から計算する。生年月日が無ければ null */
    @Transient
    public Integer getAge() {
        if (birthday == null) return null;
        return Period.between(birthday, LocalDate.now()).getYears();
    }

}
