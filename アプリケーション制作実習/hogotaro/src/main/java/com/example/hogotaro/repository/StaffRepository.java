package com.example.hogotaro.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.Staff;

public interface StaffRepository extends JpaRepository {
    List<Staff> findByOrganizationIdOrderByIdDesc(Integer organizationId);
    Optional<Staff> findByIdAndOrganizationId(Integer id, Integer organizationId);


}
