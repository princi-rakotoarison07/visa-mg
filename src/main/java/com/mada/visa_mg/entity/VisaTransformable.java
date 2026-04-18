package com.mada.visa_mg.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "visa_transformable")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VisaTransformable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "demandeur_id", nullable = false)
    private Demandeur demandeur;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "passeport_id", nullable = false)
    private Passeport passeport;

    @Column(name = "numero_reference", unique = true, length = 50)
    private String numeroReference;

    @Column(name = "lieu_entree", nullable = false, length = 150)
    private String lieuEntree;

    @Column(name = "date_entree", nullable = false)
    private LocalDate dateEntree;

    @Column(name = "date_sortie_ref")
    private LocalDate dateSortieRef;

    @Column(name = "date_expiration", nullable = false)
    private LocalDate dateExpiration;
}
