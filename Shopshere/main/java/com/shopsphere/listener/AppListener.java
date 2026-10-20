package com.shopsphere.listener;

import com.shopsphere.util.DBConnection;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * Application Lifecycle and Session Event Listener.
 * Demonstrates ServletContextListener and HttpSessionListener for syllabus requirements.
 */
@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener {

    private static final AtomicInteger activeSessions = new AtomicInteger(0);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        context.setAttribute("appName", "ShopSphere");
        context.setAttribute("appTagline", "Next-Gen Java Enterprise E-Commerce Platform");
        context.setAttribute("appVersion", "1.0.0-RTU");

        boolean dbOk = DBConnection.testConnection();
        context.setAttribute("dbConnected", dbOk);

        System.out.println("=================================================");
        System.out.println(" [ShopSphere] Web Application Context Initialized");
        System.out.println(" Container: Apache Tomcat 11");
        System.out.println(" Database Connectivity: " + (dbOk ? "ONLINE" : "OFFLINE"));
        System.out.println("=================================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[ShopSphere] Web Application Context Destroyed. Cleaned up resources.");
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        int count = activeSessions.incrementAndGet();
        se.getSession().getServletContext().setAttribute("activeSessionCount", count);
        System.out.println("[AppListener] New Session Created (Active: " + count + ")");
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        int count = activeSessions.decrementAndGet();
        if (count < 0) count = 0;
        se.getSession().getServletContext().setAttribute("activeSessionCount", count);
        System.out.println("[AppListener] Session Destroyed (Active: " + count + ")");
    }

    public static int getActiveSessions() {
        return activeSessions.get();
    }
}
