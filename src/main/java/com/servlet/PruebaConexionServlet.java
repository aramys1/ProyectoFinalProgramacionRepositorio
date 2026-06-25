package com.servlet;

import com.conexion.ConexionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
// Asegúrate de que digan javax y no jakarta
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/probar-conexion")
public class PruebaConexionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h2>Intentando conectar a Oracle Cloud...</h2>");

        try (Connection con = ConexionDB.obtenerConexion()) {
            if (con != null && !con.isClosed()) {
                out.println("<h1 style='color:green;'>¡Conexión Exitosa! 🎉</h1>");
                out.println("<p>Tu aplicación Java se ha conectado correctamente a Oracle Cloud de forma segura.</p>");
            }
        } catch (SQLException e) {
            out.println("<h1 style='color:red;'>Error de Conexión ❌</h1>");
            out.println("<p>Mensaje detallado:</p>");
            out.println("<pre style='background:#eee; padding:10px;'>" + e.getMessage() + "</pre>");
            e.printStackTrace(out);
        }
        out.println("</body></html>");
    }
}