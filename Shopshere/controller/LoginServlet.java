package com.shopsphere.controller;

import com.shopsphere.model.User;
import com.shopsphere.service.CartService;
import com.shopsphere.service.UserService;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Controller handling Customer/Admin authentication and session management.
 * Demonstrates Servlet lifecycle: init, doGet, doPost, destroy.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UserService userService;
    private CartService cartService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.userService = new UserService();
        this.cartService = new CartService();
        System.out.println("[LoginServlet] init() invoked with config: " + config.getServletName());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // Pass any redirect URL query parameter forward
        req.setAttribute("redirect", req.getParameter("redirect"));
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String redirect = req.getParameter("redirect");

        User user = userService.login(email, password);

        if (user != null) {
            // Check user status
            if ("BLOCKED".equalsIgnoreCase(user.getStatus())) {
                req.setAttribute("error", "Your account has been deactivated. Please contact support.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            // Authentication successful: create/bind session
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            // Synchronize cart count into session
            int count = cartService.getCartCount(user.getUserId());
            session.setAttribute("cartCount", count);

            // Add non-sensitive convenience cookie: remember user email for login convenience
            Cookie userCookie = new Cookie("lastLoginEmail", user.getEmail());
            userCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            userCookie.setPath(req.getContextPath());
            resp.addCookie(userCookie);

            if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("login")) {
                resp.sendRedirect(redirect);
            } else if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/?success=Welcome+back,+" + java.net.URLEncoder.encode(user.getName(), "UTF-8"));
            }
        } else {
            req.setAttribute("error", "Invalid email address or password. Please try again.");
            req.setAttribute("email", email);
            req.setAttribute("redirect", redirect);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    @Override
    public void destroy() {
        System.out.println("[LoginServlet] destroy() called.");
    }
}
