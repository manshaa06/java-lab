package com.shopsphere.dao;

import com.shopsphere.model.*;
import com.shopsphere.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Orders.
 * Implements ACID Transaction management with commit and rollback as required for enterprise systems.
 */
public class OrderDAO {

    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final AddressDAO addressDAO = new AddressDAO();
    private final UserDAO userDAO = new UserDAO();

    /**
     * Executes order placement inside an atomic JDBC transaction.
     */
    public boolean placeOrder(Order order, List<OrderItem> items, Payment payment, Integer couponId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin Transaction

            // 1. Insert Order
            String orderSql = "INSERT INTO orders (user_id, address_id, total_amount, discount, payment_method, payment_status, order_status) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setInt(2, order.getAddressId());
                psOrder.setDouble(3, order.getTotalAmount());
                psOrder.setDouble(4, order.getDiscount());
                psOrder.setString(5, order.getPaymentMethod());
                psOrder.setString(6, order.getPaymentStatus());
                psOrder.setString(7, order.getOrderStatus() != null ? order.getOrderStatus() : "CONFIRMED");

                psOrder.executeUpdate();
                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        order.setOrderId(rs.getInt(1));
                    } else {
                        throw new SQLException("Failed to obtain generated order ID");
                    }
                }
            }

            // 2. Insert Order Items and update product stock
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            String stockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";

            try (PreparedStatement psItem = conn.prepareStatement(itemSql);
                 PreparedStatement psStock = conn.prepareStatement(stockSql)) {

                for (OrderItem item : items) {
                    item.setOrderId(order.getOrderId());
                    psItem.setInt(1, order.getOrderId());
                    psItem.setInt(2, item.getProductId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getPrice());
                    psItem.addBatch();

                    // Update stock
                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getProductId());
                    psStock.setInt(3, item.getQuantity());
                    psStock.addBatch();
                }
                psItem.executeBatch();
                psStock.executeBatch();
            }

            // 3. Insert Payment Record
            if (payment != null) {
                payment.setOrderId(order.getOrderId());
                String paySql = "INSERT INTO payments (order_id, payment_method, transaction_reference, amount, payment_status) " +
                                "VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement psPay = conn.prepareStatement(paySql)) {
                    psPay.setInt(1, order.getOrderId());
                    psPay.setString(2, payment.getPaymentMethod());
                    psPay.setString(3, payment.getTransactionReference());
                    psPay.setDouble(4, payment.getAmount());
                    psPay.setString(5, payment.getPaymentStatus());
                    psPay.executeUpdate();
                }
            }

            // 4. Record Coupon Usage if coupon applied
            if (couponId != null && couponId > 0) {
                String couponSql = "INSERT INTO coupon_usage (coupon_id, user_id, order_id) VALUES (?, ?, ?)";
                try (PreparedStatement psCoupon = conn.prepareStatement(couponSql)) {
                    psCoupon.setInt(1, couponId);
                    psCoupon.setInt(2, order.getUserId());
                    psCoupon.setInt(3, order.getOrderId());
                    psCoupon.executeUpdate();
                }
            }

            // 5. Clear User's shopping cart
            String clearCartSql = "DELETE FROM cart WHERE user_id = ?";
            try (PreparedStatement psCart = conn.prepareStatement(clearCartSql)) {
                psCart.setInt(1, order.getUserId());
                psCart.executeUpdate();
            }

            // Commit Transaction
            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    System.err.println("[OrderDAO] Rolling back order transaction due to error: " + e.getMessage());
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    public Order findById(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapRowToOrder(rs);
                    order.setItems(orderItemDAO.getByOrderId(orderId));
                    order.setPayment(paymentDAO.getByOrderId(orderId));
                    order.setAddress(addressDAO.findById(order.getAddressId()));
                    order.setUser(userDAO.findById(order.getUserId()));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> findByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = mapRowToOrder(rs);
                    o.setItems(orderItemDAO.getByOrderId(o.getOrderId()));
                    o.setAddress(addressDAO.findById(o.getAddressId()));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order o = mapRowToOrder(rs);
                o.setUser(userDAO.findById(o.getUserId()));
                o.setAddress(addressDAO.findById(o.getAddressId()));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getTotalSales() {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE payment_status = 'PAID' OR payment_status = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public int getOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Order mapRowToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setAddressId(rs.getInt("address_id"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setDiscount(rs.getDouble("discount"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }
}
