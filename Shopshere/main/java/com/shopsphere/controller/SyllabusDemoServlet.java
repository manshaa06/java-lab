package com.shopsphere.controller;

import com.shopsphere.model.Product;
import com.shopsphere.service.ProductService;
import com.shopsphere.util.DBConnection;
import com.shopsphere.util.JndiDemoUtil;
import com.shopsphere.util.UrlConnectionDemoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

/**
 * Interactive Controller specifically showcasing all RTU Advanced Java Syllabus Topics.
 * Topics: Applets, JSP Elements, JSTL Core/XML/Functions, JNDI, java.net URLConnection, RMI/Socket status.
 */
@WebServlet(name = "SyllabusDemoServlet", urlPatterns = {"/syllabus-demo"})
public class SyllabusDemoServlet extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. JNDI Demonstration
        String jndiOutput = JndiDemoUtil.demonstrateJndiLookup();
        req.setAttribute("jndiOutput", jndiOutput);

        // 2. URLConnection Content/Protocol Handler Demonstration
        String testUrl = req.getParameter("inspectUrl");
        if (testUrl == null || testUrl.trim().isEmpty()) {
            testUrl = "https://www.google.com";
        }
        Map<String, Object> urlInfo = UrlConnectionDemoUtil.inspectUrl(testUrl);
        req.setAttribute("urlInfo", urlInfo);
        req.setAttribute("inspectedUrl", testUrl);

        // 3. JSTL XML Feed Loading
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("products-feed.xml")) {
            if (is != null) {
                StringBuilder xmlContent = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        xmlContent.append(line).append("\n");
                    }
                }
                req.setAttribute("xmlCatalog", xmlContent.toString());
            }
        } catch (Exception e) {
            req.setAttribute("xmlError", e.getMessage());
        }

        // 4. Products for JSTL Core / Custom Tag Demonstration
        List<Product> demoProducts = productService.getAllActiveProducts();
        if (demoProducts.size() > 5) {
            demoProducts = demoProducts.subList(0, 5);
        }
        req.setAttribute("demoProducts", demoProducts);

        // 5. System Health Status
        req.setAttribute("dbConnected", DBConnection.testConnection());

        req.getRequestDispatcher("/syllabus-demo.jsp").forward(req, resp);
    }
}
