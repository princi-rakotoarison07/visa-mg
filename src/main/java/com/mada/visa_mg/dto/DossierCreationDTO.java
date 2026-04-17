package com.mada.visa_mg.dto;

import jakarta.validation.constraints.NotNull;

public class DossierCreationDTO {

    @NotNull
    private Integer demandeurId;

    @NotNull
    private Integer visaTransformableId;

    @NotNull
    private Integer typeIdentiteId;

    @NotNull
    private Integer typeDemandeId;

    public Integer getDemandeurId() {
        return demandeurId;
    }

    public void setDemandeurId(Integer demandeurId) {
        this.demandeurId = demandeurId;
    }

    public Integer getVisaTransformableId() {
        return visaTransformableId;
    }

    public void setVisaTransformableId(Integer visaTransformableId) {
        this.visaTransformableId = visaTransformableId;
    }

    public Integer getTypeIdentiteId() {
        return typeIdentiteId;
    }

    public void setTypeIdentiteId(Integer typeIdentiteId) {
        this.typeIdentiteId = typeIdentiteId;
    }

    public Integer getTypeDemandeId() {
        return typeDemandeId;
    }

    public void setTypeDemandeId(Integer typeDemandeId) {
        this.typeDemandeId = typeDemandeId;
    }
}
