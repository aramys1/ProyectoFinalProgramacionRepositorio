<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String rutaFooter = request.getServletPath();
    boolean footerEmpleado = rutaFooter != null
            && rutaFooter.substring(rutaFooter.lastIndexOf('/') + 1).startsWith("empleado-");
%>
<style>
    .footer {
        background-color: #000;
        color: #fce4d6;
        padding: 48px 20px 18px;
        margin-top: auto;
        width: 100%;
        box-sizing: border-box;
    }

    .footer-content {
        display: grid;
        grid-template-columns: 1.3fr 1fr 1fr;
        gap: 36px;
        align-items: start;
        max-width: 1100px;
        margin: 0 auto;
    }

    .footer-col h4 {
        display: inline-block;
        margin-bottom: 15px;
        margin-top: 0;
        font-family: 'Montserrat', sans-serif;
        letter-spacing: 0;
    }

    .footer-col p {
        margin: 0;
        line-height: 1.6;
    }

    .footer-desc {
        font-size: 0.85rem;
        opacity: 0.5;
        line-height: 1.6;
        margin: 0;
    }

    .footer-col ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .footer-col ul li {
        margin-bottom: 8px;
    }

    .footer-col a {
        color: #fce4d6;
        text-decoration: none;
    }

    .footer-col a:hover {
        color: #ff9800;
    }

    /* ==========================================
       NUEVO BOTÓN RETRO DE CERRAR SESIÓN (LOGOUT)
       ========================================== */
    .btn-retro-logout {
        display: inline-block;
        background-color: #000;
        color: #ff9800 !important;
        /* Texto naranja característico */
        font-family: 'Courier Prime', monospace;
        font-size: 0.75rem !important;
        font-weight: bold;
        text-transform: uppercase;
        text-decoration: none !important;
        padding: 6px 14px;

        /* Borde retro simulando ventana de comandos/3D */
        border: 2px solid #ff9800 !important;
        box-shadow: 3px 3px 0px #ff9800;

        cursor: pointer;
        transition: all 0.1s ease;
    }

    /* Efecto al pasar el cursor por encima (Hover) */
    .btn-retro-logout:hover {
        background-color: #ff9800 !important;
        color: #000 !important;
        box-shadow: 3px 3px 0px #fce4d6;
        border-color: #fce4d6 !important;
    }

    /* Efecto de pulsación del botón (Click) */
    .btn-retro-logout:active {
        transform: translate(2px, 2px);
        box-shadow: 1px 1px 0px #ff9800;
    }

    /* Contenedor de la zona inferior */
    .copyright-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1100px;
        margin: 30px auto 0;
        padding-top: 18px;
    }

    .copyright {
        font-size: 0.7rem;
        opacity: 0.6;
        margin: 0;
    }

    .footer-logout-zone {
        padding-bottom: 4px;
    }
</style>

<footer class="footer">
    <div class="footer-content" <%= footerEmpleado ? "style=\"grid-template-columns: 1.3fr 2fr;\"" : "" %>>
        <div class="footer-col">
            <h4>Rewind & Relive</h4>
            <p>Tu destino retro preferido para descubrir, alquilar y revivir clásicos en formato VHS.</p>
        </div>

        <div class="footer-col">
            <h4>Navegación</h4>
            <ul>
                <% if (footerEmpleado) { %>
                <li><a href="${pageContext.request.contextPath}/empleado-dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/empleado-alquileres.jsp">Alquileres</a></li>
                <li><a href="${pageContext.request.contextPath}/empleado-devolucion.jsp">Devolución</a></li>
                <li><a href="${pageContext.request.contextPath}/empleado-inventario.jsp">Inventario</a></li>
                <li><a href="${pageContext.request.contextPath}/empleado-usuarios.jsp">Usuarios</a></li>
                <li><a href="${pageContext.request.contextPath}/empleado-alquilar.jsp">Nuevo Alquiler</a></li>
                <% } else { %>
                <li><a href="${pageContext.request.contextPath}/index.jsp">Inicio</a></li>
                <li><a href="${pageContext.request.contextPath}/catalogo.jsp">Catálogo</a></li>
                <li><a href="${pageContext.request.contextPath}/novedades.jsp">Novedades</a></li>
                <li><a href="${pageContext.request.contextPath}/contactanos.jsp">Contáctanos</a></li>
                <% } %>
            </ul>
        </div>

        <% if (!footerEmpleado) { %>
        <div class="footer-col">
            <h4>Mi Cuenta</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/cliente-perfil.jsp">Mi Perfil</a></li>
                <li><a href="${pageContext.request.contextPath}/cliente-carrito.jsp">Mi Carrito</a></li>
                <li><a href="${pageContext.request.contextPath}/cliente-historial.jsp">Mi Historial</a></li>
            </ul>
        </div>
        <% } %>
    </div>

    <div class="copyright-container">
        <p class="copyright">© 2026 Rewind & Relive. Todos los derechos reservados.</p>
        <div class="footer-logout-zone">
            <% if (session.getAttribute("idUsuario") != null) { %>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn-retro-logout">Cerrar Sesión</a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn-retro-logout">Iniciar Sesión</a>
            <% } %>
        </div>
    </div>
</footer>