package com.mada.visa_mg.controller;

import com.mada.visa_mg.dto.DossierCreationDTO;
import com.mada.visa_mg.dto.DuplicataCreationDTO;
import com.mada.visa_mg.dto.DossierListDTO;
import com.mada.visa_mg.dto.DossierPiecesDTO;
import com.mada.visa_mg.dto.TransfertPasseportCreationDTO;
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
import com.mada.visa_mg.repository.ref.StatutPasseportRepository;
import com.mada.visa_mg.entity.ref.StatutPasseport;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.transaction.annotation.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

@RestController
@RequestMapping("/api/dossiers")
@Transactional
@Slf4j
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
    private final PasseportRepository     passeportRepository;
    private final TransfertPasseportRepository transfertPasseportRepository;
    private final DossierStatutHistoriqueRepository dossierStatutHistoriqueRepository;
    private final PasseportStatutRepository passeportStatutRepository;
    private final StatutPasseportRepository statutPasseportRepository;

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
            CarteResidentRepository carteResidentRepository,
            PasseportRepository passeportRepository,
            TransfertPasseportRepository transfertPasseportRepository,
            DossierStatutHistoriqueRepository dossierStatutHistoriqueRepository,
            PasseportStatutRepository passeportStatutRepository,
            StatutPasseportRepository statutPasseportRepository
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
        this.passeportRepository = passeportRepository;
        this.transfertPasseportRepository = transfertPasseportRepository;
        this.dossierStatutHistoriqueRepository = dossierStatutHistoriqueRepository;
        this.passeportStatutRepository = passeportStatutRepository;
        this.statutPasseportRepository = statutPasseportRepository;
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

        // Sauvegarder l'historique
        log.info("Saving history for dossier creation: {}", dossier.getId());
        saveDossierHistory(dossier, "Création de la demande initiale");

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
            boolean isAlwaysRequired = "WEBCAM".equals(cat.getCode()) || "SIGNATURE".equals(cat.getCode());
            boolean isCochee = isAlwaysRequired || communesCochees == null || communesCochees.contains(cat.getId());
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

    @PostMapping("/transfert")
    @ResponseStatus(HttpStatus.CREATED)
    public Dossier createTransfertPasseport(@Valid @RequestBody TransfertPasseportCreationDTO dto) {
        Demandeur demandeur = demandeurRepository.findById(dto.getDemandeurId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "demandeurId invalide"));

        Passeport ancienPasseport = passeportRepository.findById(dto.getAncienPasseportId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "ancienPasseportId invalide"));

        Passeport nouveauPasseport = passeportRepository.findById(dto.getNouveauPasseportId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "nouveauPasseportId invalide"));

        if (ancienPasseport.getDemandeur() != null && !ancienPasseport.getDemandeur().getId().equals(demandeur.getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "L'ancien passeport n'appartient pas au demandeur");
        }

        if (nouveauPasseport.getDemandeur() != null && !nouveauPasseport.getDemandeur().getId().equals(demandeur.getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Le nouveau passeport n'appartient pas au demandeur");
        }

        TypeIdentite typeIdentite = typeIdentiteRepository.findById(dto.getTypeIdentiteId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "typeIdentiteId invalide"));

        TypeDemande nouveauTitreType = typeDemandeRepository.findById(1)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Type NOUVEAU TITRE manquant"));

        TypeDemande transfertType = typeDemandeRepository.findByCode("TRANSFERT")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "TypeDemande TRANSFERT manquant"));

        StatutDossier approuvee = statutDossierRepository.findByCode("APPROUVEE")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut APPROUVEE manquant"));

        StatutDossier creer = statutDossierRepository.findByCode("CREER")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut CREER manquant"));

        LocalDateTime now = LocalDateTime.now();

        // 1ere insertion : Le parent (NOUVEAU TITRE, APPROUVEE) pour lier les titres
        Dossier dossierParent = Dossier.builder()
                .demandeur(demandeur)
                .visaTransformable(null)
                .typeIdentite(typeIdentite)
                .typeDemande(nouveauTitreType)
                .statutDossier(approuvee)
                .dateDemande(LocalDate.now())
                .dateTraitement(LocalDate.now())
                .createdAt(now)
                .updatedAt(now)
                .build();
        dossierParent = dossierRepository.save(dossierParent);

        // 2eme insertion : La demande (TRANSFERT, CREER)
        Dossier dossierTransfert = Dossier.builder()
                .demandeur(demandeur)
                .visaTransformable(null)
                .typeIdentite(typeIdentite)
                .typeDemande(transfertType)
                .statutDossier(creer)
                .dateDemande(LocalDate.now())
                .createdAt(now)
                .updatedAt(now)
                .build();
        dossierTransfert = dossierRepository.save(dossierTransfert);
        saveDossierHistory(dossierTransfert, "Demande de transfert de passeport créée");

        // Mise à jour des statuts des passeports
        updatePasseportStatus(ancienPasseport, "EXPIRE", "Passeport remplacé par transfert");
        updatePasseportStatus(nouveauPasseport, "ACTIF", "Nouveau passeport activé par transfert");

        TransfertPasseport transfert = TransfertPasseport.builder()
                .ancienPasseport(ancienPasseport)
                .nouveauPasseport(nouveauPasseport)
                .createdAt(now)
                .build();
        transfertPasseportRepository.save(transfert);

        if (dto.getVisasAUpdater() != null && !dto.getVisasAUpdater().isEmpty()) {
            List<Visa> visas = visaRepository.findAllById(dto.getVisasAUpdater());
            for (Visa v : visas) {
                if (v.getPasseport().getId().equals(ancienPasseport.getId())) {
                    v.setPasseport(nouveauPasseport);
                    // On pourrait aussi lier le visa au nouveau dossierParent si besoin
                    v.setDossier(dossierParent);
                }
            }
            visaRepository.saveAll(visas);
        }

        if (dto.getCartesAUpdater() != null && !dto.getCartesAUpdater().isEmpty()) {
            List<CarteResident> cartes = carteResidentRepository.findAllById(dto.getCartesAUpdater());
            for (CarteResident c : cartes) {
                if (c.getPasseport().getId().equals(ancienPasseport.getId())) {
                    c.setPasseport(nouveauPasseport);
                    c.setDossier(dossierParent);
                }
            }
            carteResidentRepository.saveAll(cartes);
        }

        // Création optionnelle de nouveaux documents (Visa et/ou Carte Résident) liés au dossierParent
        if (dto.getDocuments() != null && !dto.getDocuments().isEmpty()) {
            for (TransfertPasseportCreationDTO.DocumentTransfertDTO doc : dto.getDocuments()) {
                if ("VISA".equals(doc.getTypeDocument())) {
                    Visa visa = Visa.builder()
                            .dossier(dossierParent)
                            .passeport(nouveauPasseport)
                            .reference(doc.getReferenceDocument())
                            .dateDebut(doc.getDateDebutDocument())
                            .dateFin(doc.getDateFinDocument())
                            .createdAt(now)
                            .build();
                    visaRepository.save(visa);
                } else if ("CARTE_RESIDENT".equals(doc.getTypeDocument())) {
                    CarteResident carte = CarteResident.builder()
                            .dossier(dossierParent)
                            .passeport(nouveauPasseport)
                            .reference(doc.getReferenceDocument())
                            .dateDebut(doc.getDateDebutDocument())
                            .dateFin(doc.getDateFinDocument())
                            .createdAt(now)
                            .build();
                    carteResidentRepository.save(carte);
                }
            }
        }

        return dossierTransfert;
    }

    @PostMapping("/duplicata")
    @ResponseStatus(HttpStatus.CREATED)
    public Dossier createDuplicata(@Valid @RequestBody DuplicataCreationDTO dto) {
        Demandeur demandeur = demandeurRepository.findById(dto.getDemandeurId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "demandeurId invalide"));

        // Visa transformable est maintenant optionnel
        VisaTransformable visaTransformable = null;
        if (dto.getVisaTransformableId() != null) {
            visaTransformable = visaTransformableRepository.findById(dto.getVisaTransformableId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "visaTransformableId invalide"));
        }

        TypeIdentite typeIdentite = typeIdentiteRepository.findById(dto.getTypeIdentiteId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "typeIdentiteId invalide"));

        TypeDemande nouveauTitreType = typeDemandeRepository.findById(1) // 1 = NOUVEAU TITRE
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Type NOUVEAU TITRE manquant"));
        TypeDemande duplicataType = typeDemandeRepository.findById(3) // 3 = DUPLICATA
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Type DUPLICATA manquant"));

        StatutDossier approuvee = statutDossierRepository.findByCode("APPROUVEE")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut APPROUVEE manquant"));
        StatutDossier creer = statutDossierRepository.findByCode("CREER")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut CREER manquant"));

        LocalDateTime now = LocalDateTime.now();

        // 1ere insertion : Le parent (NOUVEAU TITRE, APPROUVEE)
        Dossier dossierParent = Dossier.builder()
                .demandeur(demandeur)
                .visaTransformable(visaTransformable)
                .typeIdentite(typeIdentite)
                .typeDemande(nouveauTitreType)
                .statutDossier(approuvee)
                .dateDemande(LocalDate.now())
                .dateTraitement(LocalDate.now())
                .createdAt(now)
                .updatedAt(now)
                .build();
        dossierParent = dossierRepository.save(dossierParent);

        // 2eme insertion : Le duplicata (DUPLICATA, CREER)
        Dossier dossierDuplicata = Dossier.builder()
                .demandeur(demandeur)
                .visaTransformable(visaTransformable)
                .typeIdentite(typeIdentite)
                .typeDemande(duplicataType)
                .statutDossier(creer)
                .dateDemande(LocalDate.now())
                .createdAt(now)
                .updatedAt(now)
                .build();
        dossierDuplicata = dossierRepository.save(dossierDuplicata);
        saveDossierHistory(dossierDuplicata, "Demande de duplicata créée");

        // Le passeport est obligatoire et fourni par l'UI
        Passeport passeportPourDocs = passeportRepository.findById(dto.getPasseportId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "passeportId invalide"));

        // Création des documents finaux liés au DOSSIER PARENT
        for (DuplicataCreationDTO.DocumentDuplicataDTO doc : dto.getDocuments()) {
            if ("VISA".equals(doc.getTypeDocument())) {
                Visa visa = Visa.builder()
                        .dossier(dossierParent)
                        .passeport(passeportPourDocs)
                        .reference(doc.getReferenceDocument())
                        .dateDebut(doc.getDateDebutDocument())
                        .dateFin(doc.getDateFinDocument())
                        .createdAt(now)
                        .build();
                visaRepository.save(visa);
            } else if ("CARTE_RESIDENT".equals(doc.getTypeDocument())) {
                CarteResident carte = CarteResident.builder()
                        .dossier(dossierParent)
                        .passeport(passeportPourDocs)
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

        // Pièces communes
        java.util.Map<Integer, String> fichiersCommunes = dto.getPiecesCommunesFichiers();
        java.util.List<Integer> fourniesCommunes = dto.getPiecesCommunesFournies();
        
        List<CataloguePieceCommune> piecesCommunes = cataloguePieceCommuneRepository.findAll();
        for (CataloguePieceCommune cat : piecesCommunes) {
            boolean hasFichier = fichiersCommunes != null && fichiersCommunes.containsKey(cat.getId());
            boolean isChecked = fourniesCommunes != null && fourniesCommunes.contains(cat.getId());
            boolean isFourni = hasFichier || isChecked;
            
            DossierPieceCommune piece = DossierPieceCommune.builder()
                    .dossier(dossierDuplicata) // associé au duplicata
                    .cataloguePiece(cat)
                    .statutPiece(isFourni ? fourni : nonFourni)
                    .fichierPath(hasFichier ? fichiersCommunes.get(cat.getId()) : null)
                    .dateFourniture(isFourni ? now : null)
                    .build();
            dossierPieceCommuneRepository.save(piece);
        }

        // Pièces complémentaires
        java.util.Map<Integer, String> fichiers = dto.getPiecesComplementairesFichiers();
        java.util.List<Integer> fourniesComp = dto.getPiecesComplementairesFournies();

        List<CataloguePieceComplementaire> piecesComp = cataloguePieceComplementaireRepository.findAll();
        for (CataloguePieceComplementaire cat : piecesComp) {
            if (cat.getTypeIdentite() != null && cat.getTypeIdentite().getId().equals(typeIdentite.getId())) {
                boolean hasFichier = fichiers != null && fichiers.containsKey(cat.getId());
                boolean isChecked = fourniesComp != null && fourniesComp.contains(cat.getId());
                boolean isFourni = hasFichier || isChecked;

                DossierPieceComplementaire piece = DossierPieceComplementaire.builder()
                        .dossier(dossierDuplicata) // associé au duplicata
                        .catalogueComplementaire(cat)
                        .statutPiece(isFourni ? fourni : nonFourni)
                        .fichierPath(hasFichier ? fichiers.get(cat.getId()) : null)
                        .dateFourniture(isFourni ? now : null)
                        .build();
                dossierPieceComplementaireRepository.save(piece);
            }
        }

        return dossierDuplicata;
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

        StatutPiece nonFourni = statutPieceRepository.findByCode("NON_FOURNI")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "StatutPiece NON_FOURNI manquant"));

        List<DossierPieceCommune> communes = dossierPieceCommuneRepository.findByDossierId(id);

        java.util.Set<String> existingCommuneCodes = new java.util.HashSet<>();
        for (DossierPieceCommune pc : communes) {
            if (pc.getCataloguePiece() != null && pc.getCataloguePiece().getCode() != null) {
                existingCommuneCodes.add(pc.getCataloguePiece().getCode());
            }
        }

        java.util.List<CataloguePieceCommune> catalogueCommunes = cataloguePieceCommuneRepository.findAll();
        for (CataloguePieceCommune cat : catalogueCommunes) {
            if ("WEBCAM".equals(cat.getCode()) || "SIGNATURE".equals(cat.getCode())) {
                if (!existingCommuneCodes.contains(cat.getCode())) {
                    Dossier dossier = dossierRepository.findById(id)
                            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dossier introuvable"));

                    DossierPieceCommune piece = DossierPieceCommune.builder()
                            .dossier(dossier)
                            .cataloguePiece(cat)
                            .statutPiece(nonFourni)
                            .build();
                    dossierPieceCommuneRepository.save(piece);
                }
            }
        }

        communes = dossierPieceCommuneRepository.findByDossierId(id);
        List<DossierPieceComplementaire> complementaires = dossierPieceComplementaireRepository.findByDossierId(id);

        return new DossierPiecesDTO(communes, complementaires);
    }

    @GetMapping("/{id}/documents")
    public java.util.Map<String, Object> getDocuments(@PathVariable Integer id) {
        List<Visa> visas = visaRepository.findByDossierId(id);
        List<CarteResident> cartes = carteResidentRepository.findByDossierId(id);
        
        java.util.Map<String, Object> docs = new java.util.HashMap<>();
        docs.put("visas", visas);
        docs.put("cartes", cartes);
        return docs;
    }

    @GetMapping("/{id}/historique")
    public List<DossierStatutHistorique> getHistorique(@PathVariable Integer id) {
        return dossierStatutHistoriqueRepository.findByDossierIdOrderByDateChangementStatutDesc(id);
    }

    @GetMapping
    public List<DossierListDTO> getAllDossiers() {
        List<DossierListDTO> result = new ArrayList<>();
        
        List<Dossier> dossiers = dossierRepository.findAll();
        for (Dossier d : dossiers) {
            String passportNum = null;
            if (d.getVisaTransformable() != null && d.getVisaTransformable().getPasseport() != null) {
                passportNum = d.getVisaTransformable().getPasseport().getNumeroPasseport();
            } else {
                List<Passeport> pps = passeportRepository.findByDemandeurId(d.getDemandeur().getId());
                if (!pps.isEmpty()) {
                    passportNum = pps.get(pps.size() - 1).getNumeroPasseport();
                }
            }

            result.add(DossierListDTO.builder()
                .id(d.getId())
                .demandeur(d.getDemandeur())
                .createdAt(d.getCreatedAt())
                .statutCode(d.getStatutDossier().getCode())
                .statutLibelle(d.getStatutDossier().getLibelle())
                .typeDemandeCode(d.getTypeDemande() != null ? d.getTypeDemande().getCode() : null)
                .typeDemandeLibelle(d.getTypeDemande() != null ? d.getTypeDemande().getLibelle() : null)
                .passportNumero(passportNum)
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
                
                String passportNum = null;
                List<Passeport> pps = passeportRepository.findByDemandeurId(dem.getId());
                if (!pps.isEmpty()) {
                    passportNum = pps.get(pps.size() - 1).getNumeroPasseport();
                }

                if (optVisa.isPresent()) {
                    result.add(DossierListDTO.builder()
                        .id(dem.getId()) // ID du demandeur servant de référence
                        .demandeur(dem)
                        .createdAt(dem.getCreatedAt())
                        .statutCode("BROUILLON")
                        .statutLibelle("Brouillon (Étape 3)")
                        .stepToContinue(3)
                        .visaIdToContinue(optVisa.get().getId())
                        .passportNumero(passportNum)
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
                        .passportNumero(passportNum)
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

        dossier = dossierRepository.save(dossier);
        saveDossierHistory(dossier, "Le scan des pièces est terminé, dossier prêt pour traitement");

        return dossier;
    }

    @PutMapping("/{id}/approuver")
    public Dossier approuver(@PathVariable Integer id) {
        Dossier dossier = dossierRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dossier introuvable"));
        
        StatutDossier approuvee = statutDossierRepository.findByCode("APPROUVEE")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut APPROUVEE manquant"));
        
        dossier.setStatutDossier(approuvee);
        dossier.setDateTraitement(LocalDate.now());
        dossier.setUpdatedAt(LocalDateTime.now());
        
        dossier = dossierRepository.save(dossier);
        saveDossierHistory(dossier, "La demande a été approuvée");
        
        return dossier;
    }

    @PutMapping("/{id}/rejeter")
    public Dossier rejeter(@PathVariable Integer id, @RequestBody java.util.Map<String, String> body) {
        Dossier dossier = dossierRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dossier introuvable"));
        
        StatutDossier rejetee = statutDossierRepository.findByCode("REJETEE")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut REJETEE manquant"));
        
        String motif = body.get("motif");
        dossier.setStatutDossier(rejetee);
        dossier.setUpdatedAt(LocalDateTime.now());
        
        dossier = dossierRepository.save(dossier);
        saveDossierHistory(dossier, "La demande a été rejetée. Motif : " + (motif != null ? motif : "Non spécifié"));
        
        return dossier;
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

        if (piece.getCataloguePiece() != null) {
            String code = piece.getCataloguePiece().getCode();
            if ("WEBCAM".equals(code) || "SIGNATURE".equals(code)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cette pièce est obligatoire");
            }
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

    // ========== Helpers pour l'historique ==========
    private void saveDossierHistory(Dossier dossier, String commentaire) {
        try {
            log.info("Attempting to save history for dossier ID: {} with status: {}", 
                     dossier.getId(), 
                     (dossier.getStatutDossier() != null ? dossier.getStatutDossier().getCode() : "NULL"));
            
            DossierStatutHistorique history = DossierStatutHistorique.builder()
                    .dossier(dossier)
                    .statutDossier(dossier.getStatutDossier())
                    .dateChangementStatut(LocalDateTime.now())
                    .commentaire(commentaire)
                    .changedBy("SYSTEM")
                    .build();
            
            DossierStatutHistorique saved = dossierStatutHistoriqueRepository.saveAndFlush(history);
            log.info("History saved successfully with ID: {}", saved.getId());
        } catch (Exception e) {
            log.error("Failed to save dossier history: {}", e.getMessage(), e);
        }
    }

    private void updatePasseportStatus(Passeport passeport, String statusCode, String commentaire) {
        try {
            StatutPasseport statut = statutPasseportRepository.findByCode(statusCode)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Statut passeport " + statusCode + " manquant"));
            
            PasseportStatut history = PasseportStatut.builder()
                    .passeport(passeport)
                    .statutPasseport(statut)
                    .dateChangementStatut(LocalDateTime.now())
                    .commentaire(commentaire)
                    .build();
            
            passeportStatutRepository.saveAndFlush(history);
            log.info("Passport history saved for passport: {} with status: {}", passeport.getNumeroPasseport(), statusCode);
        } catch (Exception e) {
            log.error("Failed to save passport history: {}", e.getMessage());
        }
    }
}
