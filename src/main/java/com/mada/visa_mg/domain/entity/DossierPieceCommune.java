package com.mada.visa_mg.domain.entity;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.mada.visa_mg.domain.enums.StatutPiece;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(
        name = "dossier_piece_commune",
        uniqueConstraints = @UniqueConstraint(columnNames = {"dossier_id", "catalogue_piece_id"})
)
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class DossierPieceCommune {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "dossier_id", nullable = false)
    private Dossier dossier;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "catalogue_piece_id", nullable = false)
    private CataloguePieceCommune cataloguePiece;

    @Column(nullable = false)
    private StatutPiece statut = StatutPiece.NON_FOURNI;

    @Column(name = "date_fourniture")
    private LocalDate dateFourniture;
}
