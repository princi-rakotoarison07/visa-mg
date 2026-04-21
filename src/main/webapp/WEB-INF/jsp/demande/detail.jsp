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
        .btn-scan { background-color: #17a2b8; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-scan:disabled { background-color: #ccc; cursor: not-allowed; }
        .btn-approuver { background-color: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-rejeter { background-color: #dc3545; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-retour { background-color: #6c757d; color: white; padding: 10px 20px; border-radius: 4px; text-decoration: none; font-weight: bold; }
        
        #rejet-form { display: none; margin-top: 10px; padding: 15px; border: 1px solid #dc3545; border-radius: 4px; background: #fff; }
        .badge-statut { display: inline-block; padding: 5px 10px; border-radius: 12px; font-weight: bold; color: white; }
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
                <h2>Informations Générales <span id="dossier-statut" class="badge-statut"></span></h2>
                <div class="info-grid" id="info-demandeur">
                    <div>Chargement...</div>
                </div>
            </div>

            <div class="details-section">
                <h2>Pièces Justificatives</h2>
                
                <div class="progress-container">
                    <div id="progress-bar" class="progress-bar" style="width: 0%">0 / 0</div>
                </div>

                <div id="pieces-container">
                    <div>Chargement des pièces...</div>
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

        </section>
    </main>
</div>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    const dossierId = urlParams.get('id');
    let totalObligatoire = 0;
    let fournisObligatoire = 0;

    if (!dossierId) {
        alert("ID du dossier manquant !");
        window.location.href = "/demande/liste";
    }

    document.addEventListener("DOMContentLoaded", function() {
        chargerDossier();
        chargerPieces();
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
                    document.getElementById('info-demandeur').innerHTML = 
                        '<div><strong>Nom :</strong> ' + d.demandeur.nom + ' ' + d.demandeur.prenom + '</div>' +
                        '<div><strong>Date demande :</strong> ' + d.dateDemande + '</div>' +
                        '<div><strong>Type de Demande :</strong> ' + d.typeDemande.libelle + '</div>' +
                        '<div><strong>Type Visa :</strong> ' + d.typeIdentite.libelle + '</div>' +
                        '<div><strong>Téléphone :</strong> ' + d.demandeur.telephone + '</div>' +
                        '<div><strong>Email :</strong> ' + d.demandeur.email + '</div>' +
                        '<div><strong>Lieu entrée :</strong> ' + (d.visaTransformable ? d.visaTransformable.lieuEntree : '-') + '</div>' +
                        '<div><strong>Date entrée :</strong> ' + (d.visaTransformable ? d.visaTransformable.dateEntree : '-') + '</div>';
                }
            })
            .catch(err => alert("Erreur: " + err.message));
    }

    function chargerPieces() {
        fetch('/api/dossiers/' + dossierId + '/pieces')
            .then(res => res.json())
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
            .catch(err => console.error("Erreur pièces", err));
    }

    function renderPiece(container, p, type) {
        const cat = type === 'commune' ? p.cataloguePiece : p.catalogueComplementaire;
        const statutCode = p.statutPiece.code;
        const isFourni = statutCode === 'FOURNI';
        // En v2.sql sans est_obligatoire visible de l'API (sauf si on l'a rajouté), on assume tout obligatoire pour l'instant ou selon le cas.
        // Puisque nous l'avons rajouté, on peut l'utiliser
        const isObligatoire = cat.estObligatoire !== false; // par défaut true
        
        let html = '';
        
        if (isObligatoire) totalObligatoire++;
        if (isObligatoire && isFourni) fournisObligatoire++;

        const cssClass = isFourni ? 'fourni' : 'non-fourni';
        const iconInfo = isFourni 
            ? '<span class="status-icon success">✓</span>' 
            : '<span class="status-icon danger">✗</span>';

        // Bouton d'upload (seulement si non fourni)
        let actionHtml = '';
        if (isFourni) {
            actionHtml = '<a href="/api/files/' + p.fichierPath + '" target="_blank" style="margin-right:10px;">Voir le fichier</a>';
        } else {
            actionHtml = 
                '<input type="file" id="file-' + type + '-' + p.id + '" style="display:none;" onchange="uploadFichier(this, ' + p.id + ', \'' + type + '\')" />' +
                '<button type="button" class="upload-btn" onclick="document.getElementById(\'file-' + type + '-' + p.id + '\').click()">Choisir fichier</button>';
        }

        html += '<div class="checklist-item ' + cssClass + '">' +
                '  <div>' + iconInfo + ' <strong>' + cat.libelle + '</strong>' + 
                   (isObligatoire ? ' <span style="color:red;font-size:0.8rem;">*</span' : '') + '</div>' +
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

    // -- Pour le sprint suivant, la partie approbation/rejet
    function approuverDemande() {
        alert("Approbtion à implémenter dans l'API...");
        // Appel API à faire...
    }

    function rejeterDemande() {
        const motif = document.getElementById('motif-rejet').value;
        if (!motif) {
            alert("Veuillez saisir un motif de rejet");
            return;
        }
        alert("Rejet à implémenter dans l'API avec motif: " + motif);
        // Appel API à faire...
    }

</script>
</body>
</html>
