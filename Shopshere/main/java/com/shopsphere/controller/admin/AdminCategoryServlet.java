package com.shopsphere.controller.admin;

import com.shopsphere.model.Category;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Category CRUD in Admin portal.
 */
@WebServlet(name = "AdminCategoryServlet", urlPatterns = {"/admin/categories"})
public class AdminCategoryServlet extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> categories = productService.getAllCategories();
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/admin/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            Category c = new Category();
            c.setName(req.getParameter("name"));
            c.setDescription(req.getParameter("description"));
            c.setStatus(req.getParameter("status"));
            productService.createCategory(c);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?success=Category+created");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("categoryId"));
            Category c = productService.getCategoryById(id);
            if (c != null) {
                c.setName(req.getParameter("name"));
                c.setDescription(req.getParameter("description"));
                c.setStatus(req.getParameter("status"));
                productService.updateCategory(c);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/categories?success=Category+updated");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("categoryId"));
            productService.deleteCategory(id);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?success=Category+deleted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }
}
