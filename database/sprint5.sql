INSERT INTO statut_demande (code, libelle)
VALUES ('SIGNATURE_WEBCAM_TERMINE', 'Signature et webcam terminé')
ON CONFLICT (code) DO NOTHING;
