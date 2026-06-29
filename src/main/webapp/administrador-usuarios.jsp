<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>
<%
    // Lógica de procesamiento de roles
    String mensaje = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String cedula = request.getParameter("cedula");
        String nuevoRol = request.getParameter("nuevoRol");
        if (cedula != null && nuevoRol != null) {
            String sqlUpd = "UPDATE USUARIO SET ROL = ? WHERE CED_USUARIO = ? AND ROL != '3'";
            try (Connection conn = ConexionDB.obtenerConexion();
                 PreparedStatement ps = conn.prepareStatement(sqlUpd)) {
                ps.setString(1, nuevoRol);
                ps.setString(2, cedula);
                ps.executeUpdate();
                mensaje = "Operación realizada con éxito.";
            } catch (Exception e) { mensaje = "Error: " + e.getMessage(); }
        }
    }

    // Lógica de búsqueda
    String busqueda = request.getParameter("buscar");
    String sqlSelect = (busqueda != null && !busqueda.isEmpty())
            ? "SELECT * FROM USUARIO WHERE CED_USUARIO LIKE '%" + busqueda + "%' AND ROL != '3'"
            : "SELECT * FROM USUARIO WHERE ROL = '2'";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-usuario.css">
    <title>Rewind & Relive | Admin Usuarios</title>
</head>
<body>

<nav class="navbar retro-window">
    <div class="logo"><a href="index.jsp" class="logo-link">Rewind & Relive</a></div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catalogo</a></li>
        <li><a href="empleado-dashboard.jsp">Dashboard Empleado</a></li>
    </ul>
</nav>

<main class="employee-page">
    <div class="employee-header">
        <h1>Gestión de Usuarios</h1>
        <p>Administración de roles y accesos del sistema.</p>
    </div>

    <% if (!mensaje.isEmpty()) { %><div class="employee-alert employee-alert-ok"><%= mensaje %></div><% } %>

    <div class="retro-window employee-panel">
        <form method="GET" class="employee-toolbar">
            <input type="text" name="buscar" class="retro-search" placeholder="Buscar cédula..." value="<%= busqueda != null ? busqueda : "" %>">
            <button type="submit" class="retro-button">BUSCAR</button>
            <a href="administrador-usuarios.jsp" class="employee-clear">LIMPIAR</a>
        </form>

        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead>
                <tr><th>ID</th><th>Cédula</th><th>Nombre</th><th>Rol</th><th>Acción</th></tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = ConexionDB.obtenerConexion();
                         Statement st = conn.createStatement();
                         ResultSet rs = st.executeQuery(sqlSelect)) {
                        while (rs.next()) {
                            String id = rs.getString("ID_USUARIO");
                            String cedula = rs.getString("CED_USUARIO");
                            String nombre = rs.getString("PRIMER_NOMBRE_USUARIO");
                            String rol = rs.getString("ROL");
                            String nombreRol = "1".equals(rol) ? "CLIENTE" : "EMPLEADO";
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= cedula %></td>
                    <td><%= nombre %></td>
                    <td><span class="status-badge"><%= nombreRol %></span></td>
                    <td>
                        <form method="POST">
                            <input type="hidden" name="cedula" value="<%= cedula %>">
                            <input type="hidden" name="nuevoRol" value="<%= "1".equals(rol) ? "2" : "1" %>">
                            <button type="submit" class="retro-button <%= "1".equals(rol) ? "" : "btn-revocar" %>">
                                <%= "1".equals(rol) ? "OTORGAR" : "REVOCAR" %>
                            </button>
                        </form>
                    </td>
                </tr>
                <% }
                } catch (Exception e) {} %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-col"><h4>Rewind & Relive</h4><p>Gestión interna.</p></div>
    </div>
    <div class="copyright">2026 Rewind & Relive.</div>
</footer>

</body>
</html>