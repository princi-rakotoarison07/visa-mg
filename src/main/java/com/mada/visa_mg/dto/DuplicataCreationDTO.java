package com.mada.visa_mg.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Data
public class DuplicataCreationDTO {

    @NotNull
    private Integer demandeurId;

    @NotNull
    private Integer visaTransformableId;

    @NotNull
    private Integer typeIdentiteId;

    // Liste des documents à récupérer (Visa et/ou Carte Résident)
    @NotEmpty
    @Valid
    private List<DocumentDuplicataDTO> documents;

    // Map : catalogueComplementaireId -> fichierPath (retourné par /api/uploads)
    private Map<Integer, String> piecesComplementairesFichiers;

    @Data
    public static class DocumentDuplicataDTO {
        @NotNull
        private String typeDocument; // "VISA" ou "CARTE_RESIDENT"

        @NotNull
        private String referenceDocument;

        @NotNull
        private LocalDate dateDebutDocument;

        @NotNull
        private LocalDate dateFinDocument;
    }
}
