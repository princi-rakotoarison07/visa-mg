package com.mada.visa_mg.repository.ref;

import com.mada.visa_mg.entity.ref.TypeDemande;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TypeDemandeRepository extends JpaRepository<TypeDemande, Integer> {
    Optional<TypeDemande> findByCode(String code);
}
