<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,com.conexion.ConexionDB" %>
<%!
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    int idCliente = 0;
    try { idCliente = Integer.parseInt(request.getParameter("cliente")); } catch (Exception ignored) { }
    String buscar = request.getParameter("buscar");
    String filtro = buscar == null || buscar.isBlank() ? null : buscar.trim().toLowerCase();
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>Historial por cliente | Rewind &amp; Relive</title></head><body>
<nav class="navbar retro-window employee-nav"><div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
<ul class="nav-links"><li><a href="empleado-dashboard.jsp">Dashboard</a></li><li><a href="empleado-alquileres.jsp">Alquileres</a></li>
<li><a href="empleado-devolucion.jsp">Devolucion</a></li><li><a href="empleado-inventario.jsp">Inventario</a></li>
<li><a href="empleado-usuarios.jsp">Usuarios</a></li><li><a href="empleado-alquilar.jsp">Nuevo Alquiler</a></li></ul></nav>
<main class="employee-page">
<section class="employee-header"><p class="employee-kicker">Historial.clientes</p><h1>Historial por cliente</h1>
<p>Selecciona un cliente para consultar todos sus alquileres.</p><br><a class="retro-button" href="empleado-alquileres.jsp">VOLVER A ALQUILERES</a></section>
<section class="retro-window employee-panel"><div class="window-header"><span>Clientes.table</span><span>_ [] X</span></div>
<div class="employee-table-wrap"><table class="employee-table"><thead><tr><th>ID</th><th>Cliente</th><th>Cedula</th><th>Alquileres</th><th>Accion</th></tr></thead><tbody>
<%
    String sqlClientes = "SELECT u.id_usuario,u.primer_nombre_usuario || ' ' || u.primer_apellido_usuario nombre,u.ced_usuario,COUNT(a.id_alquiler) total " +
            "FROM Usuario u LEFT JOIN Alquiler a ON a.id_usuario_cliente=u.id_usuario " +
            "WHERE TO_CHAR(u.rol)='1' OR UPPER(TO_CHAR(u.rol))='CLIENTE' " +
            "GROUP BY u.id_usuario,u.primer_nombre_usuario,u.primer_apellido_usuario,u.ced_usuario ORDER BY nombre";
    try (Connection con=ConexionDB.obtenerConexion(); PreparedStatement ps=con.prepareStatement(sqlClientes); ResultSet rs=ps.executeQuery()) {
        boolean hay=false; while(rs.next()){ hay=true;
%><tr><td>#<%= rs.getInt("id_usuario") %></td><td><%= h(rs.getString("nombre")) %></td><td><%= h(rs.getString("ced_usuario")) %></td>
<td><%= rs.getInt("total") %></td><td><a class="employee-mini-button" href="empleado-historial-clientes.jsp?cliente=<%= rs.getInt("id_usuario") %>">Ver historial</a></td></tr><% }
        if(!hay){ %><tr><td colspan="5" class="employee-empty">No hay clientes registrados.</td></tr><% }
    } catch(SQLException e){ %><tr><td colspan="5">No fue posible cargar los clientes: <%= h(e.getMessage()) %></td></tr><% } %>
</tbody></table></div></section>
<% if(idCliente > 0) { %>
<section class="retro-window employee-panel"><div class="window-header"><span>Historial_Cliente_<%= idCliente %>.table</span><span>_ [] X</span></div>
<form class="employee-toolbar" method="get"><input type="hidden" name="cliente" value="<%= idCliente %>">
<input class="retro-search" name="buscar" value="<%= h(buscar) %>" placeholder="Nombre de pelicula o ID de alquiler">
<button class="retro-button" type="submit">FILTRAR</button><a class="employee-clear" href="empleado-historial-clientes.jsp?cliente=<%= idCliente %>">Limpiar</a></form>
<div class="employee-table-wrap"><table class="employee-table"><thead><tr><th>ID</th><th>Pelicula</th><th>VHS</th><th>Alquiler</th><th>Vence</th><th>Devolucion</th><th>Estado</th></tr></thead><tbody>
<%
    String sqlHistorial="SELECT a.id_alquiler,a.id_vhs,a.estado_alquiler,p.titulo,TO_CHAR(a.fecha_alquiler,'YYYY-MM-DD') fecha_alquiler,"+
            "TO_CHAR(a.fecha_limite,'YYYY-MM-DD') fecha_limite,TO_CHAR(a.fecha_devolucion,'YYYY-MM-DD') fecha_devolucion " +
            "FROM Alquiler a JOIN Vhs v ON v.id_vhs=a.id_vhs JOIN Peliculas p ON p.id_pelicula=v.id_pelicula " +
            "WHERE a.id_usuario_cliente=? AND (? IS NULL OR TO_CHAR(a.id_alquiler)=? OR LOWER(p.titulo) LIKE ?) ORDER BY a.fecha_alquiler DESC";
    try(Connection con=ConexionDB.obtenerConexion();PreparedStatement ps=con.prepareStatement(sqlHistorial)){
        ps.setInt(1,idCliente); ps.setString(2,filtro); ps.setString(3,filtro); ps.setString(4,filtro==null?null:"%"+filtro+"%");
        try(ResultSet rs=ps.executeQuery()){boolean hay=false;while(rs.next()){hay=true;String estado=rs.getString("estado_alquiler");String devolucion=rs.getString("fecha_devolucion");
%><tr><td>#<%= rs.getInt("id_alquiler") %></td><td><%= h(rs.getString("titulo")) %></td><td>#<%= rs.getInt("id_vhs") %></td>
<td><%= h(rs.getString("fecha_alquiler")) %></td><td><%= h(rs.getString("fecha_limite")) %></td><td><%= devolucion==null?"Pendiente":h(devolucion) %></td>
<td><span class="status-badge <%= devolucion==null?"status-warning":"status-ok" %>"><%= h(estado) %></span></td></tr><% }
        if(!hay){%><tr><td colspan="7" class="employee-empty">No se encontraron alquileres para este cliente.</td></tr><% }}
    }catch(SQLException e){%><tr><td colspan="7">No fue posible cargar el historial: <%= h(e.getMessage()) %></td></tr><%}%>
</tbody></table></div></section><% } %>
</main><%@ include file="footer.jsp" %><script src="${pageContext.request.contextPath}/js/script.js"></script></body></html>
