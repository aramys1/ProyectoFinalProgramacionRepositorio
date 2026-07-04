<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>

<%
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

        try (Connection conn = ConexionDB.obtenerConexion()) {
            conn.setAutoCommit(false); // Transacción para asegurar integridad

            // Insertar Usuario
            String sql = "INSERT INTO USUARIO (CED_USUARIO, PRIMER_NOMBRE_USUARIO, SEGUNDO_NOMBRE_USUARIO, " +
                    "PRIMER_APELLIDO_USUARIO, SEGUNDO_APELLIDO_USUARIO, ROL, CONTRASENA) VALUES (?, ?, ?, ?, ?, '1', ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, cedula);
            ps.setString(2, pNombre);
            ps.setString(3, sNombre);
            ps.setString(4, pApellido);
            ps.setString(5, sApellido);
            ps.setString(6, pass);
            ps.executeUpdate();

            ResultSet rs = conn.prepareStatement("SELECT id_usuario FROM Usuario WHERE ced_usuario = '" + cedula + "'").executeQuery();
            if (rs.next()) {
                int idUsuario = rs.getInt("id_usuario");

                // Insertar Tarjeta
                PreparedStatement psT = conn.prepareStatement("INSERT INTO TARJETAUSUARIO (ID_TARJETA, NUMERO, TIPO_TARJETA, FECHA_EXPIRACION, CVV, ID_USUARIO) VALUES (seq_tarjeta.NEXTVAL, ?, ?, ?, ?, ?)");
                psT.setString(1, numTarjeta);
                psT.setString(2, tipoTarjeta);
                psT.setString(3, exp);
                psT.setString(4, cvv);
                psT.setInt(5, idUsuario);
                psT.executeUpdate();

                // Insertar Emails
                String[] emails = {request.getParameter("email"), request.getParameter("email2")};
                String[] tipoEmails = {request.getParameter("tipoEmail"), request.getParameter("tipoEmail2")};
                for(int i=0; i<2; i++) {
                    if(emails[i] != null && !emails[i].isEmpty()) {
                        PreparedStatement psE = conn.prepareStatement("INSERT INTO UsuarioEmail (email, id_tipo_email, id_usuario) VALUES (?, ?, ?)");
                        psE.setString(1, emails[i]);
                        psE.setInt(2, Integer.parseInt(tipoEmails[i]));
                        psE.setInt(3, idUsuario);
                        psE.executeUpdate();
                    }
                }
            }
            conn.commit();
        } catch (Exception e) {
            // Manejar error
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
            <form id="registroForm" class="login-form" action="" method="post" onsubmit="return validarContrasenas()">
                <label>Cédula</label> <input class="retro-input" type="text" name="cedula" required>
                <label>Primer Nombre</label> <input class="retro-input" type="text" name="primerNombre" required>
                <label>Segundo Nombre</label> <input class="retro-input" type="text" name="segundoNombre">
                <label>Primer Apellido</label> <input class="retro-input" type="text" name="primerApellido" required>
                <label>Segundo Apellido</label> <input class="retro-input" type="text" name="segundoApellido" required>

                <hr style="border: 1px inset #fff; margin: 10px 0;">
                <label>Número de Tarjeta</label> <input class="retro-input" type="text" name="numTarjeta" required>
                <label>Tipo de Tarjeta</label>
                <select class="retro-input" name="tipoTarjeta"><option value="CREDITO">Crédito</option><option value="DEBITO">Débito</option></select>
                <label>Expiración (MM/AA)</label> <input class="retro-input" type="text" name="expiracion" placeholder="MM/AA" required>
                <label>CVV</label> <input class="retro-input" type="password" name="cvv" maxlength="3" required>
                <hr style="border: 1px inset #fff; margin: 10px 0;">

                <label>Email 1</label> <input class="retro-input" type="email" name="email" required>
                <select class="retro-input" name="tipoEmail"><option value="1">Personal</option><option value="2">Trabajo</option></select>
                <label>Email 2</label> <input class="retro-input" type="email" name="email2">
                <select class="retro-input" name="tipoEmail2"><option value="1">Personal</option><option value="2">Trabajo</option></select>

                <label>Teléfono 1</label> <input class="retro-input" type="text" name="telefono" required>
                <select class="retro-input" name="tipoTelefono"><option value="1">Movil</option><option value="2">Casa</option></select>
                <label>Teléfono 2</label> <input class="retro-input" type="text" name="telefono2">
                <select class="retro-input" name="tipoTelefono2"><option value="1">Movil</option><option value="2">Casa</option></select>

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