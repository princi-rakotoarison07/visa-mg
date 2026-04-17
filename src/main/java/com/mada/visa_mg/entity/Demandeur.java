package com.mada.visa_mg.entity;

import com.mada.visa_mg.entity.ref.Nationalite;
import com.mada.visa_mg.entity.ref.SituationFamiliale;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "demandeur")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Demandeur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false, length = 100)
    private String prenom;

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;

    @Column(name = "lieu_naissance", nullable = false, length = 150)
    private String lieuNaissance;

    @Column(nullable = false, length = 20)
    private String telephone;

    @Column(nullable = false, length = 100)
    private String email;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String adresse;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "nationalite_id", nullable = false)
    private Nationalite nationalite;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "situation_familiale_id", nullable = false)
    private SituationFamiliale situationFamiliale;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
}
