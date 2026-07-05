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
    <%@ include file="logo.jsp" %>
    <ul class="nav-links">
        <li><a href="catalogo.jsp">Catalogo</a></li>
        <li><a href="novedades.jsp">Novedades</a></li>
        <li><a href="contactanos.jsp">Contactanos</a></li>
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
                    <a class="retro-button nav-employee-button" href="empleado-devolucion.jsp">Devoluciones</a>
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

            <article class="log-entry">
                <div class="log-header">
                    <h4 class="log-title">[Artículo] Buenas noticias para el formato físico de películas. Las ventas de UHDs crecen impulsadas por el aumento de interés de la Generación Z</h4>
                    <span class="category-badge cat-culture">Cultura Retro</span>
                </div>
                <p class="news-item-text">
                    n los albores del streaming, parecía que esto no iba a suceder, pero sin duda ha sucedido. Estamos viendo mucha evidencia, incluso en el Criterion Mobile Closet, de que cada vez más jóvenes piensan en los medios físicos de una manera diferente. En una era donde tenemos tanto disponible bajo demanda, se vuelve cada vez más importante para nosotros
                </p>
                <a href="https://www.espinof.com/divulgacion/buenas-noticias-para-formato-fisico-peliculas-ventas-uhds-crecen-impulsadas-aumento-interes-generacion-z" target="_blank" class="catalog-link">Leer artículo original &gt;</a>
            </article>

            <article class="log-entry">
                <div class="log-header">
                    <h4 class="log-title">[Artículo]¿Vuelven las películas en formato físico?</h4>
                    <span class="category-badge cat-collection">Colección</span>
                </div>
                <p class="news-item-text">
                    ¿Estamos ante un regreso a las viejas glorias de las películas en formato físico? Es debatible, pero en cualquier caso, son buenas noticias para la cinefilia en general, y para espacios como el nuestro, donde nos gusta promover el cine en discos ópticos.
                </p>
                <a href="https://filmclubcafe.com.mx/blog/articulos/peliculas-en-formato-fisico-regresan/" target="_blank" class="catalog-link">Leer artículo original &gt;</a>
            </article>

            <article class="log-entry">
                <div class="log-header">
                    <h4 class="log-title">[Video] V/H/S | La Saga Completa | RESUMEN</h4>
                    <span class="category-badge cat-video">Multimedia</span>
                </div>
                <p class="news-item-text">
                    Te cuento una repasa la antología de terror V/H/S, explorando las perturbadoras historias encontradas en cintas de video malditas. Este resumen destaca los segmentos más icónicos de la saga y el horror visceral de sus metrajes.
                </p>

                <div class="news-video-wrapper">
                    <iframe src="https://www.youtube.com/embed/nkQqUpWYCOI"
                            title="YouTube video player"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowfullscreen>
                    </iframe>
                </div>
                <a href="https://www.youtube.com/watch?v=nkQqUpWYCOI" target="_blank" class="catalog-link">Ver video fuente directamente en YouTube &gt;</a>
            </article>

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

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>