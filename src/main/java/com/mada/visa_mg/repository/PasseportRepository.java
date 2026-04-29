package com.mada.visa_mg.repository;

import com.mada.visa_mg.entity.Passeport;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PasseportRepository extends JpaRepository<Passeport, Integer> {
    Optional<Passeport> findByNumeroPasseport(String numeroPasseport);

    List<Passeport> findByNumeroPasseportContainingIgnoreCase(String numeroPasseport);

    List<Passeport> findByDemandeurId(Integer demandeurId);
}
