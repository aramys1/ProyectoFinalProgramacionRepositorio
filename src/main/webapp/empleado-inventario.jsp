<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.util.*,com.conexion.ConexionDB" %>
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
    private int entero(String value, int defecto) {
        try { return Integer.parseInt(value); } catch (Exception e) { return defecto; }
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    String errorCreacion = null;
    if ("POST".equalsIgnoreCase(request.getMethod()) && "crear".equals(request.getParameter("accion"))) {
        try (Connection con = ConexionDB.obtenerConexion()) {
            con.setAutoCommit(false);
            try {
                String titulo = request.getParameter("titulo");
                String fecha = request.getParameter("fechaEstreno");
                String precio = request.getParameter("precio");
                String sinopsis = request.getParameter("sinopsis");
                String imagen = request.getParameter("imagenUrl");
                int clasificacion = entero(request.getParameter("clasificacion"), -1);
                int copias = entero(request.getParameter("copias"), 0);
                String estado = request.getParameter("estadoInicial");
                if (titulo == null || titulo.isBlank() || fecha == null || fecha.isBlank()
                        || precio == null || precio.isBlank() || sinopsis == null || sinopsis.isBlank()
                        || clasificacion < 1 || copias < 0 || copias > 100) {
                    throw new SQLException("Complete los campos obligatorios; las copias deben estar entre 0 y 100.");
                }
                if (estado == null || estado.isBlank()) estado = "DISPONIBLE";

                int nuevoId;
                try (PreparedStatement ps = con.prepareStatement("SELECT seq_pelicula.NEXTVAL FROM dual");
                     ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new SQLException("No se pudo generar el ID de la película.");
                    nuevoId = rs.getInt(1);
                }
                try (PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO Peliculas(id_pelicula,titulo,precio_unidad,fecha_estreno,sinopsis,imagen_url,id_clasificacion) VALUES(?,?,?,?,?,?,?)")) {
                    ps.setInt(1, nuevoId);
                    ps.setString(2, titulo.trim());
                    ps.setBigDecimal(3, new java.math.BigDecimal(precio));
                    ps.setDate(4, java.sql.Date.valueOf(fecha));
                    ps.setString(5, sinopsis.trim());
                    ps.setString(6, imagen == null || imagen.isBlank() ? null : posterPath(imagen));
                    ps.setInt(7, clasificacion);
                    ps.executeUpdate();
                }

                String[] generos = request.getParameterValues("generos");
                if (generos != null) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO PeliculasGeneros(id_genero,id_pelicula,prioridad) SELECT id_genero,?,? FROM Genero WHERE id_genero=?")) {
                        int prioridad = 1;
                        for (String genero : generos) {
                            ps.setInt(1, nuevoId);
                            ps.setInt(2, prioridad++);
                            ps.setInt(3, entero(genero, -1));
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }
                try (PreparedStatement ps = con.prepareStatement("INSERT INTO Vhs(estado_fisico_vhs,id_pelicula) VALUES(?,?)")) {
                    for (int i = 0; i < copias; i++) {
                        ps.setString(1, estado.trim().toUpperCase());
                        ps.setInt(2, nuevoId);
                        ps.addBatch();
                    }
                    if (copias > 0) ps.executeBatch();
                }
                con.commit();
                response.sendRedirect("empleado-pelicula-editar.jsp?id=" + nuevoId + "&creada=1");
                return;
            } catch (Exception e) {
                con.rollback();
                errorCreacion = e.getMessage();
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            errorCreacion = e.getMessage();
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
        <li><a href="empleado-alquilar.jsp">Nuevo Alquiler</a></li>
    </ul>
</nav>

<main class="employee-page" data-inventory-template>
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

    <% if (errorCreacion != null) { %>
    <p class="inventory-error" role="alert">No se pudo crear la película: <%= h(errorCreacion) %></p>
    <% } %>

    <section class="inventory-catalog-grid">
        <article class="retro-window inventory-add-card">
            <div class="window-header"><span>Nueva_Película.form</span><span>_ [] X</span></div>
            <div class="inventory-add-body">
                <strong>Agregar película</strong>
                <p>Registrar una película y sus copias iniciales en la base de datos.</p>
                <button type="button" class="retro-button" data-add-movie-toggle>AGREGAR</button>
            </div>
        </article>
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

    <section class="retro-window employee-panel inventory-add-panel" data-add-movie-panel <%= errorCreacion == null ? "hidden" : "" %>>
        <div class="window-header"><span>Agregar_Película.form</span><span>_ [] X</span></div>
        <form class="employee-form employee-movie-form inventory-create-form" method="post">
            <input type="hidden" name="accion" value="crear">
            <div class="employee-form-grid">
                <label>Título *<input class="retro-search" name="titulo" required value="<%= h(request.getParameter("titulo")) %>"></label>
                <label>Fecha de estreno *<input class="retro-search" type="date" name="fechaEstreno" required value="<%= h(request.getParameter("fechaEstreno")) %>"></label>
                <label>Precio por unidad *<input class="retro-search" type="number" min="0" step="0.01" name="precio" required value="<%= h(request.getParameter("precio")) %>"></label>
                <label>Clasificación *
                    <select class="retro-search" name="clasificacion" required>
                        <option value="">Seleccione</option>
                        <% try (Connection con = ConexionDB.obtenerConexion();
                               PreparedStatement ps = con.prepareStatement("SELECT id_clasificacion,desc_clasificacion FROM Clasificacion ORDER BY edad_minima");
                               ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) { String valor = String.valueOf(rs.getInt(1)); %>
                        <option value="<%= valor %>" <%= valor.equals(request.getParameter("clasificacion")) ? "selected" : "" %>><%= h(rs.getString(2)) %></option>
                        <% }} catch (SQLException e) { %><option value="">Error al cargar clasificaciones</option><% } %>
                    </select>
                </label>
                <label>Copias iniciales *<input class="retro-search" type="number" min="0" max="100" name="copias" required value="<%= request.getParameter("copias") == null ? "0" : h(request.getParameter("copias")) %>"></label>
                <label>Estado inicial *<input class="retro-search" name="estadoInicial" required value="<%= request.getParameter("estadoInicial") == null ? "DISPONIBLE" : h(request.getParameter("estadoInicial")) %>"></label>
                <label class="employee-full-field">Ruta de imagen
                    <input class="retro-search" name="imagenUrl" value="<%= h(request.getParameter("imagenUrl")) %>" placeholder="posters/pelicula.jpg">
                </label>
                <fieldset class="employee-full-field inventory-genres">
                    <legend>Géneros</legend>
                    <% Set<String> generosFormulario = request.getParameterValues("generos") == null
                            ? Collections.emptySet() : new HashSet<>(Arrays.asList(request.getParameterValues("generos")));
                       try (Connection con = ConexionDB.obtenerConexion();
                            PreparedStatement ps = con.prepareStatement("SELECT id_genero,desc_genero FROM Genero ORDER BY desc_genero");
                            ResultSet rs = ps.executeQuery()) {
                           while (rs.next()) { String valor = String.valueOf(rs.getInt(1)); %>
                    <label><input type="checkbox" name="generos" value="<%= valor %>" <%= generosFormulario.contains(valor) ? "checked" : "" %>> <%= h(rs.getString(2)) %></label>
                    <% }} catch (SQLException e) { %><span>No se pudieron cargar los géneros.</span><% } %>
                </fieldset>
                <label class="employee-full-field">Sinopsis *
                    <textarea class="retro-search employee-textarea" name="sinopsis" required><%= h(request.getParameter("sinopsis")) %></textarea>
                </label>
            </div>
            <div class="employee-form-actions">
                <button type="submit" class="retro-button">GUARDAR PELÍCULA</button>
                <button type="button" class="retro-button employee-cancel" data-add-movie-toggle>CANCELAR</button>
            </div>
        </form>
    </section>
</main>

<%@ include file="footer.jsp" %>
<script src="${pageContext.request.contextPath}/js/script.js?v=3"></script>
</body>
</html>
