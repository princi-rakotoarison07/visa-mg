<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="sidebar">
    <div class="sidebar__brand">
        <div class="sidebar__title">visa-mg</div>
        <div class="sidebar__subtitle">Back-office</div>
    </div>

    <nav class="sidebar__nav">
        <a class="sidebar__link" href="<c:url value='/'/>">Accueil</a>
        
        <div class="sidebar__menu-item">
            <a class="sidebar__link" href="#" onclick="toggleSubMenu(event)">
                Demande <span class="sidebar__arrow">&#9662;</span>
            </a>
            <div class="sidebar__submenu" style="display: none; padding-left: 1rem; overflow: hidden; transition: max-height 0.3s ease-out;">
                <a class="sidebar__link" href="<c:url value='/demande/nouveau'/>">Nouveau</a>
                <a class="sidebar__link" href="<c:url value='/demande/duplicata'/>">Duplicata</a>
                <a class="sidebar__link" href="<c:url value='/demande/transfert'/>">Transfert passeport</a>
                <a class="sidebar__link" href="<c:url value='/demande/liste'/>">Liste</a>
            </div>
        </div>
    </nav>

    <script>
        function toggleSubMenu(e) {
            e.preventDefault();
            const submenu = e.currentTarget.nextElementSibling;
            const arrow = e.currentTarget.querySelector('.sidebar__arrow');
            if (submenu.style.display === 'none' || submenu.style.display === '') {
                submenu.style.display = 'block';
                arrow.innerHTML = '&#9652;';
            } else {
                submenu.style.display = 'none';
                arrow.innerHTML = '&#9662;';
            }
        }
    </script>
</aside>
