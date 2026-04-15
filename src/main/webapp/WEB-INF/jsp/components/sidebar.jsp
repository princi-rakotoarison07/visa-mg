<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="sidebar">
    <div class="sidebar__brand">
        <div class="sidebar__title">visa-mg</div>
        <div class="sidebar__subtitle">Back-office</div>
    </div>

    <nav class="sidebar__nav">
        <a class="sidebar__link" href="<c:url value='/'/>">Accueil</a>
        <a class="sidebar__link" href="<c:url value='/api/personnes'/>">API Personnes</a>
        <a class="sidebar__link" href="<c:url value='/api/dossiers'/>">API Dossiers</a>
    </nav>
</aside>
