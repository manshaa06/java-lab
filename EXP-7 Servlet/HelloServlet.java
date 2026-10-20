package com.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String name = request.getParameter("name");
        if (name != null && !name.trim().isEmpty()) {
            out.println("<h1>Welcome " + name + "</h1>");
        } else {
            out.println("<h1>Hello Students!</h1>");
            out.println("<h2>Welcome to Servlet Programming</h2>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String course = request.getParameter("course");
        String age = request.getParameter("age");
        String phone = request.getParameter("phone");

        String referer = request.getHeader("Referer");
        boolean isJsp = "true".equalsIgnoreCase(request.getParameter("useJsp"))
                || (referer != null && referer.contains("student.jsp"));

        if (isJsp) {
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("course", course);
            request.setAttribute("age", age);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("result.jsp").forward(request, response);
            return;
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h1>Student Information Registered</h1>");
        out.println("<p><b>Name:</b> " + (name != null ? name : "") + "</p>");
        if (email != null) out.println("<p><b>Email:</b> " + email + "</p>");
        if (course != null) out.println("<p><b>Course:</b> " + course + "</p>");
        if (age != null) out.println("<p><b>Age:</b> " + age + "</p>");
        if (phone != null) out.println("<p><b>Phone:</b> " + phone + "</p>");
        out.println("<br><a href='index.html'>Back to Home</a>");
    }
}