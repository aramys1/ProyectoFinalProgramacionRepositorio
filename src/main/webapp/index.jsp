<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/styles_index.css">
    <title>Rewind & Relive | Inicio</title>
</head>
<body>

<nav class="navbar retro-window">
    <div class="logo">Rewind & Relive</div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="#">Novedades</a></li>
        <li><a href="#">Contáctanos</a></li>
        <li><button class="retro-button btn-register">Registrarse</button></li>
    </ul>
</nav>

<header class="hero">
    <div class="hero-content">
        <div class="hero-text-inner">
            <h1>Revive la magia del VHS</h1>
            <p>La mejor selección de clásicos, directo a tu sala.</p>
        </div>
    </div>
    <div class="hero-image-container">
        <div class="retro-window">
            <div class="window-header"><span>VHS_Destacado.mp4</span><span>_ □ X</span></div>
            <div class="placeholder-img"></div>
        </div>
        <button class="retro-button btn-rent">¡Alquílala ya!</button>
    </div>
</header>

<div class="content-section">
    <div class="search-section">
        <input type="text" class="retro-search" placeholder="Buscar clásicos...">
        <button class="retro-button">BUSCAR</button>
    </div>

    <section class="releases">
        <h2>Últimos Lanzamientos</h2>
        <div class="release-grid">
            <div class="retro-window release-card"></div>
            <div class="retro-window release-card"></div>
            <div class="retro-window release-card"></div>
            <div class="retro-window release-card"></div>
            <div class="retro-window release-card"></div>
            <div class="retro-window release-card"></div>
        </div>
        <a href="catalogo.jsp" class="catalog-link">VER CATÁLOGO COMPLETO ></a>
    </section>
</div>

<section class="about-section">
    <div class="retro-window">
        <h3>¿Por qué elegir el formato físico?</h3>
        <p>Porque el cine no es solo ver una película, es tenerla en tus manos.
            En Rewind & Relive preservamos la experiencia de los 80s y 90s.</p>
    </div>
</section>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-col">
            <h4>Rewind & Relive</h4>
            <p>El hogar definitivo de los clásicos en VHS.</p>
        </div>
        <div class="footer-col">
            <h4>Navegación</h4>
            <ul>
                <li><a href="catalogo.jsp">Catálogo</a></li>
                <li><a href="#">Novedades</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Contacto</h4>
            <p>📍 Av. VHS, #1980</p>
            <p>📧 hola@rewind.com</p>
        </div>
    </div>

    <hr>

    <div class="copyright">
        © 2026 Rewind & Relive. Todos los derechos reservados.
    </div>
</footer>

<script src="js/script_index.js"></script>
</body>
</html>
