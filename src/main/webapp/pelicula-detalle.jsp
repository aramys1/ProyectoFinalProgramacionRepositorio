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
    int idPelicula = 0;
    try { idPelicula = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) { }
    String titulo=null, imagen=null, anio=null, sinopsis=null;
    java.math.BigDecimal precio=null;
    int disponibles=0;
    String sql = "SELECT p.titulo,p.imagen_url,p.sinopsis,p.precio_unidad,TO_CHAR(p.fecha_estreno,'YYYY') anio," +
            "SUM(CASE WHEN UPPER(v.estado_fisico_vhs)='DISPONIBLE' THEN 1 ELSE 0 END) disponibles " +
            "FROM Peliculas p LEFT JOIN Vhs v ON v.id_pelicula=p.id_pelicula WHERE p.id_pelicula=? " +
            "GROUP BY p.titulo,p.imagen_url,p.sinopsis,p.precio_unidad,p.fecha_estreno";
    try (Connection con=ConexionDB.obtenerConexion(); PreparedStatement ps=con.prepareStatement(sql)) {
        ps.setInt(1,idPelicula);
        try (ResultSet rs=ps.executeQuery()) { if (rs.next()) {
            titulo=rs.getString("titulo"); imagen=rs.getString("imagen_url"); sinopsis=rs.getString("sinopsis");
            precio=rs.getBigDecimal("precio_unidad"); anio=rs.getString("anio"); disponibles=rs.getInt("disponibles");
        }}
    } catch (SQLException ignored) { }
    boolean clienteAutenticado = session.getAttribute("idUsuario") != null &&
            ("1".equals(String.valueOf(session.getAttribute("rolUsuario"))) ||
             "CLIENTE".equalsIgnoreCase(String.valueOf(session.getAttribute("rolUsuario"))));
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title><%= titulo == null ? "Pelicula" : h(titulo) %> | Rewind &amp; Relive</title></head><body>
<nav class="navbar retro-window"><%@ include file="logo.jsp" %><ul class="nav-links">
    <li><a href="catalogo.jsp">Catalogo</a></li><li><a href="novedades.jsp">Novedades</a></li><li><a href="contactanos.jsp">Contactanos</a></li>
    <% if (clienteAutenticado) { %><li><a href="cliente-carrito.jsp" class="retro-button">Mi Carrito</a></li>
    <% } else { %><li><a href="login.jsp" class="retro-button">Iniciar Sesion</a></li><% } %>
</ul></nav>
<main class="movie-detail-page">
<% if (titulo == null) { %>
    <div class="employee-alert employee-alert-error">No se encontro la pelicula solicitada.</div>
<% } else { %>
    <section class="movie-detail-hero">
        <article class="retro-window movie-poster-window"><div class="window-header"><span><%= h(titulo) %>.vhs</span><span>_ [] X</span></div>
            <% if (imagen != null && !imagen.isBlank()) { %><img src="recursos/<%= h(imagen) %>" alt="Poster de <%= h(titulo) %>" class="movie-detail-poster">
            <% } else { %><div class="placeholder-img movie-detail-poster"></div><% } %>
        </article>
        <article class="movie-detail-copy"><p class="employee-kicker">Ficha de pelicula</p><h1><%= h(titulo) %></h1>
            <p class="movie-detail-meta"><%= h(anio) %> | $<%= precio %> / dia</p><p class="movie-synopsis"><%= h(sinopsis) %></p>
            <p><strong>Copias disponibles:</strong> <%= disponibles %></p>
            <div class="employee-form-actions">
                <% if (clienteAutenticado && disponibles > 0) { %>
                <form method="post" action="cliente-carrito.jsp"><input type="hidden" name="accion" value="agregar"><input type="hidden" name="id_pelicula" value="<%= idPelicula %>"><button class="retro-button btn-rent" type="submit">AGREGAR AL CARRITO</button></form>
                <% } else if (!clienteAutenticado) { %><a class="retro-button btn-rent" href="login.jsp">INICIAR SESION PARA ALQUILAR</a>
                <% } else { %><button class="retro-button" type="button" disabled>SIN COPIAS DISPONIBLES</button><% } %>
                <a class="retro-button employee-cancel" href="catalogo.jsp">VOLVER AL CATALOGO</a>
            </div>
        </article>
    </section>
<% } %>
</main><%@ include file="footer.jsp" %><script src="${pageContext.request.contextPath}/js/script.js"></script></body></html>
