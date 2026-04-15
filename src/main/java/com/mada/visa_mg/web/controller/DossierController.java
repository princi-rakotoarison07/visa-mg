package com.mada.visa_mg.web.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.mada.visa_mg.domain.entity.Dossier;
import com.mada.visa_mg.service.DossierService;
import com.mada.visa_mg.web.dto.DossierCreateRequest;
import com.mada.visa_mg.web.dto.DossierResponse;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/dossiers")
public class DossierController {

    private final DossierService dossierService;

    public DossierController(DossierService dossierService) {
        this.dossierService = dossierService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public DossierResponse create(@Valid @RequestBody DossierCreateRequest request) {
        Dossier saved = dossierService.create(request.personneId(), request.typeIdentiteId());
        return toResponse(saved);
    }

    @GetMapping
    public List<DossierResponse> list() {
        return dossierService.findAll().stream().map(this::toResponse).toList();
    }

    @GetMapping("/{id}")
    public DossierResponse get(@PathVariable Long id) {
        return toResponse(dossierService.findById(id));
    }

    private DossierResponse toResponse(Dossier d) {
        return new DossierResponse(
                d.getId(),
                d.getPersonne().getId(),
                d.getTypeIdentite().getId(),
                d.getVisaTransformable() == null ? null : d.getVisaTransformable().getId(),
                d.getStatut(),
                d.getCreatedAt()
        );
    }
}
