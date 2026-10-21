package com.shopsphere.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/** JDBC connection helper shared by the Swing, Socket and RMI modules. */
public final class Db {
    private static final Properties props = new Properties();

    static {
        try (InputStream in = Db.class.getClassLoader().getResourceAsStream("db.properties")) {
            props.load(in);
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private Db() { }

    public static Connection get() throws SQLException {
        return DriverManager.getConnection(props.getProperty("db.url"),
                props.getProperty("db.user"), props.getProperty("db.password"));
    }
}
