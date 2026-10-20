package com.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cookie")
public class CookieServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        Cookie cookie = new Cookie("username", "Jahanvi");
        response.addCookie(cookie);

        out.println("<h1>Cookie Handling</h1>");
        out.println("<p>Username cookie ('Jahanvi') created/sent.</p>");

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            out.println("<h3>Existing Cookies:</h3><ul>");
            for (Cookie c : cookies) {
                out.println("<li>" + c.getName() + " = " + c.getValue() + "</li>");
            }
            out.println("</ul>");
        } else {
            out.println("<p>No cookies received in this request yet (refresh page to see cookie returned by browser).</p>");
        }

        out.println("<br><a href='index.html'>Back to Home</a>");
    }
}