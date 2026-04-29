package com.mada.visa_mg.repository;

import com.mada.visa_mg.entity.CarteResident;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CarteResidentRepository extends JpaRepository<CarteResident, Integer> {
    List<CarteResident> findByPasseportId(Integer passeportId);
    List<CarteResident> findByReferenceContainingIgnoreCase(String reference);
}
