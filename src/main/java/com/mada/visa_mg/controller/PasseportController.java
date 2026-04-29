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

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/passeports")
public class PasseportController {

    private final PasseportRepository passeportRepository;
    private final DemandeurRepository demandeurRepository;
    private final NationaliteRepository nationaliteRepository;
    private final com.mada.visa_mg.repository.VisaRepository visaRepository;
    private final com.mada.visa_mg.repository.CarteResidentRepository carteResidentRepository;

    public PasseportController(
            PasseportRepository passeportRepository,
            DemandeurRepository demandeurRepository,
            NationaliteRepository nationaliteRepository,
            com.mada.visa_mg.repository.VisaRepository visaRepository,
            com.mada.visa_mg.repository.CarteResidentRepository carteResidentRepository
    ) {
        this.passeportRepository = passeportRepository;
        this.demandeurRepository = demandeurRepository;
        this.nationaliteRepository = nationaliteRepository;
        this.visaRepository = visaRepository;
        this.carteResidentRepository = carteResidentRepository;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Passeport create(@Valid @RequestBody PasseportDTO dto) {
        Demandeur demandeur = demandeurRepository.findById(dto.getDemandeurId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "demandeurId invalide"));

        Nationalite paysDelivrance = nationaliteRepository.findById(dto.getPaysDelivranceId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "paysDelivranceId invalide"));

        // Empêcher la duplication par numéro de passeport
        java.util.Optional<Passeport> existingByNumero = passeportRepository.findByNumeroPasseport(dto.getNumeroPasseport());
        if (existingByNumero.isPresent()) {
            return existingByNumero.get();
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

    @GetMapping("/search")
    public List<PasseportSearchDTO> search(@RequestParam(name = "query", required = false, defaultValue = "") String query) {
        return passeportRepository.findByNumeroPasseportContainingIgnoreCase(query)
                .stream()
                .map(p -> new PasseportSearchDTO(p.getId(), p.getNumeroPasseport()))
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    public Passeport getById(@PathVariable Integer id) {
        return passeportRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Passeport introuvable"));
    }

    @GetMapping("/{id}/visas")
    public List<VisaDTO> getVisasByPasseport(@PathVariable Integer id) {
        return visaRepository.findByPasseportId(id).stream()
                .map(v -> new VisaDTO(v.getId(), v.getReference(), v.getDateDebut(), v.getDateFin()))
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}/cartes")
    public List<CarteDTO> getCartesByPasseport(@PathVariable Integer id) {
        return carteResidentRepository.findByPasseportId(id).stream()
                .map(c -> new CarteDTO(c.getId(), c.getReference(), c.getDateDebut(), c.getDateFin()))
                .collect(Collectors.toList());
    }

    public static class PasseportSearchDTO {
        private Integer id;
        private String numeroPasseport;

        public PasseportSearchDTO(Integer id, String numeroPasseport) {
            this.id = id;
            this.numeroPasseport = numeroPasseport;
        }

        public Integer getId() {
            return id;
        }

        public String getNumeroPasseport() {
            return numeroPasseport;
        }
    }

    public static class VisaDTO {
        private Integer id;
        private String reference;
        private java.time.LocalDate dateDebut;
        private java.time.LocalDate dateFin;

        public VisaDTO(Integer id, String reference, java.time.LocalDate dateDebut, java.time.LocalDate dateFin) {
            this.id = id;
            this.reference = reference;
            this.dateDebut = dateDebut;
            this.dateFin = dateFin;
        }

        // getters
        public Integer getId() { return id; }
        public String getReference() { return reference; }
        public java.time.LocalDate getDateDebut() { return dateDebut; }
        public java.time.LocalDate getDateFin() { return dateFin; }
    }

    public static class CarteDTO {
        private Integer id;
        private String reference;
        private java.time.LocalDate dateDebut;
        private java.time.LocalDate dateFin;

        public CarteDTO(Integer id, String reference, java.time.LocalDate dateDebut, java.time.LocalDate dateFin) {
            this.id = id;
            this.reference = reference;
            this.dateDebut = dateDebut;
            this.dateFin = dateFin;
        }

        // getters
        public Integer getId() { return id; }
        public String getReference() { return reference; }
        public java.time.LocalDate getDateDebut() { return dateDebut; }
        public java.time.LocalDate getDateFin() { return dateFin; }
    }
}
