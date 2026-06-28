<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Rewind & Relive | Catálogo</title>
</head>

<body>

<nav class="navbar retro-window">
    <div class="logo"><a href="index.jsp" class="logo-link">Rewind & Relive</a></div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp" class="active">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li><button class="retro-button">Iniciar Sesión</button></li>
    </ul>
</nav>

<div class="content-section" style="padding: 40px 20px;">
    <section class="releases">
        <h2>Nuestro Catálogo</h2>
    
    <div class="release-grid">
        
        <% 
            List<String[]> catalogo = new ArrayList<>();
            catalogo.add(new String[]{"The Terminator", "1984", "Acción"});
            catalogo.add(new String[]{"Back to the Future", "1985", "Ciencia Ficción"});
            catalogo.add(new String[]{"Blade Runner", "1982", "Ciencia Ficción"});
            catalogo.add(new String[]{"The Thing", "1982", "Terror"});
            catalogo.add(new String[]{"Aliens", "1986", "Acción"});
            catalogo.add(new String[]{"Ghostbusters", "1984", "Comedia"});

            for(String[] peli : catalogo) {
        %>
            <div class="retro-window release-card">
                <div class="window-header"><span><%= peli[0] %>.vhs</span></div>
                <div class="card-content">
                    <img src="ruta_imagen.jpg" alt="Portada de <%= peli[0] %>" class="movie-img">
                    <h3><%= peli[0] %></h3>
                    <p><%= peli[1] %> | <%= peli[2] %></p>
                    <button class="retro-button">VER MAS</button>
                </div>
            </div>
        <% } %>
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