package com.shopsphere.controller.admin;

import com.shopsphere.model.Coupon;
import com.shopsphere.service.CheckoutService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Controller handling Coupon management in Admin portal.
 */
@WebServlet(name = "AdminCouponServlet", urlPatterns = {"/admin/coupons"})
public class AdminCouponServlet extends HttpServlet {

    private CheckoutService checkoutService;

    @Override
    public void init() throws ServletException {
        this.checkoutService = new CheckoutService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Coupon> coupons = checkoutService.getAllCoupons();
        req.setAttribute("coupons", coupons);
        req.getRequestDispatcher("/admin/coupons.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            Coupon c = new Coupon();
            c.setCode(req.getParameter("code"));
            c.setDiscountType(req.getParameter("discountType"));
            c.setDiscountValue(Double.parseDouble(req.getParameter("discountValue")));
            c.setMinimumOrder(Double.parseDouble(req.getParameter("minimumOrder")));
            c.setMaximumDiscount(Double.parseDouble(req.getParameter("maximumDiscount")));
            c.setExpiryDate(Date.valueOf(req.getParameter("expiryDate")));
            c.setStatus(req.getParameter("status"));

            checkoutService.addCoupon(c);
            resp.sendRedirect(req.getContextPath() + "/admin/coupons?success=Coupon+created+successfully");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("couponId"));
            checkoutService.deleteCoupon(id);
            resp.sendRedirect(req.getContextPath() + "/admin/coupons?success=Coupon+deleted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/coupons");
        }
    }
}
