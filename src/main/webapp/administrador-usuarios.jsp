<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/admin-usuario.css">
    <title>Rewind & Relive | Admin</title>
</head>
<body>

<nav class="navbar retro-window">
    <div class="logo">
        <a href="index.jsp" class="logo-link">ADMIN PANEL</a>
    </div>
    <ul class="nav-links">
        <li><a href="admin-dashboard.jsp">Dashboard</a></li>
        <li><a href="admin-usuarios.jsp">Usuarios</a></li>
        <li><a href="admin-reportes.jsp">Reportes</a></li>
    </ul>
</nav>

<div class="admin-page">

    <span class="page-tag">GESTION DE EMPLEADOS</span>
    <h1 class="page-title">Roles de Empleado</h1>
    <p class="page-subtitle">Busca un usuario y otorga o revoca el rol de empleado.</p>

    <div class="retro-window admin-window">
        <div class="window-header">
            <span>Empleados_DB.view</span>
            <span>_ □ X</span>
        </div>

        <div class="search-bar">
            <input type="text" id="buscarInput" placeholder="Buscar usuario por nombre o cedula...">
            <button class="btn-filter" onclick="buscarUsuario()">BUSCAR</button>
            <button class="btn-clear" onclick="limpiarBusqueda()">Limpiar</button>
        </div>

        <table class="users-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Cedula</th>
                <th>Nombre</th>
                <th>Rol Actual</th>
                <th>Accion</th>
            </tr>
            </thead>
            <tbody id="tbodyUsuarios">

            <!-- Empleados visibles por defecto -->
            <tr data-rol="EMPLEADO" data-nombre="aramys cedeno" data-cedula="8-1039-59">
                <td>2</td>
                <td>8-1039-59</td>
                <td>Aramys Cedeno</td>
                <td><span class="role-badge role-EMPLEADO">EMPLEADO</span></td>
                <td><button class="btn-revocar" onclick="cambiarRol(this, 'CLIENTE')">REVOCAR</button></td>
            </tr>

            <tr data-rol="EMPLEADO" data-nombre="fabian rodriguez" data-cedula="2-756-805">
                <td>4</td>
                <td>2-756-805</td>
                <td>Fabian Rodriguez</td>
                <td><span class="role-badge role-EMPLEADO">EMPLEADO</span></td>
                <td><button class="btn-revocar" onclick="cambiarRol(this, 'CLIENTE')">REVOCAR</button></td>
            </tr>

            <!-- Clientes ocultos por defecto, visibles solo al buscar -->
            <tr data-rol="CLIENTE" data-nombre="alisson aguirre" data-cedula="8-1032-1714" class="fila-oculta">
                <td>1</td>
                <td>8-1032-1714</td>
                <td>Alisson Aguirre</td>
                <td><span class="role-badge role-CLIENTE">CLIENTE</span></td>
                <td><button class="btn-otorgar" onclick="cambiarRol(this, 'EMPLEADO')">OTORGAR</button></td>
            </tr>

            <tr data-rol="CLIENTE" data-nombre="leandro barrios" data-cedula="20-16-8080" class="fila-oculta">
                <td>5</td>
                <td>20-16-8080</td>
                <td>Leandro Barrios</td>
                <td><span class="role-badge role-CLIENTE">CLIENTE</span></td>
                <td><button class="btn-otorgar" onclick="cambiarRol(this, 'EMPLEADO')">OTORGAR</button></td>
            </tr>

            </tbody>
        </table>

    </div>
</div>

<div class="toast" id="toast"></div>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-col">
            <h4>Rewind & Relive</h4>
            <p>Panel de Administracion.</p>
        </div>
        <div class="footer-col">
            <h4>Navegacion</h4>
            <ul>
                <li><a href="admin-dashboard.jsp" style="color:#fce4d6;">Dashboard</a></li>
                <li><a href="admin-usuarios.jsp" style="color:#fce4d6;">Usuarios</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Contacto</h4>
            <p>Av. VHS, #1980</p>
        </div>
    </div>
    <div class="copyright">© 2026 Rewind & Relive.</div>
</footer>

<script src="js/admin.js"></script>
</body>
</html>