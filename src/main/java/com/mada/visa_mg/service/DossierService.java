package com.mada.visa_mg.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mada.visa_mg.domain.entity.Dossier;
import com.mada.visa_mg.domain.entity.Personne;
import com.mada.visa_mg.domain.entity.TypeIdentite;
import com.mada.visa_mg.repository.DossierRepository;
import com.mada.visa_mg.repository.PersonneRepository;
import com.mada.visa_mg.repository.TypeIdentiteRepository;

@Service
@Transactional
public class DossierService {

    private final DossierRepository dossierRepository;
    private final PersonneRepository personneRepository;
    private final TypeIdentiteRepository typeIdentiteRepository;

    public DossierService(
            DossierRepository dossierRepository,
            PersonneRepository personneRepository,
            TypeIdentiteRepository typeIdentiteRepository
    ) {
        this.dossierRepository = dossierRepository;
        this.personneRepository = personneRepository;
        this.typeIdentiteRepository = typeIdentiteRepository;
    }

    public Dossier create(Long personneId, Long typeIdentiteId) {
        Personne personne = personneRepository.findById(personneId)
                .orElseThrow(() -> new IllegalArgumentException("Personne introuvable: id=" + personneId));

        TypeIdentite typeIdentite = typeIdentiteRepository.findById(typeIdentiteId)
                .orElseThrow(() -> new IllegalArgumentException("TypeIdentite introuvable: id=" + typeIdentiteId));

        Dossier dossier = new Dossier();
        dossier.setPersonne(personne);
        dossier.setTypeIdentite(typeIdentite);
        return dossierRepository.save(dossier);
    }

    @Transactional(readOnly = true)
    public List<Dossier> findAll() {
        return dossierRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Dossier findById(Long id) {
        return dossierRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Dossier introuvable: id=" + id));
    }
}
