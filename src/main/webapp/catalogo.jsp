<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Rewind & Relive | Catálogo</title>
</head>
<body>

<nav class="navbar retro-window">
    <div class="logo">
        <a href="index.jsp" class="logo-link">Rewind & Relive</a>
    </div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li><button class="retro-button btn-register">Registrarse</button></li>
    </ul>
</nav>

<div class="content-section catalog-container">

    <div class="search-section">
        <div class="filter-form">
            <input type="text" class="retro-search" placeholder="Buscar por título...">

            <select class="retro-search select-filter">
                <option value="">Géneros</option>
                <option value="Accion">Acción</option>
                <option value="Terror">Terror</option>
                <option value="Comedia">Comedia</option>
            </select>

            <button class="retro-button">FILTRAR</button>
        </div>
    </div>

    <section class="releases">
        <h2>Catálogo de VHS</h2>

        <div class="release-grid catalog-grid">

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>VHS_001.vhs</span>
                    <span>_ □ X</span>
                </div>

                <div class="placeholder-img card-img"></div>

                <div class="card-body">
                    <h3 class="card-title">Título Ejemplo</h3>
                    <p class="card-meta">Año: 1990</p>
                    <p class="card-price">$5.00 / 48hrs</p>
                    <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                </div>
            </div>

        </div>
    </section>

</div>

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
