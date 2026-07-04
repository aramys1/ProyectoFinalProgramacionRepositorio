<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String id = request.getParameter("id");
    String titulo = "Terminator 2";
    String poster = "recursos/posters/terminator2.jpg";
    String genero = "Accion / Ciencia Ficcion";
    String anio = "1991";
    String precio = "2.99";
    String sinopsis = "Un protector cyborg viaja al pasado para defender a John Connor de una nueva amenaza liquida enviada para cambiar el futuro.";
    String descripcion = "La pelicula combina persecuciones, efectos practicos y una historia de familia encontrada. Esta vista queda preparada para recibir la informacion real de Peliculas, Vhs y estados cuando se conecte el modulo.";

    if ("2".equals(id)) {
        titulo = "Viernes 13 Parte VI";
        poster = "recursos/posters/viernes13_6ta_poster.jpeg";
        genero = "Terror";
        anio = "1986";
        precio = "1.99";
        sinopsis = "Jason vuelve a Crystal Lake en una entrega con terror clasico, humor oscuro y ambiente de videoclub.";
        descripcion = "Una plantilla de sinopsis pensada para mostrar reparto, clasificacion, disponibilidad y estados de copias sin depender todavia de una consulta adicional.";
    } else if ("3".equals(id)) {
        titulo = "Tiburon 4";
        poster = "recursos/posters/tiburon4.jpeg";
        genero = "Suspenso / Aventura";
        anio = "1987";
        precio = "1.49";
        sinopsis = "La familia Brody vuelve a enfrentarse al terror marino en una historia de persecucion y supervivencia.";
        descripcion = "La ficha sirve como puente entre el catalogo y el flujo de alquiler. Luego podra llenarse desde la base de datos con el id de pelicula.";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title><%= titulo %> | Rewind & Relive</title>
</head>
<body>

<nav class="navbar retro-window">
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catalogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contactanos</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp" class="retro-button">Iniciar Sesion</a></li>
    </ul>
</nav>

<main class="movie-detail-page">
    <section class="movie-detail-hero">
        <article class="retro-window movie-poster-window">
            <div class="window-header"><span><%= titulo %>.vhs</span><span>_ [] X</span></div>
            <img src="<%= poster %>" alt="Poster de <%= titulo %>" class="movie-detail-poster">
        </article>

        <article class="movie-detail-copy">
            <p class="employee-kicker">Ficha de pelicula</p>
            <h1><%= titulo %></h1>
            <p class="movie-detail-meta"><%= anio %> | <%= genero %> | $<%= precio %> / dia</p>
            <p class="movie-synopsis"><%= sinopsis %></p>
            <p><%= descripcion %></p>
            <div class="employee-form-actions">
                <a class="retro-button btn-rent" href="cliente-carrito.jsp">ALQUILAR PELICULA</a>
                <a class="retro-button employee-cancel" href="catalogo.jsp">VOLVER AL CATALOGO</a>
            </div>
        </article>
    </section>

    <section class="retro-window employee-panel synopsis-employee-panel">
        <div class="window-header"><span>Panel_Empleado_Inventario.view</span><span>_ [] X</span></div>
        <div class="synopsis-employee-grid">
            <div>
                <h2>Vista editable del empleado</h2>
                <form class="employee-form employee-movie-form" action="#" method="post">
                    <label>Titulo
                        <input class="retro-search" type="text" value="<%= titulo %>">
                    </label>
                    <label>Descripcion interna
                        <textarea class="retro-search employee-textarea"><%= descripcion %></textarea>
                    </label>
                    <button type="button" class="retro-button">GUARDAR BORRADOR</button>
                </form>
            </div>

            <div>
                <h2>Copias y estados</h2>
                <div class="copy-status-list">
                    <div class="copy-status-row" data-copy-status>
                        <span>VHS #088</span>
                        <span class="status-badge status-ok">DISPONIBLE</span>
                        <select class="retro-search">
                            <option>DISPONIBLE</option>
                            <option>EN USO</option>
                            <option>DANADA</option>
                        </select>
                    </div>
                    <div class="copy-status-row" data-copy-status>
                        <span>VHS #089</span>
                        <span class="status-badge status-warning">EN USO</span>
                        <select class="retro-search">
                            <option>EN USO</option>
                            <option>DISPONIBLE</option>
                            <option>DANADA</option>
                        </select>
                    </div>
                    <div class="copy-status-row" data-copy-status>
                        <span>VHS #090</span>
                        <span class="status-badge status-danger">DANADA</span>
                        <select class="retro-search">
                            <option>DANADA</option>
                            <option>DISPONIBLE</option>
                            <option>EN USO</option>
                        </select>
                    </div>
                </div>

                <div class="inventory-summary compact-summary">
                    <article><span>6</span><strong>Disponibles</strong></article>
                    <article><span>3</span><strong>En uso</strong></article>
                    <article><span>1</span><strong>Danadas</strong></article>
                </div>
            </div>
        </div>
    </section>
</main>

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
