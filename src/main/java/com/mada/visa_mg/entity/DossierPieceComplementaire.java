package com.mada.visa_mg.entity;

import com.mada.visa_mg.entity.ref.StatutPiece;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "demande_piece_complementaire",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"demande_id", "catalogue_complementaire_id"})
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DossierPieceComplementaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "demande_id", nullable = false)
    private Dossier dossier;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "catalogue_complementaire_id", nullable = false)
    private CataloguePieceComplementaire catalogueComplementaire;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "statut_piece_id", nullable = false)
    private StatutPiece statutPiece;

    @Column(name = "fichier_path", length = 500)
    private String fichierPath;

    @Column(name = "date_fourniture")
    private LocalDateTime dateFourniture;
}
