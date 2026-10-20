package com.shopsphere.controller;

import com.shopsphere.model.Address;
import com.shopsphere.model.User;
import com.shopsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling User Profile, Address management, and Language Switching.
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        // Handle language switcher (Section 23 I18N)
        if ("setLang".equals(action)) {
            String lang = req.getParameter("lang");
            if (lang != null && (lang.equalsIgnoreCase("hi") || lang.equalsIgnoreCase("en"))) {
                req.getSession().setAttribute("lang", lang.toLowerCase());
            }
            String referer = req.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                resp.sendRedirect(referer);
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getContextPath() + "/profile");
            return;
        }

        // Refresh user info from database
        User current = userService.getUserById(user.getUserId());
        List<Address> addresses = userService.getUserAddresses(user.getUserId());

        req.setAttribute("user", current);
        req.setAttribute("addresses", addresses);

        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("updateProfile".equals(action)) {
            String name = req.getParameter("name");
            String mobile = req.getParameter("mobile");

            user.setName(name);
            user.setMobile(mobile);
            userService.updateProfile(user);
            session.setAttribute("user", user);

            resp.sendRedirect(req.getContextPath() + "/profile?success=Profile+updated+successfully");
        } else if ("addAddress".equals(action)) {
            Address addr = new Address();
            addr.setUserId(user.getUserId());
            addr.setAddressLine(req.getParameter("addressLine"));
            addr.setCity(req.getParameter("city"));
            addr.setState(req.getParameter("state"));
            addr.setPincode(req.getParameter("pincode"));
            addr.setAddressType(req.getParameter("addressType"));

            userService.addAddress(addr);
            resp.sendRedirect(req.getContextPath() + "/profile?success=Address+added+successfully");
        } else if ("deleteAddress".equals(action)) {
            int addressId = Integer.parseInt(req.getParameter("addressId"));
            userService.deleteAddress(addressId, user.getUserId());
            resp.sendRedirect(req.getContextPath() + "/profile?success=Address+removed");
        } else {
            resp.sendRedirect(req.getContextPath() + "/profile");
        }
    }
}
