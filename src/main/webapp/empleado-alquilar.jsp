<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>

<%
    String paso = request.getParameter("paso");
    if (paso == null) paso = "1";

    String mensajeError = "";
    String cedulaBuscada = request.getParameter("cedula");
    String nombreCliente = "";
    String tarjetaCliente = "";
    int idCliente = 0;
    int idTarjeta = 0;

    if ("2".equals(paso) && cedulaBuscada != null && !cedulaBuscada.isEmpty()) {
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT u.id_usuario, u.primer_nombre_usuario, u.primer_apellido_usuario " +
                             "FROM Usuario u WHERE u.ced_usuario = ?")) {
            ps.setString(1, cedulaBuscada);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                idCliente = rs.getInt("id_usuario");
                nombreCliente = rs.getString("primer_nombre_usuario") + " " + rs.getString("primer_apellido_usuario");
            } else {
                mensajeError = "Cliente no encontrado. Verifique la cedula.";
            }
        } catch (Exception e) {
            mensajeError = "Error: " + e.getMessage();
        }

        if (idCliente > 0) {
            try (Connection con = ConexionDB.obtenerConexion();
                 PreparedStatement ps = con.prepareStatement(
                         "SELECT id_tarjeta, numero FROM TarjetaUsuario WHERE id_usuario = ?")) {
                ps.setInt(1, idCliente);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    idTarjeta = rs.getInt("id_tarjeta");
                    String num = rs.getString("numero");
                    // Se asigna el número tal cual viene de la base de datos
                    tarjetaCliente = (num != null) ? num : "Sin numero registrado";
                } else {
                    tarjetaCliente = "Sin tarjeta registrada";
                }
            } catch (Exception e) {
                tarjetaCliente = "Error al leer tarjeta";
            }
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && "confirmar".equals(request.getParameter("accion"))) {
        int idClienteConf = Integer.parseInt(request.getParameter("id_cliente"));
        int idVhs         = Integer.parseInt(request.getParameter("id_vhs"));
        int dias          = Integer.parseInt(request.getParameter("dias"));
        // Ahora lo obtenemos del formulario
        String idEmpleado    = request.getParameter("id_empleado");

        try (Connection con = ConexionDB.obtenerConexion()) {
            con.setAutoCommit(false);

            // 1. Calcular FECHA_LIMITE (ejemplo: fecha actual + días de alquiler)
            // Usamos un pequeño truco para sumar los días en Oracle
            String sqlAlquiler = "INSERT INTO Alquiler (ESTADO_ALQUILER, FECHA_ALQUILER, FECHA_LIMITE, ID_USUARIO_CLIENTE, ID_VHS, ID_USUARIO_EMPLEADO) " +
                    "VALUES ('PENDIENTE', SYSDATE, SYSDATE + ?, ?, ?, ?)";

            PreparedStatement psAlquiler = con.prepareStatement(sqlAlquiler);

            // Limpiamos el ID del empleado para que sea un número puro (sin guiones)
            int idEmpleadoInt = Integer.parseInt(request.getParameter("id_empleado").replace("-", ""));

            psAlquiler.setInt(1, dias);           // Para el cálculo de FECHA_LIMITE
            psAlquiler.setInt(2, idClienteConf);  // ID_USUARIO_CLIENTE
            psAlquiler.setInt(3, idVhs);          // ID_VHS
            psAlquiler.setInt(4, idEmpleadoInt);  // ID_USUARIO_EMPLEADO

            psAlquiler.executeUpdate();

            // 2. Cambiar estado del VHS
            String sqlVhs = "UPDATE Vhs SET estado_fisico_vhs = 'ALQUILADO' WHERE id_vhs = ?";
            PreparedStatement psVhs = con.prepareStatement(sqlVhs);
            psVhs.setInt(1, idVhs);
            psVhs.executeUpdate();

            con.commit();
            paso = "exito";
        } catch (Exception e) {
            mensajeError = "Error al guardar: " + e.getMessage();
            paso = "2";
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
    <title>Registrar Alquiler | Rewind & Relive</title>
</head>
<body>

<nav class="navbar retro-window employee-nav">
    <% request.setAttribute("adminPanelLogo", Boolean.TRUE); %><%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolucion</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-alquilar.jsp">Nuevo Alquiler</a></li>
    </ul>
</nav>

<main class="employee-page">

    <section class="employee-header">
        <p class="employee-kicker">Alquiler.new</p>
        <h1>Registrar Alquiler</h1>
    </section>

    <% if (!mensajeError.isEmpty()) { %>
    <div class="employee-alert employee-alert-error"><%= mensajeError %></div>
    <% } %>

    <!-- PASO 1 -->
    <% if ("1".equals(paso)) { %>
    <section class="retro-window employee-panel">
        <div class="window-header"><span>Cliente.check</span><span>_ [] X</span></div>
        <div style="padding: 30px; text-align: center;">
            <h3 style="margin-bottom: 30px;">El cliente tiene cuenta registrada?</h3>
            <div style="display: flex; gap: 20px; justify-content: center;">
                <a href="empleado-alquilar.jsp?paso=2" class="retro-button">SI, TIENE CUENTA</a>
                <a href="registro.jsp" class="retro-button" style="background-color: #d32f2f; color: white;">NO, REGISTRAR</a>
            </div>
        </div>
    </section>
    <% } %>

    <!-- PASO 2: Buscar cliente -->
    <!-- PASO 2: Buscar cliente -->
    <% if ("2".equals(paso) && idCliente == 0) { %>
    <section class="retro-window employee-panel">
        <div class="window-header"><span>Buscar_Cliente.search</span><span>_ [] X</span></div>
        <div style="padding: 30px;">
            <form method="get" action="empleado-alquilar.jsp">
                <input type="hidden" name="paso" value="2">
                <label>Cedula del cliente:</label><br><br>
                <input type="text" name="cedula" class="retro-search"
                       placeholder="Ej: 8-1032-1714" style="width:300px;" required>
                <button type="submit" class="retro-button">BUSCAR</button>
            </form>
        </div>
    </section>
    <% } %>

    <!-- PASO 2: Cliente encontrado -->
    <% if ("2".equals(paso) && idCliente > 0) { %>
    <section class="retro-window employee-panel">
        <div class="window-header"><span>Seleccionar_VHS.form</span><span>_ [] X</span></div>
        <div style="padding: 30px;">

            <p><strong>Cliente:</strong> <%= nombreCliente %></p>
            <p><strong>Tarjeta:</strong> <%= tarjetaCliente %></p>

            <hr style="margin: 20px 0; border: 1px solid #000;">

            <form method="post">
                <input type="hidden" name="accion" value="confirmar">
                <input type="hidden" name="id_cliente" value="<%= idCliente %>">

                <label>ID del Empleado (que realiza el alquiler):</label><br>
                <input type="text" name="id_empleado" class="retro-search" required style="width: 100px;">
                <br><br>

                <label>Buscar pelicula:</label><br><br>
                <input type="text" id="buscarPelicula" class="retro-search"
                       placeholder="Escribe el titulo..." style="width:300px;"
                       oninput="filtrarPeliculas()">

                <br><br>

                <label>VHS disponibles:</label><br><br>
                <select name="id_vhs" id="selectVhs" class="retro-search"
                        style="width: 400px;" required onchange="calcularTotal()">
                    <option value="">Seleccione un VHS...</option>
                    <%
                        try (Connection con = ConexionDB.obtenerConexion();
                             PreparedStatement ps = con.prepareStatement(
                                     "SELECT v.id_vhs, p.titulo, p.precio_unidad " +
                                             "FROM Vhs v JOIN Peliculas p ON v.id_pelicula = p.id_pelicula " +
                                             "WHERE v.estado_fisico_vhs = 'DISPONIBLE' ORDER BY p.titulo"
                             );
                             ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("id_vhs") %>"
                            data-precio="<%= rs.getDouble("precio_unidad") %>"
                            data-titulo="<%= rs.getString("titulo").toLowerCase() %>">
                        <%= rs.getString("titulo") %> — VHS #<%= rs.getInt("id_vhs") %>
                    </option>
                    <% } } catch (Exception e) { } %>
                </select>

                <br><br>

                <label>Dias de alquiler:</label><br><br>
                <input type="number" name="dias" id="dias" class="retro-search"
                       min="1" max="14" value="1" style="width: 100px;"
                       oninput="calcularTotal()">

                <br><br>

                <p><strong>Total a cobrar: $<span id="totalCobro">0.00</span></strong></p>
                <p style="color: #555;">Se cargara a la tarjeta: <strong><%= tarjetaCliente %></strong></p>

                <br>
                <button type="submit" class="retro-button">CONFIRMAR ALQUILER</button>
                <a href="empleado-alquilar.jsp?paso=2" class="retro-button"
                   style="background:#ccc; margin-left:10px;">CANCELAR</a>
            </form>
        </div>
    </section>
    <% } %>

    <!-- EXITO -->
    <% if ("exito".equals(paso)) { %>
    <section class="retro-window employee-panel">
        <div class="window-header"><span>Alquiler_OK.log</span><span>_ [] X</span></div>
        <div style="padding: 30px; text-align: center;">
            <h2 style="color: green;">Alquiler registrado correctamente</h2>
            <br>
            <a href="empleado-alquilar.jsp" class="retro-button">NUEVO ALQUILER</a>
            <a href="empleado-alquileres.jsp" class="retro-button"
               style="background:#ccc; margin-left:10px;">VER ALQUILERES</a>
        </div>
    </section>
    <% } %>

</main>

<%@ include file="footer.jsp" %>

<script>
    function filtrarPeliculas() {
        const buscar = document.getElementById('buscarPelicula').value.toLowerCase();
        const select = document.getElementById('selectVhs');
        const opciones = select.options;
        for (let i = 1; i < opciones.length; i++) {
            const titulo = opciones[i].getAttribute('data-titulo');
            opciones[i].style.display = titulo.includes(buscar) ? '' : 'none';
        }
        select.value = '';
        document.getElementById('totalCobro').textContent = '0.00';
    }

    function calcularTotal() {
        const select = document.getElementById('selectVhs');
        const dias = parseInt(document.getElementById('dias').value) || 0;
        const precio = parseFloat(select.options[select.selectedIndex]?.getAttribute('data-precio')) || 0;
        document.getElementById('totalCobro').textContent = (precio * dias).toFixed(2);
    }
</script>

</body>
</html>
