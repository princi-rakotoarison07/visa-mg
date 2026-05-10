<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Détail de la Demande | visa-mg</title>
    <link rel="stylesheet" href="/css/app.css" />
    <style>
        .details-section { margin-bottom: 20px; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .details-section h2 { margin-top: 0; border-bottom: 2px solid #007bff; padding-bottom: 10px; color: #007bff; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .info-grid div { margin-bottom: 10px; }
        .info-grid strong { display: inline-block; width: 150px; color: #555; }
        .checklist-item {
            display: flex; align-items: center; justify-content: space-between;
            padding: 10px; border: 1px solid #eee; margin-bottom: 5px; border-radius: 4px;
        }
        .checklist-item.fourni { background-color: #d4edda; border-color: #c3e6cb; }
        .checklist-item.non-fourni { background-color: #f8d7da; border-color: #f5c6cb; }
        .status-icon { font-weight: bold; margin-right: 10px; }
        .status-icon.success { color: #155724; }
        .status-icon.danger { color: #721c24; }
        .upload-btn { background: #007bff; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
        .upload-btn:hover { background: #0056b3; }
        .progress-container { width: 100%; background-color: #e9ecef; border-radius: 4px; margin: 20px 0; height: 20px; overflow: hidden; }
        .progress-bar { height: 100%; background-color: #28a745; text-align: center; color: white; line-height: 20px; font-size: 0.8rem; transition: width 0.3s ease; }
        
        .action-buttons { margin-top: 20px; display: flex; gap: 10px; padding-top: 20px; border-top: 1px solid #ddd; }
        .document-badge { background: #6f42c1; color: white; padding: 3px 8px; border-radius: 4px; font-size: 0.8rem; font-weight: bold; margin-right: 5px; }
        .btn-scan { background-color: #17a2b8; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-scan:disabled { background-color: #ccc; cursor: not-allowed; }
        .btn-approuver { background-color: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-rejeter { background-color: #dc3545; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-retour { background-color: #6c757d; color: white; padding: 10px 20px; border-radius: 4px; text-decoration: none; font-weight: bold; }
        
        #rejet-form { display: none; margin-top: 10px; padding: 15px; border: 1px solid #dc3545; border-radius: 4px; background: #fff; }
        .badge-statut { display: inline-block; padding: 5px 10px; border-radius: 12px; font-weight: bold; color: white; }
        
        .history-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .history-table th, .history-table td { padding: 10px; border: 1px solid #eee; text-align: left; }
        .history-table th { background-color: #f8f9fa; color: #555; }
        .history-date { white-space: nowrap; color: #666; font-size: 0.9rem; }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/jsp/components/sidebar.jsp" />

    <main class="main">
        <jsp:include page="/WEB-INF/jsp/components/header.jsp" />

        <section class="content">
            <h1 id="page-title">Détail de la Demande #...</h1>
            <a href="/demande/liste" class="btn-retour" style="margin-bottom: 20px; display: inline-block;">← Retour à la liste</a>

            <div class="details-section">
                <h2>👤 État Civil & Coordonnées</h2>
                <div class="info-grid" id="info-identite">
                    <div>Chargement...</div>
                </div>
            </div>

            <div class="details-section">
                <h2>🛂 Passeport(s) du Demandeur</h2>
                <div id="info-passeports">
                    <p>Chargement des passeports...</p>
                </div>
            </div>

            <div class="details-section">
                <h2>📝 Détails de la Demande <span id="dossier-statut" class="badge-statut"></span></h2>
                <div class="info-grid" id="info-demande">
                    <div>Chargement...</div>
                </div>
            </div>

            <div class="details-section">
                <h2>📁 Pièces Justificatives</h2>
                
                <div class="progress-container">
                    <div id="progress-bar" class="progress-bar" style="width: 0%">0 / 0</div>
                </div>

                <div id="pieces-container">
                    <div>Chargement des pièces...</div>
                </div>

                <div id="capture-modal" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.6); z-index:9999; align-items:center; justify-content:center;">
                    <div style="background:#fff; padding:20px; border-radius:8px; width:min(720px, 95vw); max-height:90vh; overflow:auto;">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
                            <h3 id="capture-title" style="margin:0;">Capture</h3>
                            <button type="button" class="btn-retour" style="border:none;" onclick="closeCaptureModal()">Fermer</button>
                        </div>

                        <div id="webcam-panel" style="display:none;">
                            <video id="webcam-video" autoplay playsinline style="width:100%; border:1px solid #ddd; border-radius:6px;"></video>
                            <canvas id="webcam-canvas" style="display:none;"></canvas>
                            <div style="display:flex; gap:10px; margin-top:10px;">
                                <button type="button" class="upload-btn" onclick="captureWebcamPhoto()">Capturer</button>
                                <button type="button" class="upload-btn" onclick="saveWebcamPhoto()">Enregistrer</button>
                            </div>
                            <div id="webcam-status" style="margin-top:10px; color:#555;"></div>
                        </div>

                        <div id="signature-panel" style="display:none;">
                            <canvas id="signature-canvas" style="width:100%; height:220px; border:1px solid #ddd; border-radius:6px; touch-action:none;"></canvas>
                            <div style="display:flex; gap:10px; margin-top:10px;">
                                <button type="button" class="upload-btn" onclick="clearSignature()">Effacer</button>
                                <button type="button" class="upload-btn" onclick="saveSignature()">Enregistrer</button>
                            </div>
                            <div id="signature-status" style="margin-top:10px; color:#555;"></div>
                        </div>
                    </div>
                </div>

                <div class="action-buttons">
                    <button id="btn-scan" class="btn-scan" disabled onclick="terminerScan()">Mettre le statut "Scan terminé"</button>
                </div>
                
                <div id="decision-actions" class="action-buttons" style="display: none;">
                    <button class="btn-approuver" onclick="approuverDemande()">Approuver le dossier</button>
                    <button class="btn-rejeter" onclick="document.getElementById('rejet-form').style.display = 'block'">Rejeter le dossier</button>
                </div>
                
                <div id="rejet-form">
                    <h4>Motif du rejet</h4>
                    <textarea id="motif-rejet" style="width: 100%; height: 80px; margin-bottom: 10px; padding: 5px;"></textarea>
                    <button class="btn-rejeter" onclick="rejeterDemande()">Confirmer le rejet</button>
                    <button class="btn-retour" onclick="document.getElementById('rejet-form').style.display = 'none'" style="border:none;">Annuler</button>
                </div>
            </div>

            <div class="details-section" id="section-documents" style="display:none;">
                <h2>📜 Titres Émis (Visas / Cartes)</h2>
                <div id="info-documents">
                    <p>Chargement des titres...</p>
                </div>
            </div>

            <div class="details-section">
                <h2>🕒 Historique des Statuts</h2>
                <div id="history-container">
                    <p>Chargement de l'historique...</p>
                </div>
            </div>

        </section>
    </main>
</div>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    const dossierId = urlParams.get('id');
    let totalObligatoire = 0;
    let fournisObligatoire = 0;

    let currentCapturePieceId = null;
    let webcamStream = null;
    let webcamCapturedBlob = null;
    let signatureDrawing = false;
    let signatureLastX = 0;
    let signatureLastY = 0;

    if (!dossierId) {
        alert("ID du dossier manquant !");
        window.location.href = "/demande/liste";
    }

    document.addEventListener("DOMContentLoaded", function() {
        chargerDossier();
        chargerPieces();
        chargerHistorique();
        chargerDocuments();
    });

    function getStatutColor(code) {
        switch(code) {
            case 'CREER': return '#17a2b8';
            case 'SCAN_TERMINER': return '#007bff';
            case 'APPROUVEE': return '#28a745';
            case 'REJETEE': return '#dc3545';
            default: return '#6c757d';
        }
    }

    function chargerDossier() {
        document.getElementById('page-title').innerText = "Détail de la Demande #" + dossierId;
        
        fetch('/api/dossiers/' + dossierId)
            .then(res => {
                if (res.status === 404) throw new Error("Dossier introuvable");
                if (!res.ok) throw new Error("Erreur de récupération");
                return res.json();
            })
            .then(d => {
                const badge = document.getElementById('dossier-statut');
                badge.innerText = d.statutDossier.libelle;
                badge.style.backgroundColor = getStatutColor(d.statutDossier.code);

                // Afficher les actions d'approbation si le scan est terminé
                if (d.statutDossier.code === 'SCAN_TERMINER') {
                    document.getElementById('decision-actions').style.display = 'flex';
                    document.getElementById('btn-scan').style.display = 'none';
                } else if (d.statutDossier.code === 'APPROUVEE' || d.statutDossier.code === 'REJETEE') {
                    document.getElementById('btn-scan').style.display = 'none';
                    document.getElementById('decision-actions').style.display = 'none';
                }

                if (d.demandeur) {
                    // Section Identité
                    document.getElementById('info-identite').innerHTML = 
                        '<div><strong>Nom Complet :</strong> ' + d.demandeur.nom + ' ' + d.demandeur.prenom + '</div>' +
                        '<div><strong>Date Naissance :</strong> ' + d.demandeur.dateNaissance + '</div>' +
                        '<div><strong>Lieu Naissance :</strong> ' + d.demandeur.lieuNaissance + '</div>' +
                        '<div><strong>Nationalité :</strong> ' + (d.demandeur.nationalite ? d.demandeur.nationalite.libelle : '-') + '</div>' +
                        '<div><strong>Sit. Familiale :</strong> ' + (d.demandeur.situationFamiliale ? d.demandeur.situationFamiliale.libelle : '-') + '</div>' +
                        '<div><strong>Téléphone :</strong> ' + d.demandeur.telephone + '</div>' +
                        '<div><strong>Email :</strong> ' + d.demandeur.email + '</div>' +
                        '<div><strong>Adresse :</strong> ' + d.demandeur.adresse + '</div>';
                    
                    // Section Demande
                    document.getElementById('info-demande').innerHTML = 
                        '<div><strong>N° Demande :</strong> #' + d.id + '</div>' +
                        '<div><strong>Date Demande :</strong> ' + d.dateDemande + '</div>' +
                        '<div><strong>Type Demande :</strong> ' + d.typeDemande.libelle + '</div>' +
                        '<div><strong>Type Visa :</strong> ' + d.typeIdentite.libelle + '</div>' +
                        '<div><strong>Lieu Entrée :</strong> ' + (d.visaTransformable ? d.visaTransformable.lieuEntree : '-') + '</div>' +
                        '<div><strong>Date Entrée :</strong> ' + (d.visaTransformable ? d.visaTransformable.dateEntree : '-') + '</div>';

                    // Charger les passeports
                    chargerPasseports(d.demandeur.id);
                }
            })
            .catch(err => {
                alert("Erreur: " + err.message);
                if (err.message === 'Dossier introuvable') {
                    window.location.href = "/demande/liste";
                }
            });
    }

    function chargerDocuments() {
        fetch('/api/dossiers/' + dossierId + '/documents')
            .then(res => res.json())
            .then(data => {
                const container = document.getElementById('info-documents');
                const section = document.getElementById('section-documents');
                
                const hasVisas = data.visas && data.visas.length > 0;
                const hasCartes = data.cartes && data.cartes.length > 0;

                if (!hasVisas && !hasCartes) {
                    section.style.display = 'none';
                    return;
                }

                section.style.display = 'block';
                let html = '<table class="history-table">' +
                           '<thead><tr><th>Type</th><th>Référence</th><th>Validité</th></tr></thead>' +
                           '<tbody>';
                
                if (hasVisas) {
                    data.visas.forEach(v => {
                        html += '<tr>' +
                                '  <td><span class="document-badge">VISA</span></td>' +
                                '  <td><strong>' + v.reference + '</strong></td>' +
                                '  <td>Du ' + v.dateDebut + ' au ' + v.dateFin + '</td>' +
                                '</tr>';
                    });
                }

                if (hasCartes) {
                    data.cartes.forEach(c => {
                        html += '<tr>' +
                                '  <td><span class="document-badge" style="background:#e83e8c;">CARTE</span></td>' +
                                '  <td><strong>' + c.reference + '</strong></td>' +
                                '  <td>Du ' + c.dateDebut + ' au ' + c.dateFin + '</td>' +
                                '</tr>';
                    });
                }
                
                html += '</tbody></table>';
                container.innerHTML = html;
            })
            .catch(err => console.error("Erreur documents", err));
    }

    function chargerPasseports(demandeurId) {
        fetch('/api/passeports/demandeur/' + demandeurId)
            .then(res => res.json())
            .then(data => {
                const container = document.getElementById('info-passeports');
                if (!data || data.length === 0) {
                    container.innerHTML = '<p>Aucun passeport enregistré pour ce demandeur.</p>';
                    return;
                }

                let html = '<table class="history-table">' +
                           '<thead><tr><th>N° Passeport</th><th>Pays</th><th>Délivrance</th><th>Expiration</th></tr></thead>' +
                           '<tbody>';
                
                data.forEach(p => {
                    html += '<tr>' +
                            '  <td><strong>' + p.numeroPasseport + '</strong></td>' +
                            '  <td>' + (p.paysDelivrance ? p.paysDelivrance.libelle : '-') + '</td>' +
                            '  <td>' + p.dateDelivrance + '</td>' +
                            '  <td>' + p.dateExpiration + '</td>' +
                            '</tr>';
                });
                
                html += '</tbody></table>';
                container.innerHTML = html;
            })
            .catch(err => {
                console.error("Erreur passeports", err);
                document.getElementById('info-passeports').innerHTML = '<p style="color:red;">Erreur lors du chargement des passeports.</p>';
            });
    }

    function chargerPieces() {
        fetch('/api/dossiers/' + dossierId + '/pieces')
            .then(res => {
                if (res.status === 404) throw new Error('Dossier introuvable');
                return res.json();
            })
            .then(data => {
                const container = document.getElementById('pieces-container');
                container.innerHTML = '<h3>Pièces Communes</h3>';
                
                totalObligatoire = 0;
                fournisObligatoire = 0;

                // Pièces communes
                if (data.piecesCommunes) {
                    data.piecesCommunes.forEach(p => renderPiece(container, p, 'commune'));
                }

                container.innerHTML += '<h3 style="margin-top:20px;">Pièces Complémentaires</h3>';
                
                if (data.piecesComplementaires && data.piecesComplementaires.length > 0) {
                    data.piecesComplementaires.forEach(p => renderPiece(container, p, 'complementaire'));
                } else {
                    container.innerHTML += '<p>Aucune pièce complémentaire requise.</p>';
                }

                updateProgressBar();
            })
            .catch(err => {
                console.error("Erreur pièces", err);
                if (err.message === 'Dossier introuvable') {
                    alert('Dossier introuvable');
                    window.location.href = "/demande/liste";
                }
            });
    }

    function renderPiece(container, p, type) {
        const cat = type === 'commune' ? p.cataloguePiece : p.catalogueComplementaire;
        const statutCode = p.statutPiece.code;
        const isFourni = statutCode === 'FOURNI';
        const isApplicable = statutCode !== 'NON_APPLICABLE';
        const isObligatoire = (type === 'commune') ? true : (cat.estObligatoire !== false);
        const code = (cat && cat.code) ? cat.code : null;
        const isCaptureRequired = (type === 'commune') && (code === 'WEBCAM' || code === 'SIGNATURE');
        
        let html = '';
        
        if (isApplicable && isObligatoire) totalObligatoire++;
        if (isApplicable && isObligatoire && isFourni) fournisObligatoire++;

        const cssClass = isFourni ? 'fourni' : 'non-fourni';
        const iconInfo = isFourni 
            ? '<span class="status-icon success">✓</span>' 
            : '<span class="status-icon danger">✗</span>';

        // Bouton d'upload (seulement si non fourni)
        let actionHtml = '';
        if (!isApplicable) {
            actionHtml = '<span style="color:#6c757d; font-size:0.9rem;">Non coché</span>';
        } else if (isFourni) {
            actionHtml = '<a href="/api/files/' + p.fichierPath + '" target="_blank" style="margin-right:10px;">Voir le fichier</a>';
        } else {
            if (type === 'commune' && code === 'WEBCAM') {
                actionHtml = '<button type="button" class="upload-btn" onclick="openWebcamCapture(' + p.id + ')">Webcam</button>';
            } else if (type === 'commune' && code === 'SIGNATURE') {
                actionHtml = '<button type="button" class="upload-btn" onclick="openSignatureCapture(' + p.id + ')">Signer</button>';
            } else {
                actionHtml =
                    '<input type="file" id="file-' + type + '-' + p.id + '" style="display:none;" onchange="uploadFichier(this, ' + p.id + ', \'' + type + '\')" />' +
                    '<button type="button" class="upload-btn" onclick="document.getElementById(\'file-' + type + '-' + p.id + '\').click()">Choisir fichier</button>';
            }
        }

        const checkedAttr = isApplicable ? 'checked' : '';
        const disabledAttr = isCaptureRequired ? 'disabled' : '';

        html += '<div class="checklist-item ' + cssClass + '">' +
                '  <div>' +
                '    <label style="display:flex; align-items:center; gap:10px;">' +
                '      <input type="checkbox" ' + checkedAttr + ' ' + disabledAttr + ' onchange="toggleApplicable(' + p.id + ', \'' + type + '\', this.checked)" />' +
                '      ' + iconInfo + ' <strong>' + cat.libelle + '</strong>' +
                '      ' + (isObligatoire ? '<span style="color:red;font-size:0.8rem;">*</span>' : '<span style="color:gray;font-size:0.8rem;">(facultatif)</span>') +
                '    </label>' +
                '  </div>' +
                '  <div>' + actionHtml + '</div>' +
                '</div>';
                
        container.innerHTML += html;
    }

    function updateProgressBar() {
        const bar = document.getElementById('progress-bar');
        const btnScan = document.getElementById('btn-scan');
        
        if (totalObligatoire === 0) {
            bar.style.width = '100%';
            bar.innerText = 'Aucune pièce';
            btnScan.disabled = false;
        } else {
            const pct = Math.round((fournisObligatoire / totalObligatoire) * 100);
            bar.style.width = pct + '%';
            bar.innerText = fournisObligatoire + ' / ' + totalObligatoire + ' (' + pct + '%)';
            
            btnScan.disabled = (fournisObligatoire < totalObligatoire);
        }
    }

    function uploadFichier(input, pieceId, type) {
        if (!input.files || input.files.length === 0) return;
        
        const formData = new FormData();
        formData.append('file', input.files[0]);

        // Upload d'abord le fichier sur le serveur
        fetch('/api/uploads', {
            method: 'POST',
            body: formData
        })
        .then(res => {
            if(!res.ok) throw new Error("Erreur lors de l'upload du fichier");
            return res.json();
        })
        .then(data => {
            const fichierPath = data.fichierPath;
            // Ensuite on assigne le fichier à la pièce
            const endpt = type === 'commune' ? 'pieces-communes' : 'pieces-complementaires';
            return fetch('/api/dossiers/' + dossierId + '/' + endpt + '/' + pieceId + '/upload', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ fichierPath: fichierPath })
            });
        })
        .then(res => {
            if(!res.ok) throw new Error("Erreur de mise à jour de la pièce");
            chargerPieces(); // recharger pour mettre à jour la barre de progression
        })
        .catch(err => alert(err.message));
    }

    function toggleApplicable(pieceId, type, applicable) {
        const endpt = type === 'commune' ? 'pieces-communes' : 'pieces-complementaires';
        return fetch('/api/dossiers/' + dossierId + '/' + endpt + '/' + pieceId + '/applicable', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ applicable: applicable })
        })
        .then(res => {
            if (!res.ok) throw new Error('Erreur lors de la mise à jour');
            chargerPieces();
        })
        .catch(err => alert(err.message));
    }

    function terminerScan() {
        if (!confirm("Voulez-vous clôturer la vérification des pièces et passer au statut Scan Terminé ?")) return;
        
        fetch('/api/dossiers/' + dossierId + '/scan-terminer', {
            method: 'PUT'
        })
        .then(res => {
            if(!res.ok) throw new Error("Erreur lors de la mise à jour du statut");
            alert("Le dossier est maintenant en SCAN TERMINÉ");
            chargerDossier();
        })
        .catch(err => alert("Erreur: " + err.message));
    }

    function openCaptureModal() {
        document.getElementById('capture-modal').style.display = 'flex';
    }

    function closeCaptureModal() {
        document.getElementById('capture-modal').style.display = 'none';
        document.getElementById('webcam-panel').style.display = 'none';
        document.getElementById('signature-panel').style.display = 'none';
        document.getElementById('webcam-status').innerText = '';
        document.getElementById('signature-status').innerText = '';
        webcamCapturedBlob = null;
        stopWebcam();
    }

    function stopWebcam() {
        if (webcamStream) {
            webcamStream.getTracks().forEach(t => t.stop());
            webcamStream = null;
        }
    }

    function openWebcamCapture(pieceId) {
        currentCapturePieceId = pieceId;
        document.getElementById('capture-title').innerText = 'Capture webcam';
        document.getElementById('signature-panel').style.display = 'none';
        document.getElementById('webcam-panel').style.display = 'block';
        document.getElementById('webcam-status').innerText = 'Autorisez la caméra puis capturez une photo.';
        openCaptureModal();

        navigator.mediaDevices.getUserMedia({ video: true })
            .then(stream => {
                webcamStream = stream;
                const video = document.getElementById('webcam-video');
                video.srcObject = stream;
            })
            .catch(err => {
                document.getElementById('webcam-status').innerText = "Accès caméra refusé/indisponible : " + err.message;
            });
    }

    function captureWebcamPhoto() {
        const video = document.getElementById('webcam-video');
        const canvas = document.getElementById('webcam-canvas');
        if (!video || video.videoWidth === 0) {
            document.getElementById('webcam-status').innerText = 'Webcam non prête.';
            return;
        }

        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

        canvas.toBlob(blob => {
            webcamCapturedBlob = blob;
            document.getElementById('webcam-status').innerText = 'Photo capturée. Cliquez sur Enregistrer.';
        }, 'image/png');
    }

    function saveWebcamPhoto() {
        if (!currentCapturePieceId) return;
        if (!webcamCapturedBlob) {
            document.getElementById('webcam-status').innerText = 'Veuillez capturer une photo d\'abord.';
            return;
        }

        const file = new File([webcamCapturedBlob], 'webcam.png', { type: 'image/png' });
        uploadGeneratedFileToPiece(file, currentCapturePieceId, 'commune')
            .then(() => {
                closeCaptureModal();
                chargerPieces();
            })
            .catch(err => {
                document.getElementById('webcam-status').innerText = 'Erreur : ' + err.message;
            });
    }

    function openSignatureCapture(pieceId) {
        currentCapturePieceId = pieceId;
        document.getElementById('capture-title').innerText = 'Signature (trackpad)';
        document.getElementById('webcam-panel').style.display = 'none';
        document.getElementById('signature-panel').style.display = 'block';
        document.getElementById('signature-status').innerText = 'Signez sur le pavé (ou souris), puis Enregistrer.';
        openCaptureModal();
        initSignatureCanvas();
        clearSignature();
    }

    function initSignatureCanvas() {
        const canvas = document.getElementById('signature-canvas');
        if (!canvas.__initialized) {
            canvas.__initialized = true;

            canvas.addEventListener('pointerdown', (e) => {
                signatureDrawing = true;
                const pos = getCanvasPos(canvas, e);
                signatureLastX = pos.x;
                signatureLastY = pos.y;
            });

            canvas.addEventListener('pointermove', (e) => {
                if (!signatureDrawing) return;
                const ctx = canvas.getContext('2d');
                const pos = getCanvasPos(canvas, e);
                ctx.lineWidth = 2;
                ctx.lineCap = 'round';
                ctx.strokeStyle = '#111';
                ctx.beginPath();
                ctx.moveTo(signatureLastX, signatureLastY);
                ctx.lineTo(pos.x, pos.y);
                ctx.stroke();
                signatureLastX = pos.x;
                signatureLastY = pos.y;
            });

            const end = () => { signatureDrawing = false; };
            canvas.addEventListener('pointerup', end);
            canvas.addEventListener('pointercancel', end);
            canvas.addEventListener('pointerleave', end);
        }

        const rect = canvas.getBoundingClientRect();
        const targetWidth = Math.max(1, Math.floor(rect.width));
        const targetHeight = Math.max(1, Math.floor(rect.height));
        if (canvas.width !== targetWidth || canvas.height !== targetHeight) {
            canvas.width = targetWidth;
            canvas.height = targetHeight;
        }
    }

    function getCanvasPos(canvas, e) {
        const rect = canvas.getBoundingClientRect();
        const scaleX = canvas.width / rect.width;
        const scaleY = canvas.height / rect.height;
        return {
            x: (e.clientX - rect.left) * scaleX,
            y: (e.clientY - rect.top) * scaleY
        };
    }

    function clearSignature() {
        const canvas = document.getElementById('signature-canvas');
        initSignatureCanvas();
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = '#fff';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
    }

    function saveSignature() {
        if (!currentCapturePieceId) return;
        const canvas = document.getElementById('signature-canvas');
        canvas.toBlob(blob => {
            if (!blob) {
                document.getElementById('signature-status').innerText = 'Impossible de générer l\'image.';
                return;
            }
            const file = new File([blob], 'signature.png', { type: 'image/png' });
            uploadGeneratedFileToPiece(file, currentCapturePieceId, 'commune')
                .then(() => {
                    closeCaptureModal();
                    chargerPieces();
                })
                .catch(err => {
                    document.getElementById('signature-status').innerText = 'Erreur : ' + err.message;
                });
        }, 'image/png');
    }

    function uploadGeneratedFileToPiece(file, pieceId, type) {
        const formData = new FormData();
        formData.append('file', file);

        return fetch('/api/uploads', {
            method: 'POST',
            body: formData
        })
        .then(res => {
            if (!res.ok) throw new Error("Erreur lors de l'upload du fichier");
            return res.json();
        })
        .then(data => {
            const fichierPath = data.fichierPath;
            const endpt = type === 'commune' ? 'pieces-communes' : 'pieces-complementaires';
            return fetch('/api/dossiers/' + dossierId + '/' + endpt + '/' + pieceId + '/upload', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ fichierPath: fichierPath })
            });
        })
        .then(res => {
            if (!res.ok) throw new Error('Erreur de mise à jour de la pièce');
        });
    }

    // -- Pour le sprint suivant, la partie approbation/rejet
    function approuverDemande() {
        if (!confirm("Voulez-vous approuver ce dossier ?")) return;
        
        fetch('/api/dossiers/' + dossierId + '/approuver', {
            method: 'PUT'
        })
        .then(res => {
            if(!res.ok) throw new Error("Erreur lors de l'approbation");
            alert("Dossier approuvé !");
            chargerDossier();
            chargerHistorique();
        })
        .catch(err => alert("Erreur: " + err.message));
    }

    function rejeterDemande() {
        const motif = document.getElementById('motif-rejet').value;
        if (!motif) {
            alert("Veuillez saisir un motif de rejet");
            return;
        }
        
        fetch('/api/dossiers/' + dossierId + '/rejeter', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ motif: motif })
        })
        .then(res => {
            if(!res.ok) throw new Error("Erreur lors du rejet");
            alert("Dossier rejeté !");
            document.getElementById('rejet-form').style.display = 'none';
            chargerDossier();
            chargerHistorique();
        })
        .catch(err => alert("Erreur: " + err.message));
    }

    function chargerHistorique() {
        fetch('/api/dossiers/' + dossierId + '/historique')
            .then(res => res.json())
            .then(data => {
                const container = document.getElementById('history-container');
                if (!data || data.length === 0) {
                    container.innerHTML = '<p>Aucun historique disponible.</p>';
                    return;
                }

                let html = '<table class="history-table">' +
                           '<thead><tr><th>Date</th><th>Statut</th><th>Commentaire</th><th>Par</th></tr></thead>' +
                           '<tbody>';
                
                data.forEach(h => {
                    const date = new Date(h.dateChangementStatut).toLocaleString();
                    html += '<tr>' +
                            '  <td class="history-date">' + date + '</td>' +
                            '  <td><span class="badge-statut" style="background-color:' + getStatutColor(h.statutDossier.code) + '; font-size:0.8rem;">' + h.statutDossier.libelle + '</span></td>' +
                            '  <td>' + (h.commentaire || '-') + '</td>' +
                            '  <td>' + (h.changedBy || 'SYSTEM') + '</td>' +
                            '</tr>';
                });
                
                html += '</tbody></table>';
                container.innerHTML = html;
            })
            .catch(err => {
                console.error("Erreur historique", err);
                document.getElementById('history-container').innerHTML = '<p style="color:red;">Erreur lors du chargement de l\'historique.</p>';
            });
    }

</script>
</body>
</html>
