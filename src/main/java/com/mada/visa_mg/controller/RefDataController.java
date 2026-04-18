package com.mada.visa_mg.controller;

import com.mada.visa_mg.entity.ref.Nationalite;
import com.mada.visa_mg.entity.ref.SituationFamiliale;
import com.mada.visa_mg.entity.ref.TypeIdentite;
import com.mada.visa_mg.repository.ref.NationaliteRepository;
import com.mada.visa_mg.repository.ref.SituationFamilialeRepository;
import com.mada.visa_mg.repository.ref.TypeIdentiteRepository;
import org.springframework.web.bind.annotation.*;

import com.mada.visa_mg.entity.CataloguePieceCommune;
import com.mada.visa_mg.entity.CataloguePieceComplementaire;
import com.mada.visa_mg.repository.CataloguePieceCommuneRepository;
import com.mada.visa_mg.repository.CataloguePieceComplementaireRepository;

import java.util.List;

@RestController
@RequestMapping("/api/ref")
public class RefDataController {

    private final NationaliteRepository nationaliteRepository;
    private final SituationFamilialeRepository situationFamilialeRepository;
    private final TypeIdentiteRepository typeIdentiteRepository;
    private final CataloguePieceCommuneRepository cataloguePieceCommuneRepository;
    private final CataloguePieceComplementaireRepository cataloguePieceComplementaireRepository;

    public RefDataController(
            NationaliteRepository nationaliteRepository,
            SituationFamilialeRepository situationFamilialeRepository,
            TypeIdentiteRepository typeIdentiteRepository,
            CataloguePieceCommuneRepository cataloguePieceCommuneRepository,
            CataloguePieceComplementaireRepository cataloguePieceComplementaireRepository
    ) {
        this.nationaliteRepository = nationaliteRepository;
        this.situationFamilialeRepository = situationFamilialeRepository;
        this.typeIdentiteRepository = typeIdentiteRepository;
        this.cataloguePieceCommuneRepository = cataloguePieceCommuneRepository;
        this.cataloguePieceComplementaireRepository = cataloguePieceComplementaireRepository;
    }

    @GetMapping("/nationalites")
    public List<Nationalite> getNationalites() {
        return nationaliteRepository.findAll();
    }

    @GetMapping("/situations-familiales")
    public List<SituationFamiliale> getSituationsFamiliales() {
        return situationFamilialeRepository.findAll();
    }

    @GetMapping("/types-identite")
    public List<TypeIdentite> getTypesIdentite() {
        return typeIdentiteRepository.findAll();
    }

    @GetMapping("/pieces-communes")
    public List<CataloguePieceCommune> getPiecesCommunes() {
        return cataloguePieceCommuneRepository.findAll();
    }

    @GetMapping("/pieces-complementaires")
    public List<CataloguePieceComplementaire> getPiecesComplementaires() {
        return cataloguePieceComplementaireRepository.findAll();
    }
}
