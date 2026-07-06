<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,com.conexion.ConexionDB" %>

<%--
    Acceso a datos del catálogo:
    - Peliculas contiene título, precio, estreno e imagen.
    - PeliculasGeneros relaciona cada película con Genero.
    - PreparedStatement mantiene separados SQL y valores del usuario.
    - try-with-resources cierra los recursos JDBC automáticamente.
--%>
<%!
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String posterPath(String valor) {
        if (valor == null) return "";

        String ruta = valor.trim().replace('\\', '/');
        while (ruta.startsWith("/")) {
            ruta = ruta.substring(1);
        }
        if (ruta.startsWith("recursos/")) {
            ruta = ruta.substring("recursos/".length());
        }
        return ruta;
    }
%>

<%
    // Solo se admiten los modos conocidos; cualquier otro valor vuelve a nombre.
    String tipoBusqueda = "genero".equalsIgnoreCase(request.getParameter("tipo"))
            ? "genero"
            : "nombre";

    String busqueda = request.getParameter("buscar");
    if (busqueda != null) {
        busqueda = busqueda.trim();
    }

    // Los signos % permiten coincidencias parciales mediante LIKE.
    String filtro = busqueda == null || busqueda.isBlank()
            ? null
            : "%" + busqueda.toLowerCase() + "%";
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=8">
    <title>Rewind &amp; Relive | Catálogo</title>
</head>

<body>

    <nav class="navbar retro-window">
        <%@ include file="logo.jsp" %>
        <ul class="nav-links">
            <li><a href="catalogo.jsp">Catálogo</a></li>
            <li><a href="novedades.jsp">Novedades</a></li>
            <li><a href="contactanos.jsp">Contáctanos</a></li>

            <%
            boolean clienteAutenticado = session.getAttribute("idUsuario") != null
                    && ("1".equals(String.valueOf(session.getAttribute("rolUsuario")))
                    || "CLIENTE".equalsIgnoreCase(String.valueOf(session.getAttribute("rolUsuario"))));

            if (clienteAutenticado) {
        %>
            <li><a href="cliente-carrito.jsp" class="retro-button">Mi carrito</a></li>
            <% } else if (session.getAttribute("idUsuario") == null) { %>
            <li><a href="login.jsp" class="retro-button">Iniciar sesión</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="content-section catalog-container">
        <%-- El método GET conserva la búsqueda en la URL y permite compartirla. --%>
        <div class="search-section">
            <form class="filter-form" method="get" action="catalogo.jsp">
                <select class="retro-search select-filter" name="tipo" aria-label="Buscar por">
                    <option value="nombre" <%= "nombre".equals(tipoBusqueda) ? "selected" : "" %>>Nombre</option>
                    <option value="genero" <%= "genero".equals(tipoBusqueda) ? "selected" : "" %>>Género</option>
                </select>

                <input type="text" name="buscar" class="retro-search" value="<%= h(busqueda) %>" placeholder="Escribe un nombre o género...">

                <button type="submit" class="retro-button">BUSCAR</button>

                <% if (filtro != null) { %>
                <a class="employee-clear" href="catalogo.jsp">Limpiar</a>
                <% } %>
            </form>
        </div>

        <section class="releases">
            <h1 class="glitch-title">Catálogo de VHS</h1>

            <div class="release-grid catalog-grid">
                <%
                String sql = "SELECT p.id_pelicula, p.titulo, p.precio_unidad, p.imagen_url, "
                        + "TO_CHAR(p.fecha_estreno, 'YYYY') anio FROM Peliculas p ";

                if (filtro != null) {
                    if ("genero".equals(tipoBusqueda)) {
                        // EXISTS evita duplicar películas que tengan varios géneros coincidentes.
                        sql += "WHERE EXISTS ("
                                + "SELECT 1 FROM PeliculasGeneros pg "
                                + "JOIN Genero g ON g.id_genero=pg.id_genero "
                                + "WHERE pg.id_pelicula=p.id_pelicula "
                                + "AND LOWER(g.desc_genero) LIKE ?) ";
                    } else {
                        sql += "WHERE LOWER(p.titulo) LIKE ? ";
                    }
                }
                sql += "ORDER BY p.titulo";

                int contador = 1;

                try (Connection con = ConexionDB.obtenerConexion();
                     PreparedStatement ps = con.prepareStatement(sql)) {

                    if (filtro != null) {
                        ps.setString(1, filtro);
                    }

                    try (ResultSet rs = ps.executeQuery()) {
                        boolean hayPeliculas = false;

                        while (rs.next()) {
                            hayPeliculas = true;
                            String imagen = rs.getString("imagen_url");
            %>
                <article class="retro-window release-card">
                    <div class="window-header">
                        <span>VHS_<%= String.format("%03d", contador++) %>.vhs</span>
                        <span>_ [] X</span>
                    </div>

                    <% if (imagen != null && !imagen.isBlank()) { %>
                    <img src="<%= request.getContextPath() %>/recursos/<%= h(posterPath(imagen)) %>" alt="<%= h(rs.getString("titulo")) %>" class="card-img">
                    <% } else { %>
                    <div class="placeholder-img card-img"></div>
                    <% } %>

                    <div class="card-body">
                        <h3 class="card-title"><%= h(rs.getString("titulo")) %></h3>
                        <p class="card-meta">Año: <%= h(rs.getString("anio")) %></p>
                        <p class="card-price">$<%= rs.getBigDecimal("precio_unidad") %> / día</p>
                        <a href="pelicula-detalle.jsp?id=<%= rs.getInt("id_pelicula") %>" class="retro-button btn-rent btn-full">ALQUILAR PELÍCULA</a>
                    </div>
                </article>
                <%
                        }

                        if (!hayPeliculas) {
            %>
                <p class="employee-empty">
                    No se encontraron películas por
                    <%= "genero".equals(tipoBusqueda) ? "ese género" : "ese nombre" %>.
                </p>
                <%
                        }
                    }
                } catch (SQLException e) {
            %>
                <div class="employee-alert employee-alert-error">
                    No fue posible buscar películas: <%= h(e.getMessage()) %>
                </div>
                <% } %>
            </div>
        </section>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js?v=7"></script>
</body>

</html>