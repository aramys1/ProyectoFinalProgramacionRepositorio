<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.math.BigDecimal, com.conexion.ConexionDB" %>
<%!
    private BigDecimal montoMulta(boolean retraso, boolean danada) {
        BigDecimal monto = BigDecimal.ZERO;
        if (retraso) {
            monto = monto.add(new BigDecimal("2.00"));
        }
        if (danada) {
            monto = monto.add(new BigDecimal("5.00"));
        }
        return monto;
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    String idParam = request.getParameter("idAlquiler") == null ? "" : request.getParameter("idAlquiler").trim();
    String mensaje = null;
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        boolean retraso = request.getParameter("retraso") != null;
        boolean danada = request.getParameter("cintaDanada") != null;
        BigDecimal multa = montoMulta(retraso, danada);

        try {
            int idAlquiler = Integer.parseInt(idParam);
            try (Connection con = ConexionDB.obtenerConexion()) {
                con.setAutoCommit(false);
                try {
                    int idVhs;
                    int idEmpleado;
                    try (PreparedStatement ps = con.prepareStatement(
                            "SELECT id_vhs, id_usuario_empleado FROM Alquiler WHERE id_alquiler = ? AND fecha_devolucion IS NULL")) {
                        ps.setInt(1, idAlquiler);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) {
                                throw new SQLException("No se encontró un alquiler activo con ese ID.");
                            }
                            idVhs = rs.getInt("id_vhs");
                            idEmpleado = rs.getInt("id_usuario_empleado");
                        }
                    }

                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE Alquiler SET estado_alquiler = 'Devuelto', fecha_devolucion = SYSDATE WHERE id_alquiler = ?")) {
                        ps.setInt(1, idAlquiler);
                        ps.executeUpdate();
                    }

                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE Vhs SET estado_fisico_vhs = ? WHERE id_vhs = ?")) {
                        ps.setString(1, danada ? "Dañada" : "Disponible");
                        ps.setInt(2, idVhs);
                        ps.executeUpdate();
                    }

                    if (multa.compareTo(BigDecimal.ZERO) > 0) {
                        String motivo = (retraso && danada) ? "Retraso y cinta dañada" : (retraso ? "Retraso" : "Cinta dañada");
                        try (PreparedStatement ps = con.prepareStatement(
                                "INSERT INTO Multas (id_multa, monto_multa, motivo_multa, estado_multa, fecha_multa, id_alquiler) " +
                                "VALUES (seq_multa.NEXTVAL, ?, ?, 'Pagada', SYSDATE, ?)")) {
                            ps.setBigDecimal(1, multa);
                            ps.setString(2, motivo);
                            ps.setInt(3, idAlquiler);
                            ps.executeUpdate();
                        }

                        int idMulta;
                        try (PreparedStatement ps = con.prepareStatement("SELECT seq_multa.CURRVAL FROM dual");
                             ResultSet rs = ps.executeQuery()) {
                            rs.next();
                            idMulta = rs.getInt(1);
                        }

                        try (PreparedStatement ps = con.prepareStatement(
                                "INSERT INTO Transaccion (id_pago, fecha_pago, monto, tipo_pago, estado_pago, id_alquiler, id_usuario_empleado, id_multa) " +
                                "VALUES (seq_pago.NEXTVAL, SYSDATE, ?, 'Multa', 'Aprobado', ?, ?, ?)")) {
                            ps.setBigDecimal(1, multa);
                            ps.setInt(2, idAlquiler);
                            ps.setInt(3, idEmpleado);
                            ps.setInt(4, idMulta);
                            ps.executeUpdate();
                        }
                    }

                    con.commit();
                    mensaje = "Devolución registrada correctamente. Multa calculada: $" + multa;
                    idParam = "";
                } catch (SQLException e) {
                    con.rollback();
                    error = e.getMessage();
                } finally {
                    con.setAutoCommit(true);
                }
            }
        } catch (NumberFormatException e) {
            error = "Ingresa un ID de alquiler válido.";
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
    <link rel="stylesheet" href="css/style.css">
    <title>Registrar Devolución | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolución</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Registro_Devolucion.exe</p>
        <h1>Registrar devolución</h1>
        <p>Busca el alquiler por ID, marca las incidencias y deja registrada la multa automáticamente.</p>
    </section>

    <% if (mensaje != null) { %><div class="employee-alert employee-alert-ok"><%= mensaje %></div><% } %>
    <% if (error != null) { %><div class="employee-alert employee-alert-error"><%= error %></div><% } %>

    <section class="employee-split">
        <article class="retro-window employee-panel">
            <div class="window-header"><span>Buscar_Alquiler.form</span><span>_ □ X</span></div>
            <form class="employee-form" method="get" action="empleado-devolucion.jsp">
                <label for="buscarId">ID del alquiler</label>
                <div class="employee-inline-form">
                    <input id="buscarId" type="number" name="idAlquiler" class="retro-search" value="<%= idParam %>" min="1" placeholder="Ej. 1024" required>
                    <button type="submit" class="retro-button">BUSCAR</button>
                </div>
            </form>
        </article>

        <article class="retro-window employee-panel">
            <div class="window-header"><span>Procesar_Devolucion.form</span><span>_ □ X</span></div>
            <%
                boolean encontrado = false;
                if (!idParam.isEmpty()) {
                    try {
                        int idAlquilerVista = Integer.parseInt(idParam);
                        try (Connection con = ConexionDB.obtenerConexion();
                             PreparedStatement ps = con.prepareStatement(
                                     "SELECT a.id_alquiler, TO_CHAR(a.fecha_limite, 'YYYY-MM-DD') fecha_limite, " +
                                     "u.primer_nombre_usuario || ' ' || u.primer_apellido_usuario cliente, p.titulo, v.id_vhs, v.estado_fisico_vhs, " +
                                     "CASE WHEN a.fecha_limite < TRUNC(SYSDATE) THEN 'Sí' ELSE 'No' END esta_retrasado " +
                                     "FROM Alquiler a JOIN Usuario u ON u.id_usuario = a.id_usuario_cliente " +
                                     "JOIN Vhs v ON v.id_vhs = a.id_vhs JOIN Peliculas p ON p.id_pelicula = v.id_pelicula " +
                                     "WHERE a.id_alquiler = ? AND a.fecha_devolucion IS NULL")) {
                            ps.setInt(1, idAlquilerVista);
                            try (ResultSet rs = ps.executeQuery()) {
                                if (rs.next()) {
                                    encontrado = true;
            %>
            <form class="employee-form" method="post" action="empleado-devolucion.jsp">
                <input type="hidden" name="idAlquiler" value="<%= rs.getInt("id_alquiler") %>">
                <div class="employee-summary">
                    <p><strong>Cliente:</strong> <%= rs.getString("cliente") %></p>
                    <p><strong>Película:</strong> <%= rs.getString("titulo") %></p>
                    <p><strong>VHS:</strong> #<%= rs.getInt("id_vhs") %> - <%= rs.getString("estado_fisico_vhs") %></p>
                    <p><strong>Fecha límite:</strong> <%= rs.getString("fecha_limite") %></p>
                    <p><strong>Retraso detectado:</strong> <%= rs.getString("esta_retrasado") %></p>
                </div>

                <label class="employee-check"><input type="checkbox" name="retraso" <%= "Sí".equals(rs.getString("esta_retrasado")) ? "checked" : "" %>> Registrar retraso ($2.00)</label>
                <label class="employee-check"><input type="checkbox" name="cintaDanada"> Cinta dañada ($5.00)</label>

                <button type="submit" class="retro-button employee-submit">PROCESAR DEVOLUCIÓN</button>
            </form>
            <%
                                }
                            }
                        }
                    } catch (NumberFormatException e) {
                        out.print("<div class='employee-empty'>El ID ingresado no es válido.</div>");
                    } catch (SQLException e) {
                        out.print("<div class='employee-alert employee-alert-error'>No se pudo buscar el alquiler: " + e.getMessage() + "</div>");
                    }
                }
                if (!idParam.isEmpty() && !encontrado) {
            %>
            <div class="employee-empty">No se encontró un alquiler activo con ese ID.</div>
            <% } else if (idParam.isEmpty()) { %>
            <div class="employee-empty">Busca un alquiler activo para habilitar el registro de devolución.</div>
            <% } %>
        </article>
    </section>
</main>
</body>
</html>
