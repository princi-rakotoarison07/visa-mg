package com.mada.visa_mg.controller;

import com.mada.visa_mg.dto.DossierCreationDTO;
import com.mada.visa_mg.dto.DuplicataCreationDTO;
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
import java.util.HashSet;
import java.util.Set;

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
    private final VisaRepository visaRepository;
    private final CarteResidentRepository carteResidentRepository;

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
            DossierPieceComplementaireRepository dossierPieceComplementaireRepository,
            VisaRepository visaRepository,
            CarteResidentRepository carteResidentRepository
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
        this.visaRepository = visaRepository;
        this.carteResidentRepository = carteResidentRepository;
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

        StatutPiece nonApplicable = statutPieceRepository.findByCode("NON_APPLICABLE")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece NON_APPLICABLE manquant"));

        Set<Integer> communesCochees = dto.getPiecesCommunesCochees() == null
                ? null
                : new HashSet<>(dto.getPiecesCommunesCochees());

        Set<Integer> complementairesCochees = dto.getPiecesComplementairesCochees() == null
                ? null
                : new HashSet<>(dto.getPiecesComplementairesCochees());

        List<CataloguePieceCommune> piecesCommunes = cataloguePieceCommuneRepository.findAll();
        for (CataloguePieceCommune cat : piecesCommunes) {
            boolean isCochee = communesCochees == null || communesCochees.contains(cat.getId());
            DossierPieceCommune piece = DossierPieceCommune.builder()
                    .dossier(dossier)
                    .cataloguePiece(cat)
                    .statutPiece(isCochee ? nonFourni : nonApplicable)
                    .build();
            dossierPieceCommuneRepository.save(piece);
        }

        List<CataloguePieceComplementaire> piecesComp = cataloguePieceComplementaireRepository.findAll();
        for (CataloguePieceComplementaire cat : piecesComp) {
            if (cat.getTypeIdentite() != null && cat.getTypeIdentite().getId().equals(typeIdentite.getId())) {
                boolean isCochee = complementairesCochees == null || complementairesCochees.contains(cat.getId());
                DossierPieceComplementaire piece = DossierPieceComplementaire.builder()
                        .dossier(dossier)
                        .catalogueComplementaire(cat)
                        .statutPiece(isCochee ? nonFourni : nonApplicable)
                        .build();
                dossierPieceComplementaireRepository.save(piece);
            }
        }

        return dossier;
    }

    @PostMapping("/duplicata")
    @ResponseStatus(HttpStatus.CREATED)
    public Dossier createDuplicata(@Valid @RequestBody DuplicataCreationDTO dto) {
        Demandeur demandeur = demandeurRepository.findById(dto.getDemandeurId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "demandeurId invalide"));

        VisaTransformable visaTransformable = visaTransformableRepository.findById(dto.getVisaTransformableId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "visaTransformableId invalide"));

        TypeIdentite typeIdentite = typeIdentiteRepository.findById(dto.getTypeIdentiteId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "typeIdentiteId invalide"));

        TypeDemande duplicataType = typeDemandeRepository.findById(3) // 3 = DUPLICATA
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Type DUPLICATA manquant"));

        StatutDossier approuvee = statutDossierRepository.findByCode("APPROUVEE")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut APPROUVEE manquant"));

        LocalDateTime now = LocalDateTime.now();

        Dossier dossier = Dossier.builder()
                .demandeur(demandeur)
                .visaTransformable(visaTransformable)
                .typeIdentite(typeIdentite)
                .typeDemande(duplicataType)
                .statutDossier(approuvee)
                .dateDemande(LocalDate.now())
                .dateTraitement(LocalDate.now()) // Traité immédiatement
                .createdAt(now)
                .updatedAt(now)
                .build();

        dossier = dossierRepository.save(dossier);

        // Création des documents finaux (Visa et/ou Carte Résident)
        for (DuplicataCreationDTO.DocumentDuplicataDTO doc : dto.getDocuments()) {
            if ("VISA".equals(doc.getTypeDocument())) {
                Visa visa = Visa.builder()
                        .dossier(dossier)
                        .passeport(visaTransformable.getPasseport())
                        .reference(doc.getReferenceDocument())
                        .dateDebut(doc.getDateDebutDocument())
                        .dateFin(doc.getDateFinDocument())
                        .createdAt(now)
                        .build();
                visaRepository.save(visa);
            } else if ("CARTE_RESIDENT".equals(doc.getTypeDocument())) {
                CarteResident carte = CarteResident.builder()
                        .dossier(dossier)
                        .passeport(visaTransformable.getPasseport())
                        .reference(doc.getReferenceDocument())
                        .dateDebut(doc.getDateDebutDocument())
                        .dateFin(doc.getDateFinDocument())
                        .createdAt(now)
                        .build();
                carteResidentRepository.save(carte);
            }
        }

        // Statuts des pièces
        StatutPiece nonFourni = statutPieceRepository.findByCode("NON_FOURNI")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece NON_FOURNI manquant"));
        StatutPiece fourni = statutPieceRepository.findByCode("FOURNI")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece FOURNI manquant"));

        // Pièces communes (toujours NON_FOURNI à la création)
        List<CataloguePieceCommune> piecesCommunes = cataloguePieceCommuneRepository.findAll();
        for (CataloguePieceCommune cat : piecesCommunes) {
            DossierPieceCommune piece = DossierPieceCommune.builder()
                    .dossier(dossier)
                    .cataloguePiece(cat)
                    .statutPiece(nonFourni)
                    .build();
            dossierPieceCommuneRepository.save(piece);
        }

        // Pièces complémentaires : si un fichier a été uploadé, on met FOURNI + fichierPath
        java.util.Map<Integer, String> fichiers = dto.getPiecesComplementairesFichiers();

        List<CataloguePieceComplementaire> piecesComp = cataloguePieceComplementaireRepository.findAll();
        for (CataloguePieceComplementaire cat : piecesComp) {
            if (cat.getTypeIdentite() != null && cat.getTypeIdentite().getId().equals(typeIdentite.getId())) {
                boolean hasFichier = fichiers != null && fichiers.containsKey(cat.getId());
                DossierPieceComplementaire piece = DossierPieceComplementaire.builder()
                        .dossier(dossier)
                        .catalogueComplementaire(cat)
                        .statutPiece(hasFichier ? fourni : nonFourni)
                        .fichierPath(hasFichier ? fichiers.get(cat.getId()) : null)
                        .dateFourniture(hasFichier ? now : null)
                        .build();
                dossierPieceComplementaireRepository.save(piece);
            }
        }

        return dossier;
    }

    @GetMapping("/{id}")
    public Dossier getById(@PathVariable Integer id) {
        return dossierRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dossier introuvable"));
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
                java.util.Optional<VisaTransformable> optVisa = visaTransformableRepository.findAll().stream()
                        .filter(v -> v.getDemandeur().getId().equals(dem.getId()))
                        .findFirst();
                
                if (optVisa.isPresent()) {
                    result.add(DossierListDTO.builder()
                        .id(dem.getId()) // ID du demandeur servant de référence
                        .demandeur(dem)
                        .createdAt(dem.getCreatedAt())
                        .statutCode("BROUILLON")
                        .statutLibelle("Brouillon (Étape 3)")
                        .stepToContinue(3)
                        .visaIdToContinue(optVisa.get().getId())
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

    // ========== Upload pièce commune individuelle ==========
    @PutMapping("/{dossierId}/pieces-communes/{pieceId}/upload")
    public DossierPieceCommune uploadPieceCommune(
            @PathVariable Integer dossierId,
            @PathVariable Integer pieceId,
            @RequestBody java.util.Map<String, String> body) {

        DossierPieceCommune piece = dossierPieceCommuneRepository.findById(pieceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pièce commune introuvable"));

        if (!piece.getDossier().getId().equals(dossierId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "La pièce n'appartient pas à ce dossier");
        }

        StatutPiece fourni = statutPieceRepository.findByCode("FOURNI")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece FOURNI manquant"));

        piece.setStatutPiece(fourni);
        piece.setFichierPath(body.get("fichierPath"));
        piece.setDateFourniture(LocalDateTime.now());

        return dossierPieceCommuneRepository.save(piece);
    }

    // ========== Upload pièce complémentaire individuelle ==========
    @PutMapping("/{dossierId}/pieces-complementaires/{pieceId}/upload")
    public DossierPieceComplementaire uploadPieceComplementaire(
            @PathVariable Integer dossierId,
            @PathVariable Integer pieceId,
            @RequestBody java.util.Map<String, String> body) {

        DossierPieceComplementaire piece = dossierPieceComplementaireRepository.findById(pieceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pièce complémentaire introuvable"));

        if (!piece.getDossier().getId().equals(dossierId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "La pièce n'appartient pas à ce dossier");
        }

        StatutPiece fourni = statutPieceRepository.findByCode("FOURNI")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece FOURNI manquant"));

        piece.setStatutPiece(fourni);
        piece.setFichierPath(body.get("fichierPath"));
        piece.setDateFourniture(LocalDateTime.now());

        return dossierPieceComplementaireRepository.save(piece);
    }

    // ========== Scan terminé : changer statut si toutes les pièces sont fournies ==========
    @PutMapping("/{dossierId}/scan-terminer")
    public Dossier scanTerminer(@PathVariable Integer dossierId) {
        Dossier dossier = dossierRepository.findById(dossierId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dossier introuvable"));

        // Vérifier que toutes les pièces communes sont FOURNI
        List<DossierPieceCommune> communes = dossierPieceCommuneRepository.findByDossierId(dossierId);
        for (DossierPieceCommune pc : communes) {
            if ("NON_APPLICABLE".equals(pc.getStatutPiece().getCode())) {
                continue;
            }
            if (!"FOURNI".equals(pc.getStatutPiece().getCode())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Pièce commune non fournie : " + pc.getCataloguePiece().getLibelle());
            }
        }

        // Vérifier que toutes les pièces complémentaires sont FOURNI
        List<DossierPieceComplementaire> complementaires = dossierPieceComplementaireRepository.findByDossierId(dossierId);
        for (DossierPieceComplementaire pc : complementaires) {
            if ("NON_APPLICABLE".equals(pc.getStatutPiece().getCode())) {
                continue;
            }

            Boolean estObligatoire = pc.getCatalogueComplementaire() != null
                    ? pc.getCatalogueComplementaire().getEstObligatoire()
                    : Boolean.TRUE;

            // Si pièce complémentaire facultative, on ne bloque pas le scan même si non fournie
            if (Boolean.FALSE.equals(estObligatoire)) {
                continue;
            }

            if (!"FOURNI".equals(pc.getStatutPiece().getCode())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Pièce complémentaire non fournie : " + pc.getCatalogueComplementaire().getLibelle());
            }
        }

        StatutDossier scanTermine = statutDossierRepository.findByCode("SCAN_TERMINER")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut SCAN_TERMINER manquant"));

        dossier.setStatutDossier(scanTermine);
        dossier.setUpdatedAt(LocalDateTime.now());

        return dossierRepository.save(dossier);
    }

    // ========== Basculer applicabilité (coché / non coché) pièce commune ==========
    @PutMapping("/{dossierId}/pieces-communes/{pieceId}/applicable")
    public DossierPieceCommune setPieceCommuneApplicable(
            @PathVariable Integer dossierId,
            @PathVariable Integer pieceId,
            @RequestBody java.util.Map<String, Object> body) {

        DossierPieceCommune piece = dossierPieceCommuneRepository.findById(pieceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pièce commune introuvable"));

        if (!piece.getDossier().getId().equals(dossierId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "La pièce n'appartient pas à ce dossier");
        }

        boolean applicable = Boolean.TRUE.equals(body.get("applicable"));

        StatutPiece nonFourni = statutPieceRepository.findByCode("NON_FOURNI")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece NON_FOURNI manquant"));

        StatutPiece nonApplicable = statutPieceRepository.findByCode("NON_APPLICABLE")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece NON_APPLICABLE manquant"));

        if (applicable) {
            if ("NON_APPLICABLE".equals(piece.getStatutPiece().getCode())) {
                piece.setStatutPiece(nonFourni);
            }
        } else {
            piece.setStatutPiece(nonApplicable);
            piece.setFichierPath(null);
            piece.setDateFourniture(null);
        }

        return dossierPieceCommuneRepository.save(piece);
    }

    // ========== Basculer applicabilité (coché / non coché) pièce complémentaire ==========
    @PutMapping("/{dossierId}/pieces-complementaires/{pieceId}/applicable")
    public DossierPieceComplementaire setPieceComplementaireApplicable(
            @PathVariable Integer dossierId,
            @PathVariable Integer pieceId,
            @RequestBody java.util.Map<String, Object> body) {

        DossierPieceComplementaire piece = dossierPieceComplementaireRepository.findById(pieceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pièce complémentaire introuvable"));

        if (!piece.getDossier().getId().equals(dossierId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "La pièce n'appartient pas à ce dossier");
        }

        boolean applicable = Boolean.TRUE.equals(body.get("applicable"));

        StatutPiece nonFourni = statutPieceRepository.findByCode("NON_FOURNI")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece NON_FOURNI manquant"));

        StatutPiece nonApplicable = statutPieceRepository.findByCode("NON_APPLICABLE")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece NON_APPLICABLE manquant"));

        if (applicable) {
            if ("NON_APPLICABLE".equals(piece.getStatutPiece().getCode())) {
                piece.setStatutPiece(nonFourni);
            }
        } else {
            piece.setStatutPiece(nonApplicable);
            piece.setFichierPath(null);
            piece.setDateFourniture(null);
        }

        return dossierPieceComplementaireRepository.save(piece);
    }
}
