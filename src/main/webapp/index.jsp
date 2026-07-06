<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,com.conexion.ConexionDB" %>
<%-- Funciones auxiliares para escapar HTML y normalizar rutas de póster. --%>
<%!
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private String posterPath(String valor) {
        if (valor == null) return "";
        String ruta=valor.trim().replace('\\','/');
        while(ruta.startsWith("/")) ruta=ruta.substring(1);
        if(ruta.startsWith("recursos/")) ruta=ruta.substring("recursos/".length());
        return ruta;
    }
%>
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

    <%-- Navegación pública; el botón de acceso solo aparece sin sesión. --%>
    <nav class="navbar retro-window">
        <%@ include file="logo.jsp" %>
        <ul class="nav-links">
            <li><a href="catalogo.jsp">Catálogo</a></li>
            <li><a href="novedades.jsp">Novedades</a></li>
            <li><a href="contactanos.jsp">Contactanos</a></li>
            <% if (session.getAttribute("idUsuario") == null) { %>
            <li><a href="login.jsp" class="retro-button">Iniciar sesión</a></li>
            <% } %>
        </ul>
    </nav>

    <%-- Portada principal con carrusel de pósteres controlado por script.js. --%>
    <header class="hero">
        <div class="hero-content">
            <div class="hero-text-inner">
                <h1>Revive la magia del VHS</h1>
                <p>La mejor seleccion de clasicos, directo a tu sala.</p>
            </div>
        </div>
        <div class="hero-image-container">
            <div class="retro-window">
                <div class="window-header"><span data-hero-poster-name>terminator2.jpg</span><span>_ [] X</span></div>
                <img class="placeholder-img hero-poster-slideshow" src="${pageContext.request.contextPath}/recursos/posters/terminator2.jpg" alt="Póster de película" data-hero-poster-slider data-poster-base="${pageContext.request.contextPath}/recursos/posters/" data-posters="Cars.jpg,obsesion.png,scary.jpg,terminator2.jpg,tiburon4.jpeg,torrente2.jpg,viernes13_6ta_poster.jpeg">
            </div>
            <a href="catalogo.jsp" class="retro-button btn-rent">ALQUILAR</a>
        </div>
    </header>

    <%-- Accesos privados mostrados exclusivamente a clientes autenticados. --%>
    <% if (session.getAttribute("idUsuario") != null &&
        ("1".equals(String.valueOf(session.getAttribute("rolUsuario"))) ||
         "CLIENTE".equalsIgnoreCase(String.valueOf(session.getAttribute("rolUsuario"))))) { %>
    <section class="demo-access-section">
        <div class="demo-access-inner">
            <article class="retro-window demo-access-card">
                <div class="window-header"><span>usuario_registrado.menu</span><span>_ [] X</span></div>
                <div class="demo-access-body">
                    <h2>Usuario registrado</h2>
                    <p>Consulta tu perfil, las películas seleccionadas y tu historial personal de alquileres.</p>
                    <div class="demo-access-actions">
                        <a class="retro-button" href="cliente-perfil.jsp">Mi perfil</a>
                        <a class="retro-button" href="cliente-carrito.jsp">Mi carrito</a>
                        <a class="retro-button" href="cliente-historial.jsp">Mi historial</a>
                    </div>
                </div>
            </article>

        </div>
    </section>
    <% } %>

    <%-- Tres películas más recientes obtenidas directamente de Oracle. --%>
    <div class="content-section">
        <section class="releases">
            <h2>Ultimos Lanzamientos</h2>
            <div class="release-grid">
                <%
                // Consulta compacta: película, año y géneros relacionados.
                String sqlLanzamientos="SELECT p.id_pelicula,p.titulo,p.imagen_url,"+
                        "TO_CHAR(p.fecha_estreno,'YYYY') anio,"+
                        "(SELECT LISTAGG(g.desc_genero,' / ') WITHIN GROUP(ORDER BY pg.prioridad) FROM PeliculasGeneros pg "+
                        "JOIN Genero g ON g.id_genero=pg.id_genero WHERE pg.id_pelicula=p.id_pelicula) generos "+
                        "FROM Peliculas p ORDER BY p.id_pelicula DESC FETCH FIRST 3 ROWS ONLY";
                // Aunque no recibe filtros, PreparedStatement mantiene el mismo patrón seguro del proyecto.
                try(Connection con=ConexionDB.obtenerConexion();PreparedStatement ps=con.prepareStatement(sqlLanzamientos);ResultSet rs=ps.executeQuery()){
                    boolean hay=false;while(rs.next()){hay=true;String imagen=rs.getString("imagen_url");
            %>
                <article class="retro-window release-card">
                    <div class="window-header"><span>PELÍCULA_<%=rs.getInt("id_pelicula")%>.vhs</span><span>_ [] X</span></div>
                    <div class="card-content">
                        <%if(imagen!=null&&!imagen.isBlank()){%><img src="<%=request.getContextPath()%>/recursos/<%=h(posterPath(imagen))%>" alt="Portada de <%=h(rs.getString("titulo"))%>" class="movie-img">
                        <%}else{%><div class="placeholder-img movie-img"></div><%}%>
                    <h3><%=h(rs.getString("titulo"))%></h3>
                        <p><%=h(rs.getString("anio"))%><%=rs.getString("generos")==null?"":" | "+h(rs.getString("generos"))%></p>
                        <a href="pelicula-detalle.jsp?id=<%=rs.getInt("id_pelicula")%>" class="retro-button">VER MÁS</a>
                    </div>
                </article>
                <%      }if(!hay){%><p class="employee-empty">Todavía no hay películas publicadas.</p><%}
                }catch(SQLException e){%><p class="employee-empty">No fue posible cargar los últimos lanzamientos.</p><%}%>
        </div>
        <a href="catalogo.jsp" class="catalog-link">VER CATÁLOGO COMPLETO &gt;</a>
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

                <script src="${pageContext.request.contextPath}/js/script.js?v=4"></script>
</body>

</html>
