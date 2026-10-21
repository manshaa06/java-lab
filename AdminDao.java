package com.shopsphere.dao;

import java.security.MessageDigest;
import java.sql.*;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/** Admin login for the Swing application (same PBKDF2 format as the web application). */
public class AdminDao {

    /** Returns the admin's name when the credentials are valid, otherwise null. */
    public String login(String email, String password) throws SQLException {
        String sql = "SELECT name, password FROM users WHERE email = ? AND role = 'ADMIN' AND status = 1";
        try (Connection con = Db.get(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && verify(password, rs.getString("password"))) return rs.getString("name");
                return null;
            }
        }
    }

    private boolean verify(String password, String stored) {
        try {
            String[] parts = stored.split(":");
            byte[] salt = hex(parts[0]);
            byte[] expected = hex(parts[1]);
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 65536, 256);
            byte[] actual = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
            return MessageDigest.isEqual(expected, actual);
        } catch (Exception e) {
            return false;
        }
    }

    private byte[] hex(String s) {
        byte[] out = new byte[s.length() / 2];
        for (int i = 0; i < out.length; i++) out[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2), 16);
        return out;
    }
}
