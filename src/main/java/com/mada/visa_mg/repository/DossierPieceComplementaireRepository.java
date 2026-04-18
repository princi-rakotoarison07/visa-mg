package com.mada.visa_mg.repository;

import com.mada.visa_mg.entity.DossierPieceComplementaire;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DossierPieceComplementaireRepository extends JpaRepository<DossierPieceComplementaire, Integer> {
    List<DossierPieceComplementaire> findByDossierId(Integer dossierId);
}
