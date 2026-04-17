package com.mada.visa_mg.controller;

import com.mada.visa_mg.entity.ref.Nationalite;
import com.mada.visa_mg.entity.ref.SituationFamiliale;
import com.mada.visa_mg.entity.ref.TypeIdentite;
import com.mada.visa_mg.repository.ref.NationaliteRepository;
import com.mada.visa_mg.repository.ref.SituationFamilialeRepository;
import com.mada.visa_mg.repository.ref.TypeIdentiteRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ref")
public class RefDataController {

    private final NationaliteRepository nationaliteRepository;
    private final SituationFamilialeRepository situationFamilialeRepository;
    private final TypeIdentiteRepository typeIdentiteRepository;

    public RefDataController(
            NationaliteRepository nationaliteRepository,
            SituationFamilialeRepository situationFamilialeRepository,
            TypeIdentiteRepository typeIdentiteRepository
    ) {
        this.nationaliteRepository = nationaliteRepository;
        this.situationFamilialeRepository = situationFamilialeRepository;
        this.typeIdentiteRepository = typeIdentiteRepository;
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
}
