<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Prueba | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window">
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="index.jsp">Inicio</a></li>
        <li><a href="catalogo.jsp">Catalogo</a></li>
    </ul>
</nav>

<main class="account-page">
    <section class="employee-header">
        <p class="employee-kicker">Pagina de prueba</p>
        <h1>Formulario demo</h1>
        <p>Esta pagina queda solo como vista de presentacion. No registra usuarios ni usa base de datos.</p>
    </section>

    <section class="retro-window employee-panel employee-form-panel">
        <div class="window-header"><span>registro_demo.form</span><span>_ [] X</span></div>
        <form class="employee-form employee-movie-form" action="#" method="get">
            <div class="employee-form-grid">
                <label>
                    Cedula
                    <input type="text" class="retro-search" placeholder="000-0000000-0">
                </label>
                <label>
                    Rol
                    <select class="retro-search">
                        <option>Cliente</option>
                        <option>Empleado</option>
                        <option>Admin</option>
                    </select>
                </label>
                <label>
                    Primer nombre
                    <input type="text" class="retro-search" placeholder="Nombre">
                </label>
                <label>
                    Primer apellido
                    <input type="text" class="retro-search" placeholder="Apellido">
                </label>
            </div>
            <div class="employee-form-actions">
                <button type="button" class="retro-button">REGISTRAR DEMO</button>
                <a href="index.jsp" class="retro-button employee-cancel">VOLVER</a>
            </div>
        </form>
    </section>
</main>

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
