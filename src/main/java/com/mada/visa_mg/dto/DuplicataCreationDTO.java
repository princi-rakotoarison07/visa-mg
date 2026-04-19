package com.mada.visa_mg.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;

@Data
public class DuplicataCreationDTO {

    @NotNull
    private Integer demandeurId;

    @NotNull
    private Integer visaTransformableId;

    @NotNull
    private Integer typeIdentiteId;

    @NotNull
    private String typeDocument; // "VISA" ou "CARTE_RESIDENT"

    @NotNull
    private String referenceDocument;

    @NotNull
    private LocalDate dateDebutDocument;

    @NotNull
    private LocalDate dateFinDocument;
}
