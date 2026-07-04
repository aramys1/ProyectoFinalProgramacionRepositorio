<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,com.conexion.ConexionDB" %>
<%!
    private String h(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private String posterPath(String value) {
        if (value == null) return "";
        String path = value.trim().replace('\\', '/');
        while (path.startsWith("/")) path = path.substring(1);
        if (path.startsWith("recursos/")) path = path.substring("recursos/".length());
        return path;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/empleado-inventario.css">
    <title>Inventario | Rewind &amp; Relive</title>
</head>
<body>
<nav class="navbar retro-window employee-nav">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolución</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-usuarios.jsp">Usuarios</a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Inventario.catalog</p>
        <h1>Inventario de películas</h1>
        <p>Películas y copias registradas actualmente en la base de datos.</p>
    </section>

    <form class="inventory-catalog-toolbar" method="get">
        <input type="text" name="buscar" class="retro-search" placeholder="Buscar película por título"
               value="<%= h(request.getParameter("buscar")) %>">
        <button type="submit" class="retro-button">FILTRAR</button>
    </form>

    <section class="inventory-catalog-grid">
        <%
            String buscar = request.getParameter("buscar");
            String sql = "SELECT p.id_pelicula, p.titulo, p.imagen_url, " +
                    "TO_CHAR(p.fecha_estreno, 'YYYY') anio, " +
                    "COUNT(v.id_vhs) total, " +
                    "SUM(CASE WHEN UPPER(v.estado_fisico_vhs) IN ('DISPONIBLE','BUENO','BUEN ESTADO') THEN 1 ELSE 0 END) disponibles " +
                    "FROM Peliculas p LEFT JOIN Vhs v ON v.id_pelicula=p.id_pelicula " +
                    "WHERE (? IS NULL OR LOWER(p.titulo) LIKE ?) " +
                    "GROUP BY p.id_pelicula,p.titulo,p.imagen_url,p.fecha_estreno ORDER BY p.titulo";
            try (Connection con = ConexionDB.obtenerConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                String filtro = buscar == null || buscar.isBlank() ? null : buscar.trim().toLowerCase();
                ps.setString(1, filtro);
                ps.setString(2, filtro == null ? null : "%" + filtro + "%");
                try (ResultSet rs = ps.executeQuery()) {
                    boolean hayPeliculas = false;
                    while (rs.next()) {
                        hayPeliculas = true;
                        int id = rs.getInt("id_pelicula");
                        String imagen = rs.getString("imagen_url");
        %>
        <article class="retro-window inventory-card">
            <div class="window-header"><span>PELÍCULA_<%= id %>.vhs</span><span>_ [] X</span></div>
            <% if (imagen != null && !imagen.isBlank()) { %>
            <img src="<%= request.getContextPath() %>/recursos/<%= h(posterPath(imagen)) %>" alt="Póster de <%= h(rs.getString("titulo")) %>" class="inventory-card-img">
            <% } else { %>
            <div class="inventory-card-img placeholder-img" role="img" aria-label="Película sin póster"></div>
            <% } %>
            <div class="inventory-card-body">
                <h2><%= h(rs.getString("titulo")) %></h2>
                <p><%= h(rs.getString("anio")) %></p>
                <p><strong>Copias:</strong> <%= rs.getInt("total") %></p>
                <a class="retro-button btn-full inventory-edit-link"
                   href="empleado-pelicula-editar.jsp?id=<%= id %>">EDITAR</a>
            </div>
        </article>
        <%
                    }
                    if (!hayPeliculas) {
        %><p class="inventory-empty">No se encontraron películas.</p><%
                    }
                }
            } catch (SQLException e) {
        %><p class="inventory-error">No fue posible cargar el inventario: <%= h(e.getMessage()) %></p><%
            }
        %>
    </section>
</main>

<%@ include file="footer.jsp" %>
<script src="${pageContext.request.contextPath}/js/script.js?v=3"></script>
</body>
</html>
