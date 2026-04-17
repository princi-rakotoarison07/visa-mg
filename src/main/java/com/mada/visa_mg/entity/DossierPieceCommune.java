package com.mada.visa_mg.entity;

import com.mada.visa_mg.entity.ref.StatutPiece;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "demande_piece_commune",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"demande_id", "catalogue_piece_id"})
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DossierPieceCommune {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "demande_id", nullable = false)
    private Dossier dossier;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "catalogue_piece_id", nullable = false)
    private CataloguePieceCommune cataloguePiece;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "statut_piece_id", nullable = false)
    private StatutPiece statutPiece;

    @Column(name = "fichier_path", length = 500)
    private String fichierPath;

    @Column(name = "date_fourniture")
    private LocalDateTime dateFourniture;
}
