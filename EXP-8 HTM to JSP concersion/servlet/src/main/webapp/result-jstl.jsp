<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration Result (JSTL)</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="card wide">
        <c:if test="${not empty name}">
            <h1 class="status">Registration Successful</h1>
            <hr>
            <h3>Student Details</h3>
            <table class="details">
                <tr>
                    <th>Name</th>
                    <td><c:out value="${name}"/></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><c:out value="${email}"/></td>
                </tr>
                <tr>
                    <th>Course</th>
                    <td><c:out value="${course}"/></td>
                </tr>
                <tr>
                    <th>Age</th>
                    <td><c:out value="${age}"/></td>
                </tr>
            </table>
        </c:if>
        <c:if test="${empty name}">
            <h1 class="status">No Student Data</h1>
            <p class="hint">Submit the registration form first, or open
                <a href="student.jsp">student.jsp</a>.</p>
        </c:if>
        <p class="links">
            <a href="student.jsp">Register Another Student</a> &nbsp;|&nbsp;
            <a href="result.jsp">View using plain EL</a> &nbsp;|&nbsp;
            <a href="index.jsp">Login</a>
        </p>
    </div>
<%@ include file="footer.jsp" %>
