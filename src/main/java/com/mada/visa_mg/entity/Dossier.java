package com.mada.visa_mg.entity;

import com.mada.visa_mg.entity.ref.StatutDossier;
import com.mada.visa_mg.entity.ref.TypeDemande;
import com.mada.visa_mg.entity.ref.TypeIdentite;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "demande")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Dossier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "demandeur_id", nullable = false)
    private Demandeur demandeur;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "visa_transformable_id", nullable = false)
    private VisaTransformable visaTransformable;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "type_visa_id", nullable = false)
    private TypeIdentite typeIdentite;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "type_demande_id", nullable = false)
    private TypeDemande typeDemande;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "statut_demande_id", nullable = false)
    private StatutDossier statutDossier;

    @Column(name = "date_demande", nullable = false)
    private LocalDate dateDemande;

    @Column(name = "date_traitement")
    private LocalDate dateTraitement;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
