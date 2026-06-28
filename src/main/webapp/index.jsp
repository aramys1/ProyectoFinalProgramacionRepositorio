<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <title>Rewind & Relive | Inicio</title>
</head>
<body>

<nav class="navbar retro-window">
    <div class="logo"><a href="index.jsp" class="logo-link">Rewind & Relive</a></div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
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
            <div class="window-header">
                <span>VHS_001.vhs</span>
                <span>_ □ X</span>
            </div>
            <div class="placeholder-img"></div>
        </div>
        <button class="retro-button btn-rent">ALQUILAR</button>
    </div>
</header>

<div class="content-section">
    <section class="releases">
        <h2>Últimos Lanzamientos</h2>

        <div class="release-grid">

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>Película.exe</span>
                </div>

                <div class="card-content">
                    <img src="ruta_imagen.jpg" alt="Portada" class="movie-img">
                    <h3>The Terminator</h3>
                    <p>1984 | Acción</p>
                    <button class="retro-button">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>Película.exe</span>
                </div>

                <div class="card-content">
                    <img src="ruta_imagen.jpg" alt="Portada" class="movie-img">
                    <h3>The Terminator</h3>
                    <p>1984 | Acción</p>
                    <button class="retro-button">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>Película.exe</span>
                </div>

                <div class="card-content">
                    <img src="ruta_imagen.jpg" alt="Portada" class="movie-img">
                    <h3>The Terminator</h3>
                    <p>1984 | Acción</p>
                    <button class="retro-button">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>Película.exe</span>
                </div>

                <div class="card-content">
                    <img src="ruta_imagen.jpg" alt="Portada" class="movie-img">
                    <h3>The Terminator</h3>
                    <p>1984 | Acción</p>
                    <button class="retro-button">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>Película.exe</span>
                </div>

                <div class="card-content">
                    <img src="ruta_imagen.jpg" alt="Portada" class="movie-img">
                    <h3>The Terminator</h3>
                    <p>1984 | Acción</p>
                    <button class="retro-button">ALQUILAR</button>
                </div>
            </div>

            <div class="retro-window release-card">
                <div class="window-header">
                    <span>Película.exe</span>
                </div>

                <div class="card-content">
                    <img src="ruta_imagen.jpg" alt="Portada" class="movie-img">
                    <h3>The Terminator</h3>
                    <p>1984 | Acción</p>
                    <button class="retro-button">ALQUILAR</button>
                </div>
            </div>

        </div>

        <a href="catalogo.jsp" class="catalog-link">
            VER CATÁLOGO COMPLETO >
        </a>

    </section>
</div>

<section class="news-section">

    <h2 class="news-title">Tablón de Anuncios</h2>

    <div class="retro-window">

        <div class="window-header">
            <span>Noticias_Rewind.txt</span>
            <span>_ □ X</span>
        </div>

        <div class="news-content">

            <div class="log-entry">
                <div class="log-header">
                    <h4 class="log-title">[2026-06-27] ¡Nueva llegada!</h4>
                    <span class="category-badge cat-inventario">Inventario</span>
                </div>
                <p>Clásicos de terror de los 80s disponibles.</p>
            </div>

            <div class="log-entry">
                <div class="log-header">
                    <h4 class="log-title">[2026-06-22] Promoción fin de semana</h4>
                    <span class="category-badge cat-noticia">Noticia</span>
                </div>
                <p>Alquila 3 películas y paga solo 2.</p>
            </div>

            <div class="log-entry">
                <div class="log-header">
                    <h4 class="log-title">[2026-06-18] Aviso importante</h4>
                    <span class="category-badge cat-noticia">Noticia</span>
                </div>
                <p>Recuerda rebobinar las cintas antes de devolverlas.</p>
            </div>

            <div class="log-entry">
                <div class="log-header">
                    <h4 class="log-title">[2026-06-15] Mantenimiento</h4>
                    <span class="category-badge cat-tecnico">Técnico</span>
                </div>
                <p>Optimizando lectores de cinta para mejor calidad.</p>
            </div>

        </div>

    </div>

</section>

<section class="about-section">
    <div class="retro-window">
        <h3>¿Por qué elegirnos?</h3>
        <p>
            Porque el cine no es solo ver, es coleccionar momentos.
            En Rewind & Relive cuidamos cada detalle para mantener viva la era del VHS.
        </p>
    </div>
</section>

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
