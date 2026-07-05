<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>
<%--
    El registro inserta Usuario y, usando su id_usuario, crea TarjetaUsuario, UsuarioEmail y
    UsuarioTelefono. Todo ocurre en una transacción: cualquier restricción UNIQUE/FK o dato inválido
    provoca rollback para no dejar una cuenta incompleta.
--%>

<%
    request.setCharacterEncoding("UTF-8");
    String errorRegistro = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Datos básicos
        String cedula = request.getParameter("cedula");
        String pNombre = request.getParameter("primerNombre");
        String sNombre = request.getParameter("segundoNombre");
        String pApellido = request.getParameter("primerApellido");
        String sApellido = request.getParameter("segundoApellido");
        String pass = request.getParameter("password");

        // Datos tarjeta
        String numTarjeta = request.getParameter("numTarjeta");
        String tipoTarjeta = request.getParameter("tipoTarjeta");
        String exp = request.getParameter("expiracion");
        String cvv = request.getParameter("cvv");

        Connection conn = null;
        try {
            String tarjetaNormalizada = numTarjeta == null ? "" : numTarjeta.replaceAll("[\\s-]", "");
            String cvvNormalizado = cvv == null ? "" : cvv.trim();
            if (!tarjetaNormalizada.matches("\\d{13,19}")) {
                throw new IllegalArgumentException("El número de tarjeta debe contener entre 13 y 19 dígitos.");
            }
            if (!cvvNormalizado.matches("\\d{3,4}")) {
                throw new IllegalArgumentException("El CVV debe contener 3 o 4 dígitos.");
            }

            // Abre la conexión. autoCommit=false evita confirmar cada INSERT por separado.
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false); // Los cambios quedan pendientes hasta conn.commit().

            // 1) Tabla padre Usuario. Su ID será la clave foránea de tarjeta y contactos.
            String sql = "INSERT INTO USUARIO (CED_USUARIO, PRIMER_NOMBRE_USUARIO, SEGUNDO_NOMBRE_USUARIO, " +
                    "PRIMER_APELLIDO_USUARIO, SEGUNDO_APELLIDO_USUARIO, ROL, CONTRASENA) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            // Cada setX define tipo JDBC y posición del parámetro correspondiente.
            ps.setString(1, cedula);
            ps.setString(2, pNombre);
            ps.setString(3, sNombre);
            ps.setString(4, pApellido);
            ps.setString(5, sApellido);
            ps.setInt(6, 1);
            ps.setString(7, pass);
            // executeUpdate se usa para INSERT/UPDATE/DELETE y devuelve filas afectadas.
            ps.executeUpdate();
            ps.close();

            // 2) Recupera el ID generado buscando la cédula, que es UNIQUE en Usuario.
            PreparedStatement psId = conn.prepareStatement("SELECT id_usuario FROM Usuario WHERE ced_usuario = ?");
            psId.setString(1, cedula);
            ResultSet rs = psId.executeQuery();
            // Solo se crean datos dependientes si Oracle devolvió el usuario recién insertado.
            if (rs.next()) {
                int idUsuario = rs.getInt("id_usuario");

                // 3) TarjetaUsuario referencia al usuario mediante ID_USUARIO.
                // seq_tarjeta.NEXTVAL solicita a Oracle un identificador único para la tarjeta.
                PreparedStatement psT = conn.prepareStatement("INSERT INTO TARJETAUSUARIO (ID_TARJETA, NUMERO, TIPO_TARJETA, FECHA_EXPIRACION, CVV, ID_USUARIO) VALUES (seq_tarjeta.NEXTVAL, ?, ?, ?, ?, ?)");
                psT.setBigDecimal(1, new java.math.BigDecimal(tarjetaNormalizada));
                psT.setString(2, tipoTarjeta);
                psT.setString(3, exp);
                psT.setInt(4, Integer.parseInt(cvvNormalizado));
                psT.setInt(5, idUsuario);
                psT.executeUpdate();
                psT.close();

                // 4) UsuarioEmail permite hasta un correo por tipo para cada usuario según su PK compuesta.
                String[] emails = {request.getParameter("email"), request.getParameter("email2")};
                String[] tipoEmails = {request.getParameter("tipoEmail"), request.getParameter("tipoEmail2")};
                for(int i=0; i<2; i++) {
                    if(emails[i] != null && !emails[i].isEmpty()) {
                        PreparedStatement psE = conn.prepareStatement("INSERT INTO UsuarioEmail (email, id_tipo_email, id_usuario) VALUES (?, ?, ?)");
                        psE.setString(1, emails[i]);
                        psE.setInt(2, Integer.parseInt(tipoEmails[i]));
                        psE.setInt(3, idUsuario);
                        psE.executeUpdate();
                        psE.close();
                    }
                }

                // 5) UsuarioTelefono funciona igual: teléfono + tipo + propietario.
                String[] telefonos = {request.getParameter("telefono"), request.getParameter("telefono2")};
                String[] tipoTelefonos = {request.getParameter("tipoTelefono"), request.getParameter("tipoTelefono2")};
                for (int i = 0; i < 2; i++) {
                    if (telefonos[i] != null && !telefonos[i].isBlank()) {
                        PreparedStatement psTel = conn.prepareStatement(
                                "INSERT INTO UsuarioTelefono (telefono, id_tipo_telefono, id_usuario) VALUES (?, ?, ?)");
                        psTel.setString(1, telefonos[i].trim());
                        psTel.setInt(2, Integer.parseInt(tipoTelefonos[i]));
                        psTel.setInt(3, idUsuario);
                        psTel.executeUpdate();
                        psTel.close();
                    }
                }
            }
            rs.close();
            psId.close();
            // Confirma simultáneamente Usuario, tarjeta, correos y teléfonos.
            conn.commit();
            response.sendRedirect("login.jsp");
            return;
        } catch (Exception e) {
            if (conn != null) {
                // Deshace todo lo pendiente; así nunca queda un registro incompleto.
                try { conn.rollback(); } catch (SQLException ignored) { }
            }
            errorRegistro = "No se pudo completar el registro: " + e.getMessage();
        } finally {
            if (conn != null) {
                // Libera la conexión aunque el INSERT o la redirección fallen.
                try { conn.close(); } catch (SQLException ignored) { }
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Rewind & Relive | Registro</title>
</head>
<body class="login-page">
<main class="login-screen">
    <section class="retro-window login-window register-window">
        <div class="window-header"><span>Registro.exe</span><span>_ [] X</span></div>
        <div class="login-content">
            <a href="index.jsp" class="login-brand">Rewind & Relive</a>
            <% if (!errorRegistro.isEmpty()) { %>
            <div class="employee-alert employee-alert-error login-alert"><%= errorRegistro %></div>
            <% } %>
            <form id="registroForm" class="login-form" action="" method="post" onsubmit="return validarContrasenas()">
                <label>Cédula</label> <input class="retro-input" type="text" name="cedula" required>
                <label>Primer Nombre</label> <input class="retro-input" type="text" name="primerNombre" required>
                <label>Segundo Nombre</label> <input class="retro-input" type="text" name="segundoNombre">
                <label>Primer Apellido</label> <input class="retro-input" type="text" name="primerApellido" required>
                <label>Segundo Apellido</label> <input class="retro-input" type="text" name="segundoApellido" required>

                <hr style="border: 1px inset #fff; margin: 10px 0;">
                <label>Número de Tarjeta</label> <input class="retro-input" type="text" name="numTarjeta" inputmode="numeric" pattern="[0-9 -]{13,23}" title="Entre 13 y 19 dígitos; puede usar espacios o guiones" required>
                <label>Tipo de Tarjeta</label>
                <select class="retro-input" name="tipoTarjeta"><option value="CREDITO">Crédito</option><option value="DEBITO">Débito</option></select>
                <label>Expiración (MM/AA)</label> <input class="retro-input" type="text" name="expiracion" placeholder="MM/AA" required>
                <label>CVV</label> <input class="retro-input" type="password" name="cvv" inputmode="numeric" pattern="[0-9]{3,4}" maxlength="4" required>
                <hr style="border: 1px inset #fff; margin: 10px 0;">

                <label>Email 1</label> <input class="retro-input" type="email" name="email" required>
                <select class="retro-input" name="tipoEmail"><option value="1">Personal</option><option value="2">Trabajo</option></select>
                <label>Email 2</label> <input class="retro-input" type="email" name="email2">
                <select class="retro-input" name="tipoEmail2"><option value="1">Personal</option><option value="2" selected>Trabajo</option></select>

                <label>Teléfono 1</label> <input class="retro-input" type="text" name="telefono" required>
                <select class="retro-input" name="tipoTelefono"><option value="1">Movil</option><option value="2">Casa</option></select>
                <label>Teléfono 2</label> <input class="retro-input" type="text" name="telefono2">
                <select class="retro-input" name="tipoTelefono2"><option value="1">Movil</option><option value="2" selected>Casa</option></select>

                <label>Contraseña</label> <input id="password" class="retro-input" type="password" name="password" required>
                <label>Confirmar Contraseña</label> <input id="confirmPassword" class="retro-input" type="password" required>

                <button type="submit" class="retro-button login-submit">CREAR CUENTA</button>
                <a href="login.jsp" class="login-back">Ya tengo cuenta</a>
            </form>
        </div>
    </section>
</main>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
