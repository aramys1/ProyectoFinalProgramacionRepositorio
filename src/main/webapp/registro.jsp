<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
            <div class="window-header">
                <span>Registro.exe</span>
                <span>_ [] X</span>
            </div>

            <div class="login-content">
                <a href="index.jsp" class="login-brand">Rewind & Relive</a>
                <p class="login-subtitle">Crea tu cuenta demo del videoclub</p>

                <form id="registroForm" class="login-form" action="#" method="post" data-demo-redirect="index.jsp">
                    <label for="nombre">Nombre completo</label>
                    <input id="nombre" class="retro-input" type="text" name="nombre" placeholder="Nombre Apellido" required>

                    <label for="correo">Correo electronico</label>
                    <input id="correo" class="retro-input" type="email" name="correo" placeholder="usuario@correo.com" required>

                    <label for="usuario">Usuario</label>
                    <input id="usuario" class="retro-input" type="text" name="usuario" placeholder="tu_usuario" required>

                    <label for="password">Contrasena</label>
                    <input id="password" class="retro-input" type="password" name="password" placeholder="********" required>

                    <label for="confirmarPassword">Confirmar contrasena</label>
                    <input id="confirmarPassword" class="retro-input" type="password" name="confirmarPassword" placeholder="********" required>

                    <label for="numeroTarjeta">Tarjeta VHS</label>
                    <input id="numeroTarjeta" class="retro-input" type="text" name="numeroTarjeta" placeholder="5 o 6 numeros" inputmode="numeric" maxlength="6" pattern="[0-9]{5,6}" required>

                    <div class="register-card-row">
                        <label>
                            Expira
                            <input class="retro-input" type="text" name="fechaExpiracion" placeholder="MM/AA" maxlength="5" pattern="(0[1-9]|1[0-2])/[0-9]{2}" required>
                        </label>
                        <label>
                            CVV
                            <input class="retro-input" type="text" name="cvv" placeholder="123" inputmode="numeric" maxlength="3" pattern="[0-9]{3}" required>
                        </label>
                    </div>

                    <label for="tipoTarjeta">Tipo de tarjeta</label>
                    <select id="tipoTarjeta" class="retro-input" name="tipoTarjeta" required>
                        <option value="">Seleccionar</option>
                        <option value="VHS Club">VHS Club</option>
                        <option value="Retro Pass">Retro Pass</option>
                    </select>

                    <button type="submit" class="retro-button login-submit">CREAR CUENTA</button>
                </form>

                <a href="login.jsp" class="login-back">Ya tengo cuenta</a>
            </div>
        </section>
    </main>

    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
