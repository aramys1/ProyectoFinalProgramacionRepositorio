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
    <title>Rewind & Relive | Novedades</title>
</head>

<body>

<nav class="navbar retro-window">
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li><a href="https://www.google.com" class="nav-search" aria-label="Buscar en Google" title="Buscar en Google"><span class="search-icon"></span></a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp" class="retro-button">Iniciar Sesión</a></li>
    </ul>
</nav>

<div class="content-section" style="padding: 40px 20px;">
    <section class="releases">
        <h1 class="glitch-title">Nuestras novedades</h1>

        <div class="retro-window news-window">
            <div class="window-header">
                <span>Novedades_del_Sistema.log</span>
                <span>_ [] X</span>
            </div>

            <div class="log-content">
                <%
                    List<String[]> noticias = new ArrayList<>();
                    noticias.add(new String[]{"LANZAMIENTO WEB V1.0", "noticia", "2026-06-10", "Rewind & Relive entra oficialmente en funcionamiento. Gracias por ser parte del lanzamiento."});
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
    </section>
</div>

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
