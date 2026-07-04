<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>
<%!
    private int contar(Connection con, String sql) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
%>
<%
    int totalActivos = 0;
    int devolucionesHoy = 0;
    int totalRetrasos = 0;
    String errorDashboard = null;
    String fechaHoy = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

    try (Connection con = ConexionDB.obtenerConexion()) {
        totalActivos = contar(con,
                "SELECT COUNT(*) FROM Alquiler " +
                "WHERE fecha_devolucion IS NULL AND UPPER(estado_alquiler) <> 'DEVUELTO'");
        devolucionesHoy = contar(con,
                "SELECT COUNT(*) FROM Alquiler " +
                "WHERE TRUNC(fecha_limite) = TRUNC(SYSDATE) AND fecha_devolucion IS NULL");
        totalRetrasos = contar(con,
                "SELECT COUNT(*) FROM Alquiler " +
                "WHERE fecha_devolucion IS NULL AND fecha_limite < TRUNC(SYSDATE)");
    } catch (SQLException e) {
        errorDashboard = e.getMessage();
    }
%>
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
        <li><a href="empleado-devolucion.jsp">Devolución</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-usuarios.jsp">Usuarios</a></li>
        <li><a href="https://www.google.com" class="nav-search" aria-label="Buscar en Google" title="Buscar en Google"><span class="search-icon"></span></a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Consola de empleado</p>
        <h1>Panel principal</h1>
        <p>Resumen operativo para alquileres activos, devoluciones del día y alertas de retraso.</p>
    </section>

    <% if (errorDashboard != null) { %>
    <div class="employee-alert employee-alert-error">
        No se pudo consultar la base de datos: <%= errorDashboard %>
    </div>
    <% } %>

    <section class="employee-metrics">
        <article class="retro-window employee-metric-card">
            <div class="window-header"><span>Alquileres_Activos.cnt</span><span>_ □ X</span></div>
            <div class="employee-metric-body">
                <strong><%= totalActivos %></strong>
                <span>Cintas actualmente en circulación</span>
                <a href="empleado-alquileres.jsp?estado=Activo" class="employee-link">Ver alquileres</a>
            </div>
        </article>

        <article class="retro-window employee-metric-card">
            <div class="window-header"><span>Devoluciones_Hoy.cnt</span><span>_ □ X</span></div>
            <div class="employee-metric-body">
                <strong><%= devolucionesHoy %></strong>
                <span>Alquileres que vencen hoy</span>
                <a href="empleado-alquileres.jsp?fecha=<%= fechaHoy %>" class="employee-link">Filtrar hoy</a>
            </div>
        </article>

        <article class="retro-window employee-metric-card metric-danger">
            <div class="window-header"><span>Alertas_Retraso.err</span><span>_ □ X</span></div>
            <div class="employee-metric-body">
                <strong><%= totalRetrasos %></strong>
                <span>Casos vencidos pendientes</span>
                <a href="empleado-alquileres.jsp?estado=Retrasado" class="employee-link">Revisar retrasos</a>
            </div>
        </article>
    </section>

    <section class="employee-actions">
        <a class="retro-button employee-action" href="empleado-devolucion.jsp">Registrar devolución</a>
        <a class="retro-button employee-action" href="empleado-inventario.jsp">Ajustar inventario</a>
        <a class="retro-button employee-action" href="empleado-alquileres.jsp">Consultar alquileres</a>
        <a class="retro-button employee-action" href="empleado-usuarios.jsp">Ver usuarios</a>
    </section>
</main>

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
