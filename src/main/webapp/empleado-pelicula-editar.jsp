<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.util.*,com.conexion.ConexionDB" %>
<%!
    private String h(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private int entero(String value, int defecto) {
        try { return Integer.parseInt(value); } catch (Exception e) { return defecto; }
    }
    private String posterPath(String value) {
        if (value == null) return "";
        String path = value.trim().replace('\\', '/');
        while (path.startsWith("/")) path = path.substring(1);
        if (path.startsWith("recursos/")) path = path.substring("recursos/".length());
        return path;
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    int idPelicula = entero(request.getParameter("id"), -1);
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod()) && idPelicula > 0) {
        try (Connection con = ConexionDB.obtenerConexion()) {
            con.setAutoCommit(false);
            try {
                String titulo = request.getParameter("titulo");
                String fecha = request.getParameter("fechaEstreno");
                String sinopsis = request.getParameter("sinopsis");
                String imagen = request.getParameter("imagenUrl");
                String precioTexto = request.getParameter("precio");
                int clasificacion = entero(request.getParameter("clasificacion"), -1);
                if (titulo == null || titulo.isBlank() || fecha == null || fecha.isBlank()
                        || sinopsis == null || sinopsis.isBlank() || precioTexto == null || precioTexto.isBlank()
                        || clasificacion < 1) {
                    throw new SQLException("Complete todos los datos obligatorios de la película.");
                }

                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE Peliculas SET titulo=?, precio_unidad=?, fecha_estreno=?, sinopsis=?, imagen_url=?, id_clasificacion=? WHERE id_pelicula=?")) {
                    ps.setString(1, titulo.trim());
                    ps.setBigDecimal(2, new java.math.BigDecimal(precioTexto));
                    ps.setDate(3, java.sql.Date.valueOf(fecha));
                    ps.setString(4, sinopsis.trim());
                    ps.setString(5, imagen == null || imagen.isBlank() ? null : imagen.trim());
                    ps.setInt(6, clasificacion);
                    ps.setInt(7, idPelicula);
                    if (ps.executeUpdate() == 0) throw new SQLException("La película indicada no existe.");
                }

                try (PreparedStatement ps = con.prepareStatement("DELETE FROM PeliculasGeneros WHERE id_pelicula=?")) {
                    ps.setInt(1, idPelicula);
                    ps.executeUpdate();
                }
                String[] generos = request.getParameterValues("generos");
                if (generos != null) {
                    int prioridad = 1;
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO PeliculasGeneros(id_genero,id_pelicula,prioridad) " +
                                    "SELECT id_genero,?,? FROM Genero WHERE id_genero=?")) {
                        for (String genero : generos) {
                            ps.setInt(1, idPelicula);
                            ps.setInt(2, prioridad++);
                            ps.setInt(3, entero(genero, -1));
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }

                try (PreparedStatement buscarCopias = con.prepareStatement("SELECT id_vhs FROM Vhs WHERE id_pelicula=?");
                     PreparedStatement actualizar = con.prepareStatement("UPDATE Vhs SET estado_fisico_vhs=? WHERE id_vhs=? AND id_pelicula=?");
                     PreparedStatement eliminar = con.prepareStatement(
                             "DELETE FROM Vhs v WHERE v.id_vhs=? AND v.id_pelicula=? " +
                                     "AND NOT EXISTS (SELECT 1 FROM Alquiler a WHERE a.id_vhs=v.id_vhs)")) {
                    buscarCopias.setInt(1, idPelicula);
                    try (ResultSet copias = buscarCopias.executeQuery()) {
                        while (copias.next()) {
                            int idVhs = copias.getInt(1);
                            if (request.getParameter("eliminar_" + idVhs) != null) {
                                eliminar.setInt(1, idVhs);
                                eliminar.setInt(2, idPelicula);
                                eliminar.executeUpdate();
                            } else {
                                String estado = request.getParameter("estado_" + idVhs);
                                if (estado != null && !estado.isBlank()) {
                                    actualizar.setString(1, estado.trim().toUpperCase());
                                    actualizar.setInt(2, idVhs);
                                    actualizar.setInt(3, idPelicula);
                                    actualizar.executeUpdate();
                                }
                            }
                        }
                    }
                }

                int nuevasCopias = entero(request.getParameter("nuevasCopias"), 0);
                if (nuevasCopias < 0 || nuevasCopias > 100) throw new SQLException("La cantidad de copias nuevas debe estar entre 0 y 100.");
                String estadoNuevo = request.getParameter("estadoNuevo");
                if (estadoNuevo == null || estadoNuevo.isBlank()) estadoNuevo = "DISPONIBLE";
                try (PreparedStatement ps = con.prepareStatement("INSERT INTO Vhs(estado_fisico_vhs,id_pelicula) VALUES(?,?)")) {
                    for (int i = 0; i < nuevasCopias; i++) {
                        ps.setString(1, estadoNuevo.trim().toUpperCase());
                        ps.setInt(2, idPelicula);
                        ps.addBatch();
                    }
                    if (nuevasCopias > 0) ps.executeBatch();
                }

                con.commit();
                response.sendRedirect("empleado-pelicula-editar.jsp?id=" + idPelicula + "&guardado=1");
                return;
            } catch (Exception e) {
                con.rollback();
                error = e.getMessage();
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            error = e.getMessage();
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
    <title>Editar película | Rewind &amp; Relive</title>
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

<main class="employee-page">
<%
    if (idPelicula < 1) {
%>
    <section class="retro-window employee-panel inventory-editor-message">
        <div class="window-header"><span>Error</span><span>_ [] X</span></div>
        <p>El identificador de la película no es válido.</p>
        <a class="retro-button" href="empleado-inventario.jsp">VOLVER</a>
    </section>
<%
    } else {
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement pelicula = con.prepareStatement(
                     "SELECT p.titulo,p.precio_unidad,TO_CHAR(p.fecha_estreno,'YYYY-MM-DD') fecha_estreno," +
                             "p.sinopsis,p.imagen_url,p.id_clasificacion,c.desc_clasificacion " +
                             "FROM Peliculas p JOIN Clasificacion c ON c.id_clasificacion=p.id_clasificacion WHERE p.id_pelicula=?")) {
            pelicula.setInt(1, idPelicula);
            try (ResultSet p = pelicula.executeQuery()) {
                if (!p.next()) {
%>
    <section class="retro-window employee-panel inventory-editor-message">
        <div class="window-header"><span>No_encontrada.error</span><span>_ [] X</span></div>
        <p>La película solicitada no existe.</p>
        <a class="retro-button" href="empleado-inventario.jsp">VOLVER</a>
    </section>
<%
                } else {
                    Set<Integer> generosSeleccionados = new HashSet<>();
                    try (PreparedStatement ps = con.prepareStatement("SELECT id_genero FROM PeliculasGeneros WHERE id_pelicula=?")) {
                        ps.setInt(1, idPelicula);
                        try (ResultSet rs = ps.executeQuery()) { while (rs.next()) generosSeleccionados.add(rs.getInt(1)); }
                    }
%>
    <section class="employee-header">
        <p class="employee-kicker">Película_<%= idPelicula %>.edit</p>
        <h1>Editar <%= h(p.getString("titulo")) %></h1>
        <p>Los cambios realizados aquí se guardan directamente en la base de datos.</p>
    </section>

    <% if (request.getParameter("guardado") != null || request.getParameter("creada") != null) { %>
    <p class="inventory-success" role="status"><%= request.getParameter("creada") != null ? "La película y sus copias se crearon correctamente." : "Los cambios se guardaron correctamente." %></p>
    <% } %>
    <% if (error != null) { %>
    <p class="inventory-error" role="alert">No se guardaron los cambios: <%= h(error) %></p>
    <% } %>

    <form class="retro-window employee-panel inventory-editor" method="post">
        <input type="hidden" name="id" value="<%= idPelicula %>">
        <div class="window-header"><span>Datos_Película.form</span><span>_ [] X</span></div>
        <div class="inventory-detail-grid">
            <div class="inventory-detail-poster-wrap">
                <% if (p.getString("imagen_url") != null && !p.getString("imagen_url").isBlank()) { %>
                <img src="<%= request.getContextPath() %>/recursos/<%= h(posterPath(p.getString("imagen_url"))) %>" alt="Póster actual" class="inventory-detail-poster">
                <% } else { %><div class="placeholder-img inventory-detail-poster"></div><% } %>
            </div>
            <div class="employee-form employee-movie-form">
                <div class="employee-form-grid">
                    <label>Título *<input class="retro-search" name="titulo" required value="<%= h(p.getString("titulo")) %>"></label>
                    <label>Fecha de estreno *<input class="retro-search" type="date" name="fechaEstreno" required value="<%= h(p.getString("fecha_estreno")) %>"></label>
                    <label>Precio por unidad *<input class="retro-search" type="number" min="0" step="0.01" name="precio" required value="<%= p.getBigDecimal("precio_unidad") %>"></label>
                    <label>Clasificación *
                        <select class="retro-search" name="clasificacion" required>
                            <% try (PreparedStatement ps = con.prepareStatement("SELECT id_clasificacion,desc_clasificacion FROM Clasificacion ORDER BY edad_minima"); ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) { %>
                            <option value="<%= rs.getInt(1) %>" <%= rs.getInt(1) == p.getInt("id_clasificacion") ? "selected" : "" %>><%= h(rs.getString(2)) %></option>
                            <% }} %>
                        </select>
                    </label>
                    <label class="employee-full-field">Ruta de imagen
                        <input class="retro-search" name="imagenUrl" value="<%= h(p.getString("imagen_url")) %>" placeholder="posters/pelicula.jpg">
                    </label>
                    <fieldset class="employee-full-field inventory-genres">
                        <legend>Géneros</legend>
                        <% try (PreparedStatement ps = con.prepareStatement("SELECT id_genero,desc_genero FROM Genero ORDER BY desc_genero"); ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) { int idGenero = rs.getInt(1); %>
                        <label><input type="checkbox" name="generos" value="<%= idGenero %>" <%= generosSeleccionados.contains(idGenero) ? "checked" : "" %>> <%= h(rs.getString(2)) %></label>
                        <% }} %>
                    </fieldset>
                    <label class="employee-full-field">Sinopsis *
                        <textarea class="retro-search employee-textarea" name="sinopsis" required><%= h(p.getString("sinopsis")) %></textarea>
                    </label>
                </div>

                <h2 class="inventory-section-title">Copias VHS</h2>
                <div class="copy-status-list inventory-copy-list">
                    <% try (PreparedStatement ps = con.prepareStatement(
                            "SELECT v.id_vhs,v.estado_fisico_vhs," +
                                    "CASE WHEN EXISTS(SELECT 1 FROM Alquiler a WHERE a.id_vhs=v.id_vhs AND UPPER(a.estado_alquiler) IN ('ACTIVO','ALQUILADO','EN USO')) THEN 1 ELSE 0 END en_uso," +
                                    "CASE WHEN EXISTS(SELECT 1 FROM Alquiler a WHERE a.id_vhs=v.id_vhs) THEN 1 ELSE 0 END tiene_historial " +
                                    "FROM Vhs v WHERE v.id_pelicula=? ORDER BY v.id_vhs")) {
                        ps.setInt(1, idPelicula);
                        try (ResultSet rs = ps.executeQuery()) {
                            boolean hayCopias = false;
                            while (rs.next()) { hayCopias = true; int idVhs = rs.getInt("id_vhs"); %>
                    <div class="copy-status-row inventory-copy-edit-row">
                        <strong>VHS #<%= idVhs %></strong>
                        <% if (rs.getInt("en_uso") == 1) { %><span class="status-badge status-warning">EN USO</span><% } %>
                        <input class="retro-search" name="estado_<%= idVhs %>" value="<%= h(rs.getString("estado_fisico_vhs")) %>" required aria-label="Estado físico de VHS <%= idVhs %>">
                        <label class="inventory-delete-copy">
                            <input type="checkbox" name="eliminar_<%= idVhs %>" <%= rs.getInt("tiene_historial") == 1 ? "disabled" : "" %>>
                            Eliminar<%= rs.getInt("tiene_historial") == 1 ? " (tiene historial)" : "" %>
                        </label>
                    </div>
                    <%      }
                            if (!hayCopias) { %><p>Esta película todavía no tiene copias VHS.</p><% }
                        }
                    } %>
                </div>

                <div class="inventory-add-copies">
                    <label>Agregar copias<input class="retro-search" type="number" name="nuevasCopias" min="0" max="100" value="0"></label>
                    <label>Estado inicial<input class="retro-search" name="estadoNuevo" value="DISPONIBLE"></label>
                </div>

                <div class="employee-form-actions">
                    <button type="submit" class="retro-button">GUARDAR CAMBIOS</button>
                    <a class="retro-button employee-cancel" href="empleado-inventario.jsp">CANCELAR</a>
                </div>
            </div>
        </div>
    </form>
<%
                }
            }
        } catch (SQLException e) {
%>
    <p class="inventory-error">No fue posible cargar la película: <%= h(e.getMessage()) %></p>
<%
        }
    }
%>
</main>
<%@ include file="footer.jsp" %>
<script src="${pageContext.request.contextPath}/js/script.js?v=3"></script>
</body>
</html>
