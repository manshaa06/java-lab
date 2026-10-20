<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal Login | ShopSphere</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&family=Outfit:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-dark text-white d-flex align-items-center justify-content-center min-vh-100 p-3">

<div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-black bg-opacity-75 border border-secondary border-opacity-25" style="max-width: 440px; width: 100%;">
    <div class="text-center mb-4">
        <span class="brand-icon-box bg-danger text-white rounded-3 d-inline-flex align-items-center justify-content-center mb-3" style="width: 52px; height: 52px;">
            <i class="bi bi-shield-lock-fill fs-4"></i>
        </span>
        <h3 class="fw-bold mb-1">Admin Console</h3>
        <p class="text-white-50 small">ShopSphere Enterprise Administration</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger py-2 small shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin-login" method="post">
        <div class="mb-3">
            <label class="form-label small fw-semibold text-white-50">Admin Email</label>
            <div class="input-group">
                <span class="input-group-text bg-dark text-white-50 border-secondary"><i class="bi bi-person-badge"></i></span>
                <input type="email" class="form-control bg-dark text-white border-secondary" name="email" id="adminEmail" required value="admin@shopsphere.com">
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label small fw-semibold text-white-50">Password</label>
            <div class="input-group">
                <span class="input-group-text bg-dark text-white-50 border-secondary"><i class="bi bi-key"></i></span>
                <input type="password" class="form-control bg-dark text-white border-secondary" name="password" id="adminPassword" required value="admin123">
            </div>
        </div>

        <button type="submit" class="btn btn-primary w-100 py-2 rounded-pill fw-semibold shadow-sm mb-3">
            <i class="bi bi-box-arrow-in-right me-1"></i> Authenticate &amp; Access Dashboard
        </button>

        <div class="text-center">
            <a href="${pageContext.request.contextPath}/" class="text-white-50 text-decoration-none small">
                <i class="bi bi-arrow-left me-1"></i> Return to Storefront
            </a>
        </div>
    </form>
</div>

</body>
</html>
