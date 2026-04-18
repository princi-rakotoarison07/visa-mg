-- Fichier de nettoyage (DROP ALL)
-- Basé sur les entités de basev2.sql

DROP TABLE IF EXISTS demande_piece_complementaire CASCADE;
DROP TABLE IF EXISTS catalogue_piece_complementaire CASCADE;
DROP TABLE IF EXISTS demande_piece_commune CASCADE;
DROP TABLE IF EXISTS catalogue_piece_commune CASCADE;
DROP TABLE IF EXISTS carte_resident CASCADE;
DROP TABLE IF EXISTS visa CASCADE;
DROP TABLE IF EXISTS demande_statut_historique CASCADE;
DROP TABLE IF EXISTS demande CASCADE;
DROP TABLE IF EXISTS visa_transformable CASCADE;
DROP TABLE IF EXISTS passeport_statut CASCADE;
DROP TABLE IF EXISTS passeport CASCADE;
DROP TABLE IF EXISTS demandeur CASCADE;
DROP TABLE IF EXISTS statut_piece CASCADE;
DROP TABLE IF EXISTS statut_demande CASCADE;
DROP TABLE IF EXISTS statut_passeport CASCADE;
DROP TABLE IF EXISTS type_demande CASCADE;
DROP TABLE IF EXISTS type_visa CASCADE;
DROP TABLE IF EXISTS situation_familiale CASCADE;
DROP TABLE IF EXISTS nationalite CASCADE;

-- Anciennes tables persistantes au cas où (issues de la V1 et JPA Spring)
DROP TABLE IF EXISTS dossier_piece_complementaire CASCADE;
DROP TABLE IF EXISTS dossier_piece_commune CASCADE;
DROP TABLE IF EXISTS dossier CASCADE;
DROP TABLE IF EXISTS type_identite CASCADE;
DROP TABLE IF EXISTS statut_dossier CASCADE;
