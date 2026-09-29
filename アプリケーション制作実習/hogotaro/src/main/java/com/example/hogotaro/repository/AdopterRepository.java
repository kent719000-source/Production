package com.example.hogotaro.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.Adopter;

public interface AdopterRepository extends JpaRepository {
    List<Adopter> findByOrganizationIdOrderByIdDesc(Integer organizationId);
    Optional<Adopter> findByIdAndOrganizationId(Integer id, Integer organizationId);
}
