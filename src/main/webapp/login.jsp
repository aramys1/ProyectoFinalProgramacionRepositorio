<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String cedula = request.getParameter("usuario"); // Usamos el campo usuario para la cédula
        String password = request.getParameter("password");

        // Consultamos usuario, contraseña y el rol
        String sql = "SELECT ROL FROM USUARIO WHERE CED_USUARIO = ? AND CONTRASENA = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cedula);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String rol = rs.getString("ROL").trim();

                    // Lógica de redirección según el rol
                    if ("1".equals(rol)) {
                        response.sendRedirect("index.jsp"); // Cliente
                    } else if ("2".equals(rol)) {
                        response.sendRedirect("empleado-dashboard.jsp"); // Empleado
                    } else if ("3".equals(rol)) { // Opcional: Si tienes ADMIN como rol 3
                        response.sendRedirect("administrador-usuarios.jsp");
                    } else {
                    }
                } else {
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
    <title>Rewind & Relive | Login</title>
</head>
<body class="login-page">
<main class="login-screen">
    <section class="retro-window login-window">
        <div class="window-header">
            <span>Iniciar sesion</span>
            <span>_ [] X</span>
        </div>

        <div class="login-content">
            <a href="index.jsp" class="login-brand">Rewind & Relive</a>
            <p class="login-subtitle">Acceso demo del videoclub</p>

            <form id="loginForm" class="login-form" action="" method="post">
                <label for="usuario">Cédula</label>
                <input id="usuario" class="retro-input" type="text" name="usuario" required>

                <label for="password">Contraseña</label>
                <input id="password" class="retro-input" type="password" name="password" required>

                <button type="submit" class="retro-button login-submit">ENTRAR</button>
                <a href="registro.jsp" class="retro-button btn-register login-register">REGISTRARSE</a>
            </form>

            <a href="index.jsp" class="login-back">Volver al inicio</a>
        </div>
    </section>
</main>

</body>
</html>