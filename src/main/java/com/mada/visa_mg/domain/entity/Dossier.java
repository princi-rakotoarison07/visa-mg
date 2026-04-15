package com.mada.visa_mg.domain.entity;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.mada.visa_mg.domain.enums.StatutDossier;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "dossier")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Dossier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "personne_id", nullable = false)
    private Personne personne;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "type_identite_id", nullable = false)
    private TypeIdentite typeIdentite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "visa_transformable_id")
    private VisaTransformable visaTransformable;

    @Column(nullable = false)
    private StatutDossier statut = StatutDossier.BROUILLON;

    @Column(name = "created_at", nullable = false)
    private LocalDate createdAt = LocalDate.now();
}
