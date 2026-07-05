<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Autenticación: busca una coincidencia exacta de cédula y contraseña en Usuario mediante parámetros.
    Si existe, copia ID, cédula y rol a HttpSession; las demás páginas usan esos atributos para autorizar.
--%>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>

<%
    String errorLogin = "";

    // GET + sesión existente: no vuelve a consultar Oracle; redirige según el rol ya autenticado.
    if (!"POST".equalsIgnoreCase(request.getMethod()) && session.getAttribute("idUsuario") != null) {
        String rolSesion = String.valueOf(session.getAttribute("rolUsuario"));
        if ("1".equals(rolSesion) || "CLIENTE".equalsIgnoreCase(rolSesion)) {
            response.sendRedirect("index.jsp"); return;
        }
        if ("2".equals(rolSesion) || "EMPLEADO".equalsIgnoreCase(rolSesion)) {
            response.sendRedirect("empleado-dashboard.jsp"); return;
        }
        if ("3".equals(rolSesion) || "ADMIN".equalsIgnoreCase(rolSesion) || "ADMINISTRADOR".equalsIgnoreCase(rolSesion)) {
            response.sendRedirect("administrador-usuarios.jsp"); return;
        }
    }

    // POST significa que el usuario envió las credenciales del formulario.
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String cedula = request.getParameter("usuario") != null ? request.getParameter("usuario").trim() : "";
        String password = request.getParameter("password") != null ? request.getParameter("password").trim() : "";

        // Los signos ? son marcadores: Oracle recibe el SQL separado de los valores escritos.
        String sql = "SELECT ID_USUARIO, CED_USUARIO, ROL FROM USUARIO WHERE CED_USUARIO = ? AND CONTRASENA = ?";

        // Connection representa la sesión con Oracle. try-with-resources la cierra automáticamente.
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Los índices comienzan en 1 y corresponden a los ? de izquierda a derecha.
            ps.setString(1, cedula);
            ps.setString(2, password);

            // executeQuery se usa para SELECT y devuelve las filas mediante ResultSet.
            try (ResultSet rs = ps.executeQuery()) {
                // rs.next() avanza a la primera fila; false significa credenciales sin coincidencia.
                if (rs.next()) {
                    String rol = rs.getString("ROL") != null ? rs.getString("ROL").trim().toUpperCase() : "";

                    // La sesión conserva identidad y rol entre peticiones HTTP posteriores.
                    session.setAttribute("idUsuario", rs.getInt("ID_USUARIO"));
                    session.setAttribute("cedulaUsuario", rs.getString("CED_USUARIO"));
                    session.setAttribute("rolUsuario", rol);

                    if ("1".equals(rol) || "CLIENTE".equals(rol)) {
                        response.sendRedirect("index.jsp");
                        return;
                    }

                    if ("2".equals(rol) || "EMPLEADO".equals(rol)) {
                        response.sendRedirect("empleado-dashboard.jsp");
                        return;
                    }

                    if ("3".equals(rol) || "ADMIN".equals(rol) || "ADMINISTRADOR".equals(rol)) {
                        response.sendRedirect("administrador-usuarios.jsp");
                        return;
                    }

                    errorLogin = "El usuario existe, pero su rol no tiene una vista asignada.";
                } else {
                    errorLogin = "Cedula o contrasena incorrecta.";
                }
            }
        } catch (SQLException e) {
            // SQLException incluye errores de conexión, nombres de columnas y ejecución de Oracle.
            errorLogin = "No se pudo validar el usuario con la base de datos: " + e.getMessage();
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
            <p class="login-subtitle">Acceso del videoclub</p>

            <% if (!errorLogin.isEmpty()) { %>
            <div class="employee-alert employee-alert-error login-alert"><%= errorLogin %></div>
            <% } %>

            <form id="loginForm" class="login-form" action="" method="post">
                <label for="usuario">Cedula</label>
                <input id="usuario" class="retro-input" type="text" name="usuario" placeholder="1-234-56" required>

                <label for="password">Contrasena</label>
                <input id="password" class="retro-input" type="password" name="password" required>

                <button type="submit" class="retro-button login-submit">ENTRAR</button>
                <a href="registro.jsp" class="retro-button btn-register login-register">REGISTRARSE</a>
            </form>

            <a href="index.jsp" class="login-back">Volver al inicio</a>
        </div>
    </section>
</main>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
