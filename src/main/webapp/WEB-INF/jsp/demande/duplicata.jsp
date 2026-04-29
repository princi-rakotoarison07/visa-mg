<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Demande de Duplicata | visa-mg</title>
    <link rel="stylesheet" href="/css/app.css" />
    <style>
        .step { display: none; }
        .step.active { display: block; }
        .error { color: red; font-size: 0.8rem; display: none; }
        .input-error { border: 1px solid red; }
        .checklist { margin-top: 15px; }
        .checklist-item { margin-bottom: 10px; padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
        .checklist-item label { font-weight: bold; }
        .upload-row { display: flex; align-items: center; gap: 10px; margin-top: 5px; }
        .upload-status { font-size: 0.85rem; padding: 2px 8px; border-radius: 3px; }
        .upload-status.success { background: #d4edda; color: #155724; }
        .upload-status.pending { background: #fff3cd; color: #856404; }
        .doc-section { border: 1px solid #ccc; padding: 15px; margin-top: 10px; border-radius: 5px; background: #f9f9f9; }
        .doc-section h4 { margin-top: 0; }
        .checkbox-group { margin-bottom: 10px; }
        .checkbox-group label { cursor: pointer; font-weight: bold; }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/jsp/components/sidebar.jsp" />

    <main class="main">
        <jsp:include page="/WEB-INF/jsp/components/header.jsp" />

        <section class="content">
            <h1>Demande de Duplicata</h1>
            <div class="steps-indicator">
                <span id="indicator-1" style="font-weight: bold;">Étape 1</span> &gt;
                <span id="indicator-2">Étape 2</span> &gt;
                <span id="indicator-3">Étape 3</span> &gt;
                <span id="indicator-4">Étape 4 (Duplicata)</span>
            </div>

            <form id="demandeForm" onsubmit="return submitForm(event)">
                <!-- ETAPE 1: Etat Civil -->
                <div id="step-1" class="step active">
                    <h2>Étape 1 : État Civil</h2>
                    <div class="form-group">
                        <label>Nom *</label>
                        <input type="text" id="nom" name="nom" required />
                    </div>
                    <div class="form-group">
                        <label>Prénom *</label>
                        <input type="text" id="prenom" name="prenom" required />
                    </div>
                    <div class="form-group">
                        <label>Date de Naissance *</label>
                        <input type="date" id="dateNaissance" name="dateNaissance" required />
                    </div>
                    <div class="form-group">
                        <label>Lieu de Naissance *</label>
                        <input type="text" id="lieuNaissance" name="lieuNaissance" required />
                    </div>
                    <div class="form-group">
                        <label>Nationalité *</label>
                        <select id="nationalite_id" name="nationalite_id" required>
                            <option value="">Sélectionner</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Situation Familiale *</label>
                        <select id="situation_familiale_id" name="situation_familiale_id" required>
                            <option value="">Sélectionner</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Téléphone *</label>
                        <input type="tel" id="telephone" name="telephone" required />
                    </div>
                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email" id="email" name="email" required />
                    </div>
                    <div class="form-group">
                        <label>Adresse *</label>
                        <textarea id="adresse" name="adresse" required></textarea>
                    </div>
                    <button type="button" onclick="nextStep(1, 2)">Suivant</button>
                </div>

                <!-- ETAPE 2: Passeport et Visa Transformable (optionnel) -->
                <div id="step-2" class="step">
                    <h2>Étape 2 : Passeport et Visa Transformable</h2>
                    <h3>Passeport</h3>
                    <div class="form-group">
                        <label>Numéro de Passeport *</label>
                        <input type="text" id="numeroPasseport" name="numero_passeport" required />
                    </div>
                    <div class="form-group">
                        <label>Pays de délivrance *</label>
                        <select id="pays_delivrance_id" name="pays_delivrance_id" required>
                            <option value="">Sélectionner</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Date de délivrance *</label>
                        <input type="date" id="dateDelivrancePasseport" name="date_delivrance" required />
                    </div>
                    <div class="form-group">
                        <label>Date d'expiration *</label>
                        <input type="date" id="dateExpirationPasseport" name="date_expiration" required />
                    </div>

                    <!-- Visa Transformable : OPTIONNEL -->
                    <div class="checkbox-group" style="margin-top: 20px;">
                        <label style="font-size: 1.1rem;">
                            <input type="checkbox" id="chk_visa_transformable" onchange="toggleVisaTransformable()" />
                            Ajouter un Visa Transformable (optionnel)
                        </label>
                        <div class="hint" style="font-size:0.85rem; color:#6c757d; margin-top:4px;">Cochez uniquement si le demandeur possède un visa transformable à associer au duplicata.</div>
                    </div>
                    <div id="section_visa_transformable" class="doc-section" style="display:none; margin-top:10px;">
                        <h4>Visa Transformable</h4>
                        <div class="form-group">
                            <label>Numéro de référence</label>
                            <input type="text" id="numeroReferenceVisa" name="numero_reference" />
                        </div>
                        <div class="form-group">
                            <label>Lieu d'entrée *</label>
                            <input type="text" id="lieuEntree" name="lieu_entree" />
                        </div>
                        <div class="form-group">
                            <label>Date d'entrée *</label>
                            <input type="date" id="dateEntree" name="date_entree" />
                        </div>
                        <div class="form-group">
                            <label>Date d'expiration *</label>
                            <input type="date" id="dateExpirationVisa" name="date_expiration_visa" />
                        </div>
                    </div>
                    <button type="button" onclick="prevStep(2, 1)">Précédent</button>
                    <button type="button" onclick="nextStep(2, 3)">Suivant</button>
                </div>

                <!-- ETAPE 3: Type de Titre + Upload Pièces Complémentaires -->
                <div id="step-3" class="step">
                    <h2>Étape 3 : Type de Titre et Pièces Justificatives</h2>
                    <div class="form-group">
                        <label>Type de Titre *</label>
                        <select id="type_visa_id" name="type_visa_id" required onchange="updateChecklist()">
                            <option value="">Sélectionner</option>
                        </select>
                    </div>

                    <div id="checklist-container" class="checklist" style="display:none;">
                        <h3>Pièces communes à fournir</h3>
                        <div id="list-obligatoire"></div>

                        <h3 id="pieces-comp-title" style="display:none;">Pièces complémentaires (upload justificatif requis si obligatoire)</h3>
                        <div id="pieces-complementaires"></div>
                    </div>

                    <br/>
                    <button type="button" onclick="prevStep(3, 2)">Précédent</button>
                    <button type="button" onclick="nextStep(3, 4)">Suivant</button>
                </div>

                <!-- ETAPE 4: Duplicata — Choix Visa et/ou Carte Résident -->
                <div id="step-4" class="step">
                    <h2>Étape 4 : Documents à récupérer</h2>
                    <p><em>Cochez le(s) document(s) à reconstituer. Vous pouvez sélectionner les deux.</em></p>

                    <!-- Checkbox Visa -->
                    <div class="checkbox-group">
                        <label>
                            <input type="checkbox" id="chk_visa" onchange="toggleDocSection('visa')" />
                            Visa
                        </label>
                    </div>
                    <div id="section_visa" class="doc-section" style="display:none;">
                        <h4>Informations du Visa</h4>
                        <div class="form-group">
                            <label>Numéro de référence (depuis photocopie) *</label>
                            <input type="text" id="ref_visa" />
                        </div>
                        <div class="form-group">
                            <label>Date de début *</label>
                            <input type="date" id="date_debut_visa" />
                        </div>
                        <div class="form-group">
                            <label>Date de fin *</label>
                            <input type="date" id="date_fin_visa" />
                        </div>
                    </div>

                    <!-- Checkbox Carte Résident -->
                    <div class="checkbox-group" style="margin-top: 15px;">
                        <label>
                            <input type="checkbox" id="chk_carte" onchange="toggleDocSection('carte')" />
                            Carte de Résident
                        </label>
                    </div>
                    <div id="section_carte" class="doc-section" style="display:none;">
                        <h4>Informations de la Carte de Résident</h4>
                        <div class="form-group">
                            <label>Numéro de référence (depuis photocopie) *</label>
                            <input type="text" id="ref_carte" />
                        </div>
                        <div class="form-group">
                            <label>Date de début *</label>
                            <input type="date" id="date_debut_carte" />
                        </div>
                        <div class="form-group">
                            <label>Date de fin *</label>
                            <input type="date" id="date_fin_carte" />
                        </div>
                    </div>

                    <br/>
                    <button type="button" onclick="prevStep(4, 3)">Précédent</button>
                    <button type="submit">Valider et Approuver la demande</button>
                </div>
            </form>
        </section>
    </main>
</div>

<script>
    // ========== Stockage des fichiers uploadés ==========
    const uploadedCommunes = {};
    const uploadedComplementaires = {};

    function validateStep(stepNum) {
        const stepDiv = document.getElementById('step-' + stepNum);
        const inputs = stepDiv.querySelectorAll('input[required], select[required], textarea[required]');
        let isValid = true;

        // Retirer l'attribut required des champs cachés
        document.querySelectorAll('.step:not(.active) input[required], .step:not(.active) select[required], .step:not(.active) textarea[required]').forEach(input => {
            input.removeAttribute('required');
            input.setAttribute('data-was-required', 'true');
        });

        // Remettre l'attribut required sur les champs de l'étape active
        stepDiv.querySelectorAll('[data-was-required="true"]').forEach(input => {
            input.setAttribute('required', 'required');
            input.removeAttribute('data-was-required');
        });

        inputs.forEach(input => {
            if (!input.checkValidity() || input.value.trim() === '') {
                input.classList.add('input-error');
                isValid = false;
            } else {
                input.classList.remove('input-error');
            }
        });
        if (!isValid) {
            alert('Veuillez remplir correctement tous les champs obligatoires.');
        }
        return isValid;
    }

    let currentDemandeurId = null;
    let currentPasseportId = null;
    let currentVisaId = null;

    async function nextStep(current, next) {
        if (!validateStep(current)) return;

        // Etape 1: Sauvegarde du demandeur
        if (current === 1) {
            const demandeurDTO = {
                nom: document.getElementById('nom').value,
                prenom: document.getElementById('prenom').value,
                dateNaissance: document.getElementById('dateNaissance').value,
                lieuNaissance: document.getElementById('lieuNaissance').value,
                nationaliteId: parseInt(document.getElementById('nationalite_id').value),
                situationFamilialeId: parseInt(document.getElementById('situation_familiale_id').value),
                telephone: document.getElementById('telephone').value,
                email: document.getElementById('email').value,
                adresse: document.getElementById('adresse').value
            };
            try {
                const res = await fetch('/api/demandeurs', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(demandeurDTO)
                });
                if (!res.ok) { alert("Erreur Demandeur : " + await res.text()); return; }
                const demandeur = await res.json();
                currentDemandeurId = demandeur.id;
            } catch(e) { alert("Erreur réseau"); return; }
        }

        // Etape 2 : Sauvegarde du passeport et visa (optionnel)
        if (current === 2) {
            const passeportDTO = {
                demandeurId: currentDemandeurId,
                numeroPasseport: document.getElementById('numeroPasseport').value,
                paysDelivranceId: parseInt(document.getElementById('pays_delivrance_id').value),
                dateDelivrance: document.getElementById('dateDelivrancePasseport').value,
                dateExpiration: document.getElementById('dateExpirationPasseport').value
            };
            try {
                const resP = await fetch('/api/passeports', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(passeportDTO)
                });
                if (!resP.ok) { alert("Erreur Passeport : " + await resP.text()); return; }
                const passeport = await resP.json();
                currentPasseportId = passeport.id;
            } catch(e) { alert("Erreur réseau Passeport"); return; }

            // Visa Transformable : seulement si la checkbox est cochée
            const visaTransformableChecked = document.getElementById('chk_visa_transformable').checked;
            if (visaTransformableChecked) {
                const lieuEntree = document.getElementById('lieuEntree').value.trim();
                const dateEntree = document.getElementById('dateEntree').value;
                const dateExpVisa = document.getElementById('dateExpirationVisa').value;

                if (!lieuEntree || !dateEntree || !dateExpVisa) {
                    alert('Veuillez remplir tous les champs obligatoires du Visa Transformable (lieu, dates).');
                    return;
                }

                const visaDTO = {
                    demandeurId: currentDemandeurId,
                    passeportId: currentPasseportId,
                    numeroReference: document.getElementById('numeroReferenceVisa').value || null,
                    lieuEntree: lieuEntree,
                    dateEntree: dateEntree,
                    dateExpiration: dateExpVisa,
                    dateSortieRef: null
                };
                try {
                    const resV = await fetch('/api/visas', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(visaDTO)
                    });
                    if (!resV.ok) { alert("Erreur Visa : " + await resV.text()); return; }
                    const visa = await resV.json();
                    currentVisaId = visa.id;
                } catch(e) { alert("Erreur réseau Visa"); return; }
            } else {
                currentVisaId = null; // Pas de visa transformable
            }
        }

        // Etape 3 : Vérifier que toutes les pièces OBLIGATOIRES ont été cochées ou uploadées
        if (current === 3) {
            // Vérifier pièces communes
            if (window.piecesCommunes) {
                for (const p of window.piecesCommunes) {
                    const isRequired = p.estObligatoire !== false; // Par défaut true si manquant
                    if (isRequired) {
                        const isChecked = document.querySelector('.chk-comm[value="' + p.id + '"]') && document.querySelector('.chk-comm[value="' + p.id + '"]').checked;
                        if (!uploadedCommunes[p.id] && !isChecked) {
                            alert('Veuillez cocher ou uploader le justificatif obligatoire (commune) : ' + p.libelle);
                            return;
                        }
                    }
                }
            }

            const typeVisa = document.getElementById('type_visa_id').value;
            if (typeVisa && window.piecesComplementaires) {
                const piecesFiltered = window.piecesComplementaires.filter(
                    p => p.typeIdentite && parseInt(p.typeIdentite.id) === parseInt(typeVisa)
                );
                for (const p of piecesFiltered) {
                    const isRequired = p.estObligatoire !== false;
                    if (isRequired) {
                        const isChecked = document.querySelector('.chk-comp[value="' + p.id + '"]') && document.querySelector('.chk-comp[value="' + p.id + '"]').checked;
                        if (!uploadedComplementaires[p.id] && !isChecked) {
                            alert('Veuillez cocher ou uploader le justificatif obligatoire (complémentaire) : ' + p.libelle);
                            return;
                        }
                    }
                }
            }
        }

        document.getElementById('step-' + current).classList.remove('active');
        document.getElementById('step-' + next).classList.add('active');
        document.getElementById('indicator-' + current).style.fontWeight = 'normal';
        document.getElementById('indicator-' + next).style.fontWeight = 'bold';

        // Mettre à jour les champs required
        validateStep(next);
    }

    function prevStep(current, prev) {
        document.getElementById('step-' + current).classList.remove('active');
        document.getElementById('step-' + prev).classList.add('active');
        document.getElementById('indicator-' + current).style.fontWeight = 'normal';
        document.getElementById('indicator-' + prev).style.fontWeight = 'bold';

        // Mettre à jour les champs required
        validateStep(prev);
    }

    // ========== Toggle Visa Transformable (Étape 2) ==========
    function toggleVisaTransformable() {
        const checked = document.getElementById('chk_visa_transformable').checked;
        document.getElementById('section_visa_transformable').style.display = checked ? 'block' : 'none';
    }

    // ========== Toggle pour les sections de document (Étape 4) ==========
    function toggleDocSection(type) {
        if (type === 'visa') {
            const checked = document.getElementById('chk_visa').checked;
            document.getElementById('section_visa').style.display = checked ? 'block' : 'none';
        } else if (type === 'carte') {
            const checked = document.getElementById('chk_carte').checked;
            document.getElementById('section_carte').style.display = checked ? 'block' : 'none';
        }
    }

    // ========== Upload fichier générique ==========
    async function uploadPiece(pieceId, fileInput, storageMap, statusPrefix) {
        const file = fileInput.files[0];
        if (!file) return;

        const statusSpan = document.getElementById(statusPrefix + pieceId);
        statusSpan.textContent = 'Envoi en cours...';
        statusSpan.className = 'upload-status pending';

        const formData = new FormData();
        formData.append('file', file);

        try {
            const res = await fetch('/api/uploads', {
                method: 'POST',
                body: formData
            });
            if (res.ok) {
                const data = await res.json();
                storageMap[pieceId] = data.fichierPath;
                statusSpan.textContent = '✓ Fichier uploadé';
                statusSpan.className = 'upload-status success';
            } else {
                statusSpan.textContent = '✗ Erreur upload';
                statusSpan.className = 'upload-status pending';
                alert("Erreur lors de l'upload : " + await res.text());
            }
        } catch(e) {
            statusSpan.textContent = '✗ Erreur réseau';
            statusSpan.className = 'upload-status pending';
        }
    }

    // ========== Mise à jour de la checklist (Étape 3) ==========
    function updateChecklist() {
        const typeVisa = document.getElementById('type_visa_id').value;
        const container = document.getElementById('checklist-container');
        const listObligatoire = document.getElementById('list-obligatoire');
        const comp = document.getElementById('pieces-complementaires');
        const compTitle = document.getElementById('pieces-comp-title');
        listObligatoire.innerHTML = '';
        comp.innerHTML = '';

        if (typeVisa) {
            container.style.display = 'block';

            // Pièces communes avec upload (obligatoire ou non)
            if (window.piecesCommunes) {
                window.piecesCommunes.forEach(p => {
                    const isRequired = p.estObligatoire !== false;
                    const badge = isRequired 
                        ? '<span style="color:red; font-size:0.8rem; font-weight:normal; margin-left:5px;">* obligatoire</span>'
                        : '<span style="color:gray; font-size:0.8rem; font-weight:normal; margin-left:5px;">(facultatif)</span>';
                    listObligatoire.innerHTML += 
                        '<div class="checklist-item">' +
                        '  <label><input type="checkbox" class="chk-comm" value="' + p.id + '"/> ' + p.libelle + badge + '</label>' +
                        '  <div class="upload-row">' +
                        '    <input type="file" id="file-comm-' + p.id + '" accept=".pdf,.jpg,.jpeg,.png" ' +
                        '           onchange="uploadPiece(' + p.id + ', this, uploadedCommunes, \'upload-status-comm-\')" />' +
                        '    <span id="upload-status-comm-' + p.id + '" class="upload-status pending">' + (isRequired ? 'Non fourni (requis)' : 'Non fourni') + '</span>' +
                        '  </div>' +
                        '</div>';
                });
            }

            // Pièces complémentaires avec upload
            if (window.piecesComplementaires) {
                const piecesFiltered = window.piecesComplementaires.filter(
                    p => p.typeIdentite && parseInt(p.typeIdentite.id) === parseInt(typeVisa)
                );

                if (piecesFiltered.length > 0) {
                    compTitle.style.display = 'block';
                    piecesFiltered.forEach(p => {
                        const isRequired = p.estObligatoire !== false;
                        const badge = isRequired 
                            ? '<span style="color:red; font-size:0.8rem; font-weight:normal; margin-left:5px;">* obligatoire</span>'
                            : '<span style="color:gray; font-size:0.8rem; font-weight:normal; margin-left:5px;">(facultatif)</span>';
                        comp.innerHTML +=
                            '<div class="checklist-item">' +
                            '  <label><input type="checkbox" class="chk-comp" value="' + p.id + '"/> ' + p.libelle + badge + '</label>' +
                            '  <div class="upload-row">' +
                            '    <input type="file" id="file-comp-' + p.id + '" accept=".pdf,.jpg,.jpeg,.png" ' +
                            '           onchange="uploadPiece(' + p.id + ', this, uploadedComplementaires, \'upload-status-comp-\')" />' +
                            '    <span id="upload-status-comp-' + p.id + '" class="upload-status pending">' + (isRequired ? 'Non fourni (requis)' : 'Non fourni') + '</span>' +
                            '  </div>' +
                            '</div>';
                    });
                } else {
                    compTitle.style.display = 'none';
                }
            }
        } else {
            container.style.display = 'none';
            compTitle.style.display = 'none';
        }
    }

    // ========== Initialisation ==========
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const stepToContinue = urlParams.get('step');
        const demandeurIdToContinue = urlParams.get('id');
        const visaIdToContinue = urlParams.get('visaId');

        if (!stepToContinue) {
            validateStep(1);
        }

        if (stepToContinue && demandeurIdToContinue) {
            currentDemandeurId = parseInt(demandeurIdToContinue);
            if (visaIdToContinue) {
                currentVisaId = parseInt(visaIdToContinue);
            }
            document.getElementById('step-1').classList.remove('active');
            document.getElementById('indicator-1').style.fontWeight = 'normal';

            document.getElementById('step-' + stepToContinue).classList.add('active');
            document.getElementById('indicator-' + stepToContinue).style.fontWeight = 'bold';

            validateStep(stepToContinue);

            fetch('/api/demandeurs/' + currentDemandeurId)
                .then(r => r.json())
                .then(dem => {
                    document.getElementById('nom').value = dem.nom || '';
                    document.getElementById('prenom').value = dem.prenom || '';
                    if(dem.dateNaissance) document.getElementById('dateNaissance').value = dem.dateNaissance.substring(0, 10);
                    document.getElementById('lieuNaissance').value = dem.lieuNaissance || '';
                    document.getElementById('telephone').value = dem.telephone || '';
                    document.getElementById('email').value = dem.email || '';
                    document.getElementById('adresse').value = dem.adresse || '';
                    if(dem.nationalite) document.getElementById('nationalite_id').value = dem.nationalite.id;
                    if(dem.situationFamiliale) document.getElementById('situation_familiale_id').value = dem.situationFamiliale.id;
                })
                .catch(e => console.error('Erreur récupération demandeur', e));
        }

        fetch('/api/ref/nationalites').then(r => r.json()).then(data => {
            const selectNat = document.getElementById('nationalite_id');
            const selectPays = document.getElementById('pays_delivrance_id');
            data.forEach(n => {
                selectNat.innerHTML += '<option value="' + n.id + '">' + n.libelle + '</option>';
                selectPays.innerHTML += '<option value="' + n.id + '">' + n.libelle + '</option>';
            });
        }).catch(e => console.error(e));

        fetch('/api/ref/situations-familiales').then(r => r.json()).then(data => {
            const selectSF = document.getElementById('situation_familiale_id');
            data.forEach(s => {
                selectSF.innerHTML += '<option value="' + s.id + '">' + s.libelle + '</option>';
            });
        }).catch(e => console.error(e));

        fetch('/api/ref/types-identite').then(r => r.json()).then(data => {
            const selectType = document.getElementById('type_visa_id');
            data.forEach(t => {
                selectType.innerHTML += '<option value="' + t.id + '" data-code="' + t.code + '">' + t.libelle + '</option>';
            });
        }).catch(e => console.error(e));

        fetch('/api/ref/pieces-communes').then(r => r.json()).then(data => {
            window.piecesCommunes = data;
        }).catch(e => console.error(e));

        fetch('/api/ref/pieces-complementaires').then(r => r.json()).then(data => {
            window.piecesComplementaires = data;
        }).catch(e => console.error(e));
    });

    // ========== Soumission finale ==========
    async function submitForm(e) {
        e.preventDefault();

        // Vérifier qu'au moins un document est coché
        const visaChecked = document.getElementById('chk_visa').checked;
        const carteChecked = document.getElementById('chk_carte').checked;

        if (!visaChecked && !carteChecked) {
            alert('Veuillez sélectionner au moins un type de document (Visa et/ou Carte de Résident).');
            return false;
        }

        // Construire la liste des documents
        const documents = [];

        if (visaChecked) {
            const ref = document.getElementById('ref_visa').value.trim();
            const debut = document.getElementById('date_debut_visa').value;
            const fin = document.getElementById('date_fin_visa').value;
            if (!ref || !debut || !fin) {
                alert('Veuillez remplir tous les champs du Visa.');
                return false;
            }
            documents.push({
                typeDocument: 'VISA',
                referenceDocument: ref,
                dateDebutDocument: debut,
                dateFinDocument: fin
            });
        }

        if (carteChecked) {
            const ref = document.getElementById('ref_carte').value.trim();
            const debut = document.getElementById('date_debut_carte').value;
            const fin = document.getElementById('date_fin_carte').value;
            if (!ref || !debut || !fin) {
                alert('Veuillez remplir tous les champs de la Carte de Résident.');
                return false;
            }
            documents.push({
                typeDocument: 'CARTE_RESIDENT',
                referenceDocument: ref,
                dateDebutDocument: debut,
                dateFinDocument: fin
            });
        }

        const fourniesComm = Array.from(document.querySelectorAll('.chk-comm:checked')).map(el => parseInt(el.value));
        const fourniesComp = Array.from(document.querySelectorAll('.chk-comp:checked')).map(el => parseInt(el.value));

        const duplicataDTO = {
            demandeurId: currentDemandeurId,
            passeportId: currentPasseportId,
            visaTransformableId: currentVisaId || null,  // null si visa transformable non renseigné
            typeIdentiteId: parseInt(document.getElementById('type_visa_id').value),
            documents: documents,
            piecesCommunesFichiers: uploadedCommunes,
            piecesComplementairesFichiers: uploadedComplementaires,
            piecesCommunesFournies: fourniesComm,
            piecesComplementairesFournies: fourniesComp
        };

        try {
            const response = await fetch('/api/dossiers/duplicata', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(duplicataDTO)
            });

            if (response.ok) {
                const dossier = await response.json();
                let msg = "Félicitations, le duplicata a été créé et approuvé avec succès !\n(Dossier ID: " + dossier.id + ")\n\nDocuments créés : ";
                if (visaChecked) msg += "Visa ";
                if (carteChecked) msg += "Carte de Résident ";
                alert(msg);
                window.location.href = "/demande/liste";
            } else {
                const err = await response.text();
                alert("Erreur lors de la création du duplicata : " + err);
            }
        } catch (err) {
            console.error('Fetch error:', err);
            alert('Erreur réseau lors de la validation.');
        }

        return false;
    }
</script>
</body>
</html>
