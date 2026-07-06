<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.util.*,com.conexion.ConexionDB" %>
<%--
    El carrito vive temporalmente en HttpSession, pero precios, copias y alquileres provienen de Oracle.
    Al confirmar, se crea una fila en Alquiler por película y se marca su Vhs como ALQUILADO.
    commit confirma todas las filas juntas; rollback evita alquileres parciales si una copia deja de estar disponible.
--%>
<%!
    // Evita inyección HTML al mostrar títulos y mensajes procedentes de Oracle.
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    // Control de acceso: el carrito pertenece únicamente a clientes autenticados.
    Object idSesion = session.getAttribute("idUsuario");
    String rolSesion = String.valueOf(session.getAttribute("rolUsuario"));
    if (idSesion == null || !("1".equals(rolSesion) || "CLIENTE".equalsIgnoreCase(rolSesion))) {
        response.sendRedirect("login.jsp");
        return;
    }
    int idUsuario = Integer.parseInt(String.valueOf(idSesion));
    // Impide que una cuenta herede el carrito de otra al iniciar sesión en el mismo navegador.
    Object propietarioCarrito = session.getAttribute("carritoUsuarioId");
    if (propietarioCarrito == null || !String.valueOf(idUsuario).equals(String.valueOf(propietarioCarrito))) {
        session.removeAttribute("carritoPeliculas");
        session.setAttribute("carritoUsuarioId", idUsuario);
    }
    @SuppressWarnings("unchecked")
    List<Integer> carrito = (List<Integer>) session.getAttribute("carritoPeliculas");
    if (carrito == null) {
        carrito = new ArrayList<Integer>();
        session.setAttribute("carritoPeliculas", carrito);
    }
    String mensaje = null, error = null;
    int diasSeleccionados = 1;
    try { diasSeleccionados = Integer.parseInt(request.getParameter("dias")); } catch (Exception ignored) { }
    // Procesa agregar, quitar, vaciar o confirmar el alquiler.
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String accion = request.getParameter("accion");
        int idPelicula = 0;
        try { idPelicula = Integer.parseInt(request.getParameter("id_pelicula")); }
        catch (Exception ignored) { }
        if ("quitar".equals(accion)) {
            carrito.remove(Integer.valueOf(idPelicula));
            mensaje = "Película eliminada del carrito.";
        } else if ("vaciar".equals(accion)) {
            carrito.clear();
            mensaje = "Carrito vaciado.";
        } else if ("alquilar".equals(accion)) {
            if (carrito.isEmpty()) {
                error = "El carrito está vacío.";
            } else if (diasSeleccionados < 1 || diasSeleccionados > 30) {
                error = "Seleccione una duración entre 1 y 30 días.";
            } else {
                Connection con = null;
                try {
                    // Toda la reserva es atómica: o se alquilan todas las películas o ninguna.
                    con = ConexionDB.obtenerConexion();
                    con.setAutoCommit(false);
                    // Alquiler exige una FK id_usuario_empleado; se asigna un empleado real existente.
                    int idEmpleado = 0;
                    try (PreparedStatement ps = con.prepareStatement(
                            "SELECT id_usuario FROM Usuario WHERE TO_CHAR(rol)='2' OR UPPER(TO_CHAR(rol))='EMPLEADO' ORDER BY id_usuario FETCH FIRST 1 ROW ONLY");
                         ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) idEmpleado = rs.getInt(1);
                    }
                    if (idEmpleado == 0) throw new SQLException("No hay ningún empleado registrado para procesar el alquiler.");

                    // Bloquea una copia disponible de cada película para evitar reservas simultáneas.
                    try (PreparedStatement buscarVhs = con.prepareStatement(
                            "SELECT id_vhs FROM Vhs WHERE id_pelicula=? AND UPPER(estado_fisico_vhs)='DISPONIBLE' " +
                                    "AND NOT EXISTS (SELECT 1 FROM Alquiler a WHERE a.id_vhs=Vhs.id_vhs AND a.fecha_devolucion IS NULL) " +
                                    "ORDER BY id_vhs FOR UPDATE");
                         // INSERT registra cliente, copia, empleado y fecha límite calculada por Oracle.
                         PreparedStatement insertar = con.prepareStatement(
                            "INSERT INTO Alquiler(estado_alquiler,fecha_alquiler,fecha_limite,id_usuario_cliente,id_vhs,id_usuario_empleado) " +
                                    "VALUES('PENDIENTE',SYSDATE,SYSDATE+?,?,?,?)");
                         // UPDATE retira la copia del catálogo disponible hasta que un empleado la devuelva.
                         PreparedStatement ocupar = con.prepareStatement(
                            "UPDATE Vhs SET estado_fisico_vhs='ALQUILADO' WHERE id_vhs=?")) {
                        for (Integer pelicula : carrito) {
                            buscarVhs.setInt(1,pelicula);
                            int idVhs;
                            try (ResultSet rs=buscarVhs.executeQuery()) {
                                if(!rs.next()) throw new SQLException("Una de las películas ya no tiene copias disponibles.");
                                idVhs=rs.getInt(1);
                            }
                            insertar.setInt(1, diasSeleccionados);
                            insertar.setInt(2, idUsuario);
                            insertar.setInt(3, idVhs);
                            insertar.setInt(4, idEmpleado);
                            insertar.executeUpdate();
                            ocupar.setInt(1, idVhs);
                            ocupar.executeUpdate();
                        }
                    }
                    con.commit(); // Solo vacía el carrito después de confirmar en Oracle.
                    int cantidad = carrito.size();
                    carrito.clear();
                    mensaje = "Alquiler confirmado por " + diasSeleccionados
                            + " día(s). Películas alquiladas: " + cantidad + ".";
                } catch (Exception e) {
                    if (con != null) {
                        try {
                            con.rollback();
                        } catch (SQLException ignored) { }
                    }
                    error = "No fue posible completar el alquiler: " + e.getMessage();
                } finally {
                    if (con != null) {
                        try {
                            con.close();
                        } catch (SQLException ignored) { }
                    }
                }
            }
        } else if ("agregar".equals(accion)) {
            if (carrito.contains(idPelicula)) error = "La película ya está en el carrito.";
            else if (carrito.size() >= 3) error = "El carrito permite un maximo de 3 peliculas.";
            else {
                // Una copia es válida si está físicamente disponible y no tiene alquiler abierto.
                String sqlDisponible = "SELECT COUNT(*) FROM Vhs v WHERE v.id_pelicula=? " +
                        "AND UPPER(v.estado_fisico_vhs)='DISPONIBLE' " +
                        "AND NOT EXISTS (SELECT 1 FROM Alquiler a WHERE a.id_vhs=v.id_vhs AND a.fecha_devolucion IS NULL)";
                try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(sqlDisponible)) {
                    ps.setInt(1, idPelicula);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            carrito.add(idPelicula);
                            mensaje = "Película agregada al carrito.";
                        } else {
                            error = "La película seleccionada no tiene copias disponibles.";
                        }
                    }
                } catch (SQLException e) {
                    error = "No fue posible consultar la disponibilidad: " + e.getMessage();
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=6">
    <title>Carrito VHS | Rewind &amp; Relive</title>
</head>

<body>
    <nav class="navbar retro-window">
        <%@ include file="logo.jsp" %>
        <ul class="nav-links">
            <li><a href="index.jsp">Inicio</a></li>
            <li><a href="catalogo.jsp">Catálogo</a></li>
            <li><a href="cliente-perfil.jsp">Mi Perfil</a></li>
            <li><a href="cliente-historial.jsp">Mi Historial</a></li>
        </ul>
    </nav>
    <main class="account-page">
        <section class="employee-header">
            <p class="employee-kicker">Orden de alquiler</p>
            <h1>Mi carrito</h1>
            <p>Peliculas seleccionadas y disponibilidad actual en la base de datos.</p>
        </section>
        <% if (mensaje != null) { %>
        <div class="employee-alert employee-alert-ok"><%= h(mensaje) %></div>
        <% } %>

        <% if (error != null) { %>
        <div class="employee-alert employee-alert-error"><%= h(error) %></div>
        <% } %>
        <section class="retro-window employee-panel">
            <div class="window-header"><span>carrito_actual.table</span><span>_ [] X</span></div>
            <div class="employee-table-wrap">
                <table class="employee-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Película</th>
                            <th>Precio dia</th>
                            <th>Disponibles</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // Acumula el precio diario de las películas visibles en el carrito.
                            java.math.BigDecimal total = java.math.BigDecimal.ZERO;

                            if (carrito.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="5" class="employee-empty">El carrito esta vacio.</td>
                        </tr>
                        <%
                            } else {
                                StringBuilder marcas = new StringBuilder();
                                for (int i = 0; i < carrito.size(); i++) {
                                    marcas.append(i == 0 ? "?" : ",?");
                                }

                                String sql =
                                        "SELECT p.id_pelicula, p.titulo, p.precio_unidad, " +
                                        "SUM(CASE WHEN UPPER(v.estado_fisico_vhs) = 'DISPONIBLE' " +
                                        "AND NOT EXISTS (SELECT 1 FROM Alquiler a " +
                                        "WHERE a.id_vhs = v.id_vhs AND a.fecha_devolucion IS NULL) " +
                                        "THEN 1 ELSE 0 END) disponibles " +
                                        "FROM Peliculas p LEFT JOIN Vhs v ON v.id_pelicula = p.id_pelicula " +
                                        "WHERE p.id_pelicula IN (" + marcas + ") " +
                                        "GROUP BY p.id_pelicula, p.titulo, p.precio_unidad ORDER BY p.titulo";

                                try (
                                    Connection con = ConexionDB.obtenerConexion();
                                    PreparedStatement ps = con.prepareStatement(sql)
                                ) {
                                    for (int i = 0; i < carrito.size(); i++) {
                                        ps.setInt(i + 1, carrito.get(i));
                                    }

                                    try (ResultSet rs = ps.executeQuery()) {
                                        int numero = 1;
                                        while (rs.next()) {
                                            java.math.BigDecimal precio = rs.getBigDecimal("precio_unidad");
                                            total = total.add(precio);
                        %>
                        <tr>
                            <td><%= numero++ %></td>
                            <td><%= h(rs.getString("titulo")) %></td>
                            <td>$<%= precio %></td>
                            <td><span class="status-badge <%= rs.getInt("disponibles") > 0 ? "status-ok" : "status-danger" %>"><%= rs.getInt("disponibles") %></span></td>
                            <td>
                                <form method="post">
                                    <input type="hidden" name="accion" value="quitar">
                                    <input type="hidden" name="id_pelicula" value="<%= rs.getInt("id_pelicula") %>">
                                    <button class="cart-item-remove" type="submit">Quitar</button>
                                </form>
                            </td>
                        </tr>
                        <%
                                        }
                                    }
                                } catch (SQLException e) {
                        %>
                        <tr>
                            <td colspan="5">No fue posible cargar el carrito: <%= h(e.getMessage()) %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
        <section class="cart-button-bar">
            <a class="cart-action-button cart-action-add" href="catalogo.jsp">Agregar películas</a>
            <% if (!carrito.isEmpty()) { %>
            <label class="cart-days-control">Días
                <input id="rentalDays" class="cart-days-input" type="number" name="dias"
                       value="<%= diasSeleccionados %>" min="1" max="30" required form="rentForm">
            </label>
            <form id="rentForm" method="post">
                <input type="hidden" name="accion" value="alquilar">
                <button class="cart-action-button cart-action-rent" type="submit">ALQUILAR</button>
            </form>
            <form method="post">
                <input type="hidden" name="accion" value="vaciar">
                <button class="cart-action-button cart-action-empty" type="submit">Vaciar carrito</button>
            </form>
            <% } %>

            <span class="account-limit" data-daily-total="<%= total %>">
                <strong>Total por día: $<%= total.setScale(2, java.math.RoundingMode.HALF_UP) %></strong>
                <% if (!carrito.isEmpty()) { %>
                | Total por <span id="rentalDaysLabel"><%= diasSeleccionados %></span> día(s):
                $<span id="rentalTotal"><%=
                    total.multiply(new java.math.BigDecimal(diasSeleccionados))
                            .setScale(2, java.math.RoundingMode.HALF_UP)
                %></span>
                <% } %>
                | Espacios disponibles: <%= 3 - carrito.size() %> / 3
            </span>
        </section>
    </main>
    <%@ include file="footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js?v=6"></script>
</body>

</html>
