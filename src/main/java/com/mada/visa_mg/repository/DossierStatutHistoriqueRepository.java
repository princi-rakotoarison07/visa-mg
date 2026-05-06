package com.mada.visa_mg.repository;

import com.mada.visa_mg.entity.DossierStatutHistorique;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DossierStatutHistoriqueRepository extends JpaRepository<DossierStatutHistorique, Integer> {
    List<DossierStatutHistorique> findByDossierIdOrderByDateChangementStatutDesc(Integer dossierId);
}
