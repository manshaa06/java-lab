package com.shopsphere.controller.admin;

import com.shopsphere.model.User;
import com.shopsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller dedicated to Administrator Authentication.
 */
@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin-login"})
public class AdminLoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                return;
            }
        }
        req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userService.login(email, password);
        if (user != null && user.isAdmin()) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            req.setAttribute("error", "Invalid administrator credentials.");
            req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
        }
    }
}
