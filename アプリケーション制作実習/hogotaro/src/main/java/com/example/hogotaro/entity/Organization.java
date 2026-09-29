package com.example.hogotaro.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.*;

/** organizations テーブル 1 行。Entity には @Data を付けない（equals/hashCode/toString が関連を辿って事故る）ので @Getter @Setter だけ */
@Entity
@Table(name = "organizations")
@Getter
@Setter
public class Organization {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    private String address;

    private String phoneNumber;

    private String email;

    private Integer capacity;

    @Column(columnDefinition = "TEXT")
    private String notes;

}
