package com.example.hogotaro.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.hogotaro.entity.Animal;
import com.example.hogotaro.repository.AnimalRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AnimalService {
	private final AnimalRepository animalRepository;
	
    public List<Animal> findAll(Integer organizationId) {
    	return animalRepository.findByOrganizationIdOrderByDesc(organizationId);
        
    }

}
