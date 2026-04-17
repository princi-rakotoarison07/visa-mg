package com.mada.visa_mg.entity;

import com.mada.visa_mg.entity.ref.Nationalite;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "passeport")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Passeport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "demandeur_id", nullable = false)
    private Demandeur demandeur;

    @Column(name = "numero_passeport", nullable = false, unique = true, length = 50)
    private String numeroPasseport;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "pays_delivrance_id", nullable = false)
    private Nationalite paysDelivrance;

    @Column(name = "date_delivrance", nullable = false)
    private LocalDate dateDelivrance;

    @Column(name = "date_expiration", nullable = false)
    private LocalDate dateExpiration;
}
