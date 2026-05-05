<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nouveau Titre de Séjour | visa-mg</title>
    <link rel="stylesheet" href="/css/app.css" />
    <style>
        .step { display: none; }
        .step.active { display: block; }
        .error { color: red; font-size: 0.8rem; display: none; }
        .input-error { border: 1px solid red; }
        .checklist { margin-top: 2rem; background: white; padding: 1.5rem; border-radius: var(--radius); border: 1px solid var(--border); }
        .checklist-item { margin-bottom: 1rem; padding: 0.75rem; border-bottom: 1px solid var(--border); }
        .checklist-item:last-child { border-bottom: none; }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/jsp/components/sidebar.jsp" />

    <main class="main">
        <jsp:include page="/WEB-INF/jsp/components/header.jsp" />

        <section class="content">
            <h1>Nouveau Titre de Séjour</h1>
            <p>Formulaire de création d'un premier titre de séjour ou d'un nouveau titre après transformation.</p>

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
                        <span class="step-label">Pièces Jointes</span>
                    </button>
                </li>
                <li class="step-item" id="step-indicator-3">
                    <button class="step-button" onclick="goToStep(3)">
                        <span class="step-icon">3</span>
                        <span class="step-label">Récapitulatif</span>
                    </button>
                </li>
            </ul>

            <form id="demandeForm" onsubmit="return submitForm(event)">
                <!-- ETAPE 1: Etat Civil -->
                <div id="step-1" class="step active">
                    <h3 class="form-section-title">
                        <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        Informations de l'État Civil
                    </h3>
                    <div class="form-grid">
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
                    </div>
                    <div class="form-group">
                        <label>Adresse *</label>
                        <textarea id="adresse" name="adresse" required rows="3"></textarea>
                    </div>
                    <div class="btn-row">
                        <button type="button" class="btn-primary" onclick="nextStep(1, 2)">Suivant</button>
                    </div>
                </div>

                <!-- ETAPE 2: Passeport et Visa -->
                <div id="step-2" class="step">
                    <h3 class="form-section-title">
                        <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>
                        Passeport et Visa Transformable
                    </h3>
                    <div class="form-grid">
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
                    </div>

                    <h4 style="margin-top: 2rem;">Visa Transformable</h4>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Numéro de référence</label>
                            <input type="text" id="numeroReferenceVisa" name="numero_reference" />
                        </div>
                        <div class="form-group">
                            <label>Lieu d'entrée *</label>
                            <input type="text" id="lieuEntree" name="lieu_entree" required />
                        </div>
                        <div class="form-group">
                            <label>Date d'entrée *</label>
                            <input type="date" id="dateEntree" name="date_entree" required />
                        </div>
                        <div class="form-group">
                            <label>Date d'expiration *</label>
                            <input type="date" id="dateExpirationVisa" name="date_expiration_visa" required />
                        </div>
                    </div>
                    <div class="btn-row">
                        <button type="button" class="btn-secondary" onclick="prevStep(2, 1)">Précédent</button>
                        <button type="button" class="btn-primary" onclick="nextStep(2, 3)">Suivant</button>
                    </div>
                </div>

                <!-- ETAPE 3: Type de Titre et Récapitulatif -->
                <div id="step-3" class="step">
                    <h3 class="form-section-title">
                        <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        Type de Titre et Validation
                    </h3>
                    <div class="form-group" style="max-width: 400px;">
                        <label>Type de Titre sollicité *</label>
                        <select id="type_visa_id" name="type_visa_id" required onchange="updateChecklist()">
                            <option value="">Sélectionner</option>
                        </select>
                    </div>

                    <div id="checklist-container" class="checklist" style="display:none;">
                        <h4>Pièces justificatives à fournir</h4>
                        <div id="list-communes"></div>
                        <div id="pieces-complementaires" style="margin-top: 1rem;"></div>
                    </div>

                    <div class="btn-row">
                        <button type="button" class="btn-secondary" onclick="prevStep(3, 2)">Précédent</button>
                        <button type="submit">Valider la demande</button>
                    </div>
                </div>
            </form>
        </section>
    </main>
</div>

