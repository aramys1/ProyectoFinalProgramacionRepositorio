<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Rewind & Relive | Catálogo</title>
</head>
<body>

<nav class="navbar retro-window">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo-link">Rewind & Relive</a>
    </div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp" class="active">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp" class="retro-button btn-register">Iniciar Sesión</a></li>
    </ul>
</nav>

<div class="content-section catalog-container">
    <section class="releases">
        <h2>Catálogo de VHS</h2>
        <div class="release-grid catalog-grid">
            <%
                int contador = 1;
                try (Connection con = ConexionDB.obtenerConexion();
                     PreparedStatement ps = con.prepareStatement(
                             "SELECT p.id_pelicula, p.titulo, p.precio_unidad, p.imagen_url, " +
                             "TO_CHAR(p.fecha_estreno, 'YYYY') AS anio FROM Peliculas p"
                     );
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        String titulo = rs.getString("titulo");
                        String precio = rs.getString("precio_unidad");
                        String anio = rs.getString("anio");
                        String imagen = rs.getString("imagen_url");
                        int idPelicula = rs.getInt("id_pelicula");
                        String nombreArchivo = "VHS_" + String.format("%03d", contador) + ".vhs";
            %>
            <div class="retro-window release-card">
                <div class="window-header"><span><%= nombreArchivo %></span></div>
                <img src="${pageContext.request.contextPath}/recursos/<%= imagen %>" alt="<%= titulo %>" class="card-img">
                <div class="card-body">
                    <h3 class="card-title"><%= titulo %></h3>
                    <p class="card-meta">Año: <%= anio %></p>
                    <p class="card-price">$<%= precio %> / 48hrs</p>
                    <a href="pelicula-detalle.jsp?id=<%= idPelicula %>">
                        <button class="retro-button btn-rent btn-full">ALQUILAR</button>
                    </a>
                </div>
            </div>
            <%
                        contador++;
                    }
                } catch (Exception e) { 
                    out.println("<p style='color:red;'>Error al cargar el catálogo: " + e.getMessage() + "</p>");
                } 
            %>
        </div>
    </section>
</div>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>