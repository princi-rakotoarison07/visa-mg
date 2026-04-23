-- ============================================================
--  BACK-OFFICE : TITRE DE SÉJOUR MADAGASCAR
--  PostgreSQL v2  —  Corrigé + complété
--  Ordre : tables de référence → demandeur → passeport
--          → visa_transformable → demande → résultat
-- ============================================================


-- ============================================================
-- 1. TABLES DE RÉFÉRENCE  (pas d'ENUM → compatible JPA)
-- ============================================================

CREATE TABLE nationalite (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(10) NOT NULL UNIQUE,   -- ex: MG, FR
    libelle VARCHAR(100) NOT NULL
);
INSERT INTO nationalite (code, libelle) VALUES
    ('MG', 'Malgache'), ('FR', 'Française'),
    ('US', 'Américaine');

-- ------------------------------------------------

CREATE TABLE situation_familiale (
    id      SERIAL      PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO situation_familiale (libelle) VALUES
    ('Célibataire'), ('Marié(e)'), ('Divorcé(e)'),
    ('Veuf / Veuve'), ('Union libre');

-- ------------------------------------------------

-- Type de visa = type d'identité (Travailleur, Investisseur…)
CREATE TABLE type_visa (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(50) NOT NULL UNIQUE,
    libelle VARCHAR(100) NOT NULL
);
INSERT INTO type_visa (code, libelle) VALUES
    ('TRAVAILLEUR', 'Travailleur expatrié'),
    ('INVESTISSEUR', 'Investisseur');

-- ------------------------------------------------

-- Type de demande (nouveau titre, renouvellement…)
CREATE TABLE type_demande (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(50) NOT NULL UNIQUE,
    libelle VARCHAR(100) NOT NULL
);
INSERT INTO type_demande (code, libelle) VALUES
    ('NOUVEAU_TITRE',   'Nouveau titre de séjour'),
    ('RENOUVELLEMENT',  'Renouvellement de titre'),
    ('DUPLICATA',       'Duplicata');

-- ------------------------------------------------

-- Statuts d'un passeport
CREATE TABLE statut_passeport (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(30) NOT NULL UNIQUE,
    libelle VARCHAR(80) NOT NULL
);
INSERT INTO statut_passeport (code, libelle) VALUES
    ('ACTIF',  'Actif'),
    ('EXPIRE', 'Expiré'),
    ('PERDU',  'Perdu'),
    ('VOLE',   'Volé');

-- ------------------------------------------------

-- Statuts d'une demande
CREATE TABLE statut_demande (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(30) NOT NULL UNIQUE,
    libelle VARCHAR(80) NOT NULL
);
INSERT INTO statut_demande (code, libelle) VALUES
    ('BROUILLON',      'Brouillon'),
    ('CREER',          'Créer'),
    ('SCAN_TERMINER',  'Scan terminé'),
    ('APPROUVEE',      'Approuvée'),
    ('REJETEE',        'Rejetée');

-- ------------------------------------------------

-- Statut des pièces justificatives
CREATE TABLE statut_piece (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(30) NOT NULL UNIQUE,
    libelle VARCHAR(80) NOT NULL
);
INSERT INTO statut_piece (code, libelle) VALUES
    ('NON_FOURNI',     'Non fourni'),
    ('FOURNI',         'Fourni'),
    ('NON_APPLICABLE', 'Non applicable');


-- ============================================================
-- 2. DEMANDEUR  (déclaré avant Passeport et Demande)
-- ============================================================

CREATE TABLE demandeur (
    id                     SERIAL       PRIMARY KEY,
    nom                    VARCHAR(100) NOT NULL,
    prenom                 VARCHAR(100) NOT NULL,
    date_naissance         DATE         NOT NULL,
    lieu_naissance         VARCHAR(150) NOT NULL,
    telephone              VARCHAR(20)  NOT NULL,
    email                  VARCHAR(100) NOT NULL,
    adresse                TEXT         NOT NULL,
    nationalite_id         INT          NOT NULL REFERENCES nationalite(id),
    situation_familiale_id INT          NOT NULL REFERENCES situation_familiale(id),
    created_at             TIMESTAMP    NOT NULL DEFAULT NOW()
);


-- ============================================================
-- 3. PASSEPORT
-- ============================================================

CREATE TABLE passeport (
    id                 SERIAL      PRIMARY KEY,
    demandeur_id       INT         NOT NULL REFERENCES demandeur(id),
    numero_passeport   VARCHAR(50) NOT NULL UNIQUE,
    pays_delivrance_id INT         NOT NULL REFERENCES nationalite(id),
    date_delivrance    DATE        NOT NULL,
    date_expiration    DATE        NOT NULL
);

-- Historique des statuts du passeport
CREATE TABLE passeport_statut (
    id                     SERIAL    PRIMARY KEY,
    passeport_id           INT       NOT NULL REFERENCES passeport(id),
    statut_passeport_id    INT       NOT NULL REFERENCES statut_passeport(id),
    date_changement_statut TIMESTAMP NOT NULL DEFAULT NOW(),
    commentaire            TEXT
);


-- ============================================================
-- 4. VISA TRANSFORMABLE  (avec tous les champs métier)
-- ============================================================

CREATE TABLE visa_transformable (
    id               SERIAL       PRIMARY KEY,
    demandeur_id     INT          NOT NULL REFERENCES demandeur(id),
    passeport_id     INT          NOT NULL REFERENCES passeport(id),
    numero_reference VARCHAR(50)  UNIQUE,
    lieu_entree      VARCHAR(150) NOT NULL,   -- ex: Nosy Be, Ivato
    date_entree      DATE         NOT NULL,
    date_sortie_ref  DATE,                    -- date de sortie de référence
    date_expiration  DATE         NOT NULL    -- 1 mois après entrée
);


-- ============================================================
-- 5. DEMANDE  (centrale — liée au visa transformable)
-- ============================================================

CREATE TABLE demande (
    id                    SERIAL    PRIMARY KEY,
    demandeur_id          INT       NOT NULL REFERENCES demandeur(id),
    visa_transformable_id INT       NOT NULL REFERENCES visa_transformable(id),
    type_visa_id          INT       NOT NULL REFERENCES type_visa(id),
    type_demande_id       INT       NOT NULL REFERENCES type_demande(id),
    statut_demande_id     INT       NOT NULL REFERENCES statut_demande(id),
    date_demande          DATE      NOT NULL DEFAULT CURRENT_DATE,
    date_traitement       DATE,
    created_at            TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Historique des changements de statut de la demande
CREATE TABLE demande_statut_historique (
    id                     SERIAL    PRIMARY KEY,
    demande_id             INT       NOT NULL REFERENCES demande(id),
    statut_demande_id      INT       NOT NULL REFERENCES statut_demande(id),
    date_changement_statut TIMESTAMP NOT NULL DEFAULT NOW(),
    commentaire            TEXT,
    changed_by             VARCHAR(100)   -- agent back-office
);


-- ============================================================
-- 6. RÉSULTATS D'UNE DEMANDE APPROUVÉE
--    Visa long séjour  +  Carte de résident
--    Créés uniquement quand statut_demande = APPROUVEE
-- ============================================================

CREATE TABLE visa (
    id           SERIAL      PRIMARY KEY,
    demande_id   INT         NOT NULL REFERENCES demande(id),
    passeport_id INT         NOT NULL REFERENCES passeport(id),
    reference    VARCHAR(50) UNIQUE,
    date_debut   DATE        NOT NULL,
    date_fin     DATE        NOT NULL,
    created_at   TIMESTAMP   NOT NULL DEFAULT NOW()
);

CREATE TABLE carte_resident (
    id           SERIAL      PRIMARY KEY,
    demande_id   INT         NOT NULL REFERENCES demande(id),
    passeport_id INT         NOT NULL REFERENCES passeport(id),
    reference    VARCHAR(50) UNIQUE,
    date_debut   DATE        NOT NULL,
    date_fin     DATE        NOT NULL,
    created_at   TIMESTAMP   NOT NULL DEFAULT NOW()
);


-- ============================================================
-- 7. CATALOGUE — PIÈCES COMMUNES  (8 pièces pour tous)
-- ============================================================

CREATE TABLE catalogue_piece_commune (
    id      SERIAL      PRIMARY KEY,
    code    VARCHAR(80) NOT NULL UNIQUE,
    libelle TEXT        NOT NULL
);
INSERT INTO catalogue_piece_commune (code, libelle) VALUES
    ('PHOTO_ID',        '01 photos d''identité récentes'),
    ('NOTICE_RENS',     'Notice de renseignement');


-- ============================================================
-- 8. PIÈCES COMMUNES PAR DEMANDE  (suivi checkbox + upload)
-- ============================================================

CREATE TABLE demande_piece_commune (
    id                 SERIAL    PRIMARY KEY,
    demande_id         INT       NOT NULL REFERENCES demande(id),
    catalogue_piece_id INT       NOT NULL REFERENCES catalogue_piece_commune(id),
    statut_piece_id    INT       NOT NULL REFERENCES statut_piece(id),
    fichier_path       VARCHAR(500),        -- chemin fichier uploadé
    date_fourniture    TIMESTAMP,
    UNIQUE (demande_id, catalogue_piece_id)
);


-- ============================================================
-- 9. CATALOGUE — PIÈCES COMPLÉMENTAIRES PAR TYPE DE VISA
-- ============================================================

CREATE TABLE catalogue_piece_complementaire (
    id           SERIAL      PRIMARY KEY,
    type_visa_id INT         NOT NULL REFERENCES type_visa(id),
    code         VARCHAR(80) NOT NULL,
    libelle      TEXT        NOT NULL,
    est_obligatoire BOOLEAN  NOT NULL DEFAULT TRUE,
    UNIQUE (type_visa_id, code)
);

-- TRAVAILLEUR
INSERT INTO catalogue_piece_complementaire (type_visa_id, code, libelle, est_obligatoire)
SELECT id, 'AUTORISATION_EMPLOI',
    'Autorisation d''emploi délivrée par le Ministère de la Fonction Publique', TRUE
FROM type_visa WHERE code = 'TRAVAILLEUR';

INSERT INTO catalogue_piece_complementaire (type_visa_id, code, libelle, est_obligatoire)
SELECT id, 'ATTESTATION_EMPLOI',
    'Attestation d''emploi délivrée par l''employeur (original)', TRUE
FROM type_visa WHERE code = 'TRAVAILLEUR';

-- INVESTISSEUR
INSERT INTO catalogue_piece_complementaire (type_visa_id, code, libelle, est_obligatoire)
SELECT id, 'STATUT_SOCIETE', 'Statut de la Société', TRUE
FROM type_visa WHERE code = 'INVESTISSEUR';

INSERT INTO catalogue_piece_complementaire (type_visa_id, code, libelle, est_obligatoire)
SELECT id, 'EXTRAIT_REGISTRE', 'Extrait d''inscription au Registre de Commerce', TRUE
FROM type_visa WHERE code = 'INVESTISSEUR';

INSERT INTO catalogue_piece_complementaire (type_visa_id, code, libelle, est_obligatoire)
SELECT id, 'CARTE_FISCALE', 'Carte fiscale en cours de validité', TRUE
FROM type_visa WHERE code = 'INVESTISSEUR';


-- ============================================================
-- 10. PIÈCES COMPLÉMENTAIRES PAR DEMANDE  (suivi + upload)
-- ============================================================

CREATE TABLE demande_piece_complementaire (
    id                          SERIAL    PRIMARY KEY,
    demande_id                  INT       NOT NULL REFERENCES demande(id),
    catalogue_complementaire_id INT       NOT NULL REFERENCES catalogue_piece_complementaire(id),
    statut_piece_id             INT       NOT NULL REFERENCES statut_piece(id),
    fichier_path                VARCHAR(500),
    date_fourniture             TIMESTAMP,
    UNIQUE (demande_id, catalogue_complementaire_id)
);