<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,com.conexion.ConexionDB" %>
<%-- Consulta Usuario y usa subconsultas por id_usuario para resumir alquileres y cargar sus datos relacionados. --%>
<%!
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    String buscar=request.getParameter("buscar");
    String filtro=buscar==null||buscar.isBlank()?null:buscar.trim().toLowerCase();
    int idDetalle=0;
    try{idDetalle=Integer.parseInt(request.getParameter("id"));}catch(Exception ignored){}
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>Usuarios | Rewind &amp; Relive</title></head><body>
<nav class="navbar retro-window employee-nav"><% request.setAttribute("adminPanelLogo", Boolean.TRUE); %><%@ include file="logo.jsp" %>
<ul class="nav-links"><li><a href="empleado-dashboard.jsp">Dashboard</a></li><li><a href="empleado-alquileres.jsp">Alquileres</a></li>
<li><a href="empleado-devolucion.jsp">Devolucion</a></li><li><a href="empleado-inventario.jsp">Inventario</a></li>
<li><a href="empleado-usuarios.jsp">Usuarios</a></li><li><a href="empleado-alquilar.jsp">Nuevo Alquiler</a></li></ul></nav>
<main class="employee-page">
<section class="employee-header"><p class="employee-kicker">Usuarios.database</p><h1>Perfiles de clientes</h1>
<p>Clientes registrados, actividad de alquiler y datos de contacto.</p></section>

<section class="retro-window employee-panel"><div class="window-header"><span>usuarios_alquileres.view</span><span>_ [] X</span></div>
<form class="employee-toolbar employee-toolbar-compact" method="get">
<input type="text" name="buscar" class="retro-search" value="<%= h(buscar) %>" placeholder="Buscar cliente o cedula">
<button type="submit" class="retro-button">FILTRAR</button><a href="empleado-usuarios.jsp" class="employee-clear">Limpiar</a></form>
<div class="employee-table-wrap"><table class="employee-table"><thead><tr><th>ID</th><th>Usuario</th><th>Cedula</th><th>Rol</th>
<th>Alquileres activos</th><th>Historial total</th><th>Peliculas actuales</th><th>Accion</th></tr></thead><tbody>
<%
    String sqlUsuarios="SELECT u.id_usuario,u.ced_usuario,u.primer_nombre_usuario || ' ' || u.primer_apellido_usuario nombre,u.rol,"+
            "(SELECT COUNT(*) FROM Alquiler a WHERE a.id_usuario_cliente=u.id_usuario AND a.fecha_devolucion IS NULL) activos,"+
            "(SELECT COUNT(*) FROM Alquiler a WHERE a.id_usuario_cliente=u.id_usuario) total,"+
            "(SELECT LISTAGG(p.titulo, ', ') WITHIN GROUP (ORDER BY p.titulo) FROM Alquiler a JOIN Vhs v ON v.id_vhs=a.id_vhs "+
            "JOIN Peliculas p ON p.id_pelicula=v.id_pelicula WHERE a.id_usuario_cliente=u.id_usuario AND a.fecha_devolucion IS NULL) actuales "+
            "FROM Usuario u WHERE (TO_CHAR(u.rol)='1' OR UPPER(TO_CHAR(u.rol))='CLIENTE') "+
            "AND (? IS NULL OR LOWER(u.primer_nombre_usuario || ' ' || u.primer_apellido_usuario) LIKE ? OR LOWER(u.ced_usuario) LIKE ?) ORDER BY nombre";
    try(Connection con=ConexionDB.obtenerConexion();PreparedStatement ps=con.prepareStatement(sqlUsuarios)){
        String contiene=filtro==null?null:"%"+filtro+"%";ps.setString(1,filtro);ps.setString(2,contiene);ps.setString(3,contiene);
        try(ResultSet rs=ps.executeQuery()){boolean hay=false;while(rs.next()){hay=true;String actuales=rs.getString("actuales");
%><tr><td>#<%= rs.getInt("id_usuario") %></td><td><%= h(rs.getString("nombre")) %></td><td><%= h(rs.getString("ced_usuario")) %></td>
<td><span class="status-badge status-ok">Cliente</span></td><td><%= rs.getInt("activos") %></td><td><%= rs.getInt("total") %></td>
<td><%= actuales==null?"Sin alquiler activo":h(actuales) %></td><td><a class="employee-mini-button" href="empleado-usuarios.jsp?id=<%= rs.getInt("id_usuario") %>">Ver mas</a></td></tr><%}
        if(!hay){%><tr><td colspan="8" class="employee-empty">No se encontraron clientes.</td></tr><%}}
    }catch(SQLException e){%><tr><td colspan="8">No fue posible cargar los clientes: <%= h(e.getMessage()) %></td></tr><%}%>
