package com.mada.visa_mg.repository.ref;

import com.mada.visa_mg.entity.ref.StatutDossier;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StatutDossierRepository extends JpaRepository<StatutDossier, Integer> {
    Optional<StatutDossier> findByCode(String code);
}
