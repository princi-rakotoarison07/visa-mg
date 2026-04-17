package com.mada.visa_mg.controller;

import com.mada.visa_mg.dto.DossierCreationDTO;
import com.mada.visa_mg.dto.DossierListDTO;
import com.mada.visa_mg.dto.DossierPiecesDTO;
import com.mada.visa_mg.entity.*;
import com.mada.visa_mg.entity.ref.StatutDossier;
import com.mada.visa_mg.entity.ref.StatutPiece;
import com.mada.visa_mg.entity.ref.TypeDemande;
import com.mada.visa_mg.entity.ref.TypeIdentite;
import com.mada.visa_mg.repository.*;
import com.mada.visa_mg.repository.ref.StatutDossierRepository;
import com.mada.visa_mg.repository.ref.StatutPieceRepository;
import com.mada.visa_mg.repository.ref.TypeDemandeRepository;
import com.mada.visa_mg.repository.ref.TypeIdentiteRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

@RestController
@RequestMapping("/api/dossiers")
public class DossierController {

    private final DossierRepository dossierRepository;
    private final DemandeurRepository demandeurRepository;
    private final VisaTransformableRepository visaTransformableRepository;
    private final TypeIdentiteRepository typeIdentiteRepository;
    private final TypeDemandeRepository typeDemandeRepository;
    private final StatutDossierRepository statutDossierRepository;
    private final CataloguePieceCommuneRepository cataloguePieceCommuneRepository;
    private final CataloguePieceComplementaireRepository cataloguePieceComplementaireRepository;
    private final StatutPieceRepository statutPieceRepository;
    private final DossierPieceCommuneRepository dossierPieceCommuneRepository;
    private final DossierPieceComplementaireRepository dossierPieceComplementaireRepository;

    public DossierController(
            DossierRepository dossierRepository,
            DemandeurRepository demandeurRepository,
            VisaTransformableRepository visaTransformableRepository,
            TypeIdentiteRepository typeIdentiteRepository,
            TypeDemandeRepository typeDemandeRepository,
            StatutDossierRepository statutDossierRepository,
            CataloguePieceCommuneRepository cataloguePieceCommuneRepository,
            CataloguePieceComplementaireRepository cataloguePieceComplementaireRepository,
            StatutPieceRepository statutPieceRepository,
            DossierPieceCommuneRepository dossierPieceCommuneRepository,
            DossierPieceComplementaireRepository dossierPieceComplementaireRepository
    ) {
        this.dossierRepository = dossierRepository;
        this.demandeurRepository = demandeurRepository;
        this.visaTransformableRepository = visaTransformableRepository;
        this.typeIdentiteRepository = typeIdentiteRepository;
        this.typeDemandeRepository = typeDemandeRepository;
        this.statutDossierRepository = statutDossierRepository;
        this.cataloguePieceCommuneRepository = cataloguePieceCommuneRepository;
        this.cataloguePieceComplementaireRepository = cataloguePieceComplementaireRepository;
        this.statutPieceRepository = statutPieceRepository;
        this.dossierPieceCommuneRepository = dossierPieceCommuneRepository;
        this.dossierPieceComplementaireRepository = dossierPieceComplementaireRepository;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Dossier create(@Valid @RequestBody DossierCreationDTO dto) {
        Demandeur demandeur = demandeurRepository.findById(dto.getDemandeurId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "demandeurId invalide"));

        VisaTransformable visaTransformable = visaTransformableRepository.findById(dto.getVisaTransformableId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "visaTransformableId invalide"));

