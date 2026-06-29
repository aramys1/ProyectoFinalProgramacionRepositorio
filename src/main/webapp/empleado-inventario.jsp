<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Gestion Inventario | Rewind & Relive</title>
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
        <p class="employee-kicker">Inventario demo</p>
        <h1>Inventario de VHS</h1>
        <p>Tabla de muestra para visualizar stock, unidades alquiladas y disponibilidad.</p>
    </section>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>Inventario_Stock.table</span><span>_ [] X</span></div>
        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Titulo</th>
                    <th>Stock total</th>
                    <th>Alquiladas</th>
                    <th>Disponibles</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>#1</td>
                    <td>Terminator 2</td>
                    <td>8</td>
                    <td>3</td>
                    <td><span class="status-badge status-ok">5</span></td>
                    <td>
                        <div class="employee-row-actions">
                            <button type="button" class="employee-icon-button" title="Sumar unidad">+</button>
                            <button type="button" class="employee-icon-button" title="Restar unidad">-</button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>#2</td>
                    <td>Viernes 13</td>
                    <td>4</td>
                    <td>4</td>
                    <td><span class="status-badge status-danger">0</span></td>
                    <td>
                        <div class="employee-row-actions">
                            <button type="button" class="employee-icon-button" title="Sumar unidad">+</button>
                            <button type="button" class="employee-icon-button" title="Restar unidad" disabled>-</button>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </section>
</main>
<script src="js/empleado-responsive.js"></script>
</body>
</html>