</tbody></table></div></section>

<% if(idDetalle>0){
    String sqlDetalle="SELECT id_usuario,ced_usuario,primer_nombre_usuario,segundo_nombre_usuario,primer_apellido_usuario,"+
            "segundo_apellido_usuario,TO_CHAR(fecha_registro,'YYYY-MM-DD') fecha_registro FROM Usuario "+
            "WHERE id_usuario=? AND (TO_CHAR(rol)='1' OR UPPER(TO_CHAR(rol))='CLIENTE')";
    try(Connection con=ConexionDB.obtenerConexion();PreparedStatement ps=con.prepareStatement(sqlDetalle)){
        ps.setInt(1,idDetalle);try(ResultSet rs=ps.executeQuery()){if(rs.next()){
%><section class="retro-window employee-panel"><div class="window-header"><span>Cliente_<%= idDetalle %>.details</span><span>_ [] X</span></div>
<div class="employee-summary" style="padding:20px"><h2><%= h(rs.getString("primer_nombre_usuario")) %> <%= h(rs.getString("segundo_nombre_usuario")) %> <%= h(rs.getString("primer_apellido_usuario")) %> <%= h(rs.getString("segundo_apellido_usuario")) %></h2>
<p><strong>ID:</strong> #<%= rs.getInt("id_usuario") %></p><p><strong>Cedula:</strong> <%= h(rs.getString("ced_usuario")) %></p>
<p><strong>Fecha de registro:</strong> <%= h(rs.getString("fecha_registro")) %></p><p><strong>Rol:</strong> Cliente</p></div>
<div style="padding:0 20px 20px">
<section style="margin-bottom:28px"><h3>Telefonos</h3><div style="display:grid;gap:10px">
<%
    String sqlTelefonos="SELECT t.desc_tipo_telefono,ut.telefono FROM UsuarioTelefono ut JOIN tipo_telefonos t ON t.id_tipo_telefono=ut.id_tipo_telefono WHERE ut.id_usuario=? ORDER BY t.desc_tipo_telefono";
    try(PreparedStatement pt=con.prepareStatement(sqlTelefonos)){pt.setInt(1,idDetalle);try(ResultSet rt=pt.executeQuery()){boolean hay=false;while(rt.next()){hay=true;
%><div style="display:flex;gap:24px;flex-wrap:wrap;padding:12px;background:#fff7ec;border:2px solid #000">
<span><strong>Tipo:</strong> <%= h(rt.getString("desc_tipo_telefono")) %></span>
<span><strong>Telefono:</strong> <%= h(rt.getString("telefono")) %></span></div>
<%}if(!hay){%><p>Sin telefonos registrados.</p><%}}}%>
</div></section>
<section><h3>Correos electronicos</h3><div style="display:grid;gap:10px">
<%
    String sqlCorreos="SELECT t.desc_tipo_email,ue.email FROM UsuarioEmail ue JOIN tipo_email t ON t.id_tipo_email=ue.id_tipo_email WHERE ue.id_usuario=? ORDER BY t.desc_tipo_email";
    try(PreparedStatement pe=con.prepareStatement(sqlCorreos)){pe.setInt(1,idDetalle);try(ResultSet re=pe.executeQuery()){boolean hay=false;while(re.next()){hay=true;
%><div style="display:flex;gap:24px;flex-wrap:wrap;padding:12px;background:#fff7ec;border:2px solid #000">
<span><strong>Tipo:</strong> <%= h(re.getString("desc_tipo_email")) %></span>
<span><strong>Correo:</strong> <%= h(re.getString("email")) %></span></div>
<%}if(!hay){%><p>Sin correos registrados.</p><%}}}%>
</div></section></div><div style="padding:0 20px 20px"><a class="retro-button" href="empleado-historial-clientes.jsp?cliente=<%= idDetalle %>">VER HISTORIAL DE ALQUILERES</a> <a class="employee-clear" href="empleado-usuarios.jsp">Cerrar detalle</a></div></section>
<%      }else{%><div class="employee-alert employee-alert-error">El cliente seleccionado no existe.</div><%}
        }
    }catch(SQLException e){%><div class="employee-alert employee-alert-error">No fue posible cargar el detalle: <%= h(e.getMessage()) %></div><%}
} %>
</main><%@ include file="footer.jsp" %><script src="${pageContext.request.contextPath}/js/script.js"></script></body></html>
