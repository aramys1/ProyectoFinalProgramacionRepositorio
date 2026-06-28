<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Rewind & Relive | Inicio</title>
</head>
<body>

<%-- Nav, Header y otras secciones estáticas se mantienen igual --%>
<nav class="navbar retro-window">
    <div class="logo"><a href="index.jsp" class="logo-link">Rewind & Relive</a></div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li><button class="retro-button btn-register">Iniciar Sesión</button></li>
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
            <div class="window-header"><span>VHS_001.vhs</span><span>_ □ X</span></div>
            <div class="placeholder-img"></div>
        </div>
        <button class="retro-button btn-rent">ALQUILAR</button>
    </div>
</header>

<div class="content-section">
    <section class="releases">
        <h2>Últimos Lanzamientos</h2>
        <div class="release-grid">
            <% 
                // AQUÍ: Reemplazarás esto por tu llamada a base de datos: 
                // List<Pelicula> peliculas = PeliculaDAO.obtenerRecientes();
                List<String> peliculas = new ArrayList<>(); 
                peliculas.add("The Terminator"); 
                
                for(String peli : peliculas) { 
            %>
            <div class="retro-window release-card">
                <div class="window-header"><span>Película.exe</span></div>
                <div class="card-content">
                    <img src="ruta_imagen.jpg" alt="Portada" class="movie-img">
                    <h3><%= peli %></h3>
                    <p>1984 | Acción</p>
                    <button class="retro-button">VER MAS</button>
                </div>
            </div>
            <% } %>
        </div>
        <a href="catalogo.jsp" class="catalog-link">VER CATÁLOGO COMPLETO ></a>
    </section>
</div>

<section class="news-section">
    <h2 class="news-title">Tablón de Anuncios</h2>
    <div class="retro-window">
        <div class="window-header"><span>Noticias_Rewind.txt</span><span>_ □ X</span></div>
        <div class="news-content">
            <% 
                // AQUÍ: Reemplazarás esto por: List<Noticia> noticias = NoticiaDAO.listar();
                // Ejemplo de estructura de datos para el bucle:
                List<String> noticias = new ArrayList<>();
                noticias.add("[2026-06-27] Nueva llegada: Clásicos de terror disponibles.");
                
                for(String noticia : noticias) { 
            %>
            <div class="log-entry">
                <div class="log-header">
                    <h4 class="log-title"><%= noticia %></h4>
                    <span class="category-badge cat-inventario">Inventario</span>
                </div>
            </div>
            <% } %>
        </div>
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
