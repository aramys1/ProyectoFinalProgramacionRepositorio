<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.conexion.ConexionDB" %>
<%
    request.setCharacterEncoding("UTF-8");
    String busqueda = request.getParameter("busqueda") == null ? "" : request.getParameter("busqueda").trim();
    String estado = request.getParameter("estado") == null ? "" : request.getParameter("estado").trim();
    String fecha = request.getParameter("fecha") == null ? "" : request.getParameter("fecha").trim();
    String errorAlquileres = null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Gestión de Alquileres | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window employee-nav">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolución</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-agregar-pelicula.jsp">Agregar pelicula</a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Alquiler JOIN Usuario JOIN Peliculas</p>
        <h1>Alquileres activos</h1>
        <p>Consulta, filtra y envía rápidamente un alquiler al registro de devolución.</p>
    </section>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>Alquileres_DB.view</span><span>_ □ X</span></div>
        <form class="employee-toolbar" method="get" action="empleado-alquileres.jsp">
            <input type="text" name="busqueda" class="retro-search" value="<%= busqueda %>" placeholder="ID, cliente o película">
            <select name="estado" class="retro-search select-filter">
                <option value="" <%= estado.isEmpty() ? "selected" : "" %>>Todos los estados</option>
                <option value="Activo" <%= "Activo".equals(estado) ? "selected" : "" %>>Activo</option>
                <option value="Retrasado" <%= "Retrasado".equals(estado) ? "selected" : "" %>>Retrasado</option>
            </select>
            <input type="date" name="fecha" class="retro-search" value="<%= fecha %>">
            <button type="submit" class="retro-button">FILTRAR</button>
            <a href="empleado-alquileres.jsp" class="employee-clear">Limpiar</a>
        </form>

        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Película</th>
                    <th>VHS</th>
                    <th>Alquiler</th>
                    <th>Vence</th>
                    <th>Estado</th>
                    <th>Acción</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int filas = 0;
                    StringBuilder sql = new StringBuilder(
                            "SELECT a.id_alquiler, a.estado_alquiler, TO_CHAR(a.fecha_alquiler, 'YYYY-MM-DD') fecha_alquiler, " +
                            "TO_CHAR(a.fecha_limite, 'YYYY-MM-DD') fecha_limite, u.primer_nombre_usuario || ' ' || u.primer_apellido_usuario cliente, " +
                            "p.titulo, v.id_vhs, CASE WHEN a.fecha_limite < TRUNC(SYSDATE) THEN 'Retrasado' ELSE a.estado_alquiler END estado_visual " +
                            "FROM Alquiler a JOIN Usuario u ON u.id_usuario = a.id_usuario_cliente " +
                            "JOIN Vhs v ON v.id_vhs = a.id_vhs JOIN Peliculas p ON p.id_pelicula = v.id_pelicula " +
                            "WHERE a.fecha_devolucion IS NULL"
                    );
                    List<String> params = new ArrayList<>();

                    if (!busqueda.isEmpty()) {
                        sql.append(" AND (LOWER(p.titulo) LIKE ? OR LOWER(u.primer_nombre_usuario || ' ' || u.primer_apellido_usuario) LIKE ? OR TO_CHAR(a.id_alquiler) LIKE ? OR TO_CHAR(u.id_usuario) LIKE ?)");
                        String like = "%" + busqueda.toLowerCase() + "%";
                        params.add(like);
                        params.add(like);
                        params.add("%" + busqueda + "%");
                        params.add("%" + busqueda + "%");
                    }
                    if ("Activo".equals(estado)) {
                        sql.append(" AND a.fecha_limite >= TRUNC(SYSDATE)");
                    } else if ("Retrasado".equals(estado)) {
                        sql.append(" AND a.fecha_limite < TRUNC(SYSDATE)");
                    }
                    if (!fecha.isEmpty()) {
                        sql.append(" AND TRUNC(a.fecha_limite) = TO_DATE(?, 'YYYY-MM-DD')");
                        params.add(fecha);
                    }
                    sql.append(" ORDER BY a.fecha_limite ASC, a.id_alquiler ASC");

                    try (Connection con = ConexionDB.obtenerConexion();
                         PreparedStatement ps = con.prepareStatement(sql.toString())) {
                        for (int i = 0; i < params.size(); i++) {
                            ps.setString(i + 1, params.get(i));
                        }
                        try (ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                filas++;
                                String estadoVisual = rs.getString("estado_visual");
                                boolean retrasado = "Retrasado".equalsIgnoreCase(estadoVisual);
                %>
                <tr>
                    <td>#<%= rs.getInt("id_alquiler") %></td>
                    <td><%= rs.getString("cliente") %></td>
                    <td><%= rs.getString("titulo") %></td>
                    <td><%= rs.getInt("id_vhs") %></td>
                    <td><%= rs.getString("fecha_alquiler") %></td>
                    <td><%= rs.getString("fecha_limite") %></td>
                    <td><span class="status-badge <%= retrasado ? "status-danger" : "status-ok" %>"><%= estadoVisual %></span></td>
                    <td><a class="employee-mini-button" href="empleado-devolucion.jsp?idAlquiler=<%= rs.getInt("id_alquiler") %>">Devolver</a></td>
                </tr>
                <%
                            }
                        }
                    } catch (SQLException e) {
                        errorAlquileres = e.getMessage();
                    }

                    if (filas == 0 && errorAlquileres == null) {
                %>
                <tr><td colspan="8" class="employee-empty">No hay alquileres activos con los filtros seleccionados.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <% if (errorAlquileres != null) { %>
        <div class="employee-alert employee-alert-error">No se pudo cargar la lista: <%= errorAlquileres %></div>
        <% } %>
    </section>
</main>
<script src="js/empleado-responsive.js"></script>
</body>
</html>
