package com.mada.visa_mg.web.dto;

import jakarta.validation.constraints.NotNull;

public record DossierCreateRequest(
        @NotNull Long personneId,
        @NotNull Long typeIdentiteId
) {
}
