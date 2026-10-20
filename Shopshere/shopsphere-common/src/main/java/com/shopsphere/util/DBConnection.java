package com.shopsphere.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * JDBC Database Connection Utility for ShopSphere.
 * Demonstrates JDBC driver registration, Connection pooling/management,
 * and proper exception handling as per RTU syllabus.
 */
public class DBConnection {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/shopsphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";

    private static String jdbcUrl = DEFAULT_URL;
    private static String dbUser = DEFAULT_USER;
    private static String dbPassword = DEFAULT_PASSWORD;

    static {
        try {
            // Explicitly load MySQL Connector/J driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    /**
     * Obtains a new JDBC database connection.
     * @return Connection object
     * @throws SQLException on database error
     */
    public static Connection getConnection() throws SQLException {
        // Allow overriding via environment or system properties if provided
        String envUrl = System.getenv("SHOPSPHERE_DB_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            jdbcUrl = envUrl;
        }
        String envUser = System.getenv("SHOPSPHERE_DB_USER");
        if (envUser != null) {
            dbUser = envUser;
        }
        String envPass = System.getenv("SHOPSPHERE_DB_PASS");
        if (envPass != null) {
            dbPassword = envPass;
        }

        return DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
    }

    /**
     * Safely closes a JDBC connection.
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Error closing connection: " + e.getMessage());
            }
        }
    }

    /**
     * Tests whether the database connection is currently alive.
     */
    public static boolean testConnection() {
        try (Connection c = getConnection()) {
            return c != null && !c.isClosed();
        } catch (SQLException e) {
            System.err.println("[DBConnection] Test connection failed: " + e.getMessage());
            return false;
        }
    }
}
