<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Mi Perfil | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window">
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="index.jsp">Inicio</a></li>
        <li><a href="catalogo.jsp">Catalogo</a></li>
        <li><a href="cliente-carrito.jsp">Mi carrito</a></li>
        <li><a href="cliente-historial.jsp">Mi historial</a></li>
    </ul>
</nav>

<main class="account-page">
    <section class="employee-header">
        <p class="employee-kicker">Cuenta de cliente</p>
        <h1>Mi perfil</h1>
        <p>Vista de presentacion para revisar ajustes, carrito e historial sin consultar la base de datos.</p>
    </section>

    <section class="account-grid">
        <article class="retro-window account-card">
            <div class="window-header"><span>perfil_usuario.ini</span><span>_ [] X</span></div>
            <div class="account-card-body">
                <h2>Cliente VHS</h2>
                <p><strong>Usuario:</strong> usuario_demo</p>
                <p><strong>Correo:</strong> cliente@rewind.demo</p>
                <p><strong>Rol:</strong> Cliente</p>
                <a href="registro.jsp" class="employee-link">Editar datos basicos</a>
            </div>
        </article>

        <article class="retro-window account-card">
            <div class="window-header"><span>acciones_rapidas.exe</span><span>_ [] X</span></div>
            <div class="account-card-body account-actions-list">
                <a class="retro-button" href="catalogo.jsp">Buscar peliculas</a>
                <a class="retro-button" href="cliente-carrito.jsp">Ver carrito</a>
                <a class="retro-button" href="cliente-historial.jsp">Ver historial</a>
            </div>
        </article>
    </section>
</main>
</body>
</html>
