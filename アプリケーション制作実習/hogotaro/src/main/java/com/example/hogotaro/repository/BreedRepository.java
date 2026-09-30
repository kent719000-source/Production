package com.example.hogotaro.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.Breed;

public interface BreedRepository extends JpaRepository<Breed, Integer> {

}
