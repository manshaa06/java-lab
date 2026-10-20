package com.shopsphere.controller;

import com.shopsphere.model.Order;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Customer Order History and Detailed Order Tracking.
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/orders", "/order-details"})
public class OrderServlet extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getContextPath() + "/orders");
            return;
        }

        String path = req.getServletPath();
        if ("/order-details".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }
            try {
                int orderId = Integer.parseInt(idStr.trim());
                Order order = orderService.getOrderById(orderId);

                // Security check: order must belong to logged-in user unless user is admin
                if (order == null || (!user.isAdmin() && order.getUserId() != user.getUserId())) {
                    resp.sendRedirect(req.getContextPath() + "/orders?error=Order+not+found+or+unauthorized");
                    return;
                }

                req.setAttribute("order", order);
                req.getRequestDispatcher("/order-details.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/orders");
            }
        } else {
            List<Order> orders = orderService.getUserOrders(user.getUserId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/orders.jsp").forward(req, resp);
        }
    }
}
