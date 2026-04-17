package com.mada.visa_mg.repository;

import com.mada.visa_mg.entity.DossierPieceCommune;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DossierPieceCommuneRepository extends JpaRepository<DossierPieceCommune, Integer> {
    List<DossierPieceCommune> findByDossierId(Integer dossierId);
}
