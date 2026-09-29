package com.example.hogotaro.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.*;

/** breeds テーブル 1 行。Entity には @Data を付けない（equals/hashCode/toString が関連を辿って事故る）ので @Getter @Setter だけ */
@Entity
@Table(name = "breeds")
@Getter
@Setter
public class Breed {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Enumerated(EnumType.STRING)
    private Species species;

    private String name;

}
