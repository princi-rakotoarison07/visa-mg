package com.mada.visa_mg.domain.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(
        name = "catalogue_piece_complementaire",
        uniqueConstraints = @UniqueConstraint(columnNames = {"type_identite_id", "code"})
)
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class CataloguePieceComplementaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "type_identite_id", nullable = false)
    private TypeIdentite typeIdentite;

    @Column(nullable = false, length = 80)
    private String code;

    @Column(nullable = false, columnDefinition = "text")
    private String libelle;

    @Column(nullable = false)
    private Integer ordre = 0;
}
