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

    Object idSesion = session.getAttribute("idUsuario");
    String rolSesion = String.valueOf(session.getAttribute("rolUsuario"));
    if (idSesion == null || !("2".equals(rolSesion) || "EMPLEADO".equalsIgnoreCase(rolSesion))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String mensaje = null;
    String error = null;
    String cedula = request.getParameter("cedula");
    if (cedula != null) cedula = cedula.trim();

    int idAlquiler = 0;
    try { idAlquiler = Integer.parseInt(request.getParameter("id")); }
    catch (Exception ignored) { }

    if ("POST".equalsIgnoreCase(request.getMethod())
            && "devolver".equals(request.getParameter("accion"))) {
        String estadoVhs = request.getParameter("estado_vhs");

        if (!("DISPONIBLE".equals(estadoVhs) || "DANADO".equals(estadoVhs))) {
            error = "Seleccione un estado válido para el VHS.";
        } else if (idAlquiler < 1 || cedula == null || cedula.isBlank()) {
            error = "El alquiler o la cédula del cliente no son válidos.";
        } else {
            try (Connection con = ConexionDB.obtenerConexion()) {
                con.setAutoCommit(false);
                try {
                    int idVhs;
                    String buscar = "SELECT a.id_vhs FROM Alquiler a " +
                            "JOIN Usuario u ON u.id_usuario=a.id_usuario_cliente " +
                            "WHERE a.id_alquiler=? AND u.ced_usuario=? " +
                            "AND a.fecha_devolucion IS NULL FOR UPDATE";
                    try (PreparedStatement ps = con.prepareStatement(buscar)) {
                        ps.setInt(1, idAlquiler);
                        ps.setString(2, cedula);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) throw new SQLException("El alquiler no existe o ya fue devuelto.");
                            idVhs = rs.getInt("id_vhs");
                        }
                    }

                    String cerrar = "UPDATE Alquiler SET estado_alquiler=CASE " +
                            "WHEN fecha_limite<SYSDATE AND ?='DANADO' THEN 'TARDE DANADO' " +
                            "WHEN fecha_limite<SYSDATE THEN 'DEVUELTO TARDE' " +
                            "WHEN ?='DANADO' THEN 'DEVUELTO DANADO' ELSE 'DEVUELTO' END, " +
                            "fecha_devolucion=SYSDATE WHERE id_alquiler=? AND fecha_devolucion IS NULL";
                    try (PreparedStatement ps = con.prepareStatement(cerrar)) {
                        ps.setString(1, estadoVhs);
                        ps.setString(2, estadoVhs);
                        ps.setInt(3, idAlquiler);
                        if (ps.executeUpdate() != 1) throw new SQLException("No se pudo cerrar el alquiler.");
                    }

                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE Vhs SET estado_fisico_vhs=? WHERE id_vhs=?")) {
                        ps.setString(1, estadoVhs);
                        ps.setInt(2, idVhs);
                        if (ps.executeUpdate() != 1) throw new SQLException("No se pudo actualizar el VHS.");
                    }

                    con.commit();
                    mensaje = "Devolución registrada. El VHS quedó como " + estadoVhs + ".";
                } catch (Exception e) {
                    con.rollback();
                    error = e.getMessage();
                }
            } catch (SQLException e) {
                error = "No fue posible procesar la devolución: " + e.getMessage();
            }
        }
    }

    String cliente = null, pelicula = null, fechaLimite = null, estadoActualVhs = null;
    int idVhsDetalle = 0;
    boolean retrasado = false;

    if (idAlquiler > 0 && cedula != null && !cedula.isBlank() && mensaje == null) {
        String detalle = "SELECT c.primer_nombre_usuario || ' ' || c.primer_apellido_usuario cliente," +
                "p.titulo,a.id_vhs,v.estado_fisico_vhs,TO_CHAR(a.fecha_limite,'YYYY-MM-DD') fecha_limite," +
                "CASE WHEN a.fecha_limite<SYSDATE THEN 1 ELSE 0 END retrasado " +
                "FROM Alquiler a JOIN Usuario c ON c.id_usuario=a.id_usuario_cliente " +
                "JOIN Vhs v ON v.id_vhs=a.id_vhs JOIN Peliculas p ON p.id_pelicula=v.id_pelicula " +
                "WHERE a.id_alquiler=? AND c.ced_usuario=? AND a.fecha_devolucion IS NULL";
        try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(detalle)) {
            ps.setInt(1, idAlquiler);
            ps.setString(2, cedula);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cliente = rs.getString("cliente");
                    pelicula = rs.getString("titulo");
                    idVhsDetalle = rs.getInt("id_vhs");
                    estadoActualVhs = rs.getString("estado_fisico_vhs");
                    fechaLimite = rs.getString("fecha_limite");
                    retrasado = rs.getInt("retrasado") == 1;
                } else if (error == null) error = "No existe ese alquiler pendiente.";
            }
        } catch (SQLException e) { error = e.getMessage(); }
    }
