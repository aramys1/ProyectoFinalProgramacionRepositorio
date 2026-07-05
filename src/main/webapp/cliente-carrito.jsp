<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.util.*,com.conexion.ConexionDB" %>
<%!
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    Object idSesion = session.getAttribute("idUsuario");
    String rolSesion = String.valueOf(session.getAttribute("rolUsuario"));
    if (idSesion == null || !("1".equals(rolSesion) || "CLIENTE".equalsIgnoreCase(rolSesion))) {
        response.sendRedirect("login.jsp"); return;
    }
    @SuppressWarnings("unchecked")
    List<Integer> carrito = (List<Integer>) session.getAttribute("carritoPeliculas");
    if (carrito == null) {
        carrito = new ArrayList<Integer>();
        session.setAttribute("carritoPeliculas", carrito);
    }
    String mensaje = null, error = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String accion = request.getParameter("accion");
        int idPelicula = 0;
        try { idPelicula = Integer.parseInt(request.getParameter("id_pelicula")); }
        catch (Exception ignored) { }
        if ("quitar".equals(accion)) {
            carrito.remove(Integer.valueOf(idPelicula));
            mensaje = "Pelicula eliminada del carrito.";
        } else if ("vaciar".equals(accion)) {
            carrito.clear();
            mensaje = "Carrito vaciado.";
        } else if ("agregar".equals(accion)) {
            if (carrito.contains(idPelicula)) error = "La pelicula ya esta en el carrito.";
            else if (carrito.size() >= 3) error = "El carrito permite un maximo de 3 peliculas.";
            else {
                String sqlDisponible = "SELECT COUNT(*) FROM Vhs WHERE id_pelicula=? AND UPPER(estado_fisico_vhs)='DISPONIBLE'";
                try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(sqlDisponible)) {
                    ps.setInt(1, idPelicula);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            carrito.add(idPelicula);
                            mensaje = "Pelicula agregada al carrito.";
                        } else error = "La pelicula seleccionada no tiene copias disponibles.";
                    }
                } catch (SQLException e) { error = "No fue posible consultar la disponibilidad: " + e.getMessage(); }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Carrito VHS | Rewind &amp; Relive</title>
</head>
<body>
<nav class="navbar retro-window">
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="index.jsp">Inicio</a></li><li><a href="catalogo.jsp">Catalogo</a></li>
        <li><a href="cliente-perfil.jsp">Mi Perfil</a></li><li><a href="cliente-historial.jsp">Mi Historial</a></li>
    </ul>
</nav>
<main class="account-page">
    <section class="employee-header">
        <p class="employee-kicker">Orden de alquiler</p><h1>Mi carrito</h1>
        <p>Peliculas seleccionadas y disponibilidad actual en la base de datos.</p>
    </section>
    <% if (mensaje != null) { %><div class="employee-alert employee-alert-ok"><%= h(mensaje) %></div><% } %>
    <% if (error != null) { %><div class="employee-alert employee-alert-error"><%= h(error) %></div><% } %>
    <section class="retro-window employee-panel">
        <div class="window-header"><span>carrito_actual.table</span><span>_ [] X</span></div>
        <div class="employee-table-wrap"><table class="employee-table">
            <thead><tr><th>#</th><th>Pelicula</th><th>Precio dia</th><th>Disponibles</th><th>Accion</th></tr></thead>
            <tbody>
            <%
                java.math.BigDecimal total = java.math.BigDecimal.ZERO;
                if (carrito.isEmpty()) {
            %><tr><td colspan="5" class="employee-empty">El carrito esta vacio.</td></tr><%
                } else {
                    StringBuilder marcas = new StringBuilder();
                    for (int i=0; i<carrito.size(); i++) marcas.append(i == 0 ? "?" : ",?");
                    String sql = "SELECT p.id_pelicula,p.titulo,p.precio_unidad," +
                            "SUM(CASE WHEN UPPER(v.estado_fisico_vhs)='DISPONIBLE' THEN 1 ELSE 0 END) disponibles " +
                            "FROM Peliculas p LEFT JOIN Vhs v ON v.id_pelicula=p.id_pelicula " +
                            "WHERE p.id_pelicula IN (" + marcas + ") GROUP BY p.id_pelicula,p.titulo,p.precio_unidad ORDER BY p.titulo";
                    try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
                        for (int i=0; i<carrito.size(); i++) ps.setInt(i+1, carrito.get(i));
                        try (ResultSet rs = ps.executeQuery()) { int numero=1; while (rs.next()) {
                            java.math.BigDecimal precio = rs.getBigDecimal("precio_unidad"); total = total.add(precio);
            %><tr>
                <td><%= numero++ %></td><td><%= h(rs.getString("titulo")) %></td><td>$<%= precio %></td>
                <td><span class="status-badge <%= rs.getInt("disponibles") > 0 ? "status-ok" : "status-danger" %>"><%= rs.getInt("disponibles") %></span></td>
                <td><form method="post"><input type="hidden" name="accion" value="quitar"><input type="hidden" name="id_pelicula" value="<%= rs.getInt("id_pelicula") %>"><button class="employee-mini-button" type="submit">Quitar</button></form></td>
            </tr><%      }}
                    } catch (SQLException e) { %><tr><td colspan="5">No fue posible cargar el carrito: <%= h(e.getMessage()) %></td></tr><% }
                }
            %>
            </tbody>
        </table></div>
    </section>
    <section class="employee-actions">
        <a class="retro-button employee-action" href="catalogo.jsp">Agregar peliculas</a>
        <% if (!carrito.isEmpty()) { %><form method="post"><input type="hidden" name="accion" value="vaciar"><button class="retro-button employee-action" type="submit">Vaciar carrito</button></form><% } %>
        <span class="account-limit">Total por dia: $<%= total %> | Espacios disponibles: <%= 3-carrito.size() %> / 3</span>
    </section>
</main>
<%@ include file="footer.jsp" %>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