        TypeIdentite typeIdentite = typeIdentiteRepository.findById(dto.getTypeIdentiteId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "typeIdentiteId invalide"));

        TypeDemande typeDemande = typeDemandeRepository.findById(dto.getTypeDemandeId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "typeDemandeId invalide"));

        StatutDossier creer = statutDossierRepository.findByCode("CREER")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut CREER manquant"));

        LocalDateTime now = LocalDateTime.now();

        Dossier dossier = Dossier.builder()
                .demandeur(demandeur)
                .visaTransformable(visaTransformable)
                .typeIdentite(typeIdentite)
                .typeDemande(typeDemande)
                .statutDossier(creer)
                .dateDemande(LocalDate.now())
                .createdAt(now)
                .updatedAt(now)
                .build();

        dossier = dossierRepository.save(dossier);

        StatutPiece nonFourni = statutPieceRepository.findByCode("NON_FOURNI")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece NON_FOURNI manquant"));

        List<CataloguePieceCommune> piecesCommunes = cataloguePieceCommuneRepository.findAll();
        for (CataloguePieceCommune cat : piecesCommunes) {
            DossierPieceCommune piece = DossierPieceCommune.builder()
                    .dossier(dossier)
                    .cataloguePiece(cat)
                    .statutPiece(nonFourni)
                    .build();
            dossierPieceCommuneRepository.save(piece);
        }

        List<CataloguePieceComplementaire> piecesComp = cataloguePieceComplementaireRepository.findAll();
        for (CataloguePieceComplementaire cat : piecesComp) {
            if (cat.getTypeIdentite() != null && cat.getTypeIdentite().getId().equals(typeIdentite.getId())) {
                DossierPieceComplementaire piece = DossierPieceComplementaire.builder()
                        .dossier(dossier)
                        .catalogueComplementaire(cat)
                        .statutPiece(nonFourni)
                        .build();
                dossierPieceComplementaireRepository.save(piece);
            }
        }

        return dossier;
    }

    @GetMapping("/{id}/pieces")
    public DossierPiecesDTO getPieces(@PathVariable Integer id) {
        if (!dossierRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Dossier introuvable");
        }

        List<DossierPieceCommune> communes = dossierPieceCommuneRepository.findByDossierId(id);
        List<DossierPieceComplementaire> complementaires = dossierPieceComplementaireRepository.findByDossierId(id);

        return new DossierPiecesDTO(communes, complementaires);
    }

    @GetMapping
    public List<DossierListDTO> getAllDossiers() {
        List<DossierListDTO> result = new ArrayList<>();
        
        List<Dossier> dossiers = dossierRepository.findAll();
        for (Dossier d : dossiers) {
            result.add(DossierListDTO.builder()
                .id(d.getId())
                .demandeur(d.getDemandeur())
                .createdAt(d.getCreatedAt())
                .statutCode(d.getStatutDossier().getCode())
                .statutLibelle(d.getStatutDossier().getLibelle())
                .build()
            );
        }

        // Identifier les brouillons (Demandeurs qui n'ont pas encore de dossier complet)
        List<Demandeur> demandeurs = demandeurRepository.findAll();
        for (Demandeur dem : demandeurs) {
            boolean hasDossier = dossiers.stream().anyMatch(d -> d.getDemandeur().getId().equals(dem.getId()));
            if (!hasDossier) {
                // Vérifier si le demandeur a au moins un Visa
                boolean hasVisa = visaTransformableRepository.findAll().stream()
                        .anyMatch(v -> v.getDemandeur().getId().equals(dem.getId()));
                
                if (hasVisa) {
                    result.add(DossierListDTO.builder()
                        .id(dem.getId()) // ID du demandeur servant de référence
                        .demandeur(dem)
                        .createdAt(dem.getCreatedAt())
                        .statutCode("BROUILLON")
                        .statutLibelle("Brouillon (Étape 3)")
                        .stepToContinue(3)
                        .build()
                    );
                } else {
                    result.add(DossierListDTO.builder()
                        .id(dem.getId()) // ID du demandeur
                        .demandeur(dem)
                        .createdAt(dem.getCreatedAt())
                        .statutCode("BROUILLON")
                        .statutLibelle("Brouillon (Étape 2)")
                        .stepToContinue(2)
                        .build()
                    );
                }
            }
        }
        return result;
    }
}
