package com.mada.visa_mg.entity;

import com.mada.visa_mg.entity.ref.StatutDossier;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "demande_statut_historique")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DossierStatutHistorique {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "demande_id", nullable = false)
    private Dossier dossier;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "statut_demande_id", nullable = false)
    private StatutDossier statutDossier;

    @Column(name = "date_changement_statut", nullable = false)
    private LocalDateTime dateChangementStatut;

    @Column(columnDefinition = "TEXT")
    private String commentaire;

    @Column(name = "changed_by", length = 100)
    private String changedBy;
}
