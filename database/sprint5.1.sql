INSERT INTO catalogue_piece_commune (code, libelle)
VALUES ('WEBCAM', 'Photo webcam')
ON CONFLICT (code) DO NOTHING;

INSERT INTO catalogue_piece_commune (code, libelle)
VALUES ('SIGNATURE', 'Signature (trackpad)')
ON CONFLICT (code) DO NOTHING;
