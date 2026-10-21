package com.shopsphere.swing.controller;

import com.shopsphere.dao.AdminDao;
import com.shopsphere.dao.ProductDao;
import com.shopsphere.swing.view.LoginFrame;
import com.shopsphere.swing.view.ProductFrame;
import java.sql.SQLException;

/** MVC "Controller": handles the login button, then opens the product window. */
public class LoginController {
    public LoginController(LoginFrame view, AdminDao dao) {
        view.onLogin(e -> {
            try {
                String name = dao.login(view.getEmail(), view.getPassword());
                if (name == null) {
                    view.setStatus("Invalid admin email or password.");
                    return;
                }
                view.dispose();
                ProductFrame frame = new ProductFrame(name);
                new ProductController(frame, new ProductDao());
                frame.setVisible(true);
            } catch (SQLException ex) {
                view.setStatus("Database error: " + ex.getMessage());
            }
        });
    }
}
