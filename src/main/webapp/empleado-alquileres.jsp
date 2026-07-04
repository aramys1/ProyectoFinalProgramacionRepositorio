<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Gestion de Alquileres | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window employee-nav">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolucion</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-usuarios.jsp">Usuarios</a></li>
        <li><a href="https://www.google.com" class="nav-search" aria-label="Buscar en Google" title="Buscar en Google"><span class="search-icon"></span></a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Alquileres demo</p>
        <h1>Alquileres activos</h1>
        <p>Consulta visual de alquileres. Los filtros quedan como maqueta hasta conectar el modulo.</p>
    </section>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>Alquileres_Demo.view</span><span>_ [] X</span></div>
        <form class="employee-toolbar" action="#" method="get">
            <input type="text" class="retro-search" placeholder="ID, cliente o pelicula">
            <select class="retro-search select-filter">
                <option>Todos los estados</option>
                <option>Activo</option>
                <option>Retrasado</option>
            </select>
            <input type="date" class="retro-search">
            <button type="button" class="retro-button">FILTRAR</button>
            <a href="empleado-alquileres.jsp" class="employee-clear">Limpiar</a>
        </form>

        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Pelicula</th>
                    <th>VHS</th>
                    <th>Alquiler</th>
                    <th>Vence</th>
                    <th>Estado</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>#1024</td>
                    <td>Cliente VHS</td>
                    <td>Terminator 2</td>
                    <td>#88</td>
                    <td>2026-06-25</td>
                    <td>2026-06-29</td>
                    <td><span class="status-badge status-ok">Activo</span></td>
                    <td><a class="employee-mini-button" href="empleado-devolucion.jsp">Devolver</a></td>
                </tr>
                <tr>
                    <td>#1025</td>
                    <td>Maria Retro</td>
                    <td>Viernes 13</td>
                    <td>#41</td>
                    <td>2026-06-21</td>
                    <td>2026-06-26</td>
                    <td><span class="status-badge status-danger">Retrasado</span></td>
                    <td><a class="employee-mini-button" href="empleado-devolucion.jsp">Devolver</a></td>
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
