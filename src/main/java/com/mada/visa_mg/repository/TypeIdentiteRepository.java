package com.mada.visa_mg.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mada.visa_mg.domain.entity.TypeIdentite;

public interface TypeIdentiteRepository extends JpaRepository<TypeIdentite, Long> {
    Optional<TypeIdentite> findByCode(String code);
}
