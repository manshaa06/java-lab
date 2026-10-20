package com.shopsphere.controller;

import com.shopsphere.model.Review;
import com.shopsphere.model.User;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller handling Product Reviews and Ratings.
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int productId = Integer.parseInt(req.getParameter("productId"));
        int rating = Integer.parseInt(req.getParameter("rating"));
        String reviewText = req.getParameter("reviewText");

        Review review = new Review();
        review.setUserId(user.getUserId());
        review.setProductId(productId);
        review.setRating(rating);
        review.setReviewText(reviewText);

        boolean success = productService.submitReview(review);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/product?id=" + productId + "&success=Review+submitted+successfully!");
        } else {
            resp.sendRedirect(req.getContextPath() + "/product?id=" + productId + "&error=Failed+to+submit+review");
        }
    }
}
