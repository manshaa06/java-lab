package com.shopsphere.swing;

import com.shopsphere.dao.AdminDao;
import com.shopsphere.swing.controller.LoginController;
import com.shopsphere.swing.view.LoginFrame;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

/** Entry point of the Swing admin application. */
public class AdminApp {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                // Pluggable look and feel
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception ignored) {
            }
            LoginFrame login = new LoginFrame();
            new LoginController(login, new AdminDao());
            login.setVisible(true);
        });
    }
}
