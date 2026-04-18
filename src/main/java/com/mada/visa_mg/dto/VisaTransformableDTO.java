package com.mada.visa_mg.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public class VisaTransformableDTO {

    @NotNull
    private Integer demandeurId;

    @NotNull
    private Integer passeportId;

    private String numeroReference;

    @NotBlank
    private String lieuEntree;

    @NotNull
    private LocalDate dateEntree;

    private LocalDate dateSortieRef;

    @NotNull
    private LocalDate dateExpiration;

    public Integer getDemandeurId() {
        return demandeurId;
    }

    public void setDemandeurId(Integer demandeurId) {
        this.demandeurId = demandeurId;
    }

    public Integer getPasseportId() {
        return passeportId;
    }

    public void setPasseportId(Integer passeportId) {
        this.passeportId = passeportId;
    }

    public String getNumeroReference() {
        return numeroReference;
    }

    public void setNumeroReference(String numeroReference) {
        this.numeroReference = numeroReference;
    }

    public String getLieuEntree() {
        return lieuEntree;
    }

    public void setLieuEntree(String lieuEntree) {
        this.lieuEntree = lieuEntree;
    }

    public LocalDate getDateEntree() {
        return dateEntree;
    }

    public void setDateEntree(LocalDate dateEntree) {
        this.dateEntree = dateEntree;
    }

    public LocalDate getDateSortieRef() {
        return dateSortieRef;
    }

    public void setDateSortieRef(LocalDate dateSortieRef) {
        this.dateSortieRef = dateSortieRef;
    }

    public LocalDate getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(LocalDate dateExpiration) {
        this.dateExpiration = dateExpiration;
    }
}
