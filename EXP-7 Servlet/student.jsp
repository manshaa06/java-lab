<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Information</title>
</head>
<body>

<h1>Student Information</h1>

<form action="hello" method="post">
    <input type="hidden" name="useJsp" value="true">
    Name: <input type="text" name="name"><br><br>
    Email: <input type="email" name="email"><br><br>
    Course: <input type="text" name="course"><br><br>
    Age: <input type="number" name="age"><br><br>
    Phone: <input type="text" name="phone"><br><br>
    <input type="submit" value="Register">
</form>

</body>
</html>
