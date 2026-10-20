package com.shopsphere.filter;

import com.shopsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication Filter to protect customer-authenticated endpoints.
 * Demonstrates Jakarta EE Filter lifecycle and request interception.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
        "/cart/*", "/checkout/*", "/place-order/*", "/orders/*",
        "/order-details/*", "/profile/*", "/wishlist/*", "/review/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[AuthenticationFilter] Initialized successfully.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String uri = req.getRequestURI();
            String query = req.getQueryString();
            String target = (query != null) ? (uri + "?" + query) : uri;

            res.sendRedirect(req.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(target, "UTF-8"));
            return;
        }

        // User authenticated, proceed along filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("[AuthenticationFilter] Destroyed.");
    }
}
