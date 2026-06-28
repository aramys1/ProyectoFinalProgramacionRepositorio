<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Rewind & Relive | Catálogo</title>
</head>
<body>

<nav class="navbar retro-window">
    <div class="logo">
        <a href="index.jsp" class="logo-link">Rewind & Relive</a>
    </div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li><button class="retro-button btn-register">Registrarse</button></li>
    </ul>
</nav>

<div class="content-section catalog-container">

    <div class="search-section">
        <div class="filter-form">
            <input type="text" class="retro-search" placeholder="Buscar por título...">
            <select class="retro-search select-filter">
                <option value="">Géneros</option>
                <option value="Accion">Acción</option>
                <option value="Terror">Terror</option>
                <option value="Comedia">Comedia</option>
            </select>
            <button class="retro-button">FILTRAR</button>
        </div>
    </div>

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
                <div class="window-header">
                    <span><%= nombreArchivo %></span>
                    <span>_ □ X</span>
                </div>
                <% if (imagen != null && !imagen.isEmpty()) { %>
                <img src="recursos/<%= imagen %>" alt="<%= titulo %>" class="card-img">
                <% } else { %>
                <div class="placeholder-img card-img"></div>
                <% } %>
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
            } catch (SQLException e) { %>
            <p style="color:red;">Error: <%= e.getMessage() %></p>
            <% } %>
        </div>
    </section>

</div>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-col">
            <h4>Rewind & Relive</h4>
            <p>El hogar de los clásicos.</p>
        </div>
        <div class="footer-col">
            <h4>Navegación</h4>
            <ul>
                <li><a href="catalogo.jsp">Catálogo</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Contacto</h4>
            <p>📍 Av. VHS, #1980</p>
        </div>
    </div>
    <div class="copyright">
        © 2026 Rewind & Relive.
    </div>
</footer>

</body>
</html>