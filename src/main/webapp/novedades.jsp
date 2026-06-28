<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Rewind & Relive | Novedades</title>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar retro-window">
    <div class="logo">
        <a href="index.jsp" class="logo-link">Rewind & Relive</a>
    </div>

    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp" class="active">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li><button class="retro-button">Registrarse</button></li>
    </ul>
</nav>

<!-- CONTENIDO -->
<div class="content-section" style="padding: 40px 20px;">

    <div class="retro-window news-window">
        <div class="window-header">
            <span>Novedades_del_Sistema.log</span>
            <span>_ □ X</span>
        </div>

        <div class="log-content">

            <!-- CONTENIDO ESTÁTICO -->

            <div class="log-entry">
                <div class="log-header">
                    <h3 class="log-title">> LANZAMIENTO WEB V1.0</h3>
                    <span class="category-badge cat-noticia">Noticia</span>
                </div>
                <span class="log-date">[2026-06-10]</span>
                <p>Rewind & Relive entra oficialmente en funcionamiento. ¡Gracias por ser parte del lanzamiento!</p>
            </div>

            <div class="log-entry">
                <div class="log-header">
                    <h3 class="log-title">> MANTENIMIENTO: ORACLE SQL</h3>
                    <span class="category-badge cat-tecnico">Técnico</span>
                </div>
                <span class="log-date">[2026-06-22]</span>
                <p>Optimización de procedimientos PL/SQL completada. Mejora del 15% en velocidad de carga.</p>
            </div>

            <div class="log-entry">
                <div class="log-header">
                    <h3 class="log-title">> NUEVO INVENTARIO: 80s</h3>
                    <span class="category-badge cat-inventario">Inventario</span>
                </div>
                <span class="log-date">[2026-06-27]</span>
                <p>Hemos integrado 20 nuevas cintas a nuestra base de datos.</p>
            </div>

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
                <li><a href="catalogo.jsp">Catálogo</a></li>
                <li><a href="novedades.jsp">Novedades</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Contacto</h4>
            <ul>
                <li><a href="#">📍 Av. VHS, #1980</a></li>
            </ul>
        </div>

    </div>

    <div class="copyright">
        © 2026 Rewind & Relive. Todos los derechos reservados.
    </div>

</footer>

</body>
</html>
