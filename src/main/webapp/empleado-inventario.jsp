<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Inventario | Rewind & Relive</title>
</head>
<body>

<nav class="navbar retro-window employee-nav">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolucion</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-usuarios.jsp">Usuarios</a></li>
        <li><a href="https://www.google.com" class="nav-search" aria-label="Buscar en Google" title="Buscar en Google"><span class="search-icon"></span></a></li>
    </ul>
</nav>

<main class="employee-page" data-inventory-template>
    <section class="employee-header">
        <p class="employee-kicker">Inventario.catalog</p>
        <h1>Inventario de peliculas</h1>
        <p>Vista de trabajo para que el empleado vea las peliculas como catalogo, agregue nuevos titulos y revise detalles editables con sus copias.</p>
    </section>

    <section class="inventory-catalog-toolbar">
        <input type="text" class="retro-search" placeholder="Buscar pelicula por titulo">
        <button type="button" class="retro-button">FILTRAR</button>
    </section>

    <section class="inventory-catalog-grid">
        <article class="retro-window inventory-add-card">
            <div class="window-header"><span>Nueva_Pelicula.form</span><span>_ [] X</span></div>
            <div class="inventory-add-body">
                <strong>Agregar pelicula</strong>
                <p>Registrar titulo, poster, precio y cantidad inicial de copias desde esta misma pagina.</p>
                <button type="button" class="retro-button" data-add-movie-toggle>AGREGAR</button>
            </div>
        </article>

        <article class="retro-window inventory-card">
            <div class="window-header"><span>VHS_001.vhs</span><span>_ [] X</span></div>
            <img src="recursos/posters/terminator2.jpg" alt="Poster de Terminator 2" class="inventory-card-img">
            <div class="inventory-card-body">
                <h2>Terminator 2</h2>
                <p>1991 | Accion / Ciencia Ficcion</p>
                <p><strong>Disponibles:</strong> 6 de 10</p>
                <button type="button" class="retro-button btn-full" data-movie-select
                        data-title="Terminator 2"
                        data-year="1991"
                        data-genre="Accion / Ciencia Ficcion"
                        data-rating="PG-13"
                        data-price="2.99"
                        data-total="10"
                        data-available="6"
                        data-rented="3"
                        data-damaged="1"
                        data-poster="recursos/posters/terminator2.jpg"
                        data-synopsis="Un protector cyborg viaja al pasado para defender a John Connor de una nueva amenaza liquida.">
                    DETALLES
                </button>
            </div>
        </article>

        <article class="retro-window inventory-card">
            <div class="window-header"><span>VHS_002.vhs</span><span>_ [] X</span></div>
            <img src="recursos/posters/viernes13_6ta_poster.jpeg" alt="Poster de Viernes 13 Parte VI" class="inventory-card-img">
            <div class="inventory-card-body">
                <h2>Viernes 13 Parte VI</h2>
                <p>1986 | Terror</p>
                <p><strong>Disponibles:</strong> 4 de 8</p>
                <button type="button" class="retro-button btn-full" data-movie-select
                        data-title="Viernes 13 Parte VI"
                        data-year="1986"
                        data-genre="Terror"
                        data-rating="R"
                        data-price="1.99"
                        data-total="8"
                        data-available="4"
                        data-rented="2"
                        data-damaged="2"
                        data-poster="recursos/posters/viernes13_6ta_poster.jpeg"
                        data-synopsis="Jason regresa a Crystal Lake en una entrega cargada de humor oscuro y terror ochentero.">
                    DETALLES
                </button>
            </div>
        </article>

        <article class="retro-window inventory-card">
            <div class="window-header"><span>VHS_003.vhs</span><span>_ [] X</span></div>
            <img src="recursos/posters/tiburon4.jpeg" alt="Poster de Tiburon 4" class="inventory-card-img">
            <div class="inventory-card-body">
                <h2>Tiburon 4</h2>
                <p>1987 | Suspenso / Aventura</p>
                <p><strong>Disponibles:</strong> 3 de 4</p>
                <button type="button" class="retro-button btn-full" data-movie-select
                        data-title="Tiburon 4"
                        data-year="1987"
                        data-genre="Suspenso / Aventura"
                        data-rating="PG-13"
                        data-price="1.49"
                        data-total="4"
                        data-available="3"
                        data-rented="1"
                        data-damaged="0"
                        data-poster="recursos/posters/tiburon4.jpeg"
                        data-synopsis="La familia Brody vuelve a enfrentarse al terror marino en una historia de persecucion y supervivencia.">
                    DETALLES
                </button>
            </div>
        </article>
    </section>

    <section class="retro-window employee-panel inventory-add-panel" data-add-movie-panel hidden>
        <div class="window-header"><span>Agregar_Pelicula_Desde_Inventario.form</span><span>_ [] X</span></div>
        <form class="employee-form employee-movie-form" action="#" method="post">
            <div class="employee-form-grid">
                <label>Titulo
                    <input class="retro-search" type="text" placeholder="Ej. The Thing">
                </label>
                <label>Anio
                    <input class="retro-search" type="number" min="1900" placeholder="1982">
                </label>
                <label>Genero
                    <input class="retro-search" type="text" placeholder="Terror / Ciencia Ficcion">
                </label>
                <label>Clasificacion
                    <input class="retro-search" type="text" placeholder="R">
                </label>
                <label>Precio por dia
                    <input class="retro-search" type="number" min="0" step="0.01" placeholder="2.99">
                </label>
                <label>Cantidad de copias
                    <input class="retro-search" type="number" min="1" placeholder="5">
                </label>
                <label class="employee-full-field">Nombre del poster
                    <input class="retro-search" type="text" placeholder="posters/thething.jpg">
                </label>
                <label class="employee-full-field">Sinopsis
                    <textarea class="retro-search employee-textarea" placeholder="Descripcion breve de la pelicula"></textarea>
                </label>
            </div>
            <div class="employee-form-actions">
                <button type="button" class="retro-button">GUARDAR PELICULA</button>
                <button type="button" class="retro-button employee-cancel" data-add-movie-toggle>CANCELAR</button>
            </div>
        </form>
    </section>

    <section class="retro-window employee-panel inventory-detail catalog-detail-panel" data-inventory-detail>
        <div class="window-header"><span>Detalle_Editable_Pelicula.form</span><span>_ [] X</span></div>
        <div class="inventory-detail-grid">
            <div class="inventory-detail-poster-wrap">
                <img src="recursos/posters/terminator2.jpg" alt="Poster seleccionado" class="inventory-detail-poster" data-field="poster">
            </div>

            <form class="employee-form employee-movie-form" action="#" method="post">
                <div class="employee-form-grid">
                    <label>Titulo
                        <input class="retro-search" type="text" data-field="title" value="">
                    </label>
                    <label>Anio
                        <input class="retro-search" type="number" data-field="year" value="">
                    </label>
                    <label>Genero
                        <input class="retro-search" type="text" data-field="genre" value="">
                    </label>
                    <label>Clasificacion
                        <input class="retro-search" type="text" data-field="rating" value="">
                    </label>
                    <label>Precio por dia
                        <input class="retro-search" type="number" min="0" step="0.01" data-field="price" value="">
                    </label>
                    <label>Total de copias
                        <input class="retro-search" type="number" min="0" data-field="total" value="">
                    </label>
                    <label class="employee-full-field">Sinopsis
                        <textarea class="retro-search employee-textarea" data-field="synopsis"></textarea>
                    </label>
                </div>

                <div class="inventory-summary">
                    <article>
                        <span data-count="available">0</span>
                        <strong>Disponibles</strong>
                        <p>Copias listas para alquiler.</p>
                    </article>
                    <article>
                        <span data-count="rented">0</span>
                        <strong>En uso</strong>
                        <p>Copias actualmente alquiladas.</p>
                    </article>
                    <article>
                        <span data-count="damaged">0</span>
                        <strong>Danadas</strong>
                        <p>Copias pendientes de reparacion o retiro.</p>
                    </article>
                </div>

                <div class="copy-status-list inventory-copy-list">
                    <div class="copy-status-row" data-copy-status>
                        <span>VHS #001</span>
                        <span class="status-badge status-ok">DISPONIBLE</span>
                        <select class="retro-search">
                            <option>DISPONIBLE</option>
                            <option>EN USO</option>
                            <option>DANADA</option>
                        </select>
                    </div>
                    <div class="copy-status-row" data-copy-status>
                        <span>VHS #002</span>
                        <span class="status-badge status-warning">EN USO</span>
                        <select class="retro-search">
                            <option>EN USO</option>
                            <option>DISPONIBLE</option>
                            <option>DANADA</option>
                        </select>
                    </div>
                    <div class="copy-status-row" data-copy-status>
                        <span>VHS #003</span>
                        <span class="status-badge status-danger">DANADA</span>
                        <select class="retro-search">
                            <option>DANADA</option>
                            <option>DISPONIBLE</option>
                            <option>EN USO</option>
                        </select>
                    </div>
                </div>

                <div class="employee-form-actions">
                    <button type="button" class="retro-button">GUARDAR CAMBIOS</button>
                    <button type="button" class="retro-button employee-cancel">MARCAR FUERA DE CATALOGO</button>
                </div>
            </form>
        </div>
    </section>
</main>

<%@ include file="footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
