package com.shopsphere.controller.admin;

import com.shopsphere.model.Order;
import com.shopsphere.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Order fulfillment, status tracking, and order history in Admin portal.
 */
@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders"})
public class AdminOrderServlet extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Order> orders = orderService.getAllOrdersForAdmin();
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String status = req.getParameter("orderStatus");
            orderService.updateOrderStatus(orderId, status);
            resp.sendRedirect(req.getContextPath() + "/admin/orders?success=Order+#" + orderId + "+status+updated+to+" + status);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }
}
