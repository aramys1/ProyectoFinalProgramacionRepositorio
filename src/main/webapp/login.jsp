<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                <span>Login.exe</span>
                <span>_ [] X</span>
            </div>

            <div class="login-content">
                <a href="index.jsp" class="login-brand">Rewind & Relive</a>
                <p class="login-subtitle">Acceso al videoclub</p>

                <form id="loginForm" class="login-form" action="VerificarLoginServlet" method="POST">
                    <label for="usuario">Usuario</label>
                    <input id="usuario" class="retro-input" type="text" name="usuario" placeholder="tu_usuario" required>

                    <label for="password">Contrasena</label>
                    <input id="password" class="retro-input" type="password" name="password" placeholder="********" required>

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
