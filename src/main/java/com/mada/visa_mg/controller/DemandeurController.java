package com.mada.visa_mg.controller;

import com.mada.visa_mg.dto.DemandeurDTO;
import com.mada.visa_mg.entity.Demandeur;
import com.mada.visa_mg.entity.ref.Nationalite;
import com.mada.visa_mg.entity.ref.SituationFamiliale;
import com.mada.visa_mg.repository.DemandeurRepository;
import com.mada.visa_mg.repository.ref.NationaliteRepository;
import com.mada.visa_mg.repository.ref.SituationFamilialeRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/demandeurs")
public class DemandeurController {

    private final DemandeurRepository demandeurRepository;
    private final NationaliteRepository nationaliteRepository;
    private final SituationFamilialeRepository situationFamilialeRepository;

    public DemandeurController(
            DemandeurRepository demandeurRepository,
            NationaliteRepository nationaliteRepository,
            SituationFamilialeRepository situationFamilialeRepository
    ) {
        this.demandeurRepository = demandeurRepository;
        this.nationaliteRepository = nationaliteRepository;
        this.situationFamilialeRepository = situationFamilialeRepository;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Demandeur create(@Valid @RequestBody DemandeurDTO dto) {
        Nationalite nationalite = nationaliteRepository.findById(dto.getNationaliteId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "nationaliteId invalide"));

        SituationFamiliale situationFamiliale = situationFamilialeRepository.findById(dto.getSituationFamilialeId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "situationFamilialeId invalide"));

        Demandeur demandeur = Demandeur.builder()
                .nom(dto.getNom())
                .prenom(dto.getPrenom())
                .dateNaissance(dto.getDateNaissance())
                .lieuNaissance(dto.getLieuNaissance())
                .telephone(dto.getTelephone())
                .email(dto.getEmail())
                .adresse(dto.getAdresse())
                .nationalite(nationalite)
                .situationFamiliale(situationFamiliale)
                .createdAt(LocalDateTime.now())
                .build();

        return demandeurRepository.save(demandeur);
    }

    @GetMapping("/{id}")
    public Demandeur getById(@PathVariable Integer id) {
        return demandeurRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Demandeur introuvable"));
    }
}
