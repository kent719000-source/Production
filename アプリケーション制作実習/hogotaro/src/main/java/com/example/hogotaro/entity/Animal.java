package com.example.hogotaro.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "animals")
@Getter
@Setter
public class Animal {
	
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "organization_id", nullable = false)
    private Organization organization;

    private String name;

    @Enumerated(EnumType.STRING)
    private Species species;

    @Enumerated(EnumType.STRING)
    private Sex sex;

    @ManyToOne
    @JoinColumn(name = "breed_id")
    private Breed breed;

    private LocalDate birthday;

    private Boolean isBirthdayEstimated;

    private LocalDate intakeDate;

    private String intakePlace;

    private String intakeMethod;

    @Enumerated(EnumType.STRING)
    private Status status;

    @ManyToOne
    @JoinColumn(name = "adopter_id")
    private Adopter adopter;

    private Boolean isNeutered;

    private Boolean comboVaccine;

    private Boolean rabiesVaccine;

    private String microchipNo;

    @Column(columnDefinition = "TEXT")
    private String healthNotes;

    @Column(columnDefinition = "TEXT")
    private String notes;

    private String imagePath;

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
