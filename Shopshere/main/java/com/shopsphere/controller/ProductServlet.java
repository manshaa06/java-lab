package com.shopsphere.controller;

import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.model.Review;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Controller handling Product listing, search, filtering, and product details.
 * Demonstrates cookies for "recently viewed products".
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/products", "/product"})
public class ProductServlet extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if ("/product".equals(servletPath)) {
            handleProductDetails(req, resp);
        } else {
            handleProductList(req, resp);
        }
    }

    private void handleProductList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getParameter("query");
        String categoryParam = req.getParameter("category");
        String minPriceParam = req.getParameter("minPrice");
        String maxPriceParam = req.getParameter("maxPrice");
        String sort = req.getParameter("sort");

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        Double minPrice = null;
        if (minPriceParam != null && !minPriceParam.trim().isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        Double maxPrice = null;
        if (maxPriceParam != null && !maxPriceParam.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Product> products = productService.searchAndFilter(query, categoryId, minPrice, maxPrice, sort);
        List<Category> categories = productService.getAllCategories();

        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.setAttribute("totalFound", products.size());

        req.getRequestDispatcher("/products.jsp").forward(req, resp);
    }

    private void handleProductDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        Product product = productService.getProductById(productId);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/products?error=Product+not+found");
            return;
        }

        List<Review> reviews = productService.getProductReviews(productId);
        double avgRating = productService.getProductAverageRating(productId);

        // Section 15 Requirement: Cookies for recently viewed products
        List<Product> recentlyViewedList = new ArrayList<>();
        String recentIdsCookieVal = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("recentProducts".equals(c.getName())) {
                    recentIdsCookieVal = c.getValue();
                    break;
                }
            }
        }

        if (!recentIdsCookieVal.isEmpty()) {
            String[] ids = recentIdsCookieVal.split("-");
            for (String rid : ids) {
                try {
                    int rPid = Integer.parseInt(rid);
                    if (rPid != productId) {
                        Product rp = productService.getProductById(rPid);
                        if (rp != null) {
                            recentlyViewedList.add(rp);
                        }
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        // Update cookie with current product ID at front (max 5)
        String newCookieVal = String.valueOf(productId);
        if (!recentIdsCookieVal.isEmpty()) {
            List<String> list = new ArrayList<>(Arrays.asList(recentIdsCookieVal.split("-")));
            list.remove(String.valueOf(productId));
            list.add(0, String.valueOf(productId));
            if (list.size() > 5) list = list.subList(0, 5);
            newCookieVal = String.join("-", list);
        }

        Cookie updatedCookie = new Cookie("recentProducts", newCookieVal);
        updatedCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
        updatedCookie.setPath(req.getContextPath());
        resp.addCookie(updatedCookie);

        req.setAttribute("product", product);
        req.setAttribute("reviews", reviews);
        req.setAttribute("avgRating", avgRating > 0 ? avgRating : 4.5);
        req.setAttribute("recentlyViewed", recentlyViewedList);

        req.getRequestDispatcher("/product-details.jsp").forward(req, resp);
    }
}
