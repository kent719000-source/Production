package com.example.hogotaro.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.EventType;

public interface EventTypeRepository extends JpaRepository<EventType, Integer> {

}
