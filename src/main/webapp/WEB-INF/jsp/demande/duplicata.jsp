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
        .checklist-item { margin-bottom: 10px; padding: 10px; border: 1px solid var(--border); border-radius: var(--radius); background: white; }
        .upload-row { display: flex; align-items: center; gap: 10px; margin-top: 5px; }
        .upload-status { font-size: 0.85rem; padding: 2px 8px; border-radius: 3px; }
        .upload-status.success { background: #d4edda; color: #155724; }
        .upload-status.pending { background: #fff3cd; color: #856404; }
        .doc-section { border: 1px solid var(--border); padding: 1.5rem; margin-top: 1rem; border-radius: var(--radius); background: #f9fafb; }
        .doc-section h4 { margin-top: 0; color: var(--primary); }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/jsp/components/sidebar.jsp" />

    <main class="main">
        <jsp:include page="/WEB-INF/jsp/components/header.jsp" />

        <section class="content">
            <h1>Demande de Duplicata</h1>
            
            <!-- Procedure Info Box -->
            <div class="info-box">
                <div class="info-box__icon">
                    <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                </div>
                <div class="info-box__content">
                    <h4>Procédure de Duplicata</h4>
                    <p>Cette demande concerne le remplacement d'un titre de séjour perdu, volé ou détérioré. Vous devrez fournir les références du document original et les justificatifs correspondants (déclaration de perte/vol).</p>
                </div>
            </div>

            <!-- Stepper -->
            <ul class="stepper">
                <li class="step-item active" id="step-indicator-1">
                    <button class="step-button" onclick="goToStep(1)">
                        <span class="step-icon">1</span>
                        <span class="step-label">État Civil</span>
                    </button>
                </li>
                <li class="step-item" id="step-indicator-2">
                    <button class="step-button" onclick="goToStep(2)">
                        <span class="step-icon">2</span>
                        <span class="step-label">Référence Visa</span>
                    </button>
                </li>
                <li class="step-item" id="step-indicator-3">
                    <button class="step-button" onclick="goToStep(3)">
                        <span class="step-icon">3</span>
                        <span class="step-label">Pièces Jointes</span>
                    </button>
                </li>
                <li class="step-item" id="step-indicator-4">
                    <button class="step-button" onclick="goToStep(4)">
                        <span class="step-icon">4</span>
                        <span class="step-label">Récapitulatif</span>
                    </button>
                </li>
            </ul>

            <form id="demandeForm" onsubmit="return submitForm(event)">
                <!-- ETAPE 1: Etat Civil -->
                <div id="step-1" class="step active">
                    <h3 class="form-section-title">Informations de l'État Civil</h3>
                    <div class="form-grid">
                        <div class="form-group"><label>Nom *</label><input type="text" id="nom" name="nom" required /></div>
                        <div class="form-group"><label>Prénom *</label><input type="text" id="prenom" name="prenom" required /></div>
                        <div class="form-group"><label>Date de Naissance *</label><input type="date" id="dateNaissance" name="dateNaissance" required /></div>
                        <div class="form-group"><label>Lieu de Naissance *</label><input type="text" id="lieuNaissance" name="lieuNaissance" required /></div>
                        <div class="form-group"><label>Nationalité *</label><select id="nationalite_id" name="nationalite_id" required><option value="">Sélectionner</option></select></div>
                        <div class="form-group"><label>Situation Familiale *</label><select id="situation_familiale_id" name="situation_familiale_id" required><option value="">Sélectionner</option></select></div>
                        <div class="form-group"><label>Téléphone *</label><input type="tel" id="telephone" name="telephone" required /></div>
                        <div class="form-group"><label>Email *</label><input type="email" id="email" name="email" required /></div>
                    </div>
                    <div class="form-group"><label>Adresse *</label><textarea id="adresse" name="adresse" required rows="3"></textarea></div>
                    <div class="btn-row">
                        <button type="button" class="btn-primary" onclick="nextStep(1, 2)">Suivant</button>
                    </div>
                </div>

                <!-- ETAPE 2: Référence Visa -->
                <div id="step-2" class="step">
                    <h3 class="form-section-title">Passeport et Références du Titre Original</h3>
                    <div class="form-grid">
                        <div class="form-group"><label>Numéro de Passeport *</label><input type="text" id="numeroPasseport" name="numero_passeport" required /></div>
                        <div class="form-group"><label>Pays de délivrance *</label><select id="pays_delivrance_id" name="pays_delivrance_id" required><option value="">Sélectionner</option></select></div>
                        <div class="form-group"><label>Date de délivrance *</label><input type="date" id="dateDelivrancePasseport" name="date_delivrance" required /></div>
                        <div class="form-group"><label>Date d'expiration *</label><input type="date" id="dateExpirationPasseport" name="date_expiration" required /></div>
                    </div>

                    <h4 style="margin-top: 2rem;">Détails du document perdu / volé</h4>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Référence du Visa original *</label>
                            <input type="text" id="ref_original_visa" placeholder="Ex: V-123456" />
                        </div>
                        <div class="form-group">
                            <label>Motif de la demande *</label>
                            <select id="motif_demande" required>
                                <option value="">Sélectionner le motif</option>
                                <option value="PERTE">Perte</option>
                                <option value="VOL">Vol</option>
                                <option value="DETERIORATION">Détérioration</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="btn-row">
                        <button type="button" class="btn-secondary" onclick="prevStep(2, 1)">Précédent</button>
                        <button type="button" class="btn-primary" onclick="nextStep(2, 3)">Suivant</button>
                    </div>
                </div>

                <!-- ETAPE 3: Pièces Jointes -->
                <div id="step-3" class="step">
                    <h3 class="form-section-title">Justificatifs et Type de Titre</h3>
                    <div class="form-group" style="max-width: 400px;">
                        <label>Type de Titre original *</label>
                        <select id="type_visa_id" name="type_visa_id" required onchange="updateChecklist()">
                            <option value="">Sélectionner</option>
                        </select>
                    </div>

                    <div id="checklist-container" class="checklist" style="display:none;">
                        <h4>Pièces à uploader</h4>
                        <div id="list-obligatoire"></div>
                        <div id="pieces-complementaires" style="margin-top: 1rem;"></div>
                    </div>

                    <div class="btn-row">
                        <button type="button" class="btn-secondary" onclick="prevStep(3, 2)">Précédent</button>
                        <button type="button" class="btn-primary" onclick="nextStep(3, 4)">Suivant</button>
                    </div>
                </div>

                <!-- ETAPE 4: Récapitulatif -->
                <div id="step-4" class="step">
                    <h3 class="form-section-title">Récapitulatif et Validation</h3>
                    <p>Sélectionnez les documents originaux que vous souhaitez reconstituer dans ce duplicata :</p>

                    <div class="form-grid">
                        <div>
                            <label><input type="checkbox" id="chk_visa" onchange="toggleDocSection('visa')" /> Visa</label>
                            <div id="section_visa" class="doc-section" style="display:none;">
                                <h4>Informations du Visa</h4>
                                <div class="form-group"><label>Référence (facultatif si inconnue)</label><input type="text" id="ref_visa" /></div>
                                <div class="form-group"><label>Date de début</label><input type="date" id="date_debut_visa" /></div>
                                <div class="form-group"><label>Date de fin</label><input type="date" id="date_fin_visa" /></div>
                            </div>
                        </div>
                        <div>
                            <label><input type="checkbox" id="chk_carte" onchange="toggleDocSection('carte')" /> Carte de Résident</label>
                            <div id="section_carte" class="doc-section" style="display:none;">
                                <h4>Informations de la Carte</h4>
                                <div class="form-group"><label>Référence (facultatif si inconnue)</label><input type="text" id="ref_carte" /></div>
                                <div class="form-group"><label>Date de début</label><input type="date" id="date_debut_carte" /></div>
                                <div class="form-group"><label>Date de fin</label><input type="date" id="date_fin_carte" /></div>
                            </div>
                        </div>
                    </div>

                    <div class="btn-row">
                        <button type="button" class="btn-secondary" onclick="prevStep(4, 3)">Précédent</button>
                        <button type="submit">Valider et Approuver</button>
                    </div>
                </div>
            </form>
        </section>
    </main>
</div>

<script>
    let completedSteps = new Set();
    const uploadedCommunes = {};
    const uploadedComplementaires = {};

    function updateStepper(activeStep) {
        for (let i = 1; i <= 4; i++) {
            const indicator = document.getElementById('step-indicator-' + i);
            indicator.classList.remove('active', 'completed');
            if (i === activeStep) { indicator.classList.add('active'); }
            else if (completedSteps.has(i)) {
                indicator.classList.add('completed');
                indicator.querySelector('.step-icon').innerHTML = '<svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>';
            } else { indicator.querySelector('.step-icon').textContent = i; }
        }
    }

    function goToStep(stepNum) {
        if (completedSteps.has(stepNum) || stepNum === 1 || (stepNum > 1 && completedSteps.has(stepNum - 1))) {
            const currentStep = parseInt(document.querySelector('.step.active').id.split('-')[1]);
            document.getElementById('step-' + currentStep).classList.remove('active');
            document.getElementById('step-' + stepNum).classList.add('active');
            updateStepper(stepNum);
        }
    }

    function validateStep(stepNum) {
        const stepDiv = document.getElementById('step-' + stepNum);
        const inputs = stepDiv.querySelectorAll('input[required], select[required]');
        let isValid = true;
        inputs.forEach(input => {
            if (!input.checkValidity() || input.value.trim() === '') { input.classList.add('input-error'); isValid = false; }
            else { input.classList.remove('input-error'); }
        });
        if (!isValid) alert('Veuillez remplir correctement tous les champs obligatoires.');
        return isValid;
    }

    let currentDemandeurId = null;
    let currentPasseportId = null;

    async function nextStep(current, next) {
        if (!validateStep(current)) return;

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
            const res = await fetch('/api/demandeurs', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(demandeurDTO) });
            const data = await res.json();
            currentDemandeurId = data.id;
        }

        if (current === 2) {
            const passeportDTO = {
                demandeurId: currentDemandeurId,
                numeroPasseport: document.getElementById('numeroPasseport').value,
                paysDelivranceId: parseInt(document.getElementById('pays_delivrance_id').value),
                dateDelivrance: document.getElementById('dateDelivrancePasseport').value,
                dateExpiration: document.getElementById('dateExpirationPasseport').value
            };
            const res = await fetch('/api/passeports', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(passeportDTO) });
            const data = await res.json();
            currentPasseportId = data.id;
        }

        completedSteps.add(current);
        document.getElementById('step-' + current).classList.remove('active');
        document.getElementById('step-' + next).classList.add('active');
        updateStepper(next);
    }

    function prevStep(current, prev) {
        document.getElementById('step-' + current).classList.remove('active');
        document.getElementById('step-' + prev).classList.add('active');
        updateStepper(prev);
    }

    function toggleDocSection(type) {
        document.getElementById('section_' + type).style.display = document.getElementById('chk_' + type).checked ? 'block' : 'none';
    }

    async function uploadPiece(pieceId, fileInput, storageMap, statusPrefix) {
        const file = fileInput.files[0];
        if (!file) return;
        const statusSpan = document.getElementById(statusPrefix + pieceId);
        statusSpan.textContent = 'Envoi...';
        const formData = new FormData();
        formData.append('file', file);
        const res = await fetch('/api/uploads', { method: 'POST', body: formData });
        const data = await res.json();
        storageMap[pieceId] = data.fichierPath;
        statusSpan.textContent = '✓ Uploadé';
        statusSpan.className = 'upload-status success';
    }

    function updateChecklist() {
        const typeVisa = document.getElementById('type_visa_id').value;
        const container = document.getElementById('checklist-container');
        const listObligatoire = document.getElementById('list-obligatoire');
        const comp = document.getElementById('pieces-complementaires');
        listObligatoire.innerHTML = ''; comp.innerHTML = '';
        if (typeVisa) {
            container.style.display = 'block';
            window.piecesCommunes.forEach(p => {
                listObligatoire.innerHTML += `<div class="checklist-item"><label><input type="checkbox" class="chk-comm" value="${p.id}"/> ${p.libelle}</label>
                <div class="upload-row"><input type="file" onchange="uploadPiece(${p.id}, this, uploadedCommunes, 'status-comm-')"/><span id="status-comm-${p.id}" class="upload-status pending">Non fourni</span></div></div>`;
            });
            const piecesFiltered = window.piecesComplementaires.filter(p => p.typeIdentite && parseInt(p.typeIdentite.id) === parseInt(typeVisa));
            piecesFiltered.forEach(p => {
                comp.innerHTML += `<div class="checklist-item"><label><input type="checkbox" class="chk-comp" value="${p.id}"/> ${p.libelle}</label>
                <div class="upload-row"><input type="file" onchange="uploadPiece(${p.id}, this, uploadedComplementaires, 'status-comp-')"/><span id="status-comp-${p.id}" class="upload-status pending">Non fourni</span></div></div>`;
            });
        } else container.style.display = 'none';
    }

    async function loadReferenceData() {
        try {
            console.log("Chargement des données de référence...");
            
            // 1. Nationalités
            const resNat = await fetch('/api/ref/nationalites');
            if (resNat.ok) {
                const data = await resNat.json();
                const natSelect = document.getElementById('nationalite_id');
                const paysSelect = document.getElementById('pays_delivrance_id');
                if (natSelect && paysSelect) {
                    data.forEach(n => {
                        natSelect.add(new Option(n.libelle, n.id));
                        paysSelect.add(new Option(n.libelle, n.id));
                    });
                }
            }

            // 2. Situations Familiales
            const resSit = await fetch('/api/ref/situations-familiales');
            if (resSit.ok) {
                const data = await resSit.json();
                const sitSelect = document.getElementById('situation_familiale_id');
                if (sitSelect) {
                    data.forEach(s => {
                        sitSelect.add(new Option(s.libelle, s.id));
                    });
                }
            }

            // 3. Types d'Identité
            const resType = await fetch('/api/ref/types-identite');
            if (resType.ok) {
                const data = await resType.json();
                const typeSelect = document.getElementById('type_visa_id');
                if (typeSelect) {
                    data.forEach(t => {
                        typeSelect.add(new Option(t.libelle, t.id));
                    });
                }
            }

            // 4. Catalogues de pièces
            const [resComm, resComp] = await Promise.all([
                fetch('/api/ref/pieces-communes'),
                fetch('/api/ref/pieces-complementaires')
            ]);
            
            if (resComm.ok) window.piecesCommunes = await resComm.json();
            if (resComp.ok) window.piecesComplementaires = await resComp.json();

            console.log("Données de référence chargées avec succès.");
        } catch (error) {
            console.error("Erreur critique lors du chargement des données:", error);
        }
    }

    document.addEventListener("DOMContentLoaded", loadReferenceData);

    async function submitForm(e) {
        e.preventDefault();
        const documents = [];
        if (document.getElementById('chk_visa').checked) documents.push({ typeDocument: 'VISA', referenceDocument: document.getElementById('ref_visa').value, dateDebutDocument: document.getElementById('date_debut_visa').value, dateFinDocument: document.getElementById('date_fin_visa').value });
        if (document.getElementById('chk_carte').checked) documents.push({ typeDocument: 'CARTE_RESIDENT', referenceDocument: document.getElementById('ref_carte').value, dateDebutDocument: document.getElementById('date_debut_carte').value, dateFinDocument: document.getElementById('date_fin_carte').value });

        const dto = {
            demandeurId: currentDemandeurId,
            passeportId: currentPasseportId,
            typeIdentiteId: parseInt(document.getElementById('type_visa_id').value),
            documents: documents,
            piecesCommunesFichiers: uploadedCommunes,
            piecesComplementairesFichiers: uploadedComplementaires,
            piecesCommunesFournies: Array.from(document.querySelectorAll('.chk-comm:checked')).map(el => parseInt(el.value)),
            piecesComplementairesFournies: Array.from(document.querySelectorAll('.chk-comp:checked')).map(el => parseInt(el.value))
        };
        const res = await fetch('/api/dossiers/duplicata', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(dto) });
        if (res.ok) { alert("Duplicata créé avec succès !"); window.location.href = "/demande/liste"; }
        return false;
    }
</script>
</body>
</html>
