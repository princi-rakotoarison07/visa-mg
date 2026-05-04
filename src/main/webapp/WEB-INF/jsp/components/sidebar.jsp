<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="sidebar">
    <div class="sidebar__brand">
        <div class="sidebar__title">visa-mg</div>
        <div class="sidebar__subtitle">Administration Portal</div>
    </div>

    <nav class="sidebar__nav">
        <div class="sidebar__section-label">Principal</div>
        
        <a class="sidebar__link ${pageContext.request.requestURI == '/' ? 'active' : ''}" href="<c:url value='/'/>">
            <svg class="sidebar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                <polyline points="9 22 9 12 15 12 15 22"></polyline>
            </svg>
            <span>Accueil</span>
        </a>

        <div class="sidebar__section-label">Gestion</div>

        <div class="sidebar__menu-item">
            <a class="sidebar__link" href="#" onclick="toggleSubMenu(event)">
                <svg class="sidebar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                    <polyline points="10 9 9 9 8 9"></polyline>
                </svg>
                <span>Demandes</span>
                <svg class="sidebar__arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="6 9 12 15 18 9"></polyline>
                </svg>
            </a>
            <div class="sidebar__submenu">
                <a class="sidebar__link" href="<c:url value='/demande/nouveau'/>">Nouvelle Demande</a>
                <a class="sidebar__link" href="<c:url value='/demande/duplicata'/>">Duplicata</a>
                <a class="sidebar__link" href="<c:url value='/demande/transfert'/>">Transfert Passeport</a>
                <a class="sidebar__link" href="<c:url value='/demande/liste'/>">Liste des Demandes</a>
            </div>
        </div>

        <a class="sidebar__link" href="#">
            <svg class="sidebar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
            </svg>
            <span>Utilisateurs</span>
        </a>

        <div class="sidebar__section-label">Système</div>
        
        <a class="sidebar__link" href="#">
            <svg class="sidebar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="3"></circle>
                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1Z"></path>
            </svg>
            <span>Paramètres</span>
        </a>
    </nav>

    <div class="sidebar__footer">
        <div class="user-profile">
            <div class="user-profile__avatar">JD</div>
            <div class="user-profile__info">
                <span class="user-profile__name">John Doe</span>
                <span class="user-profile__role">Administrateur</span>
            </div>
        </div>
    </div>

    <script>
        function toggleSubMenu(e) {
            e.preventDefault();
            const menuItem = e.currentTarget.parentElement;
            menuItem.classList.toggle('open');
        }
    </script>
</aside>
