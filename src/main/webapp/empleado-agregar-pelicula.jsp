<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <title>Agregar Pelicula | Rewind & Relive</title>
</head>
<body>
<nav class="navbar retro-window employee-nav">
    <div class="logo"><a href="index.jsp" class="logo-link">ADMIN PANEL</a></div>
    <ul class="nav-links">
        <li><a href="empleado-dashboard.jsp">Dashboard</a></li>
        <li><a href="empleado-alquileres.jsp">Alquileres</a></li>
        <li><a href="empleado-devolucion.jsp">Devolucion</a></li>
        <li><a href="empleado-inventario.jsp">Inventario</a></li>
        <li><a href="empleado-agregar-pelicula.jsp">Agregar pelicula</a></li>
        <li><a href="empleado-usuarios.jsp">Usuarios</a></li>
    </ul>
</nav>

<main class="employee-page">
    <section class="employee-header">
        <p class="employee-kicker">Catalogo.store</p>
        <h1>Agregar pelicula</h1>
        <p>Formulario de presentacion. Por ahora no inserta datos; el catalogo se mantiene como modulo aprobado.</p>
    </section>

    <section class="retro-window employee-panel employee-form-panel">
        <div class="window-header"><span>Nueva_Pelicula.form</span><span>_ [] X</span></div>
        <form class="employee-form employee-movie-form" action="#" method="post">
            <div class="employee-form-grid">
                <label>
                    Titulo *
                    <input type="text" class="retro-search" maxlength="100" placeholder="Ej. The Thing">
                </label>

                <label>
                    Precio por dia *
                    <input type="number" class="retro-search" min="0.01" step="0.01" placeholder="2.99">
                </label>

                <label>
                    Fecha de estreno *
                    <input type="date" class="retro-search">
                </label>

                <label>
                    Clasificacion *
                    <select class="retro-search">
                        <option>Seleccionar</option>
                        <option>Todo publico</option>
                        <option>Mayores de 12</option>
                        <option>Mayores de 18</option>
                    </select>
                </label>

                <label>
                    Genero principal *
                    <select class="retro-search">
                        <option>Seleccionar</option>
                        <option>Accion</option>
                        <option>Terror</option>
                        <option>Ciencia ficcion</option>
                        <option>Comedia</option>
                    </select>
                </label>

                <label>
                    Genero secundario
                    <select class="retro-search">
                        <option>Sin genero secundario</option>
                        <option>Accion</option>
                        <option>Terror</option>
                        <option>Ciencia ficcion</option>
                        <option>Comedia</option>
                    </select>
                </label>

                <label class="employee-full-field">
                    Sinopsis *
                    <textarea class="retro-search employee-textarea" maxlength="1000" placeholder="Describe la pelicula..."></textarea>
                </label>

                <label class="employee-full-field">
                    Poster / imagen
                    <input type="file" class="retro-search" accept="image/*">
                    <span class="employee-help">Campo visual de prueba. No sube archivos todavia.</span>
                </label>
            </div>

            <div class="employee-form-actions">
                <button type="button" class="retro-button">GUARDAR</button>
                <a href="empleado-dashboard.jsp" class="retro-button employee-cancel">CANCELAR</a>
            </div>
        </form>
    </section>
</main>
<script src="js/empleado-responsive.js"></script>
</body>
</html>
