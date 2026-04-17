package com.mada.visa_mg.entity.ref;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "statut_passeport")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StatutPasseport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 30)
    private String code;

    @Column(nullable = false, length = 80)
    private String libelle;
}
