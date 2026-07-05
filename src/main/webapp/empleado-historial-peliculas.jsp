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
    int idPelicula=0;
    try { idPelicula=Integer.parseInt(request.getParameter("pelicula")); } catch(Exception ignored) { }
    String buscar=request.getParameter("buscar");
    String filtro=buscar==null||buscar.isBlank()?null:buscar.trim().toLowerCase();
    String buscarPelicula=request.getParameter("buscarPelicula");
    String filtroPelicula=buscarPelicula==null||buscarPelicula.isBlank()?null:buscarPelicula.trim().toLowerCase();
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>Historial por pelicula | Rewind &amp; Relive</title></head><body>
<nav class="navbar retro-window employee-nav"><% request.setAttribute("adminPanelLogo", Boolean.TRUE); %><%@ include file="logo.jsp" %>
<ul class="nav-links"><li><a href="empleado-dashboard.jsp">Dashboard</a></li><li><a href="empleado-alquileres.jsp">Alquileres</a></li>
<li><a href="empleado-devolucion.jsp">Devolucion</a></li><li><a href="empleado-inventario.jsp">Inventario</a></li>
<li><a href="empleado-usuarios.jsp">Usuarios</a></li><li><a href="empleado-alquilar.jsp">Nuevo Alquiler</a></li></ul></nav>
<main class="employee-page">
<section class="employee-header"><p class="employee-kicker">Historial.peliculas</p><h1>Historial por pelicula</h1>
<p>Selecciona una pelicula para consultar todos sus alquileres.</p><br><a class="retro-button" href="empleado-alquileres.jsp">VOLVER A ALQUILERES</a></section>
<section class="retro-window employee-panel"><div class="window-header"><span>Peliculas.table</span><span>_ [] X</span></div>
<form class="employee-toolbar" method="get">
<input class="retro-search" name="buscarPelicula" value="<%= h(buscarPelicula) %>" placeholder="Nombre de la pelicula">
<button class="retro-button" type="submit">FILTRAR</button><a class="employee-clear" href="empleado-historial-peliculas.jsp">Limpiar</a></form>
<div class="employee-table-wrap"><table class="employee-table"><thead><tr><th>ID</th><th>Pelicula</th><th>Copias VHS</th><th>Alquileres</th><th>Accion</th></tr></thead><tbody>
<%
    String sqlPeliculas="SELECT p.id_pelicula,p.titulo,COUNT(DISTINCT v.id_vhs) copias,COUNT(a.id_alquiler) total "+
            "FROM Peliculas p LEFT JOIN Vhs v ON v.id_pelicula=p.id_pelicula LEFT JOIN Alquiler a ON a.id_vhs=v.id_vhs "+
            "WHERE (? IS NULL OR LOWER(p.titulo) LIKE ?) GROUP BY p.id_pelicula,p.titulo ORDER BY p.titulo";
    try(Connection con=ConexionDB.obtenerConexion();PreparedStatement ps=con.prepareStatement(sqlPeliculas)){
        ps.setString(1,filtroPelicula);ps.setString(2,filtroPelicula==null?null:"%"+filtroPelicula+"%");
        try(ResultSet rs=ps.executeQuery()){boolean hay=false;while(rs.next()){hay=true;
%><tr><td>#<%= rs.getInt("id_pelicula") %></td><td><%= h(rs.getString("titulo")) %></td><td><%= rs.getInt("copias") %></td><td><%= rs.getInt("total") %></td>
<td><a class="employee-mini-button" href="empleado-historial-peliculas.jsp?pelicula=<%= rs.getInt("id_pelicula") %>">Ver historial</a></td></tr><% }
        if(!hay){%><tr><td colspan="5" class="employee-empty">No se encontraron peliculas.</td></tr><%}}
    }catch(SQLException e){%><tr><td colspan="5">No fue posible cargar las peliculas: <%= h(e.getMessage()) %></td></tr><%}%>
</tbody></table></div></section>
<% if(idPelicula>0){ %>
<section class="retro-window employee-panel"><div class="window-header"><span>Historial_Pelicula_<%= idPelicula %>.table</span><span>_ [] X</span></div>
<form class="employee-toolbar" method="get"><input type="hidden" name="pelicula" value="<%= idPelicula %>">
<input class="retro-search" name="buscar" value="<%= h(buscar) %>" placeholder="Nombre del cliente o ID de alquiler">
<button class="retro-button" type="submit">FILTRAR</button><a class="employee-clear" href="empleado-historial-peliculas.jsp?pelicula=<%= idPelicula %>">Limpiar</a></form>
<div class="employee-table-wrap"><table class="employee-table"><thead><tr><th>ID</th><th>Cliente</th><th>VHS</th><th>Alquiler</th><th>Vence</th><th>Devolucion</th><th>Estado</th></tr></thead><tbody>
<%
    String sqlHistorial="SELECT a.id_alquiler,a.id_vhs,a.estado_alquiler,u.primer_nombre_usuario || ' ' || u.primer_apellido_usuario cliente,"+
            "TO_CHAR(a.fecha_alquiler,'YYYY-MM-DD') fecha_alquiler,TO_CHAR(a.fecha_limite,'YYYY-MM-DD') fecha_limite,"+
            "TO_CHAR(a.fecha_devolucion,'YYYY-MM-DD') fecha_devolucion FROM Alquiler a "+
            "JOIN Usuario u ON u.id_usuario=a.id_usuario_cliente JOIN Vhs v ON v.id_vhs=a.id_vhs "+
            "WHERE v.id_pelicula=? AND (? IS NULL OR TO_CHAR(a.id_alquiler)=? OR LOWER(u.primer_nombre_usuario || ' ' || u.primer_apellido_usuario) LIKE ?) "+
            "ORDER BY a.fecha_alquiler DESC";
    try(Connection con=ConexionDB.obtenerConexion();PreparedStatement ps=con.prepareStatement(sqlHistorial)){
        ps.setInt(1,idPelicula);ps.setString(2,filtro);ps.setString(3,filtro);ps.setString(4,filtro==null?null:"%"+filtro+"%");
        try(ResultSet rs=ps.executeQuery()){boolean hay=false;while(rs.next()){hay=true;String estado=rs.getString("estado_alquiler");String devolucion=rs.getString("fecha_devolucion");
%><tr><td>#<%= rs.getInt("id_alquiler") %></td><td><%= h(rs.getString("cliente")) %></td><td>#<%= rs.getInt("id_vhs") %></td>
<td><%= h(rs.getString("fecha_alquiler")) %></td><td><%= h(rs.getString("fecha_limite")) %></td><td><%= devolucion==null?"Pendiente":h(devolucion) %></td>
<td><span class="status-badge <%= devolucion==null?"status-warning":"status-ok" %>"><%= h(estado) %></span></td></tr><%}
        if(!hay){%><tr><td colspan="7" class="employee-empty">No se encontraron alquileres para esta pelicula.</td></tr><%}}
    }catch(SQLException e){%><tr><td colspan="7">No fue posible cargar el historial: <%= h(e.getMessage()) %></td></tr><%}%>
</tbody></table></div></section><% } %>
</main><%@ include file="footer.jsp" %><script src="${pageContext.request.contextPath}/js/script.js"></script></body></html>
