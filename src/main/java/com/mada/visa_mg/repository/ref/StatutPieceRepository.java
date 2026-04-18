package com.mada.visa_mg.repository.ref;

import com.mada.visa_mg.entity.ref.StatutPiece;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StatutPieceRepository extends JpaRepository<StatutPiece, Integer> {
    Optional<StatutPiece> findByCode(String code);
}
