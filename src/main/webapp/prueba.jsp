<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.conexion.ConexionDB" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Usuario</title>
</head>
<body>
<h2>Registrar Usuario</h2>

<%
    if ("POST".equals(request.getMethod())) {
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO Usuario (ced_usuario, primer_nombre_usuario, segundo_nombre_usuario, " +
                             "primer_apellido_usuario, segundo_apellido_usuario, fecha_registro, rol) " +
                             "VALUES (?, ?, ?, ?, ?, SYSDATE, ?)")) {

            ps.setString(1, request.getParameter("ced_usuario"));
            ps.setString(2, request.getParameter("primer_nombre_usuario"));
            ps.setString(3, request.getParameter("segundo_nombre_usuario"));
            ps.setString(4, request.getParameter("primer_apellido_usuario"));
            ps.setString(5, request.getParameter("segundo_apellido_usuario"));
            ps.setString(6, request.getParameter("rol"));
            ps.executeUpdate();
%>
<p> Usuario registrado correctamente.</p>
<%
} catch (SQLException e) {
%>
<p> Error: <%= e.getMessage() %></p>
<%
        }
    }
%>

<form method="post">
    <label>Cédula:</label><br>
    <input type="text" name="ced_usuario" required><br><br>

    <label>Primer Nombre:</label><br>
    <input type="text" name="primer_nombre_usuario" required><br><br>

    <label>Segundo Nombre:</label><br>
    <input type="text" name="segundo_nombre_usuario"><br><br>

    <label>Primer Apellido:</label><br>
    <input type="text" name="primer_apellido_usuario" required><br><br>

    <label>Segundo Apellido:</label><br>
    <input type="text" name="segundo_apellido_usuario"><br><br>

    <label>Rol:</label><br>
    <select name="rol" required>
        <option value="CLIENTE">Cliente</option>
        <option value="EMPLEADO">Empleado</option>
        <option value="ADMIN">Admin</option>
    </select><br><br>

    <button type="submit">Registrar</button>
</form>
</body>
</html>