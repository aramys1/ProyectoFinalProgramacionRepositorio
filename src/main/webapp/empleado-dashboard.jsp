<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Panel Empleado | Rewind & Relive</title>
</head>
<body>
    <nav class="navbar retro-window">
        <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
        <ul class="nav-links">
            <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
            <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
            <li><a href="empleado-inventario.jsp">Inventario</a></li>
        </ul>
    </nav>

    <div class="content-section">
        <h2>Panel de Control</h2>
        <div class="release-grid">
            <div class="retro-window">
                <div class="window-header"><span>Alquileres_Activos.cnt</span></div>
                <div class="card-content">
                    <h1>${totalActivos}</h1> <p>Cintas en circulación</p>
                </div>
            </div>
            <div class="retro-window">
                <div class="window-header"><span>Devoluciones_Hoy.cnt</span></div>
                <div class="card-content">
                    <h1>${totalDevoluciones}</h1>
                    <p>Devoluciones esperadas</p>
                </div>
            </div>
            <div class="retro-window">
                <div class="window-header"><span>Alertas_Retraso.err</span></div>
                <div class="card-content" style="color: #d32f2f;">
                    <h1>${totalRetrasos}</h1>
                    <p>¡Atención requerida!</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>