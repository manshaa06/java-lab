<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Create Account | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-5 py-2">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-4 bg-white">
                <div class="text-center mb-4">
                    <div class="brand-icon-box bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-2" style="width: 50px; height: 50px;">
                        <i class="bi bi-person-plus-fill fs-4"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Create Account</h3>
                    <p class="text-muted small">Join ShopSphere to enjoy personalized shopping and deals</p>
                </div>

                <c:if test="${error != null}">
                    <div class="alert alert-danger py-2 small shadow-sm" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-muted">Full Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-person text-muted"></i></span>
                            <input type="text" class="form-control border-start-0" name="name" required placeholder="Nikhil Sharma" value="${name}">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-muted">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                            <input type="email" class="form-control border-start-0" name="email" required placeholder="nikhil@example.com" value="${email}">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-muted">Mobile Number</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-telephone text-muted"></i></span>
                            <input type="tel" class="form-control border-start-0" name="mobile" required placeholder="9876543210" value="${mobile}">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-muted">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-shield-lock text-muted"></i></span>
                            <input type="password" class="form-control border-start-0" name="password" required placeholder="Create a strong password">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold small text-muted">Confirm Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-shield-check text-muted"></i></span>
                            <input type="password" class="form-control border-start-0" name="confirmPassword" required placeholder="Confirm your password">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-pill fw-semibold shadow-sm mb-3">
                        <i class="bi bi-person-check-fill me-1"></i> Register Account
                    </button>

                    <div class="text-center small text-muted">
                        Already have an account? 
                        <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold text-decoration-none">Sign In</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
