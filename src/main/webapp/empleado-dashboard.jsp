<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Panel Empleado | Rewind & Relive</title>
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
        <p class="employee-kicker">Consola de empleado</p>
        <h1>Panel principal</h1>
        <p>Resumen visual de prueba para presentar el flujo del empleado sin conectarlo aun a la base de datos.</p>
    </section>

    <section class="employee-metrics">
        <article class="retro-window employee-metric-card">
            <div class="window-header"><span>Alquileres_Activos.cnt</span><span>_ [] X</span></div>
            <div class="employee-metric-body">
                <strong>12</strong>
                <span>Cintas actualmente en circulacion</span>
                <a href="empleado-alquileres.jsp" class="employee-link">Ver alquileres</a>
            </div>
        </article>

        <article class="retro-window employee-metric-card">
            <div class="window-header"><span>Devoluciones_Hoy.cnt</span><span>_ [] X</span></div>
            <div class="employee-metric-body">
                <strong>4</strong>
                <span>Alquileres que vencen hoy</span>
                <a href="empleado-devolucion.jsp" class="employee-link">Registrar devolucion</a>
            </div>
        </article>

        <article class="retro-window employee-metric-card metric-danger">
            <div class="window-header"><span>Alertas_Retraso.err</span><span>_ [] X</span></div>
            <div class="employee-metric-body">
                <strong>2</strong>
                <span>Casos vencidos pendientes</span>
                <a href="empleado-alquileres.jsp" class="employee-link">Revisar retrasos</a>
            </div>
        </article>
    </section>

    <section class="employee-actions">
        <a class="retro-button employee-action" href="empleado-devolucion.jsp">Registrar devolucion</a>
        <a class="retro-button employee-action" href="empleado-inventario.jsp">Ajustar inventario</a>
        <a class="retro-button employee-action" href="empleado-agregar-pelicula.jsp">Agregar pelicula</a>
        <a class="retro-button employee-action" href="empleado-alquileres.jsp">Consultar alquileres</a>
        <a class="retro-button employee-action" href="empleado-usuarios.jsp">Ver usuarios</a>
    </section>
</main>
<script src="js/empleado-responsive.js"></script>
</body>
</html>
