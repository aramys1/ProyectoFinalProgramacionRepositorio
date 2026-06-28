<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.math.BigDecimal, com.conexion.ConexionDB" %>
<%
    request.setCharacterEncoding("UTF-8");

    String mensaje = null;
    String error = null;

    String titulo = "";
    String sinopsis = "";
    String precio = "";
    String fechaEstreno = "";
    String idClasificacion = "";
    String generoPrincipal = "";
    String generoSecundario = "";

    Object empleadoSesion = session.getAttribute("idUsuarioEmpleado");
    if (empleadoSesion == null) {
        empleadoSesion = session.getAttribute("empleadoId");
    }
    int idEmpleado = 1;
    if (empleadoSesion != null) {
        try {
            idEmpleado = Integer.parseInt(empleadoSesion.toString());
        } catch (NumberFormatException ignored) {
            idEmpleado = 1;
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        titulo = request.getParameter("titulo") == null ? "" : request.getParameter("titulo").trim();
        sinopsis = request.getParameter("sinopsis") == null ? "" : request.getParameter("sinopsis").trim();
        precio = request.getParameter("precio") == null ? "" : request.getParameter("precio").trim();
        fechaEstreno = request.getParameter("fechaEstreno") == null ? "" : request.getParameter("fechaEstreno").trim();
        idClasificacion = request.getParameter("idClasificacion") == null ? "" : request.getParameter("idClasificacion").trim();
        generoPrincipal = request.getParameter("generoPrincipal") == null ? "" : request.getParameter("generoPrincipal").trim();
        generoSecundario = request.getParameter("generoSecundario") == null ? "" : request.getParameter("generoSecundario").trim();
        String posterNombre = request.getParameter("posterNombre") == null ? "" : request.getParameter("posterNombre").trim();

        if (titulo.isEmpty() || sinopsis.isEmpty() || precio.isEmpty() || fechaEstreno.isEmpty()
                || idClasificacion.isEmpty() || generoPrincipal.isEmpty()) {
            error = "Completa todos los campos obligatorios.";
        } else {
            try (Connection con = ConexionDB.obtenerConexion()) {
                con.setAutoCommit(false);
                try {
                    String imagenUrl = posterNombre.isEmpty() ? null : "posters/" + posterNombre;
                    int idPelicula;

                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO Peliculas (id_pelicula, titulo, precio_unidad, fecha_estreno, sinopsis, imagen_url, id_clasicacion) " +
                            "VALUES (seq_pelicula.NEXTVAL, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)")) {
                        ps.setString(1, titulo);
                        ps.setBigDecimal(2, new BigDecimal(precio));
                        ps.setString(3, fechaEstreno);
                        ps.setString(4, sinopsis);
                        ps.setString(5, imagenUrl);
                        ps.setInt(6, Integer.parseInt(idClasificacion));
                        ps.executeUpdate();
                    }

                    try (PreparedStatement ps = con.prepareStatement("SELECT seq_pelicula.CURRVAL FROM dual");
                         ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        idPelicula = rs.getInt(1);
                    }

                    // Si no hay un empleado en sesión, insertaremos un NULL
                    if (idEmpleado <= 0) {
                        try (PreparedStatement ps = con.prepareStatement(
                                "INSERT INTO Publicacion (id_usuario_empleado, id_pelicula, fecha_publicacion) VALUES (NULL, ?, SYSDATE)")) {
                            ps.setInt(1, idPelicula);
                            ps.executeUpdate();
                        }
                    } else {
                        // Si tienes un ID (aunque sea el 1 por defecto), puedes usarlo normalmente
                        try (PreparedStatement ps = con.prepareStatement(
                                "INSERT INTO Publicacion (id_usuario_empleado, id_pelicula, fecha_publicacion) VALUES (?, ?, SYSDATE)")) {
                            ps.setInt(1, idEmpleado);
                            ps.setInt(2, idPelicula);
                            ps.executeUpdate();
                        }
                    }

                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO PeliculasGeneros (id_genero, id_pelicula, prioridad) VALUES (?, ?, ?)")) {
                        ps.setInt(1, Integer.parseInt(generoPrincipal));
                        ps.setInt(2, idPelicula);
                        ps.setInt(3, 1);
                        ps.executeUpdate();
                    }

                    if (!generoSecundario.isEmpty() && !generoSecundario.equals(generoPrincipal)) {
                        try (PreparedStatement ps = con.prepareStatement(
                                "INSERT INTO PeliculasGeneros (id_genero, id_pelicula, prioridad) VALUES (?, ?, ?)")) {
                            ps.setInt(1, Integer.parseInt(generoSecundario));
                            ps.setInt(2, idPelicula);
                            ps.setInt(3, 2);
                            ps.executeUpdate();
                        }
                    }

                    con.commit();
                    mensaje = "Pelicula guardada correctamente en el catalogo.";
                    titulo = "";
                    sinopsis = "";
                    precio = "";
                    fechaEstreno = "";
                    idClasificacion = "";
                    generoPrincipal = "";
                    generoSecundario = "";
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
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Agregar Pelicula | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window employee-nav">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolucion</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-agregar-pelicula.jsp">Agregar pelicula</a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Catalogo.store</p>
        <h1>Agregar pelicula</h1>
        <p>Registra una nueva pelicula, su clasificacion, generos y publicacion del empleado.</p>
    </section>

    <% if (mensaje != null) { %><div class="employee-alert employee-alert-ok"><%= mensaje %></div><% } %>
    <% if (error != null) { %><div class="employee-alert employee-alert-error">No se pudo guardar: <%= error %></div><% } %>

    <section class="retro-window employee-panel employee-form-panel">
        <div class="window-header"><span>Nueva_Pelicula.form</span><span>_ □ X</span></div>
        <form class="employee-form employee-movie-form" method="post" action="empleado-agregar-pelicula.jsp">
            <div class="employee-form-grid">
                <label>
                    Titulo *
                    <input type="text" name="titulo" class="retro-search" value="<%= titulo %>" maxlength="100" required>
                </label>

                <label>
                    Precio por dia *
                    <input type="number" name="precio" class="retro-search" value="<%= precio %>" min="0.01" step="0.01" placeholder="2.99" required>
                </label>

                <label>
                    Fecha de estreno *
                    <input type="date" name="fechaEstreno" class="retro-search" value="<%= fechaEstreno %>" required>
                </label>

                <label>
                    Clasificacion *
                    <select name="idClasificacion" class="retro-search" required>
                        <option value="">Seleccionar</option>
                        <%
                            try (Connection con = ConexionDB.obtenerConexion();
                                 PreparedStatement ps = con.prepareStatement(
                                         "SELECT id_clasificacion, desc_clasicacion FROM Clasificacion ORDER BY edad_minima");
                                 ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    String selected = String.valueOf(rs.getInt("id_clasificacion")).equals(idClasificacion) ? "selected" : "";
                        %>
                        <option value="<%= rs.getInt("id_clasificacion") %>" <%= selected %>><%= rs.getString("desc_clasicacion") %></option>
                        <%
                                }
                            } catch (SQLException e) {
                        %>
                        <option value="">No disponible</option>
                        <% } %>
                    </select>
                </label>

                <label>
                    Genero principal *
                    <select name="generoPrincipal" class="retro-search" required>
                        <option value="">Seleccionar</option>
                        <%
                            try (Connection con = ConexionDB.obtenerConexion();
                                 PreparedStatement ps = con.prepareStatement(
                                         "SELECT id_genero, desc_genero FROM Genero ORDER BY desc_genero");
                                 ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    String selected = String.valueOf(rs.getInt("id_genero")).equals(generoPrincipal) ? "selected" : "";
                        %>
                        <option value="<%= rs.getInt("id_genero") %>" <%= selected %>><%= rs.getString("desc_genero") %></option>
                        <%
                                }
                            } catch (SQLException e) {
                        %>
                        <option value="">No disponible</option>
                        <% } %>
                    </select>
                </label>

                <label>
                    Genero secundario
                    <select name="generoSecundario" class="retro-search">
                        <option value="">Sin genero secundario</option>
                        <%
                            try (Connection con = ConexionDB.obtenerConexion();
                                 PreparedStatement ps = con.prepareStatement(
                                         "SELECT id_genero, desc_genero FROM Genero ORDER BY desc_genero");
                                 ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    String selected = String.valueOf(rs.getInt("id_genero")).equals(generoSecundario) ? "selected" : "";
                        %>
                        <option value="<%= rs.getInt("id_genero") %>" <%= selected %>><%= rs.getString("desc_genero") %></option>
                        <%
                                }
                            } catch (SQLException e) {
                        %>
                        <option value="">No disponible</option>
                        <% } %>
                    </select>
                </label>

                <label class="employee-full-field">
                    Sinopsis *
                    <textarea name="sinopsis" class="retro-search employee-textarea" maxlength="1000" required><%= sinopsis %></textarea>
                </label>

                <label class="employee-full-field">
                    Poster / imagen
                    <input type="file" id="posterFile" class="retro-search" accept="image/*">
                    <input type="hidden" name="posterNombre" id="posterNombre">
                    <span class="employee-help">Se guardara como recursos/posters/nombre-del-archivo.</span>
                </label>
            </div>

            <div class="employee-form-actions">
                <button type="submit" class="retro-button">GUARDAR</button>
                <a href="empleado-dashboard.jsp" class="retro-button employee-cancel">CANCELAR</a>
            </div>
        </form>
    </section>
</main>
<script src="js/empleado-responsive.js"></script>
</body>
</html>
