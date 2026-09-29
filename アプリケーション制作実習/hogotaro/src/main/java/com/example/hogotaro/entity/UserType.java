package com.example.hogotaro.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.*;

/** user_types テーブル 1 行。Entity には @Data を付けない（equals/hashCode/toString が関連を辿って事故る）ので @Getter @Setter だけ */
@Entity
@Table(name = "user_types")
@Getter
@Setter
public class UserType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String code;

    private String name;

}
