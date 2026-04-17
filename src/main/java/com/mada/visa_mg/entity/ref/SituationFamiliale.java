package com.mada.visa_mg.entity.ref;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "situation_familiale")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SituationFamiliale {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 100)
    private String libelle;
}
