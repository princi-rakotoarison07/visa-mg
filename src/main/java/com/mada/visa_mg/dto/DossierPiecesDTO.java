package com.mada.visa_mg.dto;

import com.mada.visa_mg.entity.DossierPieceCommune;
import com.mada.visa_mg.entity.DossierPieceComplementaire;

import java.util.List;

public class DossierPiecesDTO {

    private List<DossierPieceCommune> piecesCommunes;
    private List<DossierPieceComplementaire> piecesComplementaires;

    public DossierPiecesDTO(List<DossierPieceCommune> piecesCommunes, List<DossierPieceComplementaire> piecesComplementaires) {
        this.piecesCommunes = piecesCommunes;
        this.piecesComplementaires = piecesComplementaires;
    }

    public List<DossierPieceCommune> getPiecesCommunes() {
        return piecesCommunes;
    }

    public void setPiecesCommunes(List<DossierPieceCommune> piecesCommunes) {
        this.piecesCommunes = piecesCommunes;
    }

    public List<DossierPieceComplementaire> getPiecesComplementaires() {
        return piecesComplementaires;
    }

    public void setPiecesComplementaires(List<DossierPieceComplementaire> piecesComplementaires) {
        this.piecesComplementaires = piecesComplementaires;
    }
}
