<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Rewind & Relive | Nuestro Equipo</title>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar retro-window">
    <div class="logo">
        <a href="index.jsp" class="logo-link">Rewind & Relive</a>
    </div>

    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp" class="active">Contáctanos</a></li>

        <li><button class="retro-button btn-register">Registrarse</button></li>
    </ul>
</nav>

<!-- CONTENIDO -->
<div class="content-section">

    <div class="team-header-container">
        <h1 class="glitch-title">> NUESTRO_EQUIPO_DEVELOPER.exe</h1>
    </div>

    <!-- Directorio -->
    <div class="retro-window team-main-window">
        <div class="window-header">
            <span>directorio_personal.vhs</span>
            <span>_ □ X</span>
        </div>

        <div class="team-grid">

            <!-- Aquí luego puedes hacerlo dinámico con JSP -->

            <div class="retro-window member-card">
                <div class="member-photo">
                    <img src="foto.jpg" alt="Foto">
                </div>

                <div class="member-details">
                    <h3>Nombre Apellido</h3>
                    <p class="role">Software Engineer</p>

                    <ul class="member-data-list">
                        <li><strong>ID:</strong> 001-DEV</li>
                        <li><strong>Área:</strong> Frontend / Backend</li>
                        <li><strong>Tech:</strong> Java, Oracle, CSS</li>
                        <li><strong>Hobby:</strong> League of Legends</li>
                        <li><strong>Status:</strong> [ONLINE]</li>
                    </ul>

                    <div class="member-contact-footer">
                        user@utp.ac.pa
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Información de la tienda -->
    <div class="retro-window store-window">
        <div class="window-header">
            <span>Contacto_Soporte.txt</span>
            <span>_ □ X</span>
        </div>

        <div class="store-content">
            <h3>Centro de Soporte Técnico</h3>
            <p><strong>Ubicación:</strong> Av. VHS, Edificio 1980, Local 3, Ciudad de Panamá.</p>
            <p><strong>Soporte Directo:</strong> soporte@rewindrelive.com</p>
            <p><strong>Horario:</strong> Lunes - Viernes / 08:00 - 17:00</p>
        </div>
    </div>

</div>

<!-- FOOTER -->
<footer class="footer">
    <div class="footer-content">

        <div class="footer-col">
            <h4>Rewind & Relive</h4>
            <p>El hogar de los clásicos.</p>
        </div>

        <div class="footer-col">
            <h4>Navegación</h4>
            <ul>
                <li><a href="catalogo.jsp">Catálogo</a></li>
                <li><a href="novedades.jsp">Novedades</a></li>
                <li><a href="contactanos.jsp">Contáctanos</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Contacto</h4>
            <p>📍 Av. VHS, #1980</p>
        </div>

    </div>

    <div class="copyright">
        © 2026 Rewind & Relive.
    </div>
</footer>

</body>
</html>
