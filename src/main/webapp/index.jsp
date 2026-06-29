<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Rewind & Relive | Inicio</title>
</head>
<body>

<nav class="navbar retro-window">
    <div class="logo"><a href="index.jsp" class="logo-link">Rewind & Relive</a></div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catalogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contactanos</a></li>
        <li class="nav-profile">
            <a href="cliente-perfil.jsp" class="retro-button">Mi perfil</a>
            <ul class="profile-menu">
                <li><a href="cliente-perfil.jsp">Mis ajustes</a></li>
                <li><a href="cliente-carrito.jsp">Mi carrito</a></li>
                <li><a href="cliente-historial.jsp">Mi historial</a></li>
            </ul>
        </li>
        <li class="nav-profile">
            <a href="empleado-dashboard.jsp" class="retro-button nav-employee-button">Empleado</a>
            <ul class="profile-menu">
                <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
                <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
                <li><a href="empleado-devolucion.jsp">Devolucion</a></li>
                <li><a href="empleado-inventario.jsp">Inventario</a></li>
                <li><a href="empleado-agregar-pelicula.jsp">Agregar pelicula</a></li>
                <li><a href="empleado-usuarios.jsp">Usuarios</a></li>
            </ul>
        </li>
        <li><a href="${pageContext.request.contextPath}/login.jsp" class="retro-button">Iniciar Sesion</a></li>
    </ul>
</nav>

<header class="hero">
    <div class="hero-content">
        <div class="hero-text-inner">
            <h1>Revive la magia del VHS</h1>
            <p>La mejor seleccion de clasicos, directo a tu sala.</p>
        </div>
    </div>
    <div class="hero-image-container">
        <div class="retro-window">
            <div class="window-header"><span>VHS_001.vhs</span><span>_ [] X</span></div>
            <div class="placeholder-img"></div>
        </div>
        <a href="catalogo.jsp" class="retro-button btn-rent">ALQUILAR</a>
    </div>
</header>

<section class="demo-access-section">
    <div class="demo-access-inner">
        <article class="retro-window demo-access-card">
            <div class="window-header"><span>usuario_registrado.menu</span><span>_ [] X</span></div>
            <div class="demo-access-body">
                <h2>Usuario registrado</h2>
                <p>Acceso de muestra para ver el perfil, carrito e historial sin conectar a la base de datos.</p>
                <div class="demo-access-actions">
                    <a class="retro-button" href="cliente-perfil.jsp">Mi perfil</a>
                    <a class="retro-button" href="cliente-carrito.jsp">Mi carrito</a>
                    <a class="retro-button" href="cliente-historial.jsp">Mi historial</a>
                </div>
            </div>
        </article>

        <article class="retro-window demo-access-card">
            <div class="window-header"><span>vistas_empleado.menu</span><span>_ [] X</span></div>
            <div class="demo-access-body">
                <h2>Vistas del empleado</h2>
                <p>Paneles de presentacion para alquileres, devoluciones, inventario y usuarios.</p>
                <div class="demo-access-actions">
                    <a class="retro-button nav-employee-button" href="empleado-dashboard.jsp">Dashboard</a>
                    <a class="retro-button nav-employee-button" href="empleado-alquileres.jsp">Alquileres</a>
                    <a class="retro-button nav-employee-button" href="empleado-inventario.jsp">Inventario</a>
                    <a class="retro-button nav-employee-button" href="empleado-usuarios.jsp">Usuarios</a>
                </div>
            </div>
        </article>
    </div>
</section>

<div class="content-section">
    <section class="releases">
        <h2>Ultimos Lanzamientos</h2>
        <div class="release-grid">
            <div class="retro-window release-card">
                <div class="window-header"><span>Pelicula.exe</span></div>
                <div class="card-content">
                    <img src="recursos/posters/terminator2.jpg" alt="Portada de Terminator 2" class="movie-img">
                    <h3>Terminator 2</h3>
                    <p>1991 | Accion</p>
                    <a href="catalogo.jsp" class="retro-button">VER MAS</a>
                </div>
            </div>
        </div>
        <a href="catalogo.jsp" class="catalog-link">VER CATALOGO COMPLETO &gt;</a>
    </section>
</div>

<section class="news-section">
    <h2 class="news-title">Tablon de Anuncios</h2>
    <div class="retro-window">
        <div class="window-header"><span>Noticias_Rewind.txt</span><span>_ [] X</span></div>
        <div class="news-content">
            <div class="log-entry">
                <div class="log-header">
                    <h4 class="log-title">[2026-06-27] Nueva llegada: clasicos de terror disponibles.</h4>
                    <span class="category-badge cat-inventario">Inventario</span>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="why-vhs-section">
    <div class="why-vhs-inner">
        <h2>Por que escoger VHS?</h2>
        <p class="why-vhs-intro">
            Porque cada cinta guarda una experiencia que va mas alla de reproducir una pelicula:
            es nostalgia, coleccion y una forma distinta de volver a mirar los clasicos.
        </p>
        <div class="why-vhs-grid">
            <article class="retro-window why-vhs-card">
                <div class="window-header"><span>nostalgia.txt</span><span>_ [] X</span></div>
                <div class="why-vhs-card-content">
                    <h3>Experiencia autentica</h3>
                    <p>El formato VHS conserva esa sensacion de videoclub, portada fisica y noche de pelicula en casa.</p>
                </div>
            </article>
            <article class="retro-window why-vhs-card">
                <div class="window-header"><span>coleccion.dat</span><span>_ [] X</span></div>
                <div class="why-vhs-card-content">
                    <h3>Clasicos seleccionados</h3>
                    <p>Reunimos titulos memorables para quienes disfrutan el cine retro con identidad propia.</p>
                </div>
            </article>
            <article class="retro-window why-vhs-card">
                <div class="window-header"><span>rewind.log</span><span>_ [] X</span></div>
                <div class="why-vhs-card-content">
                    <h3>Un ritual diferente</h3>
                    <p>Elegir, alquilar, rebobinar y compartir: cada paso hace que la pelicula se sienta especial.</p>
                </div>
            </article>
        </div>
    </div>
</section>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-col">
            <h4>Rewind & Relive</h4>
            <p>Tu destino retro preferido para descubrir, alquilar y revivir clasicos en formato VHS.</p>
        </div>
        <div class="footer-col">
            <h4>Navegacion</h4>
            <ul>
                <li><a href="catalogo.jsp">Catalogo</a></li>
                <li><a href="novedades.jsp">Novedades</a></li>
                <li><a href="contactanos.jsp">Contactanos</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Accesos demo</h4>
            <ul>
                <li><a href="cliente-perfil.jsp">Usuario registrado</a></li>
                <li><a href="empleado-dashboard.jsp">Vistas empleado</a></li>
            </ul>
        </div>
    </div>
    <div class="copyright">2026 Rewind & Relive. Todos los derechos reservados.</div>
</footer>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
