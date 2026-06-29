<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>

<%-- 1. LÓGICA DE ELIMINACIÓN (Solo se ejecuta si llega 'id_vhs') --%>
<%
    String idVhsEliminar = request.getParameter("id_vhs");
    if (idVhsEliminar != null && !idVhsEliminar.isEmpty()) {
        try (Connection con = ConexionDB.obtenerConexion()) {
            PreparedStatement ps = con.prepareStatement("UPDATE Vhs SET estado_fisico_vhs = 'RETIRADO' WHERE id_vhs = ?");
            ps.setInt(1, Integer.parseInt(idVhsEliminar));
            ps.executeUpdate();
            // Redirigir a la misma página sin parámetros para limpiar la URL
            response.sendRedirect("empleado-inventario.jsp?mensaje=exito");
            return; // IMPORTANTE: Detener la carga para procesar la redirección
        } catch(Exception e) {
            // Manejar error silenciosamente o con un parámetro
        }
    }
%>
<%
    String mensaje = "";
    String tipoMensaje = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idPelicula = request.getParameter("id_pelicula");
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        String estado = request.getParameter("estado");

        try (Connection con = ConexionDB.obtenerConexion()) {
            con.setAutoCommit(false);
            // Asegúrate de que tu secuencia se llame seq_vhs
            String sql = "INSERT INTO Vhs (id_vhs, estado_fisico_vhs, id_pelicula) VALUES (seq_vhs.NEXTVAL, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);

            for (int i = 0; i < cantidad; i++) {
                ps.setString(1, estado);
                ps.setInt(2, Integer.parseInt(idPelicula));
                ps.executeUpdate();
            }
            con.commit();
            mensaje = "ÉXITO: Se registraron " + cantidad + " unidades correctamente.";
            tipoMensaje = "employee-alert-ok";
        } catch (Exception e) {
            mensaje = "ERROR: " + e.getMessage();
            tipoMensaje = "employee-alert-error";
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
    <title>Registrar VHS | Rewind & Relive</title>
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
        <p class="employee-kicker">Inventario.store</p>
        <h1>Registrar nuevas copias VHS</h1>
    </section>

    <% if (!mensaje.isEmpty()) { %>
    <div class="employee-alert <%= tipoMensaje %>"><%= mensaje %></div>
    <% } %>

    <section class="retro-window employee-panel employee-form-panel">
        <div class="window-header"><span>Registrar_VHS.form</span><span>_ [] X</span></div>
        <form method="post" class="employee-form employee-movie-form">
            <div class="employee-form-grid">
                <label>Película *
                    <select name="id_pelicula" class="retro-search" required>
                        <option value="">Seleccione una película...</option>
                        <%
                            try (Connection con = ConexionDB.obtenerConexion();
                                 ResultSet rs = con.createStatement().executeQuery("SELECT id_pelicula, titulo FROM Peliculas")) {
                                while(rs.next()) { %>
                        <option value="<%=rs.getInt("id_pelicula")%>"><%=rs.getString("titulo")%></option>
                        <% }} catch(Exception e) {} %>
                    </select>
                </label>

                <label>Cantidad de copias *
                    <input type="number" name="cantidad" class="retro-search" min="1" max="50" required placeholder="Ej. 5">
                </label>

                <label>Estado físico *
                    <select name="estado" class="retro-search">
                        <option value="DISPONIBLE">DISPONIBLE</option>
                        <option value="DAÑADO">DAÑADO</option>
                    </select>
                </label>
            </div>

            <div class="employee-form-actions">
                <button type="submit" class="retro-button">REGISTRAR COPIAS</button>
                <a href="empleado-inventario.jsp" class="retro-button employee-cancel">CANCELAR</a>
            </div>
        </form>
    </section>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>Gestion_Inventario.table</span><span>_ [] X</span></div>

        <div class="employee-toolbar">
            <form method="get">
                <input type="text" name="busqueda" class="retro-search" placeholder="Buscar por título...">
                <button type="submit" class="retro-button">BUSCAR</button>
            </form>
        </div>

        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr>
                    <th>ID VHS</th>
                    <th>Título</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <%
                    String filtro = request.getParameter("busqueda");
                    String sql = "SELECT v.id_vhs, p.titulo, v.estado_fisico_vhs FROM Vhs v JOIN Peliculas p ON v.id_pelicula = p.id_pelicula";
                    if(filtro != null && !filtro.isEmpty()) {
                        sql += " WHERE UPPER(p.titulo) LIKE UPPER('%" + filtro + "%')";
                    }

                    try (Connection con = ConexionDB.obtenerConexion();
                         ResultSet rs = con.createStatement().executeQuery(sql)) {
                        while(rs.next()) {
                %>
                <tr>
                    <td>#<%=rs.getInt("id_vhs")%></td>
                    <td><%=rs.getString("titulo")%></td>
                    <td><span class="status-badge <%= "DAÑADO".equals(rs.getString("estado_fisico_vhs")) ? "status-danger" : "status-ok" %>">
                        <%=rs.getString("estado_fisico_vhs")%>
                    </span></td>
                    <td>
                        <form method="post" action="empleado-inventario.jsp">
                            <input type="hidden" name="id_vhs" value="<%=rs.getInt("id_vhs")%>">
                            <button type="submit" class="employee-icon-button" title="Eliminar/Retirar">×</button>
                        </form>
                    </td>
                </tr>
                <% } } catch(Exception e) {} %>
                </tbody>
            </table>
        </div>
    </section>


</main>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-col">
            <h4>REWIND & RELIVE</h4>
            <p class="footer-desc">Sistema de gestión de videoclub retro. Preservando el formato físico para las nuevas generaciones.</p>
        </div>
        <div class="footer-col">
            <h4>ENLACES</h4>
            <ul><li><a href="index.jsp">Inicio</a></li><li><a href="#">Soporte</a></li></ul>
        </div>
    </div>
    <p class="copyright">© 2026 Rewind & Relive Admin System</p>
</footer>

<script src="js/empleado-responsive.js"></script>
</body>
</html>