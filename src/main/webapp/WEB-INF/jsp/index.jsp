<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>visa-mg | Accueil</title>
    <link rel="stylesheet" href="/css/app.css" />
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/jsp/components/sidebar.jsp" />

    <main class="main">
        <jsp:include page="/WEB-INF/jsp/components/header.jsp" />

        <section class="content">
            <h1>Accueil</h1>
            <p>Bienvenue dans le back-office <strong>visa-mg</strong>.</p>

            <div class="cards">
                <a class="card" href="/api/personnes">Tester API Personnes</a>
                <a class="card" href="/api/dossiers">Tester API Dossiers</a>
            </div>

            <h2>Prochaines étapes</h2>
            <ul>
                <li>Créer des pages JSP pour la gestion des personnes / dossiers</li>
                <li>Brancher les formulaires HTML sur des endpoints MVC (non-REST) ou via fetch</li>
            </ul>
        </section>
    </main>
</div>
</body>
</html>
