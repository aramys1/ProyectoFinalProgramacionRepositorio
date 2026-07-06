<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,com.conexion.ConexionDB" %>
<%
    request.setCharacterEncoding("UTF-8");
    String errorRegistro = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String cedula = request.getParameter("cedula");
        String primerNombre = request.getParameter("primerNombre");
        String segundoNombre = request.getParameter("segundoNombre");
        String primerApellido = request.getParameter("primerApellido");
        String segundoApellido = request.getParameter("segundoApellido");
        String password = request.getParameter("password");

        String numeroTarjeta = request.getParameter("numTarjeta");
        String tipoTarjeta = request.getParameter("tipoTarjeta");
        String expiracion = request.getParameter("expiracion");
        String cvv = request.getParameter("cvv");

        Connection con = null;
        try {
            String tarjetaNormalizada = numeroTarjeta == null ? "" : numeroTarjeta.replaceAll("[\\s-]", "");
            String cvvNormalizado = cvv == null ? "" : cvv.trim();

            if (!tarjetaNormalizada.matches("\\d{13,19}")) {
                throw new IllegalArgumentException("El número de tarjeta debe contener entre 13 y 19 dígitos.");
            }
            if (!cvvNormalizado.matches("\\d{3,4}")) {
                throw new IllegalArgumentException("El CVV debe contener 3 o 4 dígitos.");
            }

            con = ConexionDB.obtenerConexion();
            con.setAutoCommit(false);

            String insertarUsuario = "INSERT INTO Usuario " +
                    "(ced_usuario,primer_nombre_usuario,segundo_nombre_usuario," +
                    "primer_apellido_usuario,segundo_apellido_usuario,rol,contrasena) " +
                    "VALUES(?,?,?,?,?,?,?)";
            try (PreparedStatement ps = con.prepareStatement(insertarUsuario)) {
                ps.setString(1, cedula);
                ps.setString(2, primerNombre);
                ps.setString(3, segundoNombre);
                ps.setString(4, primerApellido);
                ps.setString(5, segundoApellido);
                ps.setInt(6, 1);
                ps.setString(7, password);
                ps.executeUpdate();
            }

            int idUsuario;
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT id_usuario FROM Usuario WHERE ced_usuario=?")) {
                ps.setString(1, cedula);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new SQLException("No se pudo recuperar el usuario registrado.");
                    idUsuario = rs.getInt("id_usuario");
                }
            }

            String insertarTarjeta = "INSERT INTO TarjetaUsuario " +
                    "(id_tarjeta,numero,tipo_tarjeta,fecha_expiracion,cvv,id_usuario) " +
                    "VALUES(seq_tarjeta.NEXTVAL,?,?,?,?,?)";
            try (PreparedStatement ps = con.prepareStatement(insertarTarjeta)) {
                ps.setBigDecimal(1, new java.math.BigDecimal(tarjetaNormalizada));
                ps.setString(2, tipoTarjeta);
                ps.setString(3, expiracion);
                ps.setInt(4, Integer.parseInt(cvvNormalizado));
                ps.setInt(5, idUsuario);
                ps.executeUpdate();
            }

            String[] emails = {request.getParameter("email"), request.getParameter("email2")};
            String[] tiposEmail = {request.getParameter("tipoEmail"), request.getParameter("tipoEmail2")};
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO UsuarioEmail(email,id_tipo_email,id_usuario) VALUES(?,?,?)")) {
                for (int i = 0; i < emails.length; i++) {
                    if (emails[i] != null && !emails[i].isBlank()) {
                        ps.setString(1, emails[i].trim());
                        ps.setInt(2, Integer.parseInt(tiposEmail[i]));
                        ps.setInt(3, idUsuario);
                        ps.executeUpdate();
                    }
                }
            }

            String[] telefonos = {request.getParameter("telefono"), request.getParameter("telefono2")};
            String[] tiposTelefono = {request.getParameter("tipoTelefono"), request.getParameter("tipoTelefono2")};
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO UsuarioTelefono(telefono,id_tipo_telefono,id_usuario) VALUES(?,?,?)")) {
                for (int i = 0; i < telefonos.length; i++) {
                    if (telefonos[i] != null && !telefonos[i].isBlank()) {
                        ps.setString(1, telefonos[i].trim());
                        ps.setInt(2, Integer.parseInt(tiposTelefono[i]));
                        ps.setInt(3, idUsuario);
                        ps.executeUpdate();
                    }
                }
            }

            con.commit();
            response.sendRedirect("login.jsp");
            return;
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ignored) { }
            errorRegistro = "No se pudo completar el registro: " + e.getMessage();
        } finally {
            if (con != null) try { con.close(); } catch (SQLException ignored) { }
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
    <title>Rewind &amp; Relive | Registro</title>
</head>
<body class="login-page">
<main class="login-screen">
    <section class="retro-window login-window register-window">
        <div class="window-header">
            <span>Registro.exe</span>
            <span>_ [] X</span>
        </div>

        <div class="login-content">
            <a href="index.jsp" class="login-brand">Rewind &amp; Relive</a>

            <% if (!errorRegistro.isEmpty()) { %>
            <div class="employee-alert employee-alert-error login-alert"><%= errorRegistro %></div>
            <% } %>

            <form id="registroForm" class="login-form" method="post"
                  onsubmit="return validarContrasenas()">
                <label>Cédula</label>
                <input class="retro-input" name="cedula" required>

                <label>Primer nombre</label>
                <input class="retro-input" name="primerNombre" required>

                <label>Segundo nombre</label>
                <input class="retro-input" name="segundoNombre">

                <label>Primer apellido</label>
                <input class="retro-input" name="primerApellido" required>

                <label>Segundo apellido</label>
                <input class="retro-input" name="segundoApellido">

                <hr>
                <label>Número de tarjeta</label>
                <input class="retro-input" name="numTarjeta" inputmode="numeric"
                       pattern="[0-9 -]{13,23}" required>

                <label>Tipo de tarjeta</label>
                <select class="retro-input" name="tipoTarjeta">
                    <option value="CREDITO">Crédito</option>
                    <option value="DEBITO">Débito</option>
                </select>

                <label>Expiración (MM/AA)</label>
                <input class="retro-input" name="expiracion"
                       pattern="(0[1-9]|1[0-2])/[0-9]{2}" required>

                <label>CVV</label>
                <input class="retro-input" type="password" name="cvv"
                       inputmode="numeric" pattern="[0-9]{3,4}" maxlength="4" required>

                <hr>
                <label>Correo 1</label>
                <input class="retro-input" type="email" name="email" required>
                <select class="retro-input" name="tipoEmail">
                    <option value="1">Personal</option>
                    <option value="2">Trabajo</option>
                </select>

                <label>Correo 2</label>
                <input class="retro-input" type="email" name="email2">
                <select class="retro-input" name="tipoEmail2">
                    <option value="1">Personal</option>
                    <option value="2" selected>Trabajo</option>
                </select>

                <label>Teléfono 1</label>
                <input class="retro-input" name="telefono" required>
                <select class="retro-input" name="tipoTelefono">
                    <option value="1">Móvil</option>
                    <option value="2">Casa</option>
                </select>

                <label>Teléfono 2</label>
                <input class="retro-input" name="telefono2">
                <select class="retro-input" name="tipoTelefono2">
                    <option value="1">Móvil</option>
                    <option value="2" selected>Casa</option>
                </select>

                <label>Contraseña</label>
                <input id="password" class="retro-input" type="password"
                       name="password" required>

                <label>Confirmar contraseña</label>
                <input id="confirmPassword" class="retro-input" type="password" required>

                <button class="retro-button login-submit">CREAR CUENTA</button>
                <a href="login.jsp" class="login-back">Ya tengo cuenta</a>
            </form>
        </div>
    </section>
</main>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
