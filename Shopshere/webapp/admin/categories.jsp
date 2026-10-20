<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories | ShopSphere Admin</title>
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
                <li class="nav-item"><a class="nav-link active fw-semibold" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-tags me-1"></i> Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-receipt me-1"></i> Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-1"></i> Customers</a></li>
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
            <h3 class="fw-bold mb-1">Product Categories</h3>
            <span class="text-muted small">Manage catalog hierarchy and departmental classifications</span>
        </div>
        <button class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
            <i class="bi bi-plus-lg me-1"></i> Add Category
        </button>
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
                        <th class="ps-4">ID</th>
                        <th>Category Name</th>
                        <th>Description</th>
                        <th>Associated Products</th>
                        <th>Status</th>
                        <th class="pe-4 text-end">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${categories}">
                        <tr>
                            <td class="ps-4 font-monospace fw-bold">#${c.categoryId}</td>
                            <td class="fw-semibold text-dark">${c.name}</td>
                            <td class="small text-muted">${c.description}</td>
                            <td><span class="badge bg-primary-subtle text-primary">${c.productCount} Products</span></td>
                            <td><span class="badge bg-success-subtle text-success">${c.status}</span></td>
                            <td class="pe-4 text-end">
                                <form action="${pageContext.request.contextPath}/admin/categories" method="post" class="d-inline m-0">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="categoryId" value="${c.categoryId}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle p-2" title="Delete Category" onclick="return confirm('Delete category? (Only allowed if no active products are attached)')">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold">Create New Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Category Name</label>
                        <input type="text" name="name" class="form-control" required placeholder="e.g. Smart Wearables">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Description</label>
                        <textarea name="description" rows="3" class="form-control" placeholder="Brief summary of category..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Status</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE">ACTIVE</option>
                            <option value="INACTIVE">INACTIVE</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">Create</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
