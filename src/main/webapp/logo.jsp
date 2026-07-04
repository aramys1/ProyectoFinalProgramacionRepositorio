<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Estilos del componente Logo y Redes Sociales -->
<style>
    /* Contenedor general que agrupa el Logo + Texto + Redes */
    .logo-container-wrapper {
        display: inline-flex !important;
        align-items: center !important;
        gap: 25px !important; /* Espacio entre el bloque del logo y el bloque de redes */
    }

    .logo-link {
        display: inline-flex !important;
        align-items: center !important;
        gap: 15px !important;
        
        /* Tus estilos tipográficos */
        text-decoration: none !important;
        color: #000 !important;
        font-weight: 900 !important;
        font-size: 1.5rem !important;
        font-family: 'Montserrat', sans-serif !important;
        transition: none !important;
    }

    /* Estilos del Logo Principal */
    .logo-icon {
        height: 60px !important;       
        max-height: 60px !important;   
        width: auto !important;        
        object-fit: contain !important;
        display: inline-block !important;
    }

    /* Contenedor específico para los iconos de redes sociales */
    .logo-social-media {
        display: inline-flex !important;
        align-items: center !important;
        gap: 10px !important; /* Espacio entre cada icono de red social */
        border-left: 2px solid #000 !important; /* Pequeña barra separadora retro */
        padding-left: 15px !important;
    }

    /* Estilos para los iconos de las redes */
    .social-icon {
        height: 24px !important;       /* Tamaño pequeño y elegante para la barra */
        max-height: 24px !important;
        width: auto !important;
        object-fit: contain !important;
        display: block !important;
        transition: transform 0.2s ease !important;
    }

    /* Efecto hover sutil para mantener el dinamismo */
    .social-icon:hover {
        transform: scale(1.1);
    }
</style>

<!-- Estructura HTML unificada -->
<div class="logo-container-wrapper">
    <!-- Bloque del Logo y Nombre de la Empresa -->
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo-link">
        <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="Logo Rewind & Relive" class="logo-icon">
        Rewind & Relive
    </a>

    <!-- Bloque de Redes Sociales Adjunto -->
    <div class="logo-social-media">
        <a href="https://instagram.com" target="_blank" rel="noopener noreferrer">
            <img src="${pageContext.request.contextPath}/imgs/instagram.png" alt="Instagram" class="social-icon">
        </a>
        <a href="https://facebook.com" target="_blank" rel="noopener noreferrer">
            <img src="${pageContext.request.contextPath}/imgs/facebook.png" alt="Facebook" class="social-icon">
        </a>
        <a href="https://x.com" target="_blank" rel="noopener noreferrer">
            <img src="${pageContext.request.contextPath}/imgs/X.png" alt="X (Twitter)" class="social-icon">
        </a>
    </div>
</div>