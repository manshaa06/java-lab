package com.shopsphere.controller.admin;

import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Product CRUD and inventory updates in Admin portal.
 */
@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products"})
public class AdminProductServlet extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> products = productService.getAllProductsForAdmin();
        List<Category> categories = productService.getAllCategories();

        req.setAttribute("products", products);
        req.setAttribute("categories", categories);

        req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add": {
                Product p = new Product();
                p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                p.setName(req.getParameter("name"));
                p.setBrand(req.getParameter("brand"));
                p.setDescription(req.getParameter("description"));
                p.setPrice(Double.parseDouble(req.getParameter("price")));
                p.setDiscount(Double.parseDouble(req.getParameter("discount")));
                p.setStock(Integer.parseInt(req.getParameter("stock")));
                p.setImageUrl(req.getParameter("imageUrl"));
                p.setStatus("true".equalsIgnoreCase(req.getParameter("status")));

                productService.createProduct(p);
                resp.sendRedirect(req.getContextPath() + "/admin/products?success=Product+added+successfully");
                break;
            }
            case "update": {
                int id = Integer.parseInt(req.getParameter("productId"));
                Product p = productService.getProductById(id);
                if (p != null) {
                    p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                    p.setName(req.getParameter("name"));
                    p.setBrand(req.getParameter("brand"));
                    p.setDescription(req.getParameter("description"));
                    p.setPrice(Double.parseDouble(req.getParameter("price")));
                    p.setDiscount(Double.parseDouble(req.getParameter("discount")));
                    p.setStock(Integer.parseInt(req.getParameter("stock")));
                    p.setImageUrl(req.getParameter("imageUrl"));
                    p.setStatus("true".equalsIgnoreCase(req.getParameter("status")));

                    productService.updateProduct(p);
                }
                resp.sendRedirect(req.getContextPath() + "/admin/products?success=Product+updated+successfully");
                break;
            }
            case "updateStock": {
                int id = Integer.parseInt(req.getParameter("productId"));
                int stock = Integer.parseInt(req.getParameter("stock"));
                productService.updateInventoryStock(id, stock);
                resp.sendRedirect(req.getContextPath() + "/admin/products?success=Stock+updated");
                break;
            }
            case "delete": {
                int id = Integer.parseInt(req.getParameter("productId"));
                productService.deleteProduct(id);
                resp.sendRedirect(req.getContextPath() + "/admin/products?success=Product+deleted");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }
}
