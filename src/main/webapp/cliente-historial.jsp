<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,com.conexion.ConexionDB" %>
<%--
    El historial une Alquiler -> Vhs -> Peliculas mediante sus claves foráneas.
    La condición id_usuario_cliente=? garantiza que el ResultSet solo contenga movimientos del cliente actual.
    Oracle formatea las fechas con TO_CHAR para mostrarlas de forma uniforme en la tabla HTML.
--%>
<%!
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    // Protege el historial y usa siempre el ID guardado en la sesión, nunca uno de la URL.
    Object idSesion = session.getAttribute("idUsuario");
    String rolSesion = String.valueOf(session.getAttribute("rolUsuario"));
    if (idSesion == null || !("1".equals(rolSesion) || "CLIENTE".equalsIgnoreCase(rolSesion))) {
        response.sendRedirect("login.jsp");
        return;
    }
    int idUsuario = Integer.parseInt(String.valueOf(idSesion));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Historial | Rewind &amp; Relive</title>
</head>
<body>
<nav class="navbar retro-window">
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="index.jsp">Inicio</a></li>
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="cliente-perfil.jsp">Mi perfil</a></li>
        <li><a href="cliente-carrito.jsp">Mi carrito</a></li>
    </ul>
</nav>

<main class="account-page">
    <section class="employee-header">
        <p class="employee-kicker">Historial de alquileres</p>
        <h1>Mi historial</h1>
        <p>Todos los alquileres registrados para tu cuenta.</p>
    </section>

    <section class="retro-window employee-panel">
        <div class="window-header"><span>historial_cliente.table</span><span>_ [] X</span></div>
        <div class="employee-table-wrap">
            <table class="employee-table">
                <thead><tr><th>ID</th><th>Película</th><th>VHS</th><th>Alquiler</th><th>Vence</th><th>Devolución</th><th>Estado</th></tr></thead>
                <tbody>
                <%
                    // Recupera únicamente los alquileres pertenecientes al cliente autenticado.
                    String sql = "SELECT a.id_alquiler,p.titulo,a.id_vhs," +
                            "TO_CHAR(a.fecha_alquiler,'YYYY-MM-DD') fecha_alquiler," +
                            "TO_CHAR(a.fecha_limite,'YYYY-MM-DD') fecha_limite," +
                            "TO_CHAR(a.fecha_devolucion,'YYYY-MM-DD') fecha_devolucion,a.estado_alquiler," +
                            "CASE WHEN a.fecha_devolucion IS NULL AND a.fecha_limite<SYSDATE THEN 1 ELSE 0 END vencido " +
                            "FROM Alquiler a JOIN Vhs v ON v.id_vhs=a.id_vhs " +
                            "JOIN Peliculas p ON p.id_pelicula=v.id_pelicula " +
                            "WHERE a.id_usuario_cliente=? ORDER BY a.fecha_alquiler DESC,a.id_alquiler DESC";
                    try (Connection con=ConexionDB.obtenerConexion(); PreparedStatement ps=con.prepareStatement(sql)) {
                        ps.setInt(1,idUsuario);
                        try (ResultSet rs=ps.executeQuery()) {
                            boolean hay=false;
                            while(rs.next()) { hay=true;
                                String devolucion=rs.getString("fecha_devolucion");
                                boolean activo=devolucion==null;
                                boolean vencido=rs.getInt("vencido")==1;
                                // Los activos se calculan por fecha; los devueltos conservan el estado registrado por el empleado.
                                String estado=activo ? (vencido ? "VENCIDO" : "ACTIVO") : rs.getString("estado_alquiler");
                                String estadoNormalizado=estado==null?"":estado.toUpperCase();
                                String clase=activo ? (vencido ? "status-danger" : "status-warning") :
                                        (estadoNormalizado.contains("TARDE") || estadoNormalizado.contains("DANADO") ? "status-danger" : "status-ok");
                %>
                <tr>
                    <td>#<%= rs.getInt("id_alquiler") %></td>
                    <td><%= h(rs.getString("titulo")) %></td>
                    <td>#<%= rs.getInt("id_vhs") %></td>
                    <td><%= h(rs.getString("fecha_alquiler")) %></td>
                    <td><%= h(rs.getString("fecha_limite")) %></td>
                    <td><%= activo ? "Pendiente" : h(devolucion) %></td>
                    <td><span class="status-badge <%= clase %>"><%= estado %></span></td>
                </tr>
                <%
                            }
                            if(!hay) { %><tr><td colspan="7" class="employee-empty">Todavía no tienes alquileres registrados.</td></tr><% }
                        }
                    } catch(SQLException e) {
                %><tr><td colspan="7">No fue posible cargar el historial: <%= h(e.getMessage()) %></td></tr><% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<%@ include file="footer.jsp" %>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
