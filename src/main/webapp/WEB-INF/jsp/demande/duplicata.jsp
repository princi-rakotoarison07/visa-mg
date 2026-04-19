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
        .checklist-item { margin-bottom: 5px; }
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

                <!-- ETAPE 2: Passeport et Visa -->
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

                    <h3>Visa Transformable</h3>
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
                    <button type="button" onclick="prevStep(2, 1)">Précédent</button>
                    <button type="button" onclick="nextStep(2, 3)">Suivant</button>
                </div>

                <!-- ETAPE 3: Type de Titre et Récapitulatif -->
                <div id="step-3" class="step">
                    <h2>Étape 3 : Type de Titre et Pièces Justificatives</h2>
                    <div class="form-group">
                        <label>Type de Titre *</label>
                        <select id="type_visa_id" name="type_visa_id" required onchange="updateChecklist()">
                            <option value="">Sélectionner</option>
                        </select>
                    </div>

                    <div id="checklist-container" class="checklist" style="display:none;">
                        <h3>Pièces obligatoires à fournir</h3>
                        <div id="list-obligatoire"></div>
                        <div id="pieces-complementaires"></div>
                    </div>

                    <br/>
                    <button type="button" onclick="prevStep(3, 2)">Précédent</button>
                    <button type="button" onclick="nextStep(3, 4)">Suivant</button>
                </div>

                <!-- ETAPE 4: Duplicata Final -->
                <div id="step-4" class="step">
                    <h2>Étape 4 : Saisie du document à récupérer</h2>
                    <div class="form-group">
                        <label>Type de Document *</label>
                        <select id="type_document" name="type_document" required>
                            <option value="">Sélectionner</option>
                            <option value="VISA">Visa</option>
                            <option value="CARTE_RESIDENT">Carte de Résident</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Numéro de référence (depuis photocopie) *</label>
                        <input type="text" id="ref_document" name="ref_document" required />
                    </div>
                    <div class="form-group">
                        <label>Date de début *</label>
                        <input type="date" id="date_debut_document" name="date_debut_document" required />
                    </div>
                    <div class="form-group">
                        <label>Date de fin *</label>
                        <input type="date" id="date_fin_document" name="date_fin_document" required />
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
    function validateStep(stepNum) {
        const stepDiv = document.getElementById('step-' + stepNum);
        const inputs = stepDiv.querySelectorAll('input[required], select[required], textarea[required]');
        let isValid = true;
        
        // Retirer l'attribut required des champs cachés pour éviter les erreurs "An invalid form control is not focusable"
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
        if(!isValid) {
            alert('Veuillez remplir correctement tous les champs obligatoires (ex: adresse email au bon format).');
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

    function updateChecklist() {
        const typeVisa = document.getElementById('type_visa_id').value;
        const container = document.getElementById('checklist-container');
        const listObligatoire = document.getElementById('list-obligatoire');
        const comp = document.getElementById('pieces-complementaires');
        listObligatoire.innerHTML = '';
        comp.innerHTML = '';

        if (typeVisa) {
            container.style.display = 'block';

            if (window.piecesCommunes) {
                window.piecesCommunes.forEach(p => {
                    listObligatoire.innerHTML += '<div class="checklist-item"><input type="checkbox" /> ' + p.libelle + '</div>';
                });
            }

            if (window.piecesComplementaires) {
                window.piecesComplementaires.filter(p => p.typeIdentite && parseInt(p.typeIdentite.id) === parseInt(typeVisa)).forEach(p => {
                    comp.innerHTML += '<div class="checklist-item"><input type="checkbox" /> ' + p.libelle + '</div>';
                });
            }
        } else {
            container.style.display = 'none';
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const stepToContinue = urlParams.get('step');
        const demandeurIdToContinue = urlParams.get('id');
        const visaIdToContinue = urlParams.get('visaId');

        if (!stepToContinue) {
            // Initialisation normale pour une nouvelle demande (étape 1)
            validateStep(1);
        }

        if (stepToContinue && demandeurIdToContinue) {
            currentDemandeurId = parseInt(demandeurIdToContinue);
            if (visaIdToContinue) {
                currentVisaId = parseInt(visaIdToContinue);
            }
            // Aller à l'étape demandée
            document.getElementById('step-1').classList.remove('active');
            document.getElementById('indicator-1').style.fontWeight = 'normal';
            
            document.getElementById('step-' + stepToContinue).classList.add('active');
            document.getElementById('indicator-' + stepToContinue).style.fontWeight = 'bold';
            
            // Initialiser les champs required pour l'étape active
            validateStep(stepToContinue);
            
            // Récupérer les données du demandeur pour pré-remplir (et éviter de recréer si on revient à l'étape 1)
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

    async function submitForm(e) {
        e.preventDefault();
        if (!validateStep(4)) return false;

        const duplicataDTO = {
            demandeurId: currentDemandeurId,
            visaTransformableId: currentVisaId,
            typeIdentiteId: parseInt(document.getElementById('type_visa_id').value),
            typeDocument: document.getElementById('type_document').value,
            referenceDocument: document.getElementById('ref_document').value,
            dateDebutDocument: document.getElementById('date_debut_document').value,
            dateFinDocument: document.getElementById('date_fin_document').value
        };

        try {
            const response = await fetch('/api/dossiers/duplicata', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(duplicataDTO)
            });

            if (response.ok) {
                const dossier = await response.json();
                alert("Félicitations, le duplicata a été créé et approuvé avec succès ! (Dossier ID: " + dossier.id + ")");
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
