package com.shopsphere.swing.view;

import java.awt.*;
import java.awt.event.ActionListener;
import javax.swing.*;

/** MVC "View": admin login window (JFrame, JPanel, JLabel, JTextField, JPasswordField, JCheckBox, JButton). */
public class LoginFrame extends JFrame {
    private final JTextField emailField = new JTextField("admin@shopsphere.com", 20);
    private final JPasswordField passwordField = new JPasswordField(20);
    private final JCheckBox showPassword = new JCheckBox("Show password");
    private final JButton loginButton = new JButton("Login");
    private final JLabel statusLabel = new JLabel(" ");

    public LoginFrame() {
        super("ShopSphere Admin - Login");
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(20, 20, 10, 20));
        GridBagConstraints g = new GridBagConstraints();
        g.insets = new Insets(5, 5, 5, 5);
        g.anchor = GridBagConstraints.WEST;

        g.gridx = 0; g.gridy = 0; form.add(new JLabel("Email"), g);
        g.gridx = 1; form.add(emailField, g);
        g.gridx = 0; g.gridy = 1; form.add(new JLabel("Password"), g);
        g.gridx = 1; form.add(passwordField, g);
        g.gridx = 1; g.gridy = 2; form.add(showPassword, g);
        g.gridx = 1; g.gridy = 3; form.add(loginButton, g);
        g.gridx = 0; g.gridy = 4; g.gridwidth = 2; form.add(statusLabel, g);

        showPassword.addActionListener(e ->
                passwordField.setEchoChar(showPassword.isSelected() ? (char) 0 : '\u2022'));

        add(form);
        getRootPane().setDefaultButton(loginButton);
        pack();
        setLocationRelativeTo(null);
    }

    public String getEmail() { return emailField.getText(); }
    public String getPassword() { return new String(passwordField.getPassword()); }
    public void setStatus(String text) { statusLabel.setText(text); }
    public void onLogin(ActionListener l) { loginButton.addActionListener(l); }
}
