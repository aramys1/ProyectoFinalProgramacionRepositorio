<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Rewind & Relive | Novedades</title>
</head>

<body>

<nav class="navbar retro-window">
    <div class="logo">
        <a href="index.jsp" class="logo-link">Rewind & Relive</a>
    </div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp" class="active">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li>
            <a href="login.jsp">
                <button class="retro-button btn-register">Iniciar Sesión</button>
            </a>
        </li>
    </ul>
</nav>

<div class="content-section" style="padding: 40px 20px;">
    <section class="releases">
        <h2>Nuestras novedades</h2>

    <div class="retro-window news-window">
        <div class="window-header">
            <span>Novedades_del_Sistema.log</span>
            <span>_ □ X</span>
        </div>

        <div class="log-content">
            <%
                /* Simulación de datos:
                   Más adelante, esto se sustituirá por:
                   List<Noticia> lista = NoticiaDAO.listarTodas();
                */
                List<String[]> noticias = new ArrayList<>();
                noticias.add(new String[]{"LANZAMIENTO WEB V1.0", "noticia", "2026-06-10", "Rewind & Relive entra oficialmente en funcionamiento. ¡Gracias por ser parte del lanzamiento!"});
                noticias.add(new String[]{"MANTENIMIENTO: ORACLE SQL", "tecnico", "2026-06-22", "Optimización de procedimientos PL/SQL completada. Mejora del 15% en velocidad de carga."});
                noticias.add(new String[]{"NUEVO INVENTARIO: 80s", "inventario", "2026-06-27", "Hemos integrado 20 nuevas cintas a nuestra base de datos."});

                for(String[] n : noticias) {
            %>
                <div class="log-entry">
                    <div class="log-header">
                        <h3 class="log-title">> <%= n[0] %></h3>
                        <span class="category-badge cat-<%= n[1] %>"><%= n[1].substring(0,1).toUpperCase() + n[1].substring(1) %></span>
                    </div>
                    <span class="log-date">[<%= n[2] %>]</span>
                    <p><%= n[3] %></p>
                </div>
            <% } %>
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
