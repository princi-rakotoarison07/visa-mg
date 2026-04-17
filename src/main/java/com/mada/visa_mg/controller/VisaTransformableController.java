package com.mada.visa_mg.controller;

import com.mada.visa_mg.dto.VisaTransformableDTO;
import com.mada.visa_mg.entity.Demandeur;
import com.mada.visa_mg.entity.Passeport;
import com.mada.visa_mg.entity.VisaTransformable;
import com.mada.visa_mg.repository.DemandeurRepository;
import com.mada.visa_mg.repository.PasseportRepository;
import com.mada.visa_mg.repository.VisaTransformableRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/visas")
public class VisaTransformableController {

    private final VisaTransformableRepository visaTransformableRepository;
    private final DemandeurRepository demandeurRepository;
    private final PasseportRepository passeportRepository;

    public VisaTransformableController(
            VisaTransformableRepository visaTransformableRepository,
            DemandeurRepository demandeurRepository,
            PasseportRepository passeportRepository
    ) {
        this.visaTransformableRepository = visaTransformableRepository;
        this.demandeurRepository = demandeurRepository;
        this.passeportRepository = passeportRepository;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public VisaTransformable create(@Valid @RequestBody VisaTransformableDTO dto) {
        Demandeur demandeur = demandeurRepository.findById(dto.getDemandeurId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "demandeurId invalide"));

        Passeport passeport = passeportRepository.findById(dto.getPasseportId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "passeportId invalide"));

        VisaTransformable visa = VisaTransformable.builder()
                .demandeur(demandeur)
                .passeport(passeport)
                .numeroReference(dto.getNumeroReference())
                .lieuEntree(dto.getLieuEntree())
                .dateEntree(dto.getDateEntree())
                .dateSortieRef(dto.getDateSortieRef())
                .dateExpiration(dto.getDateExpiration())
                .build();

        return visaTransformableRepository.save(visa);
    }
}
