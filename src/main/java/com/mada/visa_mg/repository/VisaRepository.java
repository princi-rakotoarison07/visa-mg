package com.mada.visa_mg.repository;

import com.mada.visa_mg.entity.Visa;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VisaRepository extends JpaRepository<Visa, Integer> {
    List<Visa> findByPasseportId(Integer passeportId);
}
