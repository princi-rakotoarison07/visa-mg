package com.mada.visa_mg.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mada.visa_mg.domain.entity.Personne;

public interface PersonneRepository extends JpaRepository<Personne, Long> {
}
