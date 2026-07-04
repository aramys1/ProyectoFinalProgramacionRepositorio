<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Carrito VHS | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window">
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="index.jsp">Inicio</a></li>
        <li><a href="catalogo.jsp">Catalogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contactanos</a></li>
        <li><a href="https://www.google.com" class="nav-search" aria-label="Buscar en Google" title="Buscar en Google"><span class="search-icon"></span></a></li>
    </ul>
</nav>

<main class="account-page">
    <section class="employee-header">
        <p class="employee-kicker">Orden de alquiler</p>
        <h1>Mi carrito</h1>
        <p>Ejemplo visual del carrito. Luego se conectara con el catalogo y la base de datos.</p>
    </section>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>carrito_actual.table</span><span>_ [] X</span></div>
        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Pelicula</th>
                    <th>Precio dia</th>
                    <th>Estado</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>1</td>
                    <td>Terminator 2</td>
                    <td>$2.99</td>
                    <td><span class="status-badge status-ok">Pendiente</span></td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>Tiburon 4</td>
                    <td>$1.99</td>
                    <td><span class="status-badge status-ok">Pendiente</span></td>
                </tr>
                <tr>
                    <td>3</td>
                    <td colspan="3" class="employee-empty">Espacio disponible</td>
                </tr>
                </tbody>
            </table>
        </div>
    </section>

    <section class="employee-actions">
        <a class="retro-button employee-action" href="catalogo.jsp">Agregar peliculas</a>
        <button class="retro-button employee-action" type="button" disabled>Confirmar orden</button>
        <span class="account-limit">Espacios disponibles: 1 / 3</span>
    </section>
</main>

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
