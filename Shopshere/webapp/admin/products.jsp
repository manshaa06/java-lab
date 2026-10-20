<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products | ShopSphere Admin</title>
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
                <li class="nav-item"><a class="nav-link active fw-semibold" href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-1"></i> Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-tags me-1"></i> Categories</a></li>
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

<div class="container-fluid my-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Product Inventory Management</h3>
            <span class="text-muted small">Create, edit, delete, and restock products in the MySQL database</span>
        </div>
        <button class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addProductModal">
            <i class="bi bi-plus-lg me-1"></i> Add New Product
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
                        <th>Product</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Discount</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th class="pe-4 text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td class="ps-4 font-monospace fw-bold">#${p.productId}</td>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <img src="${p.imageUrl}" class="rounded-3 object-fit-cover shadow-sm" style="width: 48px; height: 48px;" alt="${p.name}">
                                    <div>
                                        <div class="fw-semibold text-dark text-truncate" style="max-width: 250px;">${p.name}</div>
                                        <span class="small text-muted">${p.brand}</span>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge bg-secondary-subtle text-secondary">${p.categoryName}</span></td>
                            <td class="fw-semibold">₹<fmt:formatNumber value="${p.price}" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td><span class="badge bg-danger-subtle text-danger">-${Math.round(p.discount)}%</span></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/products" method="post" class="d-flex align-items-center gap-1 m-0">
                                    <input type="hidden" name="action" value="updateStock">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <input type="number" name="stock" value="${p.stock}" class="form-control form-control-sm text-center font-monospace" style="width: 75px;">
                                    <button type="submit" class="btn btn-sm btn-outline-secondary" title="Save Stock">✓</button>
                                </form>
                            </td>
                            <td>
                                <span class="badge ${p.status ? 'bg-success-subtle text-success' : 'bg-secondary'} rounded-pill">
                                    ${p.status ? 'Active' : 'Inactive'}
                                </span>
                            </td>
                            <td class="pe-4 text-end">
                                <form action="${pageContext.request.contextPath}/admin/products" method="post" class="d-inline m-0">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle p-2" title="Delete Product" onclick="return confirm('Delete this product permanently?')">
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

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold" id="addProductModalLabel">Add New Product to Database</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/products" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Product Name</label>
                            <input type="text" name="name" class="form-control" required placeholder="e.g. UltraSonic ANC Earbuds">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Brand</label>
                            <input type="text" name="brand" class="form-control" required placeholder="e.g. Sony">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Category</label>
                            <select name="categoryId" class="form-select" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Price (₹)</label>
                            <input type="number" step="0.01" name="price" class="form-control" required placeholder="1499.00">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Discount (%)</label>
                            <input type="number" step="0.01" name="discount" class="form-control" value="0.00">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Initial Stock Quantity</label>
                            <input type="number" name="stock" class="form-control" value="25" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Image URL</label>
                            <input type="url" name="imageUrl" class="form-control" required placeholder="https://images.unsplash.com/photo-...">
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Description</label>
                            <textarea name="description" rows="3" class="form-control" placeholder="Detailed product specifications..."></textarea>
                        </div>
                        <div class="col-12">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="status" value="true" id="prodActive" checked>
                                <label class="form-check-label small" for="prodActive">Publish immediately (Active)</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">Save Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
