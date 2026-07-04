<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Rewind & Relive | Nuestro Equipo</title>
</head>

<body>

<nav class="navbar retro-window">
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catálogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contáctanos</a></li>
        <li><a href="https://www.google.com" class="nav-search" aria-label="Buscar en Google" title="Buscar en Google"><span class="search-icon"></span></a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp" class="retro-button">Iniciar Sesión</a></li>
    </ul>
</nav>

<div class="content-section">
    <div class="team-header-container">
        <h1 class="glitch-title">> NUESTRO_EQUIPO_DEVELOPER.exe</h1>
    </div>

    <div class="retro-window team-main-window">
        <div class="window-header">
            <span>directorio_personal.vhs</span>
            <span>_ [] X</span>
        </div>

        <div class="team-grid">
            <!-- MIEMBRO 1: ALISSON AGUIRRE -->
            <div class="retro-window member-card">
                <div class="member-photo">
                    <img src="imgs/alison.jpeg" alt="Foto de Alisson Aguirre">
                </div>
                <div class="member-details">
                    <h3>Alisson Aguirre</h3>
                    <p class="role">Software Engineer</p>
                    <ul class="member-data-list">
                        <li><strong>ID:</strong> 001-DEV</li>
                        <li><strong>Cédula:</strong> 8-1032-1714</li>
                        <li><strong>Carrera:</strong> Lic. en Ing. de Software</li>
                        <li><strong>Tech:</strong> Java, Oracle, CSS</li>
                        <li><strong>Hobby:</strong> League of Legends</li>
                        <li><strong>Status:</strong> [ONLINE]</li>
                    </ul>
                    <p class="member-experience">
                        <strong>Resumen:</strong> Especializada en arquitectura de bases de datos relacionales y optimización de consultas SQL. Ha colaborado en el diseño lógico de módulos de inventario y seguridad del sistema.
                    </p>
                    <div class="member-contact-footer">alisson.aguirre@utp.ac.pa</div>
                </div>
            </div>

            <!-- MIEMBRO 2: FABIAN RODRIGUEZ -->
            <div class="retro-window member-card">
                <div class="member-photo">
                    <img src="imgs/fabian.jpeg" alt="Foto de Fabian Rodriguez">
                </div>
                <div class="member-details">
                    <h3>Fabian Rodriguez</h3>
                    <p class="role">Software Engineer</p>
                    <ul class="member-data-list">
                        <li><strong>ID:</strong> 002-DEV</li>
                        <li><strong>Cédula:</strong> 2-756-805</li>
                        <li><strong>Carrera:</strong> Lic. en Ing. de Software</li>
                        <li><strong>Tech:</strong> Java, Oracle, CSS</li>
                        <li><strong>Hobby:</strong> Gym</li>
                        <li><strong>Status:</strong> [ONLINE]</li>
                    </ul>
                    <p class="member-experience">
                        <strong>Resumen:</strong> Enfocado en el desarrollo ágil orientado a objetos y la implementación de lógica comercial en Java. Encargado del control de transacciones de alquiler y flujos backend eficientes.
                    </p>
                    <div class="member-contact-footer">fabian.rodriguez@utp.ac.pa</div>
                </div>
            </div>

            <!-- MIEMBRO 3: HELEN BOLAÑOS -->
            <div class="retro-window member-card">
                <div class="member-photo">
                    <img src="imgs/helen.jpeg" alt="Foto de Helen Bolaños">
                </div>
                <div class="member-details">
                    <h3>Helen Bolaños</h3>
                    <p class="role">Software Engineer</p>
                    <ul class="member-data-list">
                        <li><strong>ID:</strong> 003-DEV</li>
                        <li><strong>Cédula:</strong> 20-14-8089</li>
                        <li><strong>Carrera:</strong> Lic. en Ing. de Software</li>
                        <li><strong>Tech:</strong> Java, Oracle, CSS</li>
                        <li><strong>Hobby:</strong> Salir con los amigos</li>
                        <li><strong>Status:</strong> [ONLINE]</li>
                    </ul>
                    <p class="member-experience">
                        <strong>Resumen:</strong> Apasionada por el diseño modular y el desacoplamiento de componentes. Cuenta con experiencia sólida gestionando la persistencia de datos y la validación segura de formularios web.
                    </p>
                    <div class="member-contact-footer">helen.bolanos@utp.ac.pa</div>
                </div>
            </div>

            <!-- MIEMBRO 4: LEANDRO BARRIOS -->
            <div class="retro-window member-card">
                <div class="member-photo">
                    <img src="imgs/leandro.jpeg" alt="Foto de Leandro Barrios">
                </div>
                <div class="member-details">
                    <h3>Leandro Barrios</h3>
                    <p class="role">Software Engineer</p>
                    <ul class="member-data-list">
                        <li><strong>ID:</strong> 004-DEV</li>
                        <li><strong>Cédula:</strong> 20-16-8080</li>
                        <li><strong>Carrera:</strong> Lic. en Ing. de Software</li>
                        <li><strong>Tech:</strong> Java, Oracle, CSS</li>
                        <li><strong>Hobby:</strong> Videojuegos</li>
                        <li><strong>Status:</strong> [ONLINE]</li>
                    </ul>
                    <p class="member-experience">
                        <strong>Resumen:</strong> Desarrollador enfocado en soluciones limpias usando patrones de diseño arquitectónicos. Lideró la sincronización de las vistas dinámicas JSP con el modelo del servidor local.
                    </p>
                    <div class="member-contact-footer">leandro.barrios@utp.ac.pa</div>
                </div>
            </div>

            <!-- MIEMBRO 5: ARAMYS CEDEÑO -->
            <div class="retro-window member-card">
                <div class="member-photo">
                    <img src="imgs/aramys.jpeg" alt="Foto de Aramys Cedeño">
                </div>
                <div class="member-details">
                    <h3>Aramys Cedeño</h3>
                    <p class="role">Software Engineer</p>
                    <ul class="member-data-list">
                        <li><strong>ID:</strong> 005-DEV</li>
                        <li><strong>Cédula:</strong> 8-1039-59</li>
                        <li><strong>Carrera:</strong> Lic. en Ing. de Software</li>
                        <li><strong>Tech:</strong> Java, Oracle, CSS</li>
                        <li><strong>Hobby:</strong> Gym</li>
                        <li><strong>Status:</strong> [ONLINE]</li>
                    </ul>
                    <p class="member-experience">
                        <strong>Resumen:</strong> Encargado de la maquetación responsiva e interactiva. Cuenta con trayectoria integrando estilos complejos y animaciones ligeras que preservan la fidelidad de interfaces retro.
                    </p>
                    <div class="member-contact-footer">aramys.cedeno@utp.ac.pa</div>
                </div>
            </div>

            <!-- MIEMBRO 6: MARTIN AGUILAR -->
            <div class="retro-window member-card">
                <div class="member-photo">
                    <img src="imgs/reinier.jpeg" alt="Foto de Martin Aguilar">
                </div>
                <div class="member-details">
                    <h3>Martin Aguilar</h3>
                    <p class="role">Software Engineer</p>
                    <ul class="member-data-list">
                        <li><strong>ID:</strong> 006-DEV</li>
                        <li><strong>Cédula:</strong> 8-1035-2264</li>
                        <li><strong>Carrera:</strong> Lic. en Ing. de Software</li>
                        <li><strong>Tech:</strong> Java, Oracle, CSS</li>
                        <li><strong>Hobby:</strong> Apuestas deportivas</li>
                        <li><strong>Status:</strong> [ONLINE]</li>
                    </ul>
                    <p class="member-experience">
                        <strong>Resumen:</strong> Orientado al testing de sistemas y depuración de errores críticos de ejecución en entornos distribuidos. Ha supervisado el correcto mapeo relacional de la base de datos empresarial.
                    </p>
                    <div class="member-contact-footer">martin.aguilar@utp.ac.pa</div>
                </div>
            </div>
        </div>
    </div>

    <div class="retro-window store-window">
        <div class="window-header">
            <span>Contacto_Soporte.txt</span>
            <span>_ [] X</span>
        </div>
        <div class="store-content">
            <h3>Centro de Soporte Técnico</h3>
            <p><strong>Ubicación:</strong> Facultad de Ingeniería de Sistemas Computacionales, Edificio 3, Universidad Tecnológica de Panamá.</p>
            <p><strong>Soporte Directo:</strong> soporte@rewindrelive.com</p>
            <p><strong>Horario:</strong> Lunes - Viernes / 08:00 - 17:00</p>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>
