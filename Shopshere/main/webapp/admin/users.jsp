<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | ShopSphere Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&family=Outfit:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light-subtle">

<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark py-2 px-3 shadow-sm border-bottom border-secondary border-opacity-25">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="badge bg-danger rounded-3 p-2"><i class="bi bi-shield-check fs-6"></i></span>
            <span>ShopSphere <span class="text-danger">Admin</span></span>
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-1"></i> Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-1"></i> Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-tags me-1"></i> Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-receipt me-1"></i> Orders</a></li>
                <li class="nav-item"><a class="nav-link active fw-semibold" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-1"></i> Customers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/coupons"><i class="bi bi-ticket-perforated me-1"></i> Coupons</a></li>
            </ul>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light btn-sm rounded-pill px-3" target="_blank">Customer View</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm rounded-pill px-3">Logout</a>
            </div>
        </div>
    </div>
</nav>

<div class="container my-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Customer Accounts</h3>
            <span class="text-muted small">View registered users and manage account status</span>
        </div>
        <span class="badge bg-primary px-3 py-2 rounded-pill">${users.size()} Total Accounts</span>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead class="table-light small text-uppercase text-muted">
                    <tr>
                        <th class="ps-4">User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Mobile</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Created At</th>
                        <th class="pe-4 text-end">Toggle Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td class="ps-4 font-monospace fw-bold">#${u.userId}</td>
                            <td class="fw-semibold text-dark">${u.name}</td>
                            <td>${u.email}</td>
                            <td>${u.mobile}</td>
                            <td><span class="badge ${u.admin ? 'bg-danger' : 'bg-primary'} rounded-pill">${u.role}</span></td>
                            <td>
                                <span class="badge ${u.status == 'ACTIVE' ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} rounded-pill">
                                    ${u.status}
                                </span>
                            </td>
                            <td class="small text-muted">${u.createdAt}</td>
                            <td class="pe-4 text-end">
                                <c:if test="${!u.admin}">
                                    <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline m-0">
                                        <input type="hidden" name="action" value="toggleStatus">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <input type="hidden" name="status" value="${u.status == 'ACTIVE' ? 'BLOCKED' : 'ACTIVE'}">
                                        <button type="submit" class="btn btn-sm ${u.status == 'ACTIVE' ? 'btn-outline-danger' : 'btn-outline-success'} rounded-pill px-3">
                                            ${u.status == 'ACTIVE' ? 'Block Account' : 'Activate Account'}
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
