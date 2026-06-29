<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.conexion.ConexionDB" %>

<%
    String mensaje = null;
    String tipoMensaje = null;



    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String titulo = request.getParameter("titulo");
        String precioStr = request.getParameter("precio");
        String fechaEstreno = request.getParameter("fechaEstreno");
        String clasificacion = request.getParameter("clasificacion");
        String generoPrincipal = request.getParameter("generoPrincipal");
        String generoSecundario = request.getParameter("generoSecundario");
        String sinopsis = request.getParameter("sinopsis");
        String imagen = request.getParameter("imagen");

        Connection con = null;

        try {

            con = ConexionDB.obtenerConexion();
            con.setAutoCommit(false);

            if (imagen == null || imagen.trim().isEmpty()) {
                imagen = "default.jpg";
            }

            String imagenURL = "posters/" + imagen.trim();

            int idPelicula = 0;

            PreparedStatement psSeq =
                    con.prepareStatement("SELECT seq_pelicula.NEXTVAL FROM dual");

            ResultSet rsSeq = psSeq.executeQuery();

            if (rsSeq.next()) {
                idPelicula = rsSeq.getInt(1);
            }

            rsSeq.close();
            psSeq.close();

            PreparedStatement psExiste = con.prepareStatement(
                    "SELECT COUNT(*) FROM PELICULAS WHERE UPPER(TITULO)=UPPER(?)"
            );

            psExiste.setString(1, titulo);

            ResultSet rsExiste = psExiste.executeQuery();

            int existe = 0;

            if (rsExiste.next()) {
                existe = rsExiste.getInt(1);
            }

            rsExiste.close();
            psExiste.close();

            if (existe > 0) {
                throw new Exception("Ya existe una película con ese título.");
            }

            PreparedStatement psPelicula = con.prepareStatement(
                    "INSERT INTO PELICULAS " +
                            "(ID_PELICULA, TITULO, PRECIO_UNIDAD, FECHA_ESTRENO, SINOPSIS, ID_CLASIFICACION, IMAGEN_URL) " +
                            "VALUES (?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)"
            );

            psPelicula.setInt(1, idPelicula);
            psPelicula.setString(2, titulo);
            psPelicula.setDouble(3, Double.parseDouble(precioStr));
            psPelicula.setString(4, fechaEstreno);
            psPelicula.setString(5, sinopsis);
            psPelicula.setInt(6, Integer.parseInt(clasificacion));
            psPelicula.setString(7, imagenURL);

            psPelicula.executeUpdate();

            psPelicula.close();

            PreparedStatement psGenero1 = con.prepareStatement(
                    "INSERT INTO PELICULASGENEROS " +
                            "(ID_GENERO, ID_PELICULA, PRIORIDAD) " +
                            "VALUES (?, ?, ?)"
            );

            psGenero1.setInt(1, Integer.parseInt(generoPrincipal));
            psGenero1.setInt(2, idPelicula);
            psGenero1.setInt(3, 1);

            psGenero1.executeUpdate();
            psGenero1.close();

            if (generoSecundario != null
                    && !generoSecundario.isEmpty()
                    && !generoSecundario.equals("0")
                    && !generoSecundario.equals(generoPrincipal)) {

                PreparedStatement psGenero2 = con.prepareStatement(
                        "INSERT INTO PELICULASGENEROS " +
                                "(ID_GENERO, ID_PELICULA, PRIORIDAD) " +
                                "VALUES (?, ?, ?)"
                );

                psGenero2.setInt(1, Integer.parseInt(generoSecundario));
                psGenero2.setInt(2, idPelicula);
                psGenero2.setInt(3, 2);

                psGenero2.executeUpdate();
                psGenero2.close();
            }

            con.commit();

            mensaje = "Película agregada correctamente.";
            tipoMensaje = "success";

        } catch (Exception e) {

            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception ex) {
                }
            }

            mensaje = e.getMessage();
            tipoMensaje = "error";

        } finally {

            if (con != null) {
                try {
                    con.close();
                } catch (Exception ex) {
                }
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

        <li><a href="empleado-usuarios.jsp">Usuarios</a></li>

    </ul>

</nav>



<main class="employee-page">

    <section class="employee-header">

        <p class="employee-kicker">Catalogo.store</p>

        <h1>Agregar pelicula</h1>

        <p>Formulario de presentacion. Por ahora no inserta datos; el catalogo se mantiene como modulo aprobado.</p>

    </section>



    <section class="retro-window employee-panel employee-form-panel">

        <div class="window-header"><span>Nueva_Pelicula.form</span><span>_ [] X</span></div>


            <% if (mensaje != null) { %>
            <div class="employee-alert <%= "success".equals(tipoMensaje) ? "employee-alert-success" : "employee-alert-error" %>">
                <%= mensaje %>
            </div>
            <% } %>

            <form class="employee-form employee-movie-form" method="post">

                <div class="employee-form-grid">

                    <label>
                        Título *
                        <input
                                type="text"
                                name="titulo"
                                class="retro-search"
                                maxlength="100"
                                placeholder="Ej. The Thing"
                                required>
                    </label>

                    <label>
                        Precio por día *
                        <input
                                type="number"
                                name="precio"
                                class="retro-search"
                                min="0.01"
                                step="0.01"
                                required>
                    </label>

                    <label>
                        Fecha de estreno *
                        <input
                                type="date"
                                name="fechaEstreno"
                                class="retro-search"
                                required>
                    </label>

                    <label>
                        Clasificación *
                        <select name="clasificacion" class="retro-search" required>
                            <option value="1">G (Infantil)</option>
                            <option value="2">PG (Todo público)</option>
                            <option value="3">PG-13 (Mayores de 13)</option>
                            <option value="4">R (+17)</option>
                        </select>
                    </label>

                    <label>
                        Género principal *
                        <select name="generoPrincipal" class="retro-search" required>
                            <option value="1">Drama</option>
                            <option value="2">Ciencia Ficción</option>
                            <option value="3">Aventura</option>
                            <option value="4">Acción</option>
                            <option value="5">Comedia</option>
                            <option value="6">Terror</option>
                            <option value="7">Romance</option>
                            <option value="8">Animación</option>

                        </select>
                    </label>

                    <label>
                        Género secundario
                        <select name="generoSecundario" class="retro-search">
                            <option value="0">Sin género secundario</option>

                            <option value="1">Drama</option>
                            <option value="2">Ciencia Ficción</option>
                            <option value="3">Aventura</option>
                            <option value="4">Acción</option>
                            <option value="5">Comedia</option>
                            <option value="6">Terror</option>
                            <option value="7">Romance</option>
                            <option value="8">Animación</option>
                        </select>
                    </label>

                    <label class="employee-full-field">

                        Sinopsis *

                        <textarea
                                name="sinopsis"
                                class="retro-search employee-textarea"
                                maxlength="1000"
                                required></textarea>

                    </label>
                    </div>

                    <label class="employee-full-field">

                        Nombre de la imagen *

                        <input
                                type="text"
                                name="imagen"
                                class="retro-search"
                                placeholder="ej. terminator2.jpg"
                                required>

                        <span class="employee-help">

                Coloca posteriormente la imagen dentro de
                <strong>posters/</strong>

            </span>

                    </label>

                <div class="employee-form-actions">

                    <button
                            type="submit"
                            class="retro-button">

                        GUARDAR

                    </button>

                    <a
                            href="empleado-dashboard.jsp"
                            class="retro-button employee-cancel">

                        CANCELAR

                    </a>

                </div>

            </form>



    </section>

</main>

<script src="js/empleado-responsive.js"></script>

</body>

</html>