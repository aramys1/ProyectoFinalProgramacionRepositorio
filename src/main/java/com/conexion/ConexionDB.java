package com.conexion;

import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    public static Connection obtenerConexion() throws SQLException {

        String usuario = "ADMIN";
        String password = "OracleCloud2";

        String walletPath;
        try {
            walletPath = new java.io.File(
                    ConexionDB.class.getClassLoader().getResource("wallet").toURI()
            ).getAbsolutePath();
        } catch (URISyntaxException e) {
            throw new SQLException("No se pudo encontrar la carpeta wallet.", e);
        }

        String url = "jdbc:oracle:thin:@(description=(retry_count=20)(retry_delay=3)" +
                "(address=(protocol=tcps)(port=1522)(host=adb.us-ashburn-1.oraclecloud.com))" +
                "(connect_data=(service_name=gff35d628e20764_proyectofinal_medium.adb.oraclecloud.com))" +
                "(security=(ssl_server_dn_match=yes)))";

        System.setProperty("javax.net.ssl.trustStore", walletPath + "/truststore.jks");
        System.setProperty("javax.net.ssl.trustStoreType", "JKS");
        System.setProperty("javax.net.ssl.trustStorePassword", "OracleCloud2");
        System.setProperty("javax.net.ssl.keyStore", walletPath + "/keystore.jks");
        System.setProperty("javax.net.ssl.keyStoreType", "JKS");
        System.setProperty("javax.net.ssl.keyStorePassword", "OracleCloud2");

        try {
            Class.forName("oracle.jdbc.OracleDriver");
            return DriverManager.getConnection(url, usuario, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver Oracle no encontrado.", e);
        }
    }
}