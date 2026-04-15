package com.mada.visa_mg.web.dto;

import java.time.LocalDate;

import com.mada.visa_mg.domain.enums.StatutDossier;

public record DossierResponse(
        Long id,
        Long personneId,
        Long typeIdentiteId,
        Long visaTransformableId,
        StatutDossier statut,
        LocalDate createdAt
) {
}
