<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/styles_index.css"> 
    <title>Rewind & Relive | Catálogo</title>

    <style>
        /* Estilos específicos para la sección de catálogo */
        .catalog-container {
            margin-top: 40px;
        }
        .filter-form {
            display: flex; 
            gap: 10px; 
            width: 100%;
        }
        .select-filter {
            width: auto; 
            max-width: 200px;
        }
        .catalog-grid .release-card {
            display: flex; 
            flex-direction: column; 
            height: auto; 
            padding-bottom: 15px;
        }
        .catalog-grid .card-img {
            background-size: cover; 
            background-position: center; 
            flex-grow: 1; 
            min-height: 220px;
        }
        .catalog-grid .card-body {
            padding: 10px; 
            font-family: 'Courier Prime', monospace;
        }
        .catalog-grid .card-title {
            font-family: 'Montserrat', sans-serif; 
            font-size: 1.1rem; 
            margin: 5px 0; 
            text-transform: uppercase;
        }
        .catalog-grid .card-meta {
            margin: 3px 0; 
            font-size: 0.9rem;
        }
        .catalog-grid .card-price {
            margin: 5px 0 10px 0; 
            font-size: 1rem; 
            color: #ff0055; 
            font-weight: bold;
        }
        .catalog-grid .btn-full {
            width: 100%; 
            font-size: 0.85rem;
        }
        .empty-catalog-message {
            text-align: center; 
            padding: 40px; 
            font-family: 'Courier Prime', monospace;
        }
        .logo-link {
            text-decoration: none; 
            color: inherit;
        }
    </style>
</head>
<body>

<!-- Navegación -->
<nav class="navbar retro-window">
    <div class="logo">
        <a href="index.jsp" class="logo-link">Rewind & Relive</a>
    </div>
    <ul class="nav-links">
        <li><a href="catalogo.jsp" class="active">Catálogo</a></li>
        <li><a href="#">Novedades</a></li>
        <li><a href="#">Contáctanos</a></li>
        <li><button class="retro-button btn-register">Registrarse</button></li>
    </ul>
</nav>

<div class="content-section catalog-container">
    <!-- Barra de Búsqueda y Filtros -->
    <div class="search-section">
        <form action="CatalogoServlet" method="GET" class="filter-form">
            <input type="text" name="buscar" class="retro-search" placeholder="Buscar por título, director..." value="${param.buscar}">
            
            <select name="genero" class="retro-search select-filter">
                <option value="">Todos los géneros</option>
                <option value="Accion" ${param.genero == 'Accion' ? 'selected' : ''}>Acción</option>
                <option value="Terror" ${param.genero == 'Terror' ? 'selected' : ''}>Terror</option>
                <option value="Sci-Fi" ${param.genero == 'Sci-Fi' ? 'selected' : ''}>Sci-Fi</option>
                <option value="Comedia" ${param.genero == 'Comedia' ? 'selected' : ''}>Comedia</option>
            </select>
            
            <button type="submit" class="retro-button">FILTRAR</button>
        </form>
    </div>

    <!-- Sección del Catálogo Dinámico -->
    <section class="releases">
        <h2>Catálogo de Casetes</h2>
        
        <div class="release-grid catalog-grid">
            <c:forEach var="pelicula" items="${listaPeliculas}">
                <div class="retro-window release-card">
                    <div class="window-header">
                        <span>${pelicula.codigo}.vhs</span>
                        <span>_ □ X</span>
                    </div>
                    
                    <!-- Portada dinámica -->
                    <div class="placeholder-img card-img" 
                         style="background-image: url('${not empty pelicula.imagen ? pelicula.imagen : 'img/vhs_placeholder.jpg'}');">
                    </div>
                    
                    <div class="card-body">
                        <h3 class="card-title">
                            <c:out value="${pelicula.titulo}" />
                        </h3>
                        <p class="card-meta"><strong>Año:</strong> ${pelicula.anio}</p>
                        <p class="card-meta"><strong>Género:</strong> ${pelicula.genero}</p>
                        <p class="card-price">$${pelicula.precioAlquiler} / 48hrs</p>
                        
                        <form action="RentServlet" method="POST">
                            <input type="hidden" name="idPelicula" value="${pelicula.id}">
                            <button type="submit" class="retro-button btn-rent btn-full">
                                ALQUILAR
                            </button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <!-- Mensaje si no hay resultados -->
        <c:if test="${empty listaPeliculas}">
            <div class="retro-window empty-catalog-message">
                <h3>[ ERROR 404: Cintas No Encontradas ]</h3>
                <p>No se encontraron casetes que coincidan con tu búsqueda. Intenta rebobinar e intentar de nuevo.</p>
            </div>
        </c:if>
    </section>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="footer-content">
        <div class="footer-col">
            <h4>Rewind & Relive</h4>
            <p>El hogar definitivo de los clásicos en VHS.</p>
        </div>
        <div class="footer-col">
            <h4>Navegación</h4>
            <ul>
                <li><a href="catalogo.jsp">Catálogo</a></li>
                <li><a href="#">Novedades</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Contacto</h4>
            <p>📍 Av. VHS, #1980</p>
            <p>📧 hola@rewind.com</p>
        </div>
    </div>
    <hr>
    <div class="copyright">
        © 2026 Rewind & Relive. Todos los derechos reservados.
    </div>
</footer>

<script src="js/script_index.js"></script>
</body>
</html>