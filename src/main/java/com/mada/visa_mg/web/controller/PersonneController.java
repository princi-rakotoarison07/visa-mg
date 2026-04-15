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

import com.mada.visa_mg.domain.entity.Personne;
import com.mada.visa_mg.service.PersonneService;
import com.mada.visa_mg.web.dto.PersonneCreateRequest;
import com.mada.visa_mg.web.dto.PersonneResponse;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/personnes")
public class PersonneController {

    private final PersonneService personneService;

    public PersonneController(PersonneService personneService) {
        this.personneService = personneService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public PersonneResponse create(@Valid @RequestBody PersonneCreateRequest request) {
        Personne p = new Personne();
        p.setNom(request.nom());
        p.setPrenom(request.prenom());
        p.setDateNaissance(request.dateNaissance());
        p.setNationalite(request.nationalite());
        p.setEmail(request.email());
        p.setTelephone(request.telephone());
        p.setAdresseMada(request.adresseMada());

        Personne saved = personneService.create(p);
        return toResponse(saved);
    }

    @GetMapping
    public List<PersonneResponse> list() {
        return personneService.findAll().stream().map(this::toResponse).toList();
    }

    @GetMapping("/{id}")
    public PersonneResponse get(@PathVariable Long id) {
        return toResponse(personneService.findById(id));
    }

    private PersonneResponse toResponse(Personne p) {
        return new PersonneResponse(
                p.getId(),
                p.getNom(),
                p.getPrenom(),
                p.getDateNaissance(),
                p.getNationalite(),
                p.getEmail(),
                p.getTelephone(),
                p.getAdresseMada()
        );
    }
}
