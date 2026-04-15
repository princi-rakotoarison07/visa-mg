package com.mada.visa_mg.web.dto;

import java.time.LocalDate;

public record PersonneResponse(
        Long id,
        String nom,
        String prenom,
        LocalDate dateNaissance,
        String nationalite,
        String email,
        String telephone,
        String adresseMada
) {
}
