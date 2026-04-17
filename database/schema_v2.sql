-- ============================================================
--  BACK-OFFICE : TITRE DE SÉJOUR MADAGASCAR  —  v2
--  PostgreSQL  |  Compatible Spring Boot JPA (pas d'ENUM PG)
-- ============================================================


-- ============================================================
-- 1. TABLES DE RÉFÉRENCE (remplacent les ENUM)
-- ============================================================

CREATE TABLE statut_dossier (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(30) NOT NULL UNIQUE,  -- utilisé côté Java
    libelle VARCHAR(80) NOT NULL
);
INSERT INTO statut_dossier (code, libelle) VALUES
    ('CREER',          'Dossier créé'),
    ('SOUMIS',         'Dossier soumis'),
    ('EN_INSTRUCTION', 'En cours d''instruction'),
    ('APPROUVE',       'Approuvé'),
    ('REJETE',         'Rejeté');

-- ------------------------------------------------

CREATE TABLE statut_piece (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(30) NOT NULL UNIQUE,
    libelle VARCHAR(80) NOT NULL
);
INSERT INTO statut_piece (code, libelle) VALUES
    ('NON_FOURNI',     'Non fourni'),
    ('FOURNI',         'Fourni'),
    ('NON_APPLICABLE', 'Non applicable');

-- ------------------------------------------------

CREATE TABLE situation_familiale (
    id      SERIAL       PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO situation_familiale (libelle) VALUES
    ('Célibataire'),
    ('Marié(e)'),
    ('Divorcé(e)'),
    ('Veuf / Veuve'),
    ('Union libre');

-- ------------------------------------------------

CREATE TABLE nationalite (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(10) NOT NULL UNIQUE,  -- ex: MG, FR, CN
    libelle VARCHAR(100) NOT NULL
);
INSERT INTO nationalite (code, libelle) VALUES
    ('MG', 'Malgache'),
    ('FR', 'Française'),
    ('US', 'Américaine');

-- ------------------------------------------------

CREATE TABLE type_identite (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(50) NOT NULL UNIQUE,
    libelle VARCHAR(100) NOT NULL
);
INSERT INTO type_identite (code, libelle) VALUES
    ('TRAVAILLEUR', 'Travailleur expatrié'),
    ('INVESTISSEUR', 'Investisseur');


-- ============================================================
-- 2. DEMANDEUR  (état civil complet)
-- ============================================================

CREATE TABLE demandeur (
    id                      SERIAL       PRIMARY KEY,
    nom                     VARCHAR(100) NOT NULL,
    prenom                  VARCHAR(100) NOT NULL,
    date_naissance          DATE         NOT NULL,
    lieu_naissance          VARCHAR(150),
    nationalite_id          INT          NOT NULL REFERENCES nationalite(id),
    situation_familiale_id  INT          NOT NULL REFERENCES situation_familiale(id),
    email                   VARCHAR(150),
    telephone               VARCHAR(30),
    adresse_mada            TEXT,
    created_at              TIMESTAMP    NOT NULL DEFAULT NOW()
);


-- ============================================================
-- 3. PASSEPORT
-- ============================================================

CREATE TABLE passeport (
    id                  SERIAL      PRIMARY KEY,
    demandeur_id        INT         NOT NULL REFERENCES demandeur(id),
    numero              VARCHAR(50) NOT NULL UNIQUE,
    pays_delivrance_id  INT         NOT NULL REFERENCES nationalite(id),
    date_delivrance     DATE        NOT NULL,
    date_expiration     DATE        NOT NULL
);


-- ============================================================
-- 4. VISA TRANSFORMABLE
-- ============================================================

CREATE TABLE visa_transformable (
    id              SERIAL       PRIMARY KEY,
    passeport_id    INT          NOT NULL REFERENCES passeport(id),
    lieu_entree     VARCHAR(150) NOT NULL,
    date_entree     DATE         NOT NULL,
    date_sortie_ref DATE,
    date_expiration DATE         NOT NULL
);


-- ============================================================
-- 5. DOSSIER  (pièce centrale)
-- ============================================================

CREATE TABLE dossier (
    id                    SERIAL    PRIMARY KEY,
    demandeur_id          INT       NOT NULL REFERENCES demandeur(id),
    type_identite_id      INT       NOT NULL REFERENCES type_identite(id),
    visa_transformable_id INT       REFERENCES visa_transformable(id),
    statut_dossier_id     INT       NOT NULL REFERENCES statut_dossier(id),
    created_at            TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMP NOT NULL DEFAULT NOW()
);


-- ============================================================
-- 6. CATALOGUE — PIÈCES COMMUNES  (8 pièces pour tous)
-- ============================================================

CREATE TABLE catalogue_piece_commune (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(80) NOT NULL UNIQUE,
    libelle TEXT        NOT NULL
);
INSERT INTO catalogue_piece_commune (code, libelle) VALUES
    ('PHOTO_ID',        '02 photos d''identité récentes'),
    ('NOTICE_RENS',     'Notice de renseignement'),
    ('DEMANDE_MIN',     'Demande adressée au Ministre de l''Intérieur (avec adresse email et téléphone portable)'),
    ('COPIE_VISA',      'Photocopie certifiée du visa en cours de validité'),
    ('COPIE_PASSPORT',  'Photocopie certifiée de la 1ère page du passeport'),
    ('COPIE_CARTE_RES', 'Photocopie certifiée de la carte résident en cours de validité'),
    ('CERT_RESIDENCE',  'Certificat de résidence à Madagascar'),
    ('CASIER_JUD',      'Extrait de casier judiciaire (moins de 3 mois)');


-- ============================================================
-- 7. PIÈCES COMMUNES PAR DOSSIER  (suivi + upload)
-- ============================================================

CREATE TABLE dossier_piece_commune (
    id                  SERIAL    PRIMARY KEY,
    dossier_id          INT       NOT NULL REFERENCES dossier(id),
    catalogue_piece_id  INT       NOT NULL REFERENCES catalogue_piece_commune(id),
    statut_piece_id     INT       NOT NULL REFERENCES statut_piece(id),
    fichier_path        VARCHAR(500),          -- chemin du fichier uploadé
    date_fourniture     TIMESTAMP,
    UNIQUE (dossier_id, catalogue_piece_id)
);


-- ============================================================
-- 8. CATALOGUE — PIÈCES COMPLÉMENTAIRES PAR TYPE
-- ============================================================

CREATE TABLE catalogue_piece_complementaire (
    id               SERIAL      PRIMARY KEY,
    type_identite_id INT         NOT NULL REFERENCES type_identite(id),
    code             VARCHAR(80) NOT NULL,
    libelle          TEXT        NOT NULL,
    UNIQUE (type_identite_id, code)
);

-- TRAVAILLEUR
INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle)
SELECT id, 'AUTORISATION_EMPLOI',
    'Autorisation d''emploi délivrée par le Ministère de la Fonction Publique'
FROM type_identite WHERE code = 'TRAVAILLEUR';

INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle)
SELECT id, 'ATTESTATION_EMPLOI',
    'Attestation d''emploi délivrée par l''employeur (original)'
