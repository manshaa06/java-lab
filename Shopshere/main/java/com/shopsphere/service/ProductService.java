package com.shopsphere.service;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.dao.ReviewDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.model.Review;

import java.util.List;

/**
 * Service Layer for Product and Category business logic.
 */
public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public List<Product> getAllActiveProducts() {
        return productDAO.getAll();
    }

    public List<Product> getAllProductsForAdmin() {
        return productDAO.getAllForAdmin();
    }

    public Product getProductById(int productId) {
        return productDAO.findById(productId);
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return productDAO.findByCategory(categoryId);
    }

    public List<Product> searchAndFilter(String query, Integer categoryId, Double minPrice, Double maxPrice, String sortBy) {
        return productDAO.search(query, categoryId, minPrice, maxPrice, sortBy);
    }

    public boolean createProduct(Product product) {
        if (product.getPrice() < 0 || product.getStock() < 0) {
            return false;
        }
        return productDAO.insert(product);
    }

    public boolean updateProduct(Product product) {
        if (product.getProductId() <= 0 || product.getPrice() < 0) {
            return false;
        }
        return productDAO.update(product);
    }

    public boolean deleteProduct(int productId) {
        return productDAO.delete(productId);
    }

    public boolean updateInventoryStock(int productId, int newStock) {
        if (newStock < 0) return false;
        return productDAO.updateStock(productId, newStock);
    }

    public List<Product> getLowStockAlerts(int threshold) {
        return productDAO.getLowStock(threshold);
    }

    public List<Category> getAllCategories() {
        return categoryDAO.getAll();
    }

    public Category getCategoryById(int categoryId) {
        return categoryDAO.findById(categoryId);
    }

    public boolean createCategory(Category category) {
        return categoryDAO.insert(category);
    }

    public boolean updateCategory(Category category) {
        return categoryDAO.update(category);
    }

    public boolean deleteCategory(int categoryId) {
        return categoryDAO.delete(categoryId);
    }

    public List<Review> getProductReviews(int productId) {
        return reviewDAO.getByProductId(productId);
    }

    public double getProductAverageRating(int productId) {
        return reviewDAO.getAverageRating(productId);
    }

    public boolean submitReview(Review review) {
        if (review.getRating() < 1 || review.getRating() > 5) {
            return false;
        }
        return reviewDAO.addReview(review);
    }
}
