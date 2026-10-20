package com.shopsphere.controller;

import com.shopsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controller handling Customer Registration.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String mobile = req.getParameter("mobile");

        if (name == null || email == null || password == null || name.trim().isEmpty() || email.trim().isEmpty()) {
            req.setAttribute("error", "Please fill in all mandatory fields.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.setAttribute("mobile", mobile);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        boolean success = userService.registerCustomer(name, email, password, mobile);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/login?success=Registration+successful!+Please+sign+in.");
        } else {
            req.setAttribute("error", "An account with this email address already exists.");
            req.setAttribute("name", name);
            req.setAttribute("mobile", mobile);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
