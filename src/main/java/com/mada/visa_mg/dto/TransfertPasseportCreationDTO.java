package com.mada.visa_mg.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class TransfertPasseportCreationDTO {

    @NotNull
    private Integer demandeurId;

    @NotNull
    private Integer ancienPasseportId;

    @NotNull
    private Integer nouveauPasseportId;

    @NotNull
    private Integer typeIdentiteId;

    // Liste des IDs spécifiques à transférer
    private List<Integer> visasAUpdater;
    private List<Integer> cartesAUpdater;

    // Liste optionnelle de documents (Visa et/ou Carte Résident) à créer lors du transfert
    private List<DocumentTransfertDTO> documents;

    @Data
    public static class DocumentTransfertDTO {
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
