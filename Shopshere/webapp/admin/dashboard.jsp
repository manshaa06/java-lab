<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | ShopSphere Enterprise</title>
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
                <li class="nav-item"><a class="nav-link active fw-semibold" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-1"></i> Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-1"></i> Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-tags me-1"></i> Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-receipt me-1"></i> Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-1"></i> Customers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/coupons"><i class="bi bi-ticket-perforated me-1"></i> Coupons</a></li>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light btn-sm rounded-pill px-3" target="_blank">
                    <i class="bi bi-shop me-1"></i> Customer View
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm rounded-pill px-3">
                    <i class="bi bi-box-arrow-right me-1"></i> Logout
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="container-fluid my-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Administrative Dashboard</h3>
            <span class="text-muted small">Real-time telemetry and management controls</span>
        </div>
        <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill font-monospace">
            Active Web Sessions: ${activeSessions}
        </span>
    </div>

    <!-- 4 KPI Cards -->
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-muted small fw-semibold text-uppercase">Total Sales</span>
                    <span class="rounded-3 bg-success-subtle text-success p-2"><i class="bi bi-currency-rupee fs-5"></i></span>
                </div>
                <h3 class="fw-bold mb-0 text-success">₹<fmt:formatNumber value="${totalSales}" minFractionDigits="2" maxFractionDigits="2"/></h3>
                <span class="small text-muted">Settled transactions</span>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-muted small fw-semibold text-uppercase">Total Orders</span>
                    <span class="rounded-3 bg-primary-subtle text-primary p-2"><i class="bi bi-cart-check fs-5"></i></span>
                </div>
                <h3 class="fw-bold mb-0 text-primary">${totalOrders}</h3>
                <span class="small text-muted">All-time customer orders</span>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-muted small fw-semibold text-uppercase">Catalog Products</span>
                    <span class="rounded-3 bg-info-subtle text-info p-2"><i class="bi bi-box-seam fs-5"></i></span>
                </div>
                <h3 class="fw-bold mb-0 text-info">${totalProducts}</h3>
                <span class="small text-muted">Live products in database</span>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-muted small fw-semibold text-uppercase">Registered Users</span>
                    <span class="rounded-3 bg-warning-subtle text-warning p-2"><i class="bi bi-people fs-5"></i></span>
                </div>
                <h3 class="fw-bold mb-0 text-dark">${totalUsers}</h3>
                <span class="small text-muted">Admin &amp; customer accounts</span>
            </div>
        </div>
    </div>

    <!-- Low Stock Inventory Alerts -->
    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                        <h5 class="fw-bold mb-0">Low Stock Inventory Alerts (&le; 25 units)</h5>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-primary btn-sm rounded-pill">Manage Products</a>
                </div>

                <div class="table-responsive">
                    <table class="table table-sm align-middle mb-0">
                        <thead class="table-light small text-uppercase text-muted">
                            <tr>
                                <th>Product</th>
                                <th>Category</th>
                                <th>Stock</th>
                                <th class="text-end">Quick Restock</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="lp" items="${lowStock}">
                                <tr>
                                    <td>
                                        <div class="fw-semibold small text-truncate" style="max-width: 180px;">${lp.name}</div>
                                        <span class="text-muted" style="font-size: 0.72rem;">${lp.brand}</span>
                                    </td>
                                    <td class="small">${lp.categoryName}</td>
                                    <td>
                                        <span class="badge ${lp.stock <= 10 ? 'bg-danger' : 'bg-warning text-dark'} font-monospace">
                                            ${lp.stock} left
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/admin/products" method="post" class="d-inline-flex gap-1 m-0">
                                            <input type="hidden" name="action" value="updateStock">
                                            <input type="hidden" name="productId" value="${lp.productId}">
                                            <input type="number" name="stock" value="${lp.stock + 50}" class="form-control form-control-sm text-center font-monospace" style="width: 70px;">
                                            <button type="submit" class="btn btn-sm btn-success rounded-pill px-2">Update</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Recent Customer Orders -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <h5 class="fw-bold mb-0">Recent Customer Orders</h5>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-primary btn-sm rounded-pill">View All</a>
                </div>

                <div class="table-responsive">
                    <table class="table table-sm align-middle mb-0">
                        <thead class="table-light small text-uppercase text-muted">
                            <tr>
                                <th>Order #</th>
                                <th>Customer</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ro" items="${recentOrders}">
                                <tr>
                                    <td class="fw-bold font-monospace">#${ro.orderId}</td>
                                    <td class="small">${ro.user.name}</td>
                                    <td class="fw-bold text-primary small">₹<fmt:formatNumber value="${ro.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td>
                                        <span class="badge ${ro.orderStatus == 'DELIVERED' ? 'bg-success' : 'bg-primary'} rounded-pill">
                                            ${ro.orderStatus}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/order-details?id=${ro.orderId}" class="btn btn-link btn-sm p-0">Details</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
