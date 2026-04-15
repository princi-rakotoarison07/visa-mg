

-- 1. TABLE DES TYPES D'IDENTITÉ (référentiel)
CREATE TABLE type_identite (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    ordre_affichage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABLE DES STATUTS DE DEMANDE (référentiel)
CREATE TABLE statut_demande (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABLE DES PERSONNES (identité)
CREATE TABLE identite (
    id SERIAL PRIMARY KEY,
    type_identite_id INT NOT NULL REFERENCES type_identite(id),
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    situation_familiale VARCHAR(50), -- célibataire, marié, divorcé, veuf
    date_naissance DATE,
    lieu_naissance VARCHAR(100),
    nationalite VARCHAR(100) NOT NULL,
    email VARCHAR(200),
    telephone VARCHAR(50),
    adresse TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. TABLE PASSEPORT
CREATE TABLE passeport (
    id SERIAL PRIMARY KEY,
    identite_id INT NOT NULL REFERENCES identite(id) ON DELETE CASCADE,
    numero VARCHAR(50) NOT NULL,
    date_delivrance DATE,
    date_expiration DATE,
    pays_delivrance VARCHAR(100) DEFAULT 'Madagascar',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. TABLE VISA TRANSFORMABLE
CREATE TABLE visa_transformable (
    id SERIAL PRIMARY KEY,
    identite_id INT NOT NULL REFERENCES identite(id) ON DELETE CASCADE,
    date_entree_mada DATE NOT NULL,
    lieu_entree VARCHAR(100),               -- ex: 'Nosy Be', 'Tana'
    date_sortie_prevue DATE,                -- date de sortie prévue (référence)
    date_expiration_visa DATE NOT NULL,
    numero_visa VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. TABLE DEMANDE TITRE (le "nouveau titre")
CREATE TABLE demande_titre (
    id SERIAL PRIMARY KEY,
    identite_id INT NOT NULL REFERENCES identite(id) ON DELETE CASCADE,
    visa_id INT REFERENCES visa_transformable(id) ON DELETE SET NULL,
    statut_id INT NOT NULL REFERENCES statut_demande(id),
    date_soumission DATE,
    date_decision DATE,
    commentaire_admin TEXT,
    numero_dossier VARCHAR(50) UNIQUE,  -- numéro unique généré automatiquement
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. TABLE PIÈCES COMMUNES (référentiel)
CREATE TABLE piece_commune (
    id SERIAL PRIMARY KEY,
    nom_piece VARCHAR(150) NOT NULL UNIQUE,
    description TEXT,
    ordre_affichage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. TABLE PIÈCES COMPLÉMENTAIRES (liées à un type d'identité)
CREATE TABLE piece_complementaire (
    id SERIAL PRIMARY KEY,
    type_identite_id INT NOT NULL REFERENCES type_identite(id) ON DELETE CASCADE,
    nom_piece VARCHAR(150) NOT NULL,
    obligatoire BOOLEAN DEFAULT TRUE,
    ordre_affichage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(type_identite_id, nom_piece)
);

-- 9. TABLE DE LIAISON : demande + pièce commune + fourni
CREATE TABLE demande_piece_commune_fournie (
    demande_id INT NOT NULL REFERENCES demande_titre(id) ON DELETE CASCADE,
    piece_commune_id INT NOT NULL REFERENCES piece_commune(id),
    fourni BOOLEAN DEFAULT FALSE,
    date_depot DATE,
    remarque TEXT,
    PRIMARY KEY (demande_id, piece_commune_id)
);

-- 10. TABLE DE LIAISON : demande + pièce complémentaire + fourni
CREATE TABLE demande_piece_complementaire_fournie (
    demande_id INT NOT NULL REFERENCES demande_titre(id) ON DELETE CASCADE,
    piece_complementaire_id INT NOT NULL REFERENCES piece_complementaire(id),
    fourni BOOLEAN DEFAULT FALSE,
    date_depot DATE,
    remarque TEXT,
    PRIMARY KEY (demande_id, piece_complementaire_id)
);

-- =====================================================
-- INSERTION DES DONNÉES DE RÉFÉRENCE
-- =====================================================

-- 1. Types d'identité
INSERT INTO type_identite (libelle, description, ordre_affichage) VALUES
('Travailleur', 'Personne exerçant une activité salariée à Madagascar', 1),
('Investisseur', 'Personne investissant dans l’économie malgache', 2),
('Etudiant', 'Personne inscrite dans un établissement d’enseignement à Madagascar', 3);

-- 2. Statuts de demande (workflow)
INSERT INTO statut_demande (libelle, ordre, couleur) VALUES
('brouillon', 10, 'gris'),
('soumis', 20, 'bleu'),
('en_instruction', 30, 'orange'),
('valide', 40, 'vert'),
('rejete', 50, 'rouge');

-- 3. Pièces communes (toutes demandes confondues)
INSERT INTO piece_commune (nom_piece, description, ordre_affichage) VALUES
('02 photos d’identité', 'Format standard 4x3 ou 5x5', 1),
('Notice de renseignement', 'Formulaire dûment rempli', 2),
('Demande adressée à Mr le Ministère de l’Intérieur et de la Décentralisation avec adresse e-mail et numéro téléphone portable', 'Lettre manuscrite ou tapée', 3),
('Photocopie certifiée du visa en cours de validité', 'Visa transformable ou autre', 4),
('Photocopie certifiée de la première page du passeport', 'Pages d’identité et tampons', 5),
('Photocopie certifiée de la carte résident en cours de validité', 'Uniquement si renouvellement', 6),
('Certificat de résidence à Madagascar', 'Délivré par la commune', 7),
('Extrait de casier judiciaire moins de 3 mois', 'Bulletin n°3', 8);

-- 4. Pièces complémentaires par type d'identité
-- Récupérer les ID des types (je les cherche par libellé pour éviter de hardcoder les ID)
DO $$
DECLARE
    v_travailleur_id INT;
    v_investisseur_id INT;
    v_etudiant_id INT;
BEGIN
    SELECT id INTO v_travailleur_id FROM type_identite WHERE libelle = 'Travailleur';
    SELECT id INTO v_investisseur_id FROM type_identite WHERE libelle = 'Investisseur';
    SELECT id INTO v_etudiant_id FROM type_identite WHERE libelle = 'Etudiant';

    -- Travailleur
    INSERT INTO piece_complementaire (type_identite_id, nom_piece, obligatoire, ordre_affichage) VALUES
    (v_travailleur_id, 'Autorisation emploi délivrée à Madagascar par le Ministère de la Fonction publique', true, 1),
    (v_travailleur_id, 'Attestation d’emploi délivré par l’employeur (Original)', true, 2);

    -- Investisseur
    INSERT INTO piece_complementaire (type_identite_id, nom_piece, obligatoire, ordre_affichage) VALUES
    (v_investisseur_id, 'Statut de la Société', true, 1),
    (v_investisseur_id, 'Extrait d’inscription au registre de commerce', true, 2),
    (v_investisseur_id, 'Carte fiscale', true, 3);

    -- Étudiant (vous pourrez compléter)
    INSERT INTO piece_complementaire (type_identite_id, nom_piece, obligatoire, ordre_affichage) VALUES
    (v_etudiant_id, 'Certificat d’inscription dans un établissement reconnu', true, 1),
    (v_etudiant_id, 'Justificatif de moyens financiers (relevé bancaire ou attestation)', true, 2);
END $$;

-- =====================================================
-- INDEX POUR LES PERFORMANCES
-- =====================================================
CREATE INDEX idx_identite_type ON identite(type_identite_id);
CREATE INDEX idx_identite_nationalite ON identite(nationalite);
CREATE INDEX idx_passeport_identite ON passeport(identite_id);
CREATE INDEX idx_visa_identite ON visa_transformable(identite_id);
CREATE INDEX idx_demande_identite ON demande_titre(identite_id);
CREATE INDEX idx_demande_statut ON demande_titre(statut_id);
CREATE INDEX idx_demande_numero ON demande_titre(numero_dossier);
CREATE INDEX idx_demande_piece_commune_demande ON demande_piece_commune_fournie(demande_id);
CREATE INDEX idx_demande_piece_complementaire_demande ON demande_piece_complementaire_fournie(demande_id);

-- =====================================================
-- FONCTION POUR GÉNÉRER AUTO LE NUMÉRO DE DOSSIER
-- =====================================================
CREATE OR REPLACE FUNCTION generer_numero_dossier()
RETURNS TRIGGER AS $$
DECLARE
    annee TEXT;
    mois TEXT;
    sequence INT;
BEGIN
    annee := to_char(NEW.created_at, 'YYYY');
    mois := to_char(NEW.created_at, 'MM');
    
    -- Compter combien de dossiers cette année
    SELECT COALESCE(MAX(CAST(split_part(numero_dossier, '-', 3) AS INT)), 0) + 1
    INTO sequence
    FROM demande_titre
    WHERE numero_dossier LIKE 'DOS-' || annee || '-' || mois || '-%';
    
    NEW.numero_dossier := 'DOS-' || annee || '-' || mois || '-' || LPAD(sequence::TEXT, 4, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Déclencher la génération auto avant insertion
CREATE TRIGGER trigger_generer_numero_dossier
BEFORE INSERT ON demande_titre
FOR EACH ROW
WHEN (NEW.numero_dossier IS NULL)
EXECUTE FUNCTION generer_numero_dossier();

-- =====================================================
-- FONCTION POUR METTRE À JOUR updated_at
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_identite_updated_at
BEFORE UPDATE ON identite
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_demande_updated_at
BEFORE UPDATE ON demande_titre
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- EXEMPLE D'INSERTION (pour tester)
-- =====================================================
DO $$
DECLARE
    v_type_id INT;
    v_statut_brouillon_id INT;
    v_identite_id INT;
    v_visa_id INT;
    v_demande_id INT;
BEGIN
    -- Récupérer les IDs
    SELECT id INTO v_type_id FROM type_identite WHERE libelle = 'Investisseur';
    SELECT id INTO v_statut_brouillon_id FROM statut_demande WHERE libelle = 'brouillon';
    
    -- 1. Créer une identité
    INSERT INTO identite (type_identite_id, nom, prenom, situation_familiale, nationalite, email, telephone)
    VALUES (v_type_id, 'Rakoto', 'Jean', 'marié', 'Française', 'jean.rakoto@email.com', '0321234567')
    RETURNING id INTO v_identite_id;
    
    -- 2. Ajouter un passeport
    INSERT INTO passeport (identite_id, numero, date_delivrance, date_expiration)
    VALUES (v_identite_id, 'FR123456', '2020-01-01', '2030-01-01');
    
    -- 3. Ajouter un visa transformable
    INSERT INTO visa_transformable (identite_id, date_entree_mada, lieu_entree, date_sortie_prevue, date_expiration_visa)
    VALUES (v_identite_id, '2025-03-01', 'Nosy Be', '2026-03-01', '2025-08-01')
    RETURNING id INTO v_visa_id;
    
    -- 4. Créer une demande
    INSERT INTO demande_titre (identite_id, visa_id, statut_id)
    VALUES (v_identite_id, v_visa_id, v_statut_brouillon_id)
    RETURNING id INTO v_demande_id;
    
    -- 5. Lier toutes les pièces communes (non fournies par défaut)
    INSERT INTO demande_piece_commune_fournie (demande_id, piece_commune_id, fourni)
    SELECT v_demande_id, id, false FROM piece_commune;
    
    -- 6. Lier toutes les pièces complémentaires pour ce type (Investisseur)
    INSERT INTO demande_piece_complementaire_fournie (demande_id, piece_complementaire_id, fourni)
    SELECT v_demande_id, pc.id, false
    FROM piece_complementaire pc
    WHERE pc.type_identite_id = v_type_id;
    
    RAISE NOTICE 'Identité créée avec ID : %, Demande créée avec ID : %, Numéro dossier : %', v_identite_id, v_demande_id, (SELECT numero_dossier FROM demande_titre WHERE id = v_demande_id);
END $$;

-- =====================================================
-- REQUÊTE POUR VOIR L'ÉTAT D'UNE DEMANDE (exemple)
-- =====================================================
-- SELECT 
--     d.id AS demande_id,
--     d.numero_dossier,
--     i.nom,
--     i.prenom,
--     t.libelle AS type_identite,
--     s.libelle AS statut,
--     d.date_soumission
-- FROM demande_titre d
-- JOIN identite i ON d.identite_id = i.id
-- JOIN type_identite t ON i.type_identite_id = t.id
-- JOIN statut_demande s ON d.statut_id = s.id
-- ORDER BY d.created_at DESC;

-- =====================================================
-- FIN DU SCRIPT
-- =====================================================