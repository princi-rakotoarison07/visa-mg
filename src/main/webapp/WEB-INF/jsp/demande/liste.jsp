<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Liste des Demandes | visa-mg</title>
    <link rel="stylesheet" href="/css/app.css" />
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn-continuer { background-color: #007bff; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; }
        .btn-continuer:hover { background-color: #0056b3; }
        .badge { padding: 3px 8px; border-radius: 12px; font-size: 0.8em; }
        .badge.brouillon { background-color: #ffc107; color: #000; }
        .badge.soumise { background-color: #17a2b8; color: #fff; }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/jsp/components/sidebar.jsp" />

    <main class="main">
        <jsp:include page="/WEB-INF/jsp/components/header.jsp" />

        <section class="content">
            <h1>Liste des Demandes</h1>
            
            <table>
                <thead>
                    <tr>
                        <th>Type Demande</th>
                        <th>Demandeur</th>
                        <th>Date de création</th>
                        <th>Statut</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="dossiers-table-body">
                    <tr>
                        <td colspan="5">Chargement en cours, veuillez patienter...</td>
                    </tr>
                </tbody>
            </table>
        </section>
    </main>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    fetch('/api/dossiers')
      .then(res => res.json())
      .then(dossiers => {
          const tbody = document.getElementById('dossiers-table-body');
          tbody.innerHTML = '';
          if(dossiers.length === 0) {
              tbody.innerHTML = '<tr><td colspan="5">Aucune demande trouvée.</td></tr>';
              return;
          }
          
          // Tri croissant par ID
          dossiers.sort((a,b) => a.id - b.id);
          
          dossiers.forEach(d => {
              const dateCreation = d.createdAt ? d.createdAt.substring(0, 10) : (d.dateDemande || '-');
              const nom = d.demandeur ? d.demandeur.nom + ' ' + d.demandeur.prenom : 'Identité inconnue';
              const statut = d.statutCode ? d.statutCode : 'INCONNU';
              const statutTexte = d.statutLibelle ? d.statutLibelle : statut;
              const typeDemandeTexte = d.typeDemandeLibelle ? d.typeDemandeLibelle : 'Non défini';
              
              let badgeClass = 'badge ';
              let actionLink = '';
              
              if (statut === 'BROUILLON') {
                 badgeClass += 'brouillon';
                 let urlNouveau = '/demande/nouveau?id=' + d.id + '&step=' + d.stepToContinue;
                 if (d.visaIdToContinue) {
                     urlNouveau += '&visaId=' + d.visaIdToContinue;
                 }
                 actionLink = '<a href="' + urlNouveau + '" class="btn-continuer">Continuer</a>';
              } else if (statut === 'CREER') {
                 badgeClass += 'soumise';
                 actionLink = '<a href="/demande/detail?id=' + d.id + '" style="color: #007bff; font-size: 1.2rem; text-decoration: none;" title="Voir détail">👁️</a>';
              } else if (statut === 'SCAN_TERMINER') {
                 badgeClass += 'soumise';
                 actionLink = '<a href="/demande/detail?id=' + d.id + '" style="color: #28a745; font-size: 1.2rem; text-decoration: none;" title="Voir détail">👁️</a>';
              } else {
                 badgeClass += 'soumise';
                 actionLink = '<a href="/demande/detail?id=' + d.id + '" style="color: #007bff; font-size: 1.2rem; text-decoration: none;" title="Voir détail">👁️</a>';
              }
              
              if (d.typeDemandeCode === 'NOUVEAU_TITRE' && statut === 'APPROUVEE') {
                 actionLink = '<span style="color: gray; font-size: 0.9rem;">Parent</span>';
              }
              
              tbody.innerHTML += '<tr>' +
                  '<td>' + typeDemandeTexte + '</td>' +
                  '<td>' + nom + '</td>' +
                  '<td>' + dateCreation + '</td>' +
                  '<td><span class="' + badgeClass + '">' + statutTexte + '</span></td>' +
                  '<td>' + actionLink + '</td>' +
              '</tr>';
          });
      })
      .catch(error => {
          console.error("Erreur de chargement", error);
          document.getElementById('dossiers-table-body').innerHTML = '<tr><td colspan="5" style="color:red;">Erreur de connexion a API.</td></tr>';
      });
});
</script>
</body>
</html>
