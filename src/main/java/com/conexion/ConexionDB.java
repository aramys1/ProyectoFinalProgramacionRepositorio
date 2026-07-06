package com.conexion;

import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    /**
     * Abre una conexión cifrada con Oracle Autonomous Database.
     * El llamador debe cerrarla, preferiblemente mediante try-with-resources.
     */
    public static Connection obtenerConexion() throws SQLException {

        // Credenciales usadas por JDBC para autenticarse ante Oracle (idealmente deben venir del entorno).
        String usuario = "ADMIN";
        String password = "OracleCloud2";

        // Resuelve el wallet incluido en los recursos de la aplicación.
        String walletPath;
        try {
            walletPath = new java.io.File(
                    ConexionDB.class.getClassLoader().getResource("wallet").toURI()
            ).getAbsolutePath();
        } catch (URISyntaxException e) {
            throw new SQLException("No se pudo encontrar la carpeta wallet.", e);
        }

        // Descriptor TCPS del servicio Oracle Cloud.
        String url = "jdbc:oracle:thin:@(description=(retry_count=20)(retry_delay=3)" +
                "(address=(protocol=tcps)(port=1522)(host=adb.us-ashburn-1.oraclecloud.com))" +
                "(connect_data=(service_name=gff35d628e20764_proyectofinal_medium.adb.oraclecloud.com))" +
                "(security=(ssl_server_dn_match=yes)))";

        // Configura certificados y claves requeridos por la conexión TLS.
        System.setProperty("javax.net.ssl.trustStore", walletPath + "/truststore.jks");
        System.setProperty("javax.net.ssl.trustStoreType", "JKS");
        System.setProperty("javax.net.ssl.trustStorePassword", "OracleCloud2");
        System.setProperty("javax.net.ssl.keyStore", walletPath + "/keystore.jks");
        System.setProperty("javax.net.ssl.keyStoreType", "JKS");
        System.setProperty("javax.net.ssl.keyStorePassword", "OracleCloud2");

        // Carga explícitamente el controlador y entrega la conexión al llamador.
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            // DriverManager negocia la conexión usando URL, usuario, contraseña y wallet configurado.
            return DriverManager.getConnection(url, usuario, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver Oracle no encontrado.", e);
        }
    }
}
