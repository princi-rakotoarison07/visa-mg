package com.mada.visa_mg.entity;

import com.mada.visa_mg.entity.ref.TypeIdentite;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
        name = "catalogue_piece_complementaire",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"type_visa_id", "code"})
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CataloguePieceComplementaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "type_visa_id", nullable = false)
    private TypeIdentite typeIdentite;

    @Column(nullable = false, length = 80)
    private String code;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String libelle;

    @Column(name = "est_obligatoire", nullable = false)
    private Boolean estObligatoire;
}
