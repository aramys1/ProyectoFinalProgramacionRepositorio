<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Rewind & Relive | Nuestro Equipo</title>
</head>

<body>

<nav class="navbar retro-window">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo-link">Rewind & Relive</a>
    </div>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/catalogo.jsp">Catálogo</a></li>
        <li><a href="${pageContext.request.contextPath}/novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp" class="active">Contáctanos</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp" class="retro-button btn-register">Iniciar Sesión</a></li>
    </ul>
</nav>

<div class="content-section">
    <div class="team-header-container">
        <h1 class="glitch-title">> NUESTRO_EQUIPO_DEVELOPER.exe</h1>
    </div>

    <div class="retro-window team-main-window">
        <div class="window-header">
            <span>directorio_personal.vhs</span>
            <span>_ □ X</span>
        </div>

        <div class="team-grid">
            <%-- Lista de integrantes --%>
            <% String[][] equipo = {
                {"Alisson Aguire", "alisson.aguirre@utp.ac.pa", "alison.jpeg", "001-DEV", "League of Legends"},
                {"Fabian Rodriguez", "fabian.rodriguez@utp.ac.pa", "fabian.jpeg", "002-DEV", "Gym"},
                {"Helen Bolaños", "Helen.bolanos@utp.ac.pa", "helen.jpeg", "003-DEV", "Salir con los amigos"},
                {"Leandro Barrios", "leandro.barrios@utp.ac.pa", "leandro.jpeg", "004-DEV", "Videojuegos"},
                {"Aramys Cedeño", "Aramys.cedeno@utp.ac.pa", "aramys.jpeg", "005-DEV", "Gym"},
                {"Martin Aguilar", "martin.aguilar@utp.ac.pa", "reinier.jpeg", "006-DEV", "Apuestas deportivas"}
            }; 
            
            for(String[] miembro : equipo) { %>
                <div class="retro-window member-card">
                    <div class="member-photo">
                        <img src="${pageContext.request.contextPath}/imgs/<%= miembro[2] %>" alt="<%= miembro[0] %>">
                    </div>
                    <div class="member-details">
                        <h3><%= miembro[0] %></h3>
                        <p class="role">Software Engineer</p>
                        <ul class="member-data-list">
                            <li><strong>ID:</strong> <%= miembro[3] %></li>
                            <li><strong>Área:</strong> Frontend / Backend</li>
                            <li><strong>Tech:</strong> Java, Oracle, CSS</li>
                            <li><strong>Hobby:</strong> <%= miembro[4] %></li>
                            <li><strong>Status:</strong> [ONLINE]</li>
                        </ul>
                        <div class="member-contact-footer"><%= miembro[1] %></div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <div class="retro-window store-window">
        <div class="window-header">
            <span>Contacto_Soporte.txt</span>
            <span>_ □ X</span>
        </div>
        <div class="store-content">
            <h3>Centro de Soporte Técnico</h3>
            <p><strong>Ubicación:</strong> Facultad de Sistemas, Edificio 3, Ciudad de Panamá.</p>
            <p><strong>Soporte Directo:</strong> soporte@rewindrelive.com</p>
            <p><strong>Horario:</strong> Lunes - Viernes / 08:00 - 17:00</p>
        </div>
    </div>
</div>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-col">
            <h4>Rewind & Relive</h4>
            <p>Tu destino retro preferido.</p>
        </div>
        <div class="footer-col">
            <h4>Navegación</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/catalogo.jsp">Catálogo</a></li>
                <li><a href="${pageContext.request.contextPath}/novedades.jsp">Novedades</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Contacto</h4>
            <ul><li><a href="#">📍 Av. VHS, #1980</a></li></ul>
        </div>
    </div>
    <div class="copyright">© 2026 Rewind & Relive. Todos los derechos reservados.</div>
</footer>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>