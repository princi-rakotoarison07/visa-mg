package com.mada.visa_mg.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mada.visa_mg.domain.entity.Dossier;

public interface DossierRepository extends JpaRepository<Dossier, Long> {
}
