package com.example.hogotaro.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.Organization;

public interface OrganizationRepository extends JpaRepository<Organization, Integer> {

}
