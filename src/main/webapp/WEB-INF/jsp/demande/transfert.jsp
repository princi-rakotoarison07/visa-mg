<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Transfert Passeport | visa-mg</title>
            <link rel="stylesheet" href="/css/app.css" />
            <style>
                .input-error {
                    border: 1px solid red;
                }

                .hint {
                    font-size: 0.85rem;
                    color: #6c757d;
                    margin-top: 5px;
                }

                .box {
                    border: 1px solid #ddd;
                    border-radius: 6px;
                    padding: 15px;
                    margin-top: 15px;
                    background: #fff;
                }

                .row {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 10px;
                }

                @media (max-width: 900px) {
                    .row {
                        grid-template-columns: 1fr;
                    }
                }

                .search-box {
                    border: 2px solid #007bff;
                    border-radius: 8px;
                    padding: 18px;
                    margin-bottom: 20px;
                    background: #f0f7ff;
                }

                .search-box h3 {
                    margin-top: 0;
                    color: #007bff;
                }

                .search-results {
                    list-style: none;
                    padding: 0;
                    margin: 8px 0 0;
                    max-height: 200px;
                    overflow-y: auto;
                }

                .search-results li {
                    padding: 8px 12px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    margin-bottom: 4px;
                    cursor: pointer;
                    background: #fff;
                }

                .search-results li:hover {
                    background: #e9f0ff;
                    border-color: #007bff;
                }

                .search-results li.selected {
                    background: #d4edda;
                    border-color: #28a745;
                }

                .badge-found {
                    display: inline-block;
                    padding: 3px 10px;
                    border-radius: 12px;
                    font-size: 0.8rem;
                    font-weight: bold;
                    margin-left: 10px;
                }

                .badge-found.ok {
                    background: #d4edda;
                    color: #155724;
                }

                .badge-found.manual {
                    background: #fff3cd;
                    color: #856404;
                }

                .section-title {
                    font-size: 1.15rem;
                    font-weight: bold;
                    margin: 20px 0 10px;
                    padding-bottom: 5px;
                    border-bottom: 2px solid #eee;
                }

                .readonly-info {
                    background: #f8f9fa;
                    border: 1px solid #dee2e6;
                }
            </style>
        </head>

        <body>
            <div class="layout">
                <jsp:include page="/WEB-INF/jsp/components/sidebar.jsp" />

                <main class="main">
                    <jsp:include page="/WEB-INF/jsp/components/header.jsp" />

                    <section class="content">
                        <h1>Transfert de Passeport</h1>

                        <form id="transfertForm" onsubmit="return submitForm(event)">

                            <!-- ============ RECHERCHE ANCIEN PASSEPORT ============ -->
                            <div class="search-box">
                                <h3>🔍 Rechercher l'ancien passeport</h3>
                                <div class="form-group">
                                    <label>Numéro de l'ancien passeport</label>
                                    <input type="text" id="ancienSearch"
                                        placeholder="Tapez le numéro du passeport (ex: AB123456)..."
                                        oninput="searchAncienPasseport()" autocomplete="off" />
                                    <div class="hint">Si le passeport existe dans la base, les informations du demandeur
                                        seront remplies automatiquement. Sinon, vous devrez tout saisir manuellement.
                                    </div>
                                </div>
                                <ul id="searchResultsList" class="search-results" style="display:none;"></ul>
                                <div id="searchStatus" style="margin-top:8px; display:none;"></div>
                            </div>

                            <!-- ============ IDENTITÉ DU DEMANDEUR ============ -->
                            <div class="section-title">Identité du demandeur</div>
                            <div class="box" id="demandeurBox">
                                <div class="row">
                                    <div class="form-group">
                                        <label>Nom *</label>
                                        <input type="text" id="nom" required />
                                    </div>
                                    <div class="form-group">
                                        <label>Prénom *</label>
                                        <input type="text" id="prenom" required />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label>Date de naissance *</label>
                                        <input type="date" id="dateNaissance" required />
                                    </div>
                                    <div class="form-group">
                                        <label>Lieu de naissance *</label>
                                        <input type="text" id="lieuNaissance" required />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label>Nationalité *</label>
                                        <select id="nationalite_id" required>
                                            <option value="">Sélectionner</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Situation familiale *</label>
                                        <select id="situation_familiale_id" required>
                                            <option value="">Sélectionner</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label>Téléphone *</label>
                                        <input type="tel" id="telephone" required />
                                    </div>
                                    <div class="form-group">
                                        <label>Email *</label>
                                        <input type="email" id="email" required />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Adresse *</label>
                                    <textarea id="adresse" required></textarea>
                                </div>
                            </div>

                            <!-- ============ ANCIEN PASSEPORT ============ -->
                            <div class="section-title">Ancien passeport</div>
                            <div class="box" id="ancienPasseportBox">
                                <div class="row">
                                    <div class="form-group">
                                        <label>Numéro ancien passeport *</label>
                                        <input type="text" id="ancienNumero" required />
                                    </div>
                                    <div class="form-group">
                                        <label>Pays de délivrance *</label>
                                        <select id="ancienPaysDelivrance" required>
                                            <option value="">Sélectionner</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label>Date de délivrance *</label>
                                        <input type="date" id="ancienDateDelivrance" required />
                                    </div>
                                    <div class="form-group">
                                        <label>Date d'expiration *</label>
                                        <input type="date" id="ancienDateExpiration" required />
                                    </div>
                                </div>
                            </div>

                            <!-- ============ NOUVEAU PASSEPORT ============ -->
                            <div class="section-title">Nouveau passeport</div>
                            <div class="box">
                                <div class="row">
                                    <div class="form-group">
                                        <label>Numéro nouveau passeport *</label>
                                        <input type="text" id="nouveauNumero" required />
                                    </div>
                                    <div class="form-group">
                                        <label>Pays de délivrance *</label>
                                        <select id="nouveauPaysDelivrance" required>
                                            <option value="">Sélectionner</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label>Date de délivrance *</label>
                                        <input type="date" id="nouveauDateDelivrance" required />
                                    </div>
                                    <div class="form-group">
                                        <label>Date d'expiration *</label>
                                        <input type="date" id="nouveauDateExpiration" required />
                                    </div>
                                </div>
                            </div>

                            <!-- ============ TYPE DE TITRE ============ -->
                            <div class="section-title">Type de titre</div>
                            <div class="box">
                                <div class="form-group">
                                    <label>Type de Titre *</label>
                                    <select id="type_visa_id" required>
                                        <option value="">Sélectionner</option>
                                    </select>
                                </div>
                            </div>

                            <!-- ============ OPTIONS POUR LES VISAS ============ -->
                            <div class="box">
                                <h3 style="margin-top:0;">Gestion du Visa</h3>
                                <div style="margin-bottom:10px;">
                                    <label style="margin-right:20px;">
                                        <input type="radio" name="visa_action" value="none" checked
                                            onchange="toggleVisaAction()" />
                                        Ne rien faire
                                    </label>
                                    <label style="margin-right:20px;">
                                        <input type="radio" name="visa_action" value="search"
                                            onchange="toggleVisaAction()" />
                                        Choisir un Visa existant
                                    </label>
                                    <label>
                                        <input type="radio" name="visa_action" value="create"
                                            onchange="toggleVisaAction()" />
                                        Créer un nouveau Visa
                                    </label>
                                </div>

                                <!-- Bloc de recherche de visa existant -->
                                <div id="section_search_visa"
                                    style="display:none; padding:10px; border:1px solid #ddd; border-radius:5px; background:#f0fbf0;">
                                    <label>Rechercher le Visa par Numéro de référence :</label>
                                    <div style="display:flex; gap:10px; margin-top:5px;">
                                        <input type="text" id="search_visa_ref" placeholder="Ex: V123456"
                                            style="flex:1;" />
                                        <button type="button" onclick="searchVisa()"
                                            class="btn-secondary">Rechercher</button>
                                    </div>
                                    <div id="searchVisaResult"
                                        style="margin-top:10px; font-weight:bold; color:#155724;"></div>
                                    <!-- Checkbox caché pour associer l'ID trouvé -->
                                    <div id="selectedVisaContainer" style="display:none; margin-top:10px;">
                                        <label>
                                            <input type="checkbox" name="visasAUpdater" id="found_visa_id" checked />
                                            Associer ce Visa au nouveau passeport
                                        </label>
                                    </div>
                                </div>

                                <!-- Bloc de création de nouveau visa -->
                                <div id="section_new_visa"
                                    style="display:none; margin-top:10px; padding:10px; border:1px solid #ddd; border-radius:5px; background:#f9f9f9;">
                                    <h4>Nouvelles Informations du Visa</h4>
                                    <div class="row">
                                        <div class="form-group">
                                            <label>Numéro de référence *</label>
                                            <input type="text" id="new_visa_ref" />
                                        </div>
                                        <div class="form-group">
                                            <label>Date de début *</label>
                                            <input type="date" id="new_visa_debut" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Date de fin *</label>
                                        <input type="date" id="new_visa_fin" />
                                    </div>
                                </div>
                            </div>

                            <!-- ============ OPTIONS POUR LES CARTES DE RÉSIDENCE ============ -->
                            <div class="box">
                                <h3 style="margin-top:0;">Gestion de la Carte de Résidence</h3>
                                <div style="margin-bottom:10px;">
                                    <label style="margin-right:20px;">
                                        <input type="radio" name="carte_action" value="none" checked
                                            onchange="toggleCarteAction()" />
                                        Ne rien faire
                                    </label>
                                    <label style="margin-right:20px;">
                                        <input type="radio" name="carte_action" value="search"
                                            onchange="toggleCarteAction()" />
                                        Choisir une Carte existante
                                    </label>
                                    <label>
                                        <input type="radio" name="carte_action" value="create"
                                            onchange="toggleCarteAction()" />
                                        Créer une nouvelle Carte
                                    </label>
                                </div>

                                <!-- Bloc de recherche de carte existante -->
                                <div id="section_search_carte"
                                    style="display:none; padding:10px; border:1px solid #ddd; border-radius:5px; background:#f0fbf0;">
                                    <label>Rechercher la Carte par Numéro de référence :</label>
                                    <div style="display:flex; gap:10px; margin-top:5px;">
                                        <input type="text" id="search_carte_ref" placeholder="Ex: C123456"
                                            style="flex:1;" />
                                        <button type="button" onclick="searchCarte()"
                                            class="btn-secondary">Rechercher</button>
                                    </div>
                                    <div id="searchCarteResult"
                                        style="margin-top:10px; font-weight:bold; color:#155724;"></div>
                                    <!-- Checkbox caché pour associer l'ID trouvé -->
                                    <div id="selectedCarteContainer" style="display:none; margin-top:10px;">
                                        <label>
                                            <input type="checkbox" name="cartesAUpdater" id="found_carte_id" checked />
                                            Associer cette Carte au nouveau passeport
                                        </label>
                                    </div>
                                </div>

                                <!-- Bloc de création de nouvelle carte -->
                                <div id="section_new_carte"
                                    style="display:none; margin-top:10px; padding:10px; border:1px solid #ddd; border-radius:5px; background:#f9f9f9;">
                                    <h4>Nouvelles Informations de la Carte de Résidence</h4>
                                    <div class="row">
                                        <div class="form-group">
                                            <label>Numéro de référence *</label>
                                            <input type="text" id="new_carte_ref" />
                                        </div>
                                        <div class="form-group">
                                            <label>Date de début *</label>
                                            <input type="date" id="new_carte_debut" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Date de fin *</label>
                                        <input type="date" id="new_carte_fin" />
                                    </div>
                                </div>
                            </div>

                            <div style="margin-top: 25px;">
                                <button type="submit" style="font-size:1.1rem; padding:10px 30px;">Valider le
                                    transfert</button>
                            </div>
                        </form>
                    </section>
                </main>
            </div>

            <script>
                // ========== État global ==========
                let ancienPasseportId = null;      // ID du passeport trouvé dans la base (null si saisie manuelle)
                let existingDemandeurId = null;    // ID du demandeur déjà existant (null si saisie manuelle)
                let searchResults = [];            // Résultats de recherche courants

                // ========== Gestion des actions sur Visa et Carte ==========
                function toggleVisaAction() {
                    const action = document.querySelector('input[name="visa_action"]:checked').value;
                    document.getElementById('section_search_visa').style.display = (action === 'search') ? 'block' : 'none';
                    document.getElementById('section_new_visa').style.display = (action === 'create') ? 'block' : 'none';

                    // Si on change d'action, réinitialiser la recherche
                    if (action !== 'search') {
                        document.getElementById('searchVisaResult').innerHTML = '';
                        document.getElementById('selectedVisaContainer').style.display = 'none';
                        document.getElementById('found_visa_id').value = '';
                    }
                }

                function toggleCarteAction() {
                    const action = document.querySelector('input[name="carte_action"]:checked').value;
                    document.getElementById('section_search_carte').style.display = (action === 'search') ? 'block' : 'none';
                    document.getElementById('section_new_carte').style.display = (action === 'create') ? 'block' : 'none';

                    if (action !== 'search') {
                        document.getElementById('searchCarteResult').innerHTML = '';
                        document.getElementById('selectedCarteContainer').style.display = 'none';
                        document.getElementById('found_carte_id').value = '';
                    }
                }

                async function searchVisa() {
                    const ref = document.getElementById('search_visa_ref').value.trim();
                    if (!ref) return;
                    try {
                        const res = await fetch('/api/passeports/visas/search?query=' + encodeURIComponent(ref));
                        if (res.ok) {
                            const visas = await res.json();
                            if (visas.length > 0) {
                                const v = visas[0]; // On prend le premier trouvé
                                document.getElementById('searchVisaResult').innerHTML = '✓ Visa trouvé : Réf ' + v.reference + ' (Du ' + v.dateDebut + ' au ' + v.dateFin + ')';
                                document.getElementById('found_visa_id').value = v.id;
                                document.getElementById('selectedVisaContainer').style.display = 'block';
                            } else {
                                document.getElementById('searchVisaResult').innerHTML = '<span style="color:red;">Aucun Visa trouvé.</span>';
                                document.getElementById('selectedVisaContainer').style.display = 'none';
                            }
                        }
                    } catch (e) { console.error('Erreur', e); }
                }

                async function searchCarte() {
                    const ref = document.getElementById('search_carte_ref').value.trim();
                    if (!ref) return;
                    try {
                        const res = await fetch('/api/passeports/cartes/search?query=' + encodeURIComponent(ref));
                        if (res.ok) {
                            const cartes = await res.json();
                            if (cartes.length > 0) {
                                const c = cartes[0];
                                document.getElementById('searchCarteResult').innerHTML = '✓ Carte trouvée : Réf ' + c.reference + ' (Du ' + c.dateDebut + ' au ' + c.dateFin + ')';
                                document.getElementById('found_carte_id').value = c.id;
                                document.getElementById('selectedCarteContainer').style.display = 'block';
                            } else {
                                document.getElementById('searchCarteResult').innerHTML = '<span style="color:red;">Aucune Carte trouvée.</span>';
                                document.getElementById('selectedCarteContainer').style.display = 'none';
                            }
                        }
                    } catch (e) { console.error('Erreur', e); }
                }

                // ========== Recherche de passeport ==========
                let searchTimeout = null;
                function searchAncienPasseport() {
                    const q = document.getElementById('ancienSearch').value.trim();
                    const resultsList = document.getElementById('searchResultsList');
                    const statusDiv = document.getElementById('searchStatus');

                    if (!q || q.length < 2) {
                        resultsList.style.display = 'none';
                        statusDiv.style.display = 'none';
                        return;
                    }

                    // Debounce 300ms
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(async () => {
                        try {
                            const res = await fetch('/api/passeports/search?query=' + encodeURIComponent(q));
                            if (!res.ok) return;

                            searchResults = await res.json();

                            if (searchResults.length === 0) {
                                resultsList.style.display = 'none';
                                statusDiv.style.display = 'block';
                                statusDiv.innerHTML = '<span class="badge-found manual">Aucun passeport trouvé — Veuillez saisir les informations manuellement</span>';
                                resetToManualMode();
                                // Pré-remplir le numéro dans le champ ancien passeport
                                document.getElementById('ancienNumero').value = q;
                                return;
                            }

                            // Afficher les résultats
                            resultsList.innerHTML = '';
                            searchResults.forEach(p => {
                                const li = document.createElement('li');
                                li.textContent = p.numeroPasseport;
                                li.setAttribute('data-id', p.id);
                                li.onclick = function () { selectPasseport(p.id, p.numeroPasseport); };
                                resultsList.appendChild(li);
                            });
                            resultsList.style.display = 'block';
                            statusDiv.style.display = 'none';

                        } catch (e) {
                            console.error('Erreur recherche passeport', e);
                        }
                    }, 300);
                }

                // ========== Sélection d'un passeport trouvé ==========
                async function selectPasseport(passeportId, numero) {
                    document.getElementById('searchResultsList').style.display = 'none';
                    const statusDiv = document.getElementById('searchStatus');
                    statusDiv.style.display = 'block';
                    statusDiv.innerHTML = '<span class="badge-found ok">✓ Passeport sélectionné : <strong>' + numero + '</strong> — Chargement des informations...</span>';

                    try {
                        // Charger les détails complets du passeport (avec demandeur)
                        const res = await fetch('/api/passeports/' + passeportId);
                        if (!res.ok) {
                            alert('Erreur lors du chargement du passeport');
                            return;
                        }

                        const passeport = await res.json();
                        ancienPasseportId = passeport.id;

                        // Remplir les champs ancien passeport et les rendre readonly
                        document.getElementById('ancienNumero').value = passeport.numeroPasseport || '';
                        document.getElementById('ancienNumero').readOnly = true;
                        document.getElementById('ancienNumero').classList.add('readonly-info');

                        if (passeport.paysDelivrance) {
                            document.getElementById('ancienPaysDelivrance').value = passeport.paysDelivrance.id;
                        }
                        document.getElementById('ancienPaysDelivrance').disabled = true;
                        document.getElementById('ancienPaysDelivrance').classList.add('readonly-info');

                        if (passeport.dateDelivrance) {
                            document.getElementById('ancienDateDelivrance').value = passeport.dateDelivrance.substring(0, 10);
                        }
                        document.getElementById('ancienDateDelivrance').readOnly = true;
                        document.getElementById('ancienDateDelivrance').classList.add('readonly-info');

                        if (passeport.dateExpiration) {
                            document.getElementById('ancienDateExpiration').value = passeport.dateExpiration.substring(0, 10);
                        }
                        document.getElementById('ancienDateExpiration').readOnly = true;
                        document.getElementById('ancienDateExpiration').classList.add('readonly-info');

                        // Remplir le demandeur si disponible
                        const dem = passeport.demandeur;
                        if (dem) {
                            existingDemandeurId = dem.id;

                            document.getElementById('nom').value = dem.nom || '';
                            document.getElementById('prenom').value = dem.prenom || '';
                            if (dem.dateNaissance) document.getElementById('dateNaissance').value = dem.dateNaissance.substring(0, 10);
                            document.getElementById('lieuNaissance').value = dem.lieuNaissance || '';
                            document.getElementById('telephone').value = dem.telephone || '';
                            document.getElementById('email').value = dem.email || '';
                            document.getElementById('adresse').value = dem.adresse || '';
                            if (dem.nationalite) document.getElementById('nationalite_id').value = dem.nationalite.id;
                            if (dem.situationFamiliale) document.getElementById('situation_familiale_id').value = dem.situationFamiliale.id;

                            // Rendre les champs demandeur readonly
                            setDemandeurReadOnly(true);
                        }

                        statusDiv.innerHTML = '<span class="badge-found ok">✓ Passeport <strong>' + numero + '</strong> sélectionné — Informations remplies automatiquement</span>';

                        // Le bloc de chargement auto a été retiré, on laisse l'utilisateur choisir par référence explicitement.

                    } catch (e) {
                        console.error('Erreur chargement passeport', e);
                        alert('Erreur lors du chargement des détails du passeport.');
                    }
                }

                // ========== Remettre en mode saisie manuelle ==========
                function resetToManualMode() {
                    ancienPasseportId = null;
                    existingDemandeurId = null;

                    // Réactiver les champs ancien passeport
                    document.getElementById('ancienNumero').readOnly = false;
                    document.getElementById('ancienNumero').classList.remove('readonly-info');
                    document.getElementById('ancienPaysDelivrance').disabled = false;
                    document.getElementById('ancienPaysDelivrance').classList.remove('readonly-info');
                    document.getElementById('ancienDateDelivrance').readOnly = false;
                    document.getElementById('ancienDateDelivrance').classList.remove('readonly-info');
                    document.getElementById('ancienDateExpiration').readOnly = false;
                    document.getElementById('ancienDateExpiration').classList.remove('readonly-info');

                    // Réactiver les champs demandeur
                    setDemandeurReadOnly(false);

                    // Vider les champs demandeur
                    document.getElementById('nom').value = '';
                    document.getElementById('prenom').value = '';
                    document.getElementById('dateNaissance').value = '';
                    document.getElementById('lieuNaissance').value = '';
                    document.getElementById('telephone').value = '';
                    document.getElementById('email').value = '';
                    document.getElementById('adresse').value = '';
                    document.getElementById('nationalite_id').value = '';
                    document.getElementById('situation_familiale_id').value = '';

                    // Vider les champs ancien passeport
                    document.getElementById('ancienPaysDelivrance').value = '';
                    document.getElementById('ancienDateDelivrance').value = '';
                    document.getElementById('ancienDateExpiration').value = '';

                    // Masquer le bloc de documents existants
                    // Ancien bloc de recherche supprimé
                }

                function setDemandeurReadOnly(readonly) {
                    const fields = ['nom', 'prenom', 'dateNaissance', 'lieuNaissance', 'telephone', 'email'];
                    fields.forEach(id => {
                        const el = document.getElementById(id);
                        el.readOnly = readonly;
                        if (readonly) el.classList.add('readonly-info');
                        else el.classList.remove('readonly-info');
                    });

                    const textareas = ['adresse'];
                    textareas.forEach(id => {
                        const el = document.getElementById(id);
                        el.readOnly = readonly;
                        if (readonly) el.classList.add('readonly-info');
                        else el.classList.remove('readonly-info');
                    });

                    const selects = ['nationalite_id', 'situation_familiale_id'];
                    selects.forEach(id => {
                        const el = document.getElementById(id);
                        el.disabled = readonly;
                        if (readonly) el.classList.add('readonly-info');
                        else el.classList.remove('readonly-info');
                    });
                }

                // ========== Validation globale ==========
                function validateForm() {
                    const form = document.getElementById('transfertForm');
                    let isValid = true;

                    // Valider tous les champs required visibles (pas disabled)
                    form.querySelectorAll('input[required]:not([disabled]), select[required]:not([disabled]), textarea[required]:not([disabled])').forEach(input => {
                        if (!input.checkValidity() || (typeof input.value === 'string' && input.value.trim() === '')) {
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

                // ========== Soumission ==========
                async function submitForm(e) {
                    e.preventDefault();
                    if (!validateForm()) return false;

                    // Validation des sections optionnelles
                    const visaAction = document.querySelector('input[name="visa_action"]:checked').value;
                    const carteAction = document.querySelector('input[name="carte_action"]:checked').value;

                    if (visaAction === 'create') {
                        const ref = document.getElementById('new_visa_ref').value.trim();
                        const debut = document.getElementById('new_visa_debut').value;
                        const fin = document.getElementById('new_visa_fin').value;
                        if (!ref || !debut || !fin) {
                            alert('Veuillez remplir tous les champs du Visa à créer.');
                            return false;
                        }
                    } else if (visaAction === 'search' && document.getElementById('found_visa_id').value === '') {
                        alert('Veuillez rechercher et sélectionner un Visa existant, ou choisir une autre option.');
                        return false;
                    }

                    if (carteAction === 'create') {
                        const ref = document.getElementById('new_carte_ref').value.trim();
                        const debut = document.getElementById('new_carte_debut').value;
                        const fin = document.getElementById('new_carte_fin').value;
                        if (!ref || !debut || !fin) {
                            alert('Veuillez remplir tous les champs de la Carte de Résidence à créer.');
                            return false;
                        }
                    } else if (carteAction === 'search' && document.getElementById('found_carte_id').value === '') {
                        alert('Veuillez rechercher et sélectionner une Carte existante, ou choisir une autre option.');
                        return false;
                    }

                    // ---- 1. Créer ou réutiliser le demandeur ----
                    let demandeurId = existingDemandeurId;
                    if (!demandeurId) {
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
                            if (!res.ok) { alert('Erreur Demandeur: ' + await res.text()); return false; }
                            const demandeur = await res.json();
                            demandeurId = demandeur.id;
                        } catch (e) { alert('Erreur réseau Demandeur'); return false; }
                    }

                    // ---- 2. Créer ou réutiliser l'ancien passeport ----
                    let ancienPId = ancienPasseportId;
                    if (!ancienPId) {
                        const ancienDTO = {
                            demandeurId: demandeurId,
                            numeroPasseport: document.getElementById('ancienNumero').value.trim(),
                            paysDelivranceId: parseInt(document.getElementById('ancienPaysDelivrance').value),
                            dateDelivrance: document.getElementById('ancienDateDelivrance').value,
                            dateExpiration: document.getElementById('ancienDateExpiration').value
                        };

                        try {
                            const resP = await fetch('/api/passeports', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify(ancienDTO)
                            });
                            if (!resP.ok) { alert('Erreur ancien passeport: ' + await resP.text()); return false; }
                            const p = await resP.json();
                            ancienPId = p.id;
                        } catch (e) { alert('Erreur réseau ancien passeport'); return false; }
                    }

                    // ---- 3. Créer le nouveau passeport ----
                    const nouveauDTO = {
                        demandeurId: demandeurId,
                        numeroPasseport: document.getElementById('nouveauNumero').value.trim(),
                        paysDelivranceId: parseInt(document.getElementById('nouveauPaysDelivrance').value),
                        dateDelivrance: document.getElementById('nouveauDateDelivrance').value,
                        dateExpiration: document.getElementById('nouveauDateExpiration').value
                    };

                    let nouveauPasseportId;
                    try {
                        const resNew = await fetch('/api/passeports', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(nouveauDTO)
                        });
                        if (!resNew.ok) { alert('Erreur nouveau passeport: ' + await resNew.text()); return false; }
                        const np = await resNew.json();
                        nouveauPasseportId = np.id;
                    } catch (e) { alert('Erreur réseau nouveau passeport'); return false; }

                    // ---- 4. Documents optionnels (Visa / Carte) ----
                    const documents = [];
                    if (visaAction === 'create') {
                        documents.push({
                            typeDocument: 'VISA',
                            referenceDocument: document.getElementById('new_visa_ref').value.trim(),
                            dateDebutDocument: document.getElementById('new_visa_debut').value,
                            dateFinDocument: document.getElementById('new_visa_fin').value
                        });
                    }
                    if (carteAction === 'create') {
                        documents.push({
                            typeDocument: 'CARTE_RESIDENT',
                            referenceDocument: document.getElementById('new_carte_ref').value.trim(),
                            dateDebutDocument: document.getElementById('new_carte_debut').value,
                            dateFinDocument: document.getElementById('new_carte_fin').value
                        });
                    }

                    // ---- 5. Envoyer le transfert ----
                    // Extraction des IDs de documents sélectionnés
                    const visasChecked = Array.from(document.querySelectorAll('input[name="visasAUpdater"]:checked')).map(el => parseInt(el.value));
                    const cartesChecked = Array.from(document.querySelectorAll('input[name="cartesAUpdater"]:checked')).map(el => parseInt(el.value));

                    const transfertDTO = {
                        demandeurId: demandeurId,
                        ancienPasseportId: ancienPId,
                        nouveauPasseportId: nouveauPasseportId,
                        typeIdentiteId: parseInt(document.getElementById('type_visa_id').value),
                        visasAUpdater: visasChecked.length > 0 ? visasChecked : null,
                        cartesAUpdater: cartesChecked.length > 0 ? cartesChecked : null,
                        documents: documents.length > 0 ? documents : null
                    };

                    try {
                        const resT = await fetch('/api/dossiers/transfert', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(transfertDTO)
                        });

                        if (!resT.ok) {
                            alert('Erreur transfert: ' + await resT.text());
                            return false;
                        }

                        const dossier = await resT.json();
                        let msg = 'Transfert créé avec succès ! (Dossier ID: ' + dossier.id + ')';
                        if (visaAction === 'create') msg += '\n✓ Visa créé.';
                        if (carteAction === 'create') msg += '\n✓ Carte de Résidence créée.';
                        alert(msg);
                        window.location.href = '/demande/liste';
                    } catch (e) {
                        alert('Erreur réseau transfert');
                    }

                    return false;
                }

                // ========== Initialisation ==========
                document.addEventListener('DOMContentLoaded', function () {
                    fetch('/api/ref/nationalites').then(r => r.json()).then(data => {
                        const selNat = document.getElementById('nationalite_id');
                        const selAncPays = document.getElementById('ancienPaysDelivrance');
                        const selNouvPays = document.getElementById('nouveauPaysDelivrance');
                        data.forEach(n => {
                            const opt = '<option value="' + n.id + '">' + n.libelle + '</option>';
                            selNat.innerHTML += opt;
                            selAncPays.innerHTML += opt;
                            selNouvPays.innerHTML += opt;
                        });
                    });

                    fetch('/api/ref/situations-familiales').then(r => r.json()).then(data => {
                        const sel = document.getElementById('situation_familiale_id');
                        data.forEach(s => {
                            sel.innerHTML += '<option value="' + s.id + '">' + s.libelle + '</option>';
                        });
                    });

                    fetch('/api/ref/types-identite').then(r => r.json()).then(data => {
                        const sel = document.getElementById('type_visa_id');
                        data.forEach(t => {
                            sel.innerHTML += '<option value="' + t.id + '">' + t.libelle + '</option>';
                        });
                    });
                });
            </script>
        </body>

        </html>