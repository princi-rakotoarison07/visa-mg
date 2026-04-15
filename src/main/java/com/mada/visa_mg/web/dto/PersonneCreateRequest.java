package com.mada.visa_mg.web.dto;

import java.time.LocalDate;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record PersonneCreateRequest(
        @NotBlank String nom,
        @NotBlank String prenom,
        @NotNull LocalDate dateNaissance,
        @NotBlank String nationalite,
        String email,
        String telephone,
        String adresseMada
) {
}
