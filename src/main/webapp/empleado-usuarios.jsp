<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Usuarios | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window employee-nav">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolucion</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-agregar-pelicula.jsp">Agregar pelicula</a></li>
        <li><a href="empleado-usuarios.jsp">Usuarios</a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Usuarios demo</p>
        <h1>Perfiles de usuarios</h1>
        <p>Vista de ejemplo para revisar clientes, roles y alquileres sin consultar informacion real.</p>
    </section>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>usuarios_alquileres.view</span><span>_ [] X</span></div>
        <form class="employee-toolbar employee-toolbar-compact" action="#" method="get">
            <input type="text" class="retro-search" placeholder="Buscar cliente, cedula o rol">
            <button type="button" class="retro-button">FILTRAR</button>
            <a href="empleado-usuarios.jsp" class="employee-clear">Limpiar</a>
        </form>

        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Usuario</th>
                    <th>Cedula</th>
                    <th>Rol</th>
                    <th>Alquileres activos</th>
                    <th>Historial total</th>
                    <th>Peliculas actuales</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>#10</td>
                    <td>Cliente VHS</td>
                    <td>000-0000000-0</td>
                    <td><span class="status-badge status-ok">Cliente</span></td>
                    <td>2</td>
                    <td>7</td>
                    <td>Terminator 2, Tiburon 4</td>
                </tr>
                <tr>
                    <td>#2</td>
                    <td>Empleado Demo</td>
                    <td>111-1111111-1</td>
                    <td><span class="status-badge status-ok">Empleado</span></td>
                    <td>0</td>
                    <td>0</td>
                    <td>Sin alquiler activo</td>
                </tr>
                </tbody>
            </table>
        </div>
    </section>
</main>
<script src="js/empleado-responsive.js"></script>
</body>
</html>
