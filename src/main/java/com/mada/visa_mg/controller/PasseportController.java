package com.mada.visa_mg.controller;

import com.mada.visa_mg.dto.PasseportDTO;
import com.mada.visa_mg.entity.Demandeur;
import com.mada.visa_mg.entity.Passeport;
import com.mada.visa_mg.entity.ref.Nationalite;
import com.mada.visa_mg.repository.DemandeurRepository;
import com.mada.visa_mg.repository.PasseportRepository;
import com.mada.visa_mg.repository.ref.NationaliteRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/passeports")
public class PasseportController {

    private final PasseportRepository passeportRepository;
    private final DemandeurRepository demandeurRepository;
    private final NationaliteRepository nationaliteRepository;

    public PasseportController(
            PasseportRepository passeportRepository,
            DemandeurRepository demandeurRepository,
            NationaliteRepository nationaliteRepository
    ) {
        this.passeportRepository = passeportRepository;
        this.demandeurRepository = demandeurRepository;
        this.nationaliteRepository = nationaliteRepository;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Passeport create(@Valid @RequestBody PasseportDTO dto) {
        Demandeur demandeur = demandeurRepository.findById(dto.getDemandeurId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "demandeurId invalide"));

        Nationalite paysDelivrance = nationaliteRepository.findById(dto.getPaysDelivranceId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "paysDelivranceId invalide"));

        // Vérifier si un passeport existe déjà pour ce demandeur
        java.util.Optional<Passeport> existingPasseport = passeportRepository.findAll().stream()
                .filter(p -> p.getDemandeur().getId().equals(demandeur.getId()))
                .findFirst();
                
        if (existingPasseport.isPresent()) {
            return existingPasseport.get();
        }

        Passeport passeport = Passeport.builder()
                .demandeur(demandeur)
                .numeroPasseport(dto.getNumeroPasseport())
                .paysDelivrance(paysDelivrance)
                .dateDelivrance(dto.getDateDelivrance())
                .dateExpiration(dto.getDateExpiration())
                .build();

        return passeportRepository.save(passeport);
    }
}
