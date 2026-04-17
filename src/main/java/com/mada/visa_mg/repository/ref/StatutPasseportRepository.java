package com.mada.visa_mg.repository.ref;

import com.mada.visa_mg.entity.ref.StatutPasseport;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StatutPasseportRepository extends JpaRepository<StatutPasseport, Integer> {
    Optional<StatutPasseport> findByCode(String code);
}
