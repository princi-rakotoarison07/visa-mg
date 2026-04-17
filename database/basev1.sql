-- ============================================================
--  BACK-OFFICE : TITRE DE SÉJOUR MADAGASCAR
--  PostgreSQL — Schéma simplifié
-- ============================================================


-- ============================================================
-- ÉNUMÉRATIONS
-- ============================================================

CREATE TYPE statut_dossier AS ENUM (
    'creer',
    'valide',
    'rejete',
    'approuve'
);

CREATE TYPE statut_piece AS ENUM (
    'non_fourni',
    'fourni',
    'non_applicable'
);


-- ============================================================
-- 1. TYPE D'IDENTITÉ
-- ============================================================

CREATE TABLE type_identite (
    id          SERIAL       PRIMARY KEY,
    code        VARCHAR(50)  NOT NULL UNIQUE,
    libelle     VARCHAR(100) NOT NULL
);

-- Données de référence
INSERT INTO type_identite (code, libelle) VALUES
    ('TRAVAILLEUR', 'Travailleur expatrié'),
    ('INVESTISSEUR', 'Investisseur');


-- ============================================================
-- 2. demandeur
-- ============================================================
CREATE TABLE nationalite (
    id              SERIAL       PRIMARY KEY,
    code        VARCHAR(50)  NOT NULL UNIQUE,
    libelle         VARCHAR(100) NOT NULL
    
);
CREATE TABLE situation_famialiale (
    id              SERIAL       PRIMARY KEY,
    libelle         VARCHAR(100) NOT NULL
    
);


CREATE TABLE demandeur (
    id              SERIAL       PRIMARY KEY,
    nom             VARCHAR(100) NOT NULL,
    prenom          VARCHAR(100) NOT NULL,
    date_naissance  DATE         NOT NULL,
    nationalite_id  INT         NOT NULL REFERENCES nationalite(id),
    situation_famialiale_id  INT         NOT NULL REFERENCES situation_famialiale(id),
    email           VARCHAR(150),
    telephone       VARCHAR(30),
    adresse_mada    TEXT
);


-- ============================================================
-- 3. PASSEPORT
-- ============================================================

CREATE TABLE passeport (
    id              SERIAL      PRIMARY KEY,
    demandeur_id     INT         NOT NULL REFERENCES demandeur(id),
    numero          VARCHAR(50) NOT NULL UNIQUE,
    pays_delivrance_id INT         NOT NULL REFERENCES nationalite(id),
    date_delivrance DATE        NOT NULL,
    date_expiration DATE        NOT NULL
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
-- 5. DOSSIER
-- ============================================================

CREATE TABLE dossier (
    id                    SERIAL          PRIMARY KEY,
    demandeur_id           INT             NOT NULL REFERENCES demandeur(id),
    type_identite_id      INT             NOT NULL REFERENCES type_identite(id),
    visa_transformable_id INT             REFERENCES visa_transformable(id),
    statut                statut_dossier  NOT NULL DEFAULT 'creer',
    created_at            DATE            NOT NULL DEFAULT CURRENT_DATE
);


-- ============================================================
-- 6. CATALOGUE — PIÈCES COMMUNES
-- ============================================================

CREATE TABLE catalogue_piece_commune (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(80) NOT NULL UNIQUE,
    libelle TEXT        NOT NULL,
    ordre   INT         NOT NULL DEFAULT 0
);

-- Données de référence
INSERT INTO catalogue_piece_commune (code, libelle, ordre) VALUES
    ('PHOTO_ID',        '02 photos d''identité récentes',                                                  1),
    ('NOTICE_RENS',     'Notice de renseignement',                                                         2),
    ('DEMANDE_MIN',     'Demande adressée au Ministre de l''Intérieur (avec adresse email et téléphone)', 3),
    ('COPIE_VISA',      'Photocopie certifiée du visa en cours de validité',                               4),
    ('COPIE_PASSPORT',  'Photocopie certifiée de la 1ère page du passeport',                              5),
    ('COPIE_CARTE_RES', 'Photocopie certifiée de la carte résident en cours de validité',                 6),
    ('CERT_RESIDENCE',  'Certificat de résidence à Madagascar',                                            7),
    ('CASIER_JUD',      'Extrait de casier judiciaire (moins de 3 mois)',                                  8);


-- ============================================================
-- 7. PIÈCES COMMUNES PAR DOSSIER 
-- ============================================================

CREATE TABLE dossier_piece_commune (
    id                 SERIAL       PRIMARY KEY,
    dossier_id         INT          NOT NULL REFERENCES dossier(id),
    catalogue_piece_id INT          NOT NULL REFERENCES catalogue_piece_commune(id),
    statut             statut_piece NOT NULL DEFAULT 'non_fourni',
    date_fourniture    DATE,
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
    ordre            INT         NOT NULL DEFAULT 0,
    UNIQUE (type_identite_id, code)
);

-- Données de référence : TRAVAILLEUR
INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle, ordre)
SELECT id, 'AUTORISATION_EMPLOI',
    'Autorisation d''emploi délivrée par le Ministère de la Fonction Publique', 1
FROM type_identite WHERE code = 'TRAVAILLEUR';

INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle, ordre)
SELECT id, 'ATTESTATION_EMPLOI',
    'Attestation d''emploi délivrée par l''employeur (original)', 2
FROM type_identite WHERE code = 'TRAVAILLEUR';

-- Données de référence : INVESTISSEUR
INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle, ordre)
SELECT id, 'STATUT_SOCIETE',
    'Statut de la Société', 1
FROM type_identite WHERE code = 'INVESTISSEUR';

INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle, ordre)
SELECT id, 'EXTRAIT_REGISTRE',
    'Extrait d''inscription au Registre de Commerce', 2
FROM type_identite WHERE code = 'INVESTISSEUR';

INSERT INTO catalogue_piece_complementaire (type_identite_id, code, libelle, ordre)
SELECT id, 'CARTE_FISCALE',
    'Carte fiscale en cours de validité', 3
FROM type_identite WHERE code = 'INVESTISSEUR';


-- ============================================================
-- 9. PIÈCES COMPLÉMENTAIRES PAR DOSSIER (suivi / checkbox)
-- ============================================================

CREATE TABLE dossier_piece_complementaire (
    id                          SERIAL       PRIMARY KEY,
    dossier_id                  INT          NOT NULL REFERENCES dossier(id),
    catalogue_complementaire_id INT          NOT NULL REFERENCES catalogue_piece_complementaire(id),
    statut                      statut_piece NOT NULL DEFAULT 'non_fourni',
    date_fourniture             DATE,
    UNIQUE (dossier_id, catalogue_complementaire_id)
);