FROM type_identite WHERE code = 'TRAVAILLEUR';

-- INVESTISSEUR
INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle)
SELECT id, 'STATUT_SOCIETE', 'Statut de la Société'
FROM type_identite WHERE code = 'INVESTISSEUR';

INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle)
SELECT id, 'EXTRAIT_REGISTRE', 'Extrait d''inscription au Registre de Commerce'
FROM type_identite WHERE code = 'INVESTISSEUR';

INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle)
SELECT id, 'CARTE_FISCALE', 'Carte fiscale en cours de validité'
FROM type_identite WHERE code = 'INVESTISSEUR';


-- ============================================================
-- 9. PIÈCES COMPLÉMENTAIRES PAR DOSSIER  (suivi + upload)
-- ============================================================

CREATE TABLE dossier_piece_complementaire (
    id                          SERIAL    PRIMARY KEY,
    dossier_id                  INT       NOT NULL REFERENCES dossier(id),
    catalogue_complementaire_id INT       NOT NULL REFERENCES catalogue_piece_complementaire(id),
    statut_piece_id             INT       NOT NULL REFERENCES statut_piece(id),
    fichier_path                VARCHAR(500),     -- chemin du fichier uploadé
    date_fourniture             TIMESTAMP,
    UNIQUE (dossier_id, catalogue_complementaire_id)
);
