<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.util.*,com.conexion.ConexionDB" %>
<%!
    private String h(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private int entero(String valor, int defecto) {
        try { return Integer.parseInt(valor); } catch (Exception e) { return defecto; }
    }
    private String nuloSiVacio(String valor) {
        return valor == null || valor.isBlank() ? null : valor.trim();
    }
    private String tarjetaOculta(String numero) {
        if (numero == null || numero.isBlank()) return "No registrada";
        String limpia = numero.replaceAll("\\D", "");
        String ultimos = limpia.length() <= 4 ? limpia : limpia.substring(limpia.length() - 4);
        return "•••• •••• •••• " + ultimos;
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    Object idSesion = session.getAttribute("idUsuario");
    String rolSesion = String.valueOf(session.getAttribute("rolUsuario"));
    if (idSesion == null || !("1".equals(rolSesion) || "CLIENTE".equalsIgnoreCase(rolSesion))) {
        response.sendRedirect("login.jsp");
        return;
    }
    int idUsuario = Integer.parseInt(String.valueOf(idSesion));
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Connection con = null;
        try {
            String cedula = nuloSiVacio(request.getParameter("cedula"));
            String primerNombre = nuloSiVacio(request.getParameter("primerNombre"));
            String segundoNombre = nuloSiVacio(request.getParameter("segundoNombre"));
            String primerApellido = nuloSiVacio(request.getParameter("primerApellido"));
            String segundoApellido = nuloSiVacio(request.getParameter("segundoApellido"));
            String nuevaPassword = nuloSiVacio(request.getParameter("nuevaPassword"));
            String confirmarPassword = nuloSiVacio(request.getParameter("confirmarPassword"));
            if (cedula == null || primerNombre == null || primerApellido == null) {
                throw new IllegalArgumentException("La cédula, el primer nombre y el primer apellido son obligatorios.");
            }
            if (nuevaPassword != null && !nuevaPassword.equals(confirmarPassword)) {
                throw new IllegalArgumentException("Las contraseñas nuevas no coinciden.");
            }

            String email1 = nuloSiVacio(request.getParameter("email1"));
            String email2 = nuloSiVacio(request.getParameter("email2"));
            int tipoEmail1 = entero(request.getParameter("tipoEmail1"), -1);
            int tipoEmail2 = entero(request.getParameter("tipoEmail2"), -1);
            String telefono1 = nuloSiVacio(request.getParameter("telefono1"));
            String telefono2 = nuloSiVacio(request.getParameter("telefono2"));
            int tipoTelefono1 = entero(request.getParameter("tipoTelefono1"), -1);
            int tipoTelefono2 = entero(request.getParameter("tipoTelefono2"), -1);
            if (email1 != null && email2 != null && tipoEmail1 == tipoEmail2) {
                throw new IllegalArgumentException("Los dos correos deben usar tipos diferentes.");
            }
            if (telefono1 != null && telefono2 != null && tipoTelefono1 == tipoTelefono2) {
                throw new IllegalArgumentException("Los dos teléfonos deben usar tipos diferentes.");
            }

            con = ConexionDB.obtenerConexion();
            con.setAutoCommit(false);
            String sqlUsuario = nuevaPassword == null
                    ? "UPDATE Usuario SET ced_usuario=?,primer_nombre_usuario=?,segundo_nombre_usuario=?,primer_apellido_usuario=?,segundo_apellido_usuario=? WHERE id_usuario=?"
                    : "UPDATE Usuario SET ced_usuario=?,primer_nombre_usuario=?,segundo_nombre_usuario=?,primer_apellido_usuario=?,segundo_apellido_usuario=?,contrasena=? WHERE id_usuario=?";
            try (PreparedStatement ps = con.prepareStatement(sqlUsuario)) {
                ps.setString(1, cedula); ps.setString(2, primerNombre); ps.setString(3, segundoNombre);
                ps.setString(4, primerApellido); ps.setString(5, segundoApellido);
                if (nuevaPassword == null) ps.setInt(6, idUsuario);
                else { ps.setString(6, nuevaPassword); ps.setInt(7, idUsuario); }
                if (ps.executeUpdate() != 1) throw new SQLException("No se encontró el usuario autenticado.");
            }

            try (PreparedStatement ps = con.prepareStatement("DELETE FROM UsuarioEmail WHERE id_usuario=?")) {
                ps.setInt(1,idUsuario); ps.executeUpdate();
            }
            try (PreparedStatement ps = con.prepareStatement("INSERT INTO UsuarioEmail(email,id_tipo_email,id_usuario) SELECT ?,id_tipo_email,? FROM tipo_email WHERE id_tipo_email=?")) {
                if (email1 != null) { ps.setString(1,email1); ps.setInt(2,idUsuario); ps.setInt(3,tipoEmail1); ps.executeUpdate(); }
                if (email2 != null) { ps.setString(1,email2); ps.setInt(2,idUsuario); ps.setInt(3,tipoEmail2); ps.executeUpdate(); }
            }
            try (PreparedStatement ps = con.prepareStatement("DELETE FROM UsuarioTelefono WHERE id_usuario=?")) {
                ps.setInt(1,idUsuario); ps.executeUpdate();
            }
            try (PreparedStatement ps = con.prepareStatement("INSERT INTO UsuarioTelefono(telefono,id_tipo_telefono,id_usuario) SELECT ?,id_tipo_telefono,? FROM tipo_telefonos WHERE id_tipo_telefono=?")) {
                if (telefono1 != null) { ps.setString(1,telefono1); ps.setInt(2,idUsuario); ps.setInt(3,tipoTelefono1); ps.executeUpdate(); }
                if (telefono2 != null) { ps.setString(1,telefono2); ps.setInt(2,idUsuario); ps.setInt(3,tipoTelefono2); ps.executeUpdate(); }
            }

            String numeroNuevo = nuloSiVacio(request.getParameter("numeroTarjeta"));
            String tipoTarjeta = nuloSiVacio(request.getParameter("tipoTarjeta"));
            String expiracion = nuloSiVacio(request.getParameter("expiracion"));
            if (tipoTarjeta != null && expiracion != null) {
                String sqlTarjeta = numeroNuevo == null
                        ? "UPDATE TarjetaUsuario SET tipo_tarjeta=?,fecha_expiracion=? WHERE id_usuario=?"
                        : "UPDATE TarjetaUsuario SET numero=?,tipo_tarjeta=?,fecha_expiracion=? WHERE id_usuario=?";
                try (PreparedStatement ps = con.prepareStatement(sqlTarjeta)) {
                    if (numeroNuevo == null) {
                        ps.setString(1,tipoTarjeta); ps.setString(2,expiracion); ps.setInt(3,idUsuario);
                    } else {
                        String normalizado=numeroNuevo.replaceAll("[\\s-]","");
                        if(!normalizado.matches("\\d{13,19}")) throw new IllegalArgumentException("El número nuevo de tarjeta debe tener entre 13 y 19 dígitos.");
                        ps.setBigDecimal(1,new java.math.BigDecimal(normalizado)); ps.setString(2,tipoTarjeta);
                        ps.setString(3,expiracion); ps.setInt(4,idUsuario);
                    }
                    ps.executeUpdate();
                }
            }
            con.commit();
            session.setAttribute("cedulaUsuario",cedula);
            response.sendRedirect("cliente-perfil.jsp?guardado=1");
            return;
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ignored) { }
            error=e.getMessage();
        } finally {
            if (con != null) try { con.close(); } catch (SQLException ignored) { }
        }
    }

    String cedula="",primerNombre="",segundoNombre="",primerApellido="",segundoApellido="",fechaRegistro="";
    String numeroTarjeta=null,tipoTarjeta="",expiracion="";
    List<String[]> emails=new ArrayList<>(), telefonos=new ArrayList<>();
    List<String[]> tiposEmail=new ArrayList<>(), tiposTelefono=new ArrayList<>();
    try (Connection con=ConexionDB.obtenerConexion()) {
        try (PreparedStatement ps=con.prepareStatement("SELECT ced_usuario,primer_nombre_usuario,segundo_nombre_usuario,primer_apellido_usuario,segundo_apellido_usuario,TO_CHAR(fecha_registro,'YYYY-MM-DD') fecha_registro FROM Usuario WHERE id_usuario=?")) {
            ps.setInt(1,idUsuario); try(ResultSet rs=ps.executeQuery()){ if(rs.next()){
                cedula=rs.getString("ced_usuario"); primerNombre=rs.getString("primer_nombre_usuario"); segundoNombre=rs.getString("segundo_nombre_usuario");
                primerApellido=rs.getString("primer_apellido_usuario"); segundoApellido=rs.getString("segundo_apellido_usuario"); fechaRegistro=rs.getString("fecha_registro");
            }}
        }
        try (PreparedStatement ps=con.prepareStatement("SELECT email,id_tipo_email FROM UsuarioEmail WHERE id_usuario=? ORDER BY id_tipo_email")) {
            ps.setInt(1,idUsuario); try(ResultSet rs=ps.executeQuery()){ while(rs.next()) emails.add(new String[]{rs.getString(1),rs.getString(2)}); }
        }
        try (PreparedStatement ps=con.prepareStatement("SELECT telefono,id_tipo_telefono FROM UsuarioTelefono WHERE id_usuario=? ORDER BY id_tipo_telefono")) {
            ps.setInt(1,idUsuario); try(ResultSet rs=ps.executeQuery()){ while(rs.next()) telefonos.add(new String[]{rs.getString(1),rs.getString(2)}); }
        }
        try (PreparedStatement ps=con.prepareStatement("SELECT numero,tipo_tarjeta,fecha_expiracion FROM TarjetaUsuario WHERE id_usuario=? ORDER BY id_tarjeta FETCH FIRST 1 ROW ONLY")) {
            ps.setInt(1,idUsuario); try(ResultSet rs=ps.executeQuery()){ if(rs.next()){numeroTarjeta=rs.getString(1);tipoTarjeta=rs.getString(2);expiracion=rs.getString(3);} }
        }
        try (PreparedStatement ps=con.prepareStatement("SELECT id_tipo_email,desc_tipo_email FROM tipo_email ORDER BY id_tipo_email");ResultSet rs=ps.executeQuery()) {
            while(rs.next()) tiposEmail.add(new String[]{rs.getString(1),rs.getString(2)});
        }
        try (PreparedStatement ps=con.prepareStatement("SELECT id_tipo_telefono,desc_tipo_telefono FROM tipo_telefonos ORDER BY id_tipo_telefono");ResultSet rs=ps.executeQuery()) {
            while(rs.next()) tiposTelefono.add(new String[]{rs.getString(1),rs.getString(2)});
        }
    } catch(SQLException e) { error=error==null?e.getMessage():error; }
    while(emails.size()<2) emails.add(new String[]{"", tiposEmail.size()>emails.size()?tiposEmail.get(emails.size())[0]:""});
    while(telefonos.size()<2) telefonos.add(new String[]{"", tiposTelefono.size()>telefonos.size()?tiposTelefono.get(telefonos.size())[0]:""});
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>Mi Perfil | Rewind &amp; Relive</title></head><body>
<nav class="navbar retro-window"><%@ include file="logo.jsp" %><ul class="nav-links">
<li><a href="index.jsp">Inicio</a></li><li><a href="catalogo.jsp">Catálogo</a></li><li><a href="cliente-carrito.jsp">Mi carrito</a></li><li><a href="cliente-historial.jsp">Mi historial</a></li>
</ul></nav>
<main class="account-page">
<section class="employee-header"><p class="employee-kicker">Cuenta de cliente #<%= idUsuario %></p><h1>Mi perfil</h1>
<p>Datos personales asociados a tu cuenta desde <%= h(fechaRegistro) %>.</p></section>
<% if(request.getParameter("guardado")!=null){%><div class="employee-alert employee-alert-ok">Tu perfil se actualizó correctamente.</div><%}%>
<% if(error!=null){%><div class="employee-alert employee-alert-error">No fue posible completar la operación: <%= h(error) %></div><%}%>
<% boolean editando = request.getParameter("editar") != null || error != null;
   if (!editando) { %>
<section class="account-grid">
<article class="retro-window account-card"><div class="window-header"><span>datos_personales.view</span><span>_ [] X</span></div>
<div class="account-card-body"><h2><%=h(primerNombre)%> <%=h(segundoNombre)%> <%=h(primerApellido)%> <%=h(segundoApellido)%></h2>
<p><strong>Cédula:</strong> <%=h(cedula)%></p><p><strong>Fecha de registro:</strong> <%=h(fechaRegistro)%></p><p><strong>Rol:</strong> Cliente</p></div></article>
<article class="retro-window account-card"><div class="window-header"><span>contacto.view</span><span>_ [] X</span></div>
<div class="account-card-body"><h2>Contacto</h2>
<% boolean hayEmail=false; for(String[] dato:emails){if(dato[0]!=null&&!dato[0].isBlank()){hayEmail=true;String nombreTipo="";for(String[] tipo:tiposEmail)if(tipo[0].equals(dato[1]))nombreTipo=tipo[1];%>
<p><strong>Correo <%=h(nombreTipo)%>:</strong> <%=h(dato[0])%></p><%}} if(!hayEmail){%><p>Sin correos registrados.</p><%}%>
<% boolean hayTelefono=false; for(String[] dato:telefonos){if(dato[0]!=null&&!dato[0].isBlank()){hayTelefono=true;String nombreTipo="";for(String[] tipo:tiposTelefono)if(tipo[0].equals(dato[1]))nombreTipo=tipo[1];%>
<p><strong>Teléfono <%=h(nombreTipo)%>:</strong> <%=h(dato[0])%></p><%}} if(!hayTelefono){%><p>Sin teléfonos registrados.</p><%}%>
</div></article>
<article class="retro-window account-card"><div class="window-header"><span>tarjeta.view</span><span>_ [] X</span></div>
<div class="account-card-body"><h2>Tarjeta</h2><p><strong>Número:</strong> <%=h(tarjetaOculta(numeroTarjeta))%></p>
<p><strong>Tipo:</strong> <%=h(tipoTarjeta)%></p><p><strong>Expiración:</strong> <%=h(expiracion)%></p></div></article>
<article class="retro-window account-card"><div class="window-header"><span>acciones_perfil.exe</span><span>_ [] X</span></div>
<div class="account-card-body account-actions-list"><a class="retro-button" href="cliente-perfil.jsp?editar=1">EDITAR INFORMACIÓN</a>
<a class="retro-button" href="cliente-carrito.jsp">VER CARRITO</a><a class="retro-button" href="cliente-historial.jsp">VER HISTORIAL</a></div></article>
</section>
<% } else { %>
<section class="retro-window employee-panel employee-form-panel"><div class="window-header"><span>perfil_usuario.edit</span><span>_ [] X</span></div>
<form class="employee-form employee-movie-form" method="post"><div class="employee-form-grid">
<label>Cédula *<input class="retro-search" name="cedula" required value="<%=h(cedula)%>"></label>
<label>Primer nombre *<input class="retro-search" name="primerNombre" required value="<%=h(primerNombre)%>"></label>
<label>Segundo nombre<input class="retro-search" name="segundoNombre" value="<%=h(segundoNombre)%>"></label>
<label>Primer apellido *<input class="retro-search" name="primerApellido" required value="<%=h(primerApellido)%>"></label>
<label>Segundo apellido<input class="retro-search" name="segundoApellido" value="<%=h(segundoApellido)%>"></label>
<label>Nueva contraseña<input class="retro-search" type="password" name="nuevaPassword" minlength="4" autocomplete="new-password" placeholder="Déjala vacía para conservarla"></label>
<label>Confirmar contraseña<input class="retro-search" type="password" name="confirmarPassword" minlength="4" autocomplete="new-password"></label>
<% for(int i=0;i<2;i++){String[] dato=emails.get(i);%>
<label>Correo <%=i+1%><input class="retro-search" type="email" name="email<%=i+1%>" value="<%=h(dato[0])%>"></label>
<label>Tipo de correo <%=i+1%><select class="retro-search" name="tipoEmail<%=i+1%>"><%for(String[] tipo:tiposEmail){%><option value="<%=tipo[0]%>" <%=tipo[0].equals(dato[1])?"selected":""%>><%=h(tipo[1])%></option><%}%></select></label>
<%}%>
<% for(int i=0;i<2;i++){String[] dato=telefonos.get(i);%>
<label>Teléfono <%=i+1%><input class="retro-search" name="telefono<%=i+1%>" value="<%=h(dato[0])%>"></label>
<label>Tipo de teléfono <%=i+1%><select class="retro-search" name="tipoTelefono<%=i+1%>"><%for(String[] tipo:tiposTelefono){%><option value="<%=tipo[0]%>" <%=tipo[0].equals(dato[1])?"selected":""%>><%=h(tipo[1])%></option><%}%></select></label>
<%}%>
<div class="employee-full-field"><h2>Tarjeta</h2><p><strong>Número actual:</strong> <%=h(tarjetaOculta(numeroTarjeta))%></p></div>
<label>Nueva tarjeta<input class="retro-search" name="numeroTarjeta" inputmode="numeric" placeholder="Vacío para conservar la actual"></label>
<label>Tipo<select class="retro-search" name="tipoTarjeta"><option value="CREDITO" <%="CREDITO".equalsIgnoreCase(tipoTarjeta)?"selected":""%>>Crédito</option><option value="DEBITO" <%="DEBITO".equalsIgnoreCase(tipoTarjeta)?"selected":""%>>Débito</option></select></label>
<label>Expiración<input class="retro-search" name="expiracion" pattern="(0[1-9]|1[0-2])/[0-9]{2}" placeholder="MM/AA" value="<%=h(expiracion)%>"></label>
</div><div class="employee-form-actions"><button class="retro-button" type="submit">GUARDAR PERFIL</button><a class="retro-button employee-cancel" href="cliente-perfil.jsp">CANCELAR</a></div></form>
</section>
<% } %>
</main><%@ include file="footer.jsp" %><script src="${pageContext.request.contextPath}/js/script.js"></script></body></html>