<script>
    let completedSteps = new Set();

    function updateStepper(activeStep) {
        for (let i = 1; i <= 3; i++) {
            const indicator = document.getElementById('step-indicator-' + i);
            indicator.classList.remove('active', 'completed');
            if (i === activeStep) {
                indicator.classList.add('active');
            } else if (completedSteps.has(i)) {
                indicator.classList.add('completed');
                const icon = indicator.querySelector('.step-icon');
                icon.innerHTML = '<svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>';
            } else {
                indicator.querySelector('.step-icon').textContent = i;
            }
        }
    }

    function goToStep(stepNum) {
        // Autoriser seulement si l'étape est déjà complétée ou si c'est l'étape suivante immédiate de la dernière complétée
        if (completedSteps.has(stepNum) || stepNum === 1 || (stepNum > 1 && completedSteps.has(stepNum - 1))) {
            const currentStep = parseInt(document.querySelector('.step.active').id.split('-')[1]);
            document.getElementById('step-' + currentStep).classList.remove('active');
            document.getElementById('step-' + stepNum).classList.add('active');
            updateStepper(stepNum);
        }
    }

    function validateStep(stepNum) {
        const stepDiv = document.getElementById('step-' + stepNum);
        const inputs = stepDiv.querySelectorAll('input[required], select[required], textarea[required]');
        let isValid = true;
        
        inputs.forEach(input => {
            if (!input.checkValidity() || input.value.trim() === '') {
                input.classList.add('input-error');
                isValid = false;
            } else {
                input.classList.remove('input-error');
            }
        });
        if(!isValid) {
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

        // Etape 2 : Sauvegarde du passeport et visa
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

            const visaDTO = {
                demandeurId: currentDemandeurId,
                passeportId: currentPasseportId,
                numeroReference: document.getElementById('numeroReferenceVisa').value || null,
                lieuEntree: document.getElementById('lieuEntree').value,
                dateEntree: document.getElementById('dateEntree').value,
                dateExpiration: document.getElementById('dateExpirationVisa').value,
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

    function updateChecklist() {
        const typeVisa = document.getElementById('type_visa_id').value;
        const container = document.getElementById('checklist-container');
        const listCommunes = document.getElementById('list-communes');
        const comp = document.getElementById('pieces-complementaires');
        listCommunes.innerHTML = '';
        comp.innerHTML = '';

        if (typeVisa) {
            container.style.display = 'block';
            if (window.piecesCommunes) {
                window.piecesCommunes.forEach(p => {
                    listCommunes.innerHTML +=
                        '<div class="checklist-item">' +
                        '  <label><input type="checkbox" class="piece-checkbox" data-required="true" data-piece-type="commune" data-piece-id="' + p.id + '" /> ' +
                        '    ' + p.libelle + ' <span style="color:var(--accent); font-weight:normal;">*</span></label>' +
                        '</div>';
                });
            }
            if (window.piecesComplementaires) {
                const piecesFiltered = window.piecesComplementaires.filter(p => p.typeIdentite && parseInt(p.typeIdentite.id) === parseInt(typeVisa));
                piecesFiltered.forEach(p => {
                    const isRequired = p.estObligatoire !== false;
                    comp.innerHTML +=
                        '<div class="checklist-item">' +
                        '  <label><input type="checkbox" class="piece-checkbox" data-required="' + isRequired + '" data-piece-type="complementaire" data-piece-id="' + p.id + '" /> ' +
                        '    ' + p.libelle + (isRequired ? ' <span style="color:var(--accent); font-weight:normal;">*</span>' : '') + '</label>' +
                        '</div>';
                });
            }
        } else {
            container.style.display = 'none';
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        // Fetch refs
        fetch('/api/ref/nationalites').then(r => r.json()).then(data => {
            const selectNat = document.getElementById('nationalite_id');
            const selectPays = document.getElementById('pays_delivrance_id');
            data.forEach(n => {
                selectNat.innerHTML += '<option value="' + n.id + '">' + n.libelle + '</option>';
                selectPays.innerHTML += '<option value="' + n.id + '">' + n.libelle + '</option>';
            });
        });
        fetch('/api/ref/situations-familiales').then(r => r.json()).then(data => {
            const selectSF = document.getElementById('situation_familiale_id');
            data.forEach(s => { selectSF.innerHTML += '<option value="' + s.id + '">' + s.libelle + '</option>'; });
        });
        fetch('/api/ref/types-identite').then(r => r.json()).then(data => {
            const selectType = document.getElementById('type_visa_id');
            data.forEach(t => { selectType.innerHTML += '<option value="' + t.id + '">' + t.libelle + '</option>'; });
        });
        fetch('/api/ref/pieces-communes').then(r => r.json()).then(data => { window.piecesCommunes = data; });
        fetch('/api/ref/pieces-complementaires').then(r => r.json()).then(data => { window.piecesComplementaires = data; });
    });

    async function submitForm(e) {
        e.preventDefault();
        if (!validateStep(3)) return false;
        const requiredUnchecked = Array.from(document.querySelectorAll('.piece-checkbox[data-required="true"]')).filter(cb => !cb.checked);
        if (requiredUnchecked.length > 0) { alert('Veuillez cocher toutes les pièces obligatoires.'); return false; }

        const checkedCommunes = Array.from(document.querySelectorAll('.piece-checkbox[data-piece-type="commune"]')).filter(cb => cb.checked).map(cb => parseInt(cb.getAttribute('data-piece-id')));
        const checkedComplementaires = Array.from(document.querySelectorAll('.piece-checkbox[data-piece-type="complementaire"]')).filter(cb => cb.checked).map(cb => parseInt(cb.getAttribute('data-piece-id')));

        const dossierDTO = {
            demandeurId: currentDemandeurId,
            visaTransformableId: currentVisaId,
            typeIdentiteId: parseInt(document.getElementById('type_visa_id').value),
            typeDemandeId: 1,
            piecesCommunesCochees: checkedCommunes,
            piecesComplementairesCochees: checkedComplementaires
        };

        try {
            const response = await fetch('/api/dossiers', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(dossierDTO)
            });
            if (response.ok) {
                alert("La demande a bien été créée !");
                window.location.href = "/demande/liste";
            } else {
                alert("Erreur : " + await response.text());
            }
        } catch (err) { alert('Erreur réseau.'); }
        return false;
    }
</script>
</body>
</html>
