package com.example.hogotaro.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.Animal;

public interface AnimalRepository extends JpaRepository {
	List<Animal> findByOrganizationIdOrderByDesc(Integer organizationId);
	Optional<Animal> findByIdAndOrganizationId(Integer id,Integer organizationId);

}
