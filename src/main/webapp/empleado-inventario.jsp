<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>
<%
    request.setCharacterEncoding("UTF-8");
    String mensaje = null;
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String accion = request.getParameter("accion");
        String idPeliculaParam = request.getParameter("idPelicula");
        try {
            int idPelicula = Integer.parseInt(idPeliculaParam);
            try (Connection con = ConexionDB.obtenerConexion()) {
                if ("sumar".equals(accion)) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO Vhs (estado_fisico_vhs, id_pelicula) VALUES ('Disponible', ?)")) {
                        ps.setInt(1, idPelicula);
                        ps.executeUpdate();
                        mensaje = "Unidad agregada al inventario.";
                    }
                } else if ("restar".equals(accion)) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "DELETE FROM Vhs WHERE id_vhs = (" +
                            "SELECT id_vhs FROM (" +
                            "SELECT v.id_vhs FROM Vhs v WHERE v.id_pelicula = ? " +
                            "AND NOT EXISTS (SELECT 1 FROM Alquiler a WHERE a.id_vhs = v.id_vhs AND a.fecha_devolucion IS NULL) " +
                            "AND UPPER(v.estado_fisico_vhs) <> 'ALQUILADA' ORDER BY v.id_vhs" +
                            ") WHERE ROWNUM = 1)")) {
                        ps.setInt(1, idPelicula);
                        int filas = ps.executeUpdate();
                        mensaje = filas > 0 ? "Unidad disponible retirada del inventario." : "No hay unidades disponibles para retirar.";
                    }
                }
            }
        } catch (NumberFormatException e) {
            error = "Película inválida.";
        } catch (SQLException e) {
            error = e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Gestión Inventario | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolución</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Peliculas + Vhs</p>
        <h1>Inventario de VHS</h1>
        <p>Consulta stock, unidades alquiladas y ajusta copias disponibles por película.</p>
    </section>

    <% if (mensaje != null) { %><div class="employee-alert employee-alert-ok"><%= mensaje %></div><% } %>
    <% if (error != null) { %><div class="employee-alert employee-alert-error">No se pudo actualizar inventario: <%= error %></div><% } %>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>Inventario_Stock.table</span><span>_ □ X</span></div>
        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Título</th>
                    <th>Stock total</th>
                    <th>Alquiladas</th>
                    <th>Disponibles</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int filas = 0;
                    try (Connection con = ConexionDB.obtenerConexion();
                         PreparedStatement ps = con.prepareStatement(
                                 "SELECT p.id_pelicula, p.titulo, " +
                                 "COUNT(v.id_vhs) stock_total, " +
                                 "SUM(CASE WHEN a.id_alquiler IS NOT NULL THEN 1 ELSE 0 END) alquiladas, " +
                                 "COUNT(v.id_vhs) - SUM(CASE WHEN a.id_alquiler IS NOT NULL THEN 1 ELSE 0 END) disponibles " +
                                 "FROM Peliculas p LEFT JOIN Vhs v ON v.id_pelicula = p.id_pelicula " +
                                 "LEFT JOIN Alquiler a ON a.id_vhs = v.id_vhs AND a.fecha_devolucion IS NULL " +
                                 "GROUP BY p.id_pelicula, p.titulo ORDER BY p.titulo")) {
                        try (ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                filas++;
                                int disponibles = rs.getInt("disponibles");
                %>
                <tr>
                    <td>#<%= rs.getInt("id_pelicula") %></td>
                    <td><%= rs.getString("titulo") %></td>
                    <td><%= rs.getInt("stock_total") %></td>
                    <td><%= rs.getInt("alquiladas") %></td>
                    <td><span class="status-badge <%= disponibles > 0 ? "status-ok" : "status-danger" %>"><%= disponibles %></span></td>
                    <td>
                        <div class="employee-row-actions">
                            <form method="post" action="empleado-inventario.jsp">
                                <input type="hidden" name="idPelicula" value="<%= rs.getInt("id_pelicula") %>">
                                <input type="hidden" name="accion" value="sumar">
                                <button type="submit" class="employee-icon-button" title="Sumar unidad">+</button>
                            </form>
                            <form method="post" action="empleado-inventario.jsp">
                                <input type="hidden" name="idPelicula" value="<%= rs.getInt("id_pelicula") %>">
                                <input type="hidden" name="accion" value="restar">
                                <button type="submit" class="employee-icon-button" title="Restar unidad" <%= disponibles == 0 ? "disabled" : "" %>>-</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <%
                            }
                        }
                    } catch (SQLException e) {
                        error = e.getMessage();
                    }
                    if (filas == 0 && error == null) {
                %>
                <tr><td colspan="6" class="employee-empty">Aún no hay películas registradas para inventariar.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% if (error != null) { %><div class="employee-alert employee-alert-error">No se pudo consultar inventario: <%= error %></div><% } %>
    </section>
</main>
</body>
</html>
