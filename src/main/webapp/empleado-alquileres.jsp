<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>
<%-- Une Usuario, Alquiler, Vhs y Peliculas; fecha_devolucion separa operaciones activas del historial. --%>
<%!
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    String buscar = request.getParameter("buscar");
    String estado = request.getParameter("estado");
    String fecha = request.getParameter("fecha");
    boolean verHistorial = "historial".equalsIgnoreCase(request.getParameter("vista"));
    String filtroBuscar = buscar == null || buscar.isBlank() ? null : buscar.trim().toLowerCase();
    String filtroEstado = estado == null || estado.isBlank() ? null : estado.trim().toUpperCase();
    java.sql.Date filtroFecha = null;
    try { if (fecha != null && !fecha.isBlank()) filtroFecha = java.sql.Date.valueOf(fecha); }
    catch (IllegalArgumentException ignored) { }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Gestion de Alquileres | Rewind &amp; Relive</title>
</head>
<body>
<nav class="navbar retro-window employee-nav">
    <% request.setAttribute("adminPanelLogo", Boolean.TRUE); %><%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolucion</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-usuarios.jsp">Usuarios</a></li>
        <li><a href="empleado-alquilar.jsp">Nuevo Alquiler</a></li>
    </ul>
</nav>
<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Alquileres.database</p>
        <h1>Alquileres registrados</h1>
        <p><%= verHistorial ? "Registro de alquileres que ya fueron devueltos." : "Consulta de los alquileres pendientes de devolucion." %></p>
        <br>
        <br>
        <a class="retro-button" href="empleado-alquileres.jsp?vista=<%= verHistorial ? "activos" : "historial" %>">
            <%= verHistorial ? "VER ALQUILERES ACTIVOS" : "VER HISTORIAL DE DEVOLUCIONES" %>
        </a>
        <a class="retro-button" style="margin-left: 10px" href="empleado-historial-clientes.jsp">HISTORIAL POR CLIENTE</a>
        <a class="retro-button" href="empleado-historial-peliculas.jsp">HISTORIAL POR PELICULA</a>
    </section>
    <section class="retro-window employee-panel">
        <div class="window-header"><span>Alquileres.table</span><span>_ [] X</span></div>
        <form class="employee-toolbar" method="get">
            <input type="hidden" name="vista" value="<%= verHistorial ? "historial" : "activos" %>">
            <input type="text" name="buscar" class="retro-search" placeholder="ID, cliente o pelicula" value="<%= h(buscar) %>">
            <select name="estado" class="retro-search select-filter">
                <option value="">Todos los estados</option>
                <option value="PENDIENTE" <%= "PENDIENTE".equals(filtroEstado) ? "selected" : "" %>>Pendiente</option>
                <option value="ACTIVO" <%= "ACTIVO".equals(filtroEstado) ? "selected" : "" %>>Activo</option>
                <option value="DEVUELTO" <%= "DEVUELTO".equals(filtroEstado) ? "selected" : "" %>>Devuelto</option>
                <option value="RETRASADO" <%= "RETRASADO".equals(filtroEstado) ? "selected" : "" %>>Retrasado</option>
            </select>
            <input type="date" name="fecha" class="retro-search" value="<%= h(fecha) %>">
            <button type="submit" class="retro-button">FILTRAR</button>
            <a href="empleado-alquileres.jsp?vista=<%= verHistorial ? "historial" : "activos" %>" class="employee-clear">Limpiar</a>
        </form>
        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead><tr>
                    <th>ID</th><th>Cliente</th><th>Pelicula</th><th>VHS</th><th>Alquiler</th>
                    <th>Vence</th><th>Devolucion</th><th>Empleado</th><th>Estado</th><th>Accion</th>
                </tr></thead>
                <tbody>
                <%
                    String sql = "SELECT a.id_alquiler, a.estado_alquiler, " +
                            "TO_CHAR(a.fecha_alquiler, 'YYYY-MM-DD') fecha_alquiler_txt, " +
                            "TO_CHAR(a.fecha_limite, 'YYYY-MM-DD') fecha_limite_txt, " +
                            "TO_CHAR(a.fecha_devolucion, 'YYYY-MM-DD') fecha_devolucion_txt, " +
                            "a.id_vhs, a.id_usuario_empleado, " +
                            "c.primer_nombre_usuario || ' ' || c.primer_apellido_usuario cliente, p.titulo " +
                            "FROM Alquiler a JOIN Usuario c ON c.id_usuario=a.id_usuario_cliente " +
                            "JOIN Vhs v ON v.id_vhs=a.id_vhs JOIN Peliculas p ON p.id_pelicula=v.id_pelicula " +
                            "WHERE (? IS NULL OR TO_CHAR(a.id_alquiler)=? OR LOWER(c.primer_nombre_usuario || ' ' || c.primer_apellido_usuario) LIKE ? OR LOWER(p.titulo) LIKE ?) " +
                            "AND (? IS NULL OR UPPER(a.estado_alquiler)=?) AND (? IS NULL OR TRUNC(a.fecha_alquiler)=?) " +
                            "AND ((?='HISTORIAL' AND a.fecha_devolucion IS NOT NULL) OR (?='ACTIVOS' AND a.fecha_devolucion IS NULL)) " +
                            "ORDER BY a.fecha_alquiler DESC, a.id_alquiler DESC";
                    try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
                        String contiene = filtroBuscar == null ? null : "%" + filtroBuscar + "%";
                        ps.setString(1, filtroBuscar); ps.setString(2, filtroBuscar);
                        ps.setString(3, contiene); ps.setString(4, contiene);
                        ps.setString(5, filtroEstado); ps.setString(6, filtroEstado);
                        ps.setDate(7, filtroFecha); ps.setDate(8, filtroFecha);
                        ps.setString(9, verHistorial ? "HISTORIAL" : "ACTIVOS");
                        ps.setString(10, verHistorial ? "HISTORIAL" : "ACTIVOS");
                        try (ResultSet rs = ps.executeQuery()) {
                            boolean hayAlquileres = false;
                            while (rs.next()) {
                                hayAlquileres = true;
                                String estadoActual = rs.getString("estado_alquiler");
                                String normalizado = estadoActual == null ? "" : estadoActual.toUpperCase();
                                String clase = (normalizado.contains("TARDE") || normalizado.contains("DANADO") || normalizado.contains("VENCIDO")) ? "status-danger" :
                                        (("DEVUELTO".equals(normalizado) || "COMPLETADO".equals(normalizado)) ? "status-ok" : "status-warning");
                                String devolucion = rs.getString("fecha_devolucion_txt");
                %>
                <tr>
                    <td>#<%= rs.getInt("id_alquiler") %></td>
                    <td><%= h(rs.getString("cliente")) %></td>
                    <td><%= h(rs.getString("titulo")) %></td>
                    <td>#<%= rs.getInt("id_vhs") %></td>
                    <td><%= h(rs.getString("fecha_alquiler_txt")) %></td>
                    <td><%= h(rs.getString("fecha_limite_txt")) %></td>
                    <td><%= devolucion == null ? "Pendiente" : h(devolucion) %></td>
                    <td>#<%= rs.getInt("id_usuario_empleado") %></td>
                    <td><span class="status-badge <%= clase %>"><%= h(estadoActual) %></span></td>
                    <td><% if (devolucion == null) { %>
                        <a class="employee-mini-button" href="empleado-devolucion.jsp">Devolver</a>
                        <% } else { %><span>Completado</span><% } %></td>
                </tr>
                <%          }
                            if (!hayAlquileres) { %>
                <tr><td colspan="10">No se encontraron alquileres con los filtros seleccionados.</td></tr>
                <%          }
                        }
                    } catch (SQLException e) { %>
                <tr><td colspan="10">No fue posible cargar los alquileres: <%= h(e.getMessage()) %></td></tr>
                <%  } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
<%@ include file="footer.jsp" %>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