%>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>Registrar devolución | Rewind &amp; Relive</title></head><body>
<nav class="navbar retro-window employee-nav">
<% request.setAttribute("adminPanelLogo", Boolean.TRUE); %><%@ include file="logo.jsp" %>
<ul class="nav-links"><li><a href="empleado-dashboard.jsp">Dashboard</a></li><li><a href="empleado-alquileres.jsp">Alquileres</a></li><li><a href="empleado-devolucion.jsp">Devolución</a></li><li><a href="empleado-inventario.jsp">Inventario</a></li><li><a href="empleado-usuarios.jsp">Usuarios</a></li><li><a href="empleado-alquilar.jsp">Nuevo alquiler</a></li></ul>
</nav>
<main class="employee-page">
<section class="employee-header"><p class="employee-kicker">Registro_Devolucion.exe</p><h1>Registrar devolución</h1><p>Busca al cliente, selecciona su alquiler activo y registra el estado de la copia.</p></section>
<% if(mensaje!=null){%><div class="employee-alert employee-alert-ok"><%=h(mensaje)%></div><%}%>
<% if(error!=null){%><div class="employee-alert employee-alert-error"><%=h(error)%></div><%}%>
<section class="employee-split"><article class="retro-window employee-panel"><div class="window-header"><span>Buscar_Cliente.form</span><span>_ [] X</span></div>
<form class="employee-form" method="get"><label>Cédula del cliente</label><div class="employee-inline-form"><input name="cedula" class="retro-search" value="<%=h(cedula)%>" required><button class="retro-button">BUSCAR</button></div></form>
<% if(cedula!=null&&!cedula.isBlank()&&mensaje==null){
String activos="SELECT a.id_alquiler,p.titulo,a.id_vhs,TO_CHAR(a.fecha_alquiler,'YYYY-MM-DD') fecha_alquiler,TO_CHAR(a.fecha_limite,'YYYY-MM-DD') fecha_limite FROM Alquiler a JOIN Usuario u ON u.id_usuario=a.id_usuario_cliente JOIN Vhs v ON v.id_vhs=a.id_vhs JOIN Peliculas p ON p.id_pelicula=v.id_pelicula WHERE u.ced_usuario=? AND a.fecha_devolucion IS NULL ORDER BY a.fecha_alquiler DESC";
try(Connection con=ConexionDB.obtenerConexion();PreparedStatement ps=con.prepareStatement(activos)){ps.setString(1,cedula);try(ResultSet rs=ps.executeQuery()){boolean hay=false;%>
<form class="employee-form" method="get"><input type="hidden" name="cedula" value="<%=h(cedula)%>"><div class="employee-table-wrap"><table class="employee-table"><thead><tr><th></th><th>ID</th><th>Película</th><th>VHS</th><th>Alquiler</th><th>Vence</th></tr></thead><tbody>
<%while(rs.next()){hay=true;%><tr><td><input type="radio" name="id" value="<%=rs.getInt("id_alquiler")%>" required></td><td>#<%=rs.getInt("id_alquiler")%></td><td><%=h(rs.getString("titulo"))%></td><td>#<%=rs.getInt("id_vhs")%></td><td><%=h(rs.getString("fecha_alquiler"))%></td><td><%=h(rs.getString("fecha_limite"))%></td></tr><%}%>
<%if(!hay){%><tr><td colspan="6">No tiene alquileres activos.</td></tr><%}%></tbody></table></div><%if(hay){%><button class="retro-button">SELECCIONAR</button><%}%></form>
<%}}catch(SQLException e){%><div class="employee-alert employee-alert-error"><%=h(e.getMessage())%></div><%}}%>
</article>
<%if(cliente!=null){%><article class="retro-window employee-panel"><div class="window-header"><span>Procesar_Devolucion.form</span><span>_ [] X</span></div><form class="employee-form" method="post"><input type="hidden" name="accion" value="devolver"><input type="hidden" name="id" value="<%=idAlquiler%>"><input type="hidden" name="cedula" value="<%=h(cedula)%>"><div class="employee-summary"><p><strong>Cliente:</strong> <%=h(cliente)%></p><p><strong>Película:</strong> <%=h(pelicula)%></p><p><strong>VHS:</strong> #<%=idVhsDetalle%> - <%=h(estadoActualVhs)%></p><p><strong>Fecha límite:</strong> <%=h(fechaLimite)%></p><p><strong>Retraso:</strong> <%=retrasado?"Sí":"No"%></p></div><label>Estado al devolver</label><select name="estado_vhs" class="retro-search" required><option value="DISPONIBLE">Buen estado / Disponible</option><option value="DANADO">Dañado</option></select><button class="retro-button employee-submit">PROCESAR DEVOLUCIÓN</button></form></article><%}%>
</section><%if(mensaje!=null){%><a href="empleado-alquileres.jsp?vista=historial" class="retro-button">VER HISTORIAL</a><%}%>
</main><%@ include file="footer.jsp" %><script src="${pageContext.request.contextPath}/js/script.js"></script></body></html>
