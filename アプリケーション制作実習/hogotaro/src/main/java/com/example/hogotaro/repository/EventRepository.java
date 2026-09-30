package com.example.hogotaro.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.Event;

public interface EventRepository extends JpaRepository<Event, Integer> {
    List<Event> findByOrganizationIdOrderByIdDesc(Integer organizationId);
    Optional<Event> findByIdAndOrganizationId(Integer id, Integer organizationId);
    List<Event>
    findByOrganizationIdAndEventDateBetweenOrderByEventDateAscEventTimeAsc(
            Integer organizationId,
            LocalDate startDate,
            LocalDate endDate);
    
}
