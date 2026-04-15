package com.mada.visa_mg.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mada.visa_mg.domain.entity.Personne;
import com.mada.visa_mg.repository.PersonneRepository;

@Service
@Transactional
public class PersonneService {

    private final PersonneRepository personneRepository;

    public PersonneService(PersonneRepository personneRepository) {
        this.personneRepository = personneRepository;
    }

    public Personne create(Personne personne) {
        personne.setId(null);
        return personneRepository.save(personne);
    }

    @Transactional(readOnly = true)
    public List<Personne> findAll() {
        return personneRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Personne findById(Long id) {
        return personneRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Personne introuvable: id=" + id));
    }
}
