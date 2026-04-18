package com.mada.visa_mg.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public class PasseportDTO {

    @NotNull
    private Integer demandeurId;

    @NotBlank
    private String numeroPasseport;

    @NotNull
    private Integer paysDelivranceId;

    @NotNull
    private LocalDate dateDelivrance;

    @NotNull
    private LocalDate dateExpiration;

    public Integer getDemandeurId() {
        return demandeurId;
    }

    public void setDemandeurId(Integer demandeurId) {
        this.demandeurId = demandeurId;
    }

    public String getNumeroPasseport() {
        return numeroPasseport;
    }

    public void setNumeroPasseport(String numeroPasseport) {
        this.numeroPasseport = numeroPasseport;
    }

    public Integer getPaysDelivranceId() {
        return paysDelivranceId;
    }

    public void setPaysDelivranceId(Integer paysDelivranceId) {
        this.paysDelivranceId = paysDelivranceId;
    }

    public LocalDate getDateDelivrance() {
        return dateDelivrance;
    }

    public void setDateDelivrance(LocalDate dateDelivrance) {
        this.dateDelivrance = dateDelivrance;
    }

    public LocalDate getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(LocalDate dateExpiration) {
        this.dateExpiration = dateExpiration;
    }
}
