package com.shopsphere.service;

import com.shopsphere.dao.OrderDAO;
import com.shopsphere.model.Order;

import java.util.List;

/**
 * Service Layer for Order management and history.
 */
public class OrderService {

    private final OrderDAO orderDAO = new OrderDAO();

    public Order getOrderById(int orderId) {
        return orderDAO.findById(orderId);
    }

    public List<Order> getUserOrders(int userId) {
        return orderDAO.findByUser(userId);
    }

    public List<Order> getAllOrdersForAdmin() {
        return orderDAO.getAllOrders();
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        return orderDAO.updateStatus(orderId, newStatus);
    }

    public double getTotalSalesRevenue() {
        return orderDAO.getTotalSales();
    }

    public int getTotalOrderCount() {
        return orderDAO.getOrderCount();
    }
}
