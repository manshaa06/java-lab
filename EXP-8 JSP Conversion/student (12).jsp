<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%!
    int visits = 0;
%>
<%-- JSP comment: this text is removed at translation time and never reaches the browser --%>
<% visits++; %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Information</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="card">
        <h1>Student Information</h1>
        <form action="hello" method="post">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" placeholder="Enter full name" value="${param.name}" required>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="Enter email" value="${param.email}" required>

            <label for="course">Course</label>
            <input type="text" id="course" name="course" placeholder="Enter course" value="${param.course}" required>

            <label for="age">Age</label>
            <input type="number" id="age" name="age" placeholder="Enter age" value="${param.age}" min="1" max="120" required>

            <button type="submit">Register</button>
        </form>
        <p class="hint">Page requests handled by this JSP instance: <%= visits %></p>
        <p class="links"><a href="index.jsp">Back to Login</a></p>
    </div>
<%@ include file="footer.jsp" %>
