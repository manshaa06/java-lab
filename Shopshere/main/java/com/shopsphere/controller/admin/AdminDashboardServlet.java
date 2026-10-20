package com.shopsphere.controller.admin;

import com.shopsphere.listener.AppListener;
import com.shopsphere.model.Order;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;
import com.shopsphere.service.ProductService;
import com.shopsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Admin Dashboard KPIs, Analytics, and Inventory Alerts.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private OrderService orderService;
    private ProductService productService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.orderService = new OrderService();
        this.productService = new ProductService();
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        double totalSales = orderService.getTotalSalesRevenue();
        int totalOrders = orderService.getTotalOrderCount();
        List<Product> allProducts = productService.getAllProductsForAdmin();
        List<User> allUsers = userService.getAllUsers();
        List<Product> lowStock = productService.getLowStockAlerts(25);
        List<Order> recentOrders = orderService.getAllOrdersForAdmin();

        if (recentOrders.size() > 5) {
            recentOrders = recentOrders.subList(0, 5);
        }

        req.setAttribute("totalSales", totalSales);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalProducts", allProducts.size());
        req.setAttribute("totalUsers", allUsers.size());
        req.setAttribute("lowStock", lowStock);
        req.setAttribute("recentOrders", recentOrders);
        req.setAttribute("activeSessions", AppListener.getActiveSessions());

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
