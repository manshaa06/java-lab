<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration Result</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="card wide">
        <h1 class="status">Registration Successful</h1>
        <hr>
        <h3>Student Details</h3>
        <table class="details">
            <tr>
                <th>Name</th>
                <td>${name}</td>
            </tr>
            <tr>
                <th>Email</th>
                <td>${email}</td>
            </tr>
            <tr>
                <th>Course</th>
                <td>${course}</td>
            </tr>
            <tr>
                <th>Age</th>
                <td>${age}</td>
            </tr>
            <tr>
                <th>Name (request parameter)</th>
                <td>${param.name}</td>
            </tr>
        </table>
        <p class="hint">Values above are read from request scope with EL; the last row is read with the
            implicit <code>param</code> object, so it also works on a direct GET of this page.</p>
        <p class="links">
            <a href="student.jsp">Register Another Student</a> &nbsp;|&nbsp;
            <a href="result-jstl.jsp">View using JSTL</a> &nbsp;|&nbsp;
            <a href="index.jsp">Login</a>
        </p>
    </div>
<%@ include file="footer.jsp" %>
