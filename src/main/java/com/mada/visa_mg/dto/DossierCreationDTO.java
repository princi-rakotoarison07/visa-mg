package com.mada.visa_mg.dto;

import jakarta.validation.constraints.NotNull;

import java.util.List;

public class DossierCreationDTO {

    @NotNull
    private Integer demandeurId;

    @NotNull
    private Integer visaTransformableId;

    @NotNull
    private Integer typeIdentiteId;

    @NotNull
    private Integer typeDemandeId;

    // catalogue_piece_commune.id cochés (si null/absent: on considère tout coché)
    private List<Integer> piecesCommunesCochees;

    // catalogue_piece_complementaire.id cochés (si null/absent: on considère tout coché)
    private List<Integer> piecesComplementairesCochees;

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

    public List<Integer> getPiecesCommunesCochees() {
        return piecesCommunesCochees;
    }

    public void setPiecesCommunesCochees(List<Integer> piecesCommunesCochees) {
        this.piecesCommunesCochees = piecesCommunesCochees;
    }

    public List<Integer> getPiecesComplementairesCochees() {
        return piecesComplementairesCochees;
    }

    public void setPiecesComplementairesCochees(List<Integer> piecesComplementairesCochees) {
        this.piecesComplementairesCochees = piecesComplementairesCochees;
    }
}
