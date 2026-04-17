package com.mada.visa_mg.entity.ref;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "type_visa")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TypeIdentite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 50)
    private String code;

    @Column(nullable = false, length = 100)
    private String libelle;
}
