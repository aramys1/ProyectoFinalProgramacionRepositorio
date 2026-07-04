<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Historial | Rewind & Relive</title>
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
        <p class="employee-kicker">Historial de alquileres</p>
        <h1>Mi historial</h1>
        <p>Datos de ejemplo para presentar como se vera el historial cuando se conecte el modulo.</p>
    </section>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>historial_cliente.table</span><span>_ [] X</span></div>
        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Pelicula</th>
                    <th>Alquiler</th>
                    <th>Vence</th>
                    <th>Devolucion</th>
                    <th>Estado</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>#1001</td>
                    <td>Volver al Futuro</td>
                    <td>2026-06-20</td>
                    <td>2026-06-24</td>
                    <td>2026-06-23</td>
                    <td><span class="status-badge status-ok">Devuelto</span></td>
                </tr>
                <tr>
                    <td>#1002</td>
                    <td>Viernes 13</td>
                    <td>2026-06-25</td>
                    <td>2026-06-29</td>
                    <td>Pendiente</td>
                    <td><span class="status-badge status-danger">Activo</span></td>
                </tr>
                </tbody>
            </table>
        </div>
    </section>
</main>

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
