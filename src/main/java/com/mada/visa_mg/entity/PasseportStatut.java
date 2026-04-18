package com.mada.visa_mg.entity;

import com.mada.visa_mg.entity.ref.StatutPasseport;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "passeport_statut")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PasseportStatut {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "passeport_id", nullable = false)
    private Passeport passeport;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "statut_passeport_id", nullable = false)
    private StatutPasseport statutPasseport;

    @Column(name = "date_changement_statut", nullable = false)
    private LocalDateTime dateChangementStatut;

    @Column(columnDefinition = "TEXT")
    private String commentaire;
}
