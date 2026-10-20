<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card shadow-sm border-0 mb-4 sticky-top" style="top: 90px;">
    <div class="card-header bg-white py-3 border-0">
        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-funnel-fill text-primary me-2"></i>Filter Products</h6>
    </div>
    <div class="card-body pt-0">
        <form action="${pageContext.request.contextPath}/products" method="get">
            <input type="hidden" name="query" value="${param.query}">

            <!-- Category Filter -->
            <div class="mb-4">
                <label class="form-label fw-semibold small text-uppercase text-muted" style="letter-spacing: 0.5px;">Category</label>
                <div class="d-flex flex-column gap-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="category" id="catAll" value="" ${empty param.category ? 'checked' : ''}>
                        <label class="form-check-label small" for="catAll">All Categories</label>
                    </div>
                    <c:forEach var="cat" items="${categories}">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="category" id="cat_${cat.categoryId}" value="${cat.categoryId}" ${param.category == cat.categoryId ? 'checked' : ''}>
                            <label class="form-check-label small d-flex justify-content-between align-items-center" for="cat_${cat.categoryId}">
                                <span>${cat.name}</span>
                                <span class="badge bg-light text-muted border">${cat.productCount}</span>
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Price Range -->
            <div class="mb-4">
                <label class="form-label fw-semibold small text-uppercase text-muted" style="letter-spacing: 0.5px;">Price Range</label>
                <div class="row g-2">
                    <div class="col-6">
                        <input type="number" class="form-control form-control-sm" name="minPrice" placeholder="Min ₹" value="${param.minPrice}">
                    </div>
                    <div class="col-6">
                        <input type="number" class="form-control form-control-sm" name="maxPrice" placeholder="Max ₹" value="${param.maxPrice}">
                    </div>
                </div>
            </div>

            <!-- Sorting -->
            <div class="mb-4">
                <label class="form-label fw-semibold small text-uppercase text-muted" style="letter-spacing: 0.5px;">Sort By</label>
                <select name="sort" class="form-select form-select-sm">
                    <option value="" ${empty param.sort ? 'selected' : ''}>Newest Arrivals</option>
                    <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                    <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                    <option value="discount" ${param.sort == 'discount' ? 'selected' : ''}>Highest Discount</option>
                </select>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary btn-sm rounded-pill">Apply Filters</button>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-light btn-sm rounded-pill text-muted">Reset</a>
            </div>
        </form>
    </div>
</div>
