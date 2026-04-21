package com.mada.visa_mg.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "catalogue_piece_commune")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CataloguePieceCommune {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 80)
    private String code;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String libelle;

    @Column(name = "est_obligatoire", nullable = false)
    private Boolean estObligatoire = true;
}
