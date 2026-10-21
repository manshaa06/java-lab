package com.shopsphere.dao;

import com.shopsphere.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** JDBC CRUD for products (Connection, PreparedStatement, ResultSet, SQLException). */
public class ProductDao {
    private static final String BASE =
        "SELECT p.*, c.name AS category_name FROM products p JOIN categories c ON p.category_id = c.category_id ";

    private Product map(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setName(rs.getString("name"));
        p.setBrand(rs.getString("brand"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setDiscount(rs.getDouble("discount"));
        p.setStock(rs.getInt("stock"));
        p.setImageUrl(rs.getString("image_url"));
        p.setStatus(rs.getBoolean("status"));
        p.setCategoryName(rs.getString("category_name"));
        return p;
    }

    public List<Product> findAll() throws SQLException {
        List<Product> list = new ArrayList<>();
        try (Connection con = Db.get();
             PreparedStatement ps = con.prepareStatement(BASE + "ORDER BY p.product_id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Product findById(int id) throws SQLException {
        try (Connection con = Db.get(); PreparedStatement ps = con.prepareStatement(BASE + "WHERE p.product_id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<Product> search(String text) throws SQLException {
        List<Product> list = new ArrayList<>();
        try (Connection con = Db.get();
             PreparedStatement ps = con.prepareStatement(BASE + "WHERE p.name LIKE ? OR p.brand LIKE ? ORDER BY p.name")) {
            ps.setString(1, "%" + text + "%");
            ps.setString(2, "%" + text + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /** Sets the stock to an absolute quantity. */
    public boolean updateStock(int productId, int quantity) throws SQLException {
        if (quantity < 0) return false;
        try (Connection con = Db.get();
             PreparedStatement ps = con.prepareStatement("UPDATE products SET stock = ? WHERE product_id = ?")) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() == 1;
        }
    }

    public void insert(Product p) throws SQLException {
        String sql = "INSERT INTO products (category_id,name,brand,description,price,discount,stock,image_url,status) " +
                     "VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection con = Db.get(); PreparedStatement ps = con.prepareStatement(sql)) {
            bind(ps, p);
            ps.executeUpdate();
        }
    }

    public void update(Product p) throws SQLException {
        String sql = "UPDATE products SET category_id=?, name=?, brand=?, description=?, price=?, discount=?, " +
                     "stock=?, image_url=?, status=? WHERE product_id=?";
        try (Connection con = Db.get(); PreparedStatement ps = con.prepareStatement(sql)) {
            bind(ps, p);
            ps.setInt(10, p.getProductId());
            ps.executeUpdate();
        }
    }

    private void bind(PreparedStatement ps, Product p) throws SQLException {
        ps.setInt(1, p.getCategoryId());
        ps.setString(2, p.getName());
        ps.setString(3, p.getBrand());
        ps.setString(4, p.getDescription());
        ps.setDouble(5, p.getPrice());
        ps.setDouble(6, p.getDiscount());
        ps.setInt(7, p.getStock());
        ps.setString(8, p.getImageUrl() == null ? "" : p.getImageUrl());
        ps.setBoolean(9, p.isStatus());
    }

    /** Soft delete (keeps old orders valid). */
    public void deactivate(int id) throws SQLException {
        try (Connection con = Db.get();
             PreparedStatement ps = con.prepareStatement("UPDATE products SET status = 0 WHERE product_id = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    /** category id -> name, for the Swing combo box. */
    public Map<Integer, String> categories() throws SQLException {
        Map<Integer, String> map = new LinkedHashMap<>();
        try (Connection con = Db.get();
             PreparedStatement ps = con.prepareStatement("SELECT category_id, name FROM categories ORDER BY name");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) map.put(rs.getInt(1), rs.getString(2));
        }
        return map;
    }
}
