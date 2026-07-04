<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Registrar Devolucion | Rewind & Relive</title>
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
        <p class="employee-kicker">Registro_Devolucion.exe</p>
        <h1>Registrar devolucion</h1>
        <p>Formulario visual para preparar el flujo de devoluciones. No actualiza inventario ni multas todavia.</p>
    </section>

    <section class="employee-split">
        <article class="retro-window employee-panel">
            <div class="window-header"><span>Buscar_Alquiler.form</span><span>_ [] X</span></div>
            <form class="employee-form" action="#" method="get">
                <label for="buscarId">ID del alquiler</label>
                <div class="employee-inline-form">
                    <input id="buscarId" type="number" class="retro-search" value="1024" min="1" placeholder="Ej. 1024">
                    <button type="button" class="retro-button">BUSCAR</button>
                </div>
            </form>
        </article>

        <article class="retro-window employee-panel">
            <div class="window-header"><span>Procesar_Devolucion.form</span><span>_ [] X</span></div>
            <form class="employee-form" action="#" method="post">
                <div class="employee-summary">
                    <p><strong>Cliente:</strong> Cliente VHS</p>
                    <p><strong>Pelicula:</strong> Terminator 2</p>
                    <p><strong>VHS:</strong> #88 - Buen estado</p>
                    <p><strong>Fecha limite:</strong> 2026-06-29</p>
                    <p><strong>Retraso detectado:</strong> No</p>
                </div>

                <label class="employee-check"><input type="checkbox" name="retraso"> Registrar retraso ($2.00)</label>
                <label class="employee-check"><input type="checkbox" name="cintaDanada"> Cinta danada ($5.00)</label>

                <button type="button" class="retro-button employee-submit">PROCESAR DEVOLUCION</button>
            </form>
        </article>
    </section>
</main>
<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
