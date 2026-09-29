package com.example.hogotaro.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.Event;

public interface EventRepository extends JpaRepository {
    List<Event> findByOrganizationIdOrderByIdDesc(Integer organizationId);
    Optional<Event> findByIdAndOrganizationId(Integer id, Integer organizationId);

}
