<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Sign In | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-5 py-3">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-4 bg-white">
                <div class="text-center mb-4">
                    <div class="brand-icon-box bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-2" style="width: 50px; height: 50px;">
                        <i class="bi bi-person-fill-lock fs-4"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Welcome Back</h3>
                    <p class="text-muted small">Sign in to your ShopSphere customer account</p>
                </div>

                <c:if test="${error != null}">
                    <div class="alert alert-danger py-2 small shadow-sm" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="redirect" value="${redirect}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-muted">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                            <input type="email" class="form-control border-start-0" name="email" id="loginEmail" required 
                                   placeholder="name@example.com" value="${email != null ? email : cookie.lastLoginEmail.value}">
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label class="form-label fw-semibold small text-muted mb-0">Password</label>
                        </div>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-key text-muted"></i></span>
                            <input type="password" class="form-control border-start-0" name="password" id="loginPassword" required placeholder="Enter password">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-pill fw-semibold shadow-sm mb-3">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                    </button>

                    <!-- Quick Demo Credentials Box for Viva / Demonstration -->
                    <div class="bg-light p-3 rounded-3 border mb-3">
                        <div class="small fw-bold text-muted mb-2 text-uppercase" style="letter-spacing: 0.5px;">
                            <i class="bi bi-lightning-charge-fill text-warning me-1"></i>Quick Demo Credentials:
                        </div>
                        <div class="d-flex flex-wrap gap-2">
                            <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill" onclick="fillCreds('nikhil@shopsphere.com', 'password123')">
                                Customer (Nikhil)
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill" onclick="fillCreds('student@shopsphere.com', 'student123')">
                                Student (RTU)
                            </button>
                            <button type="button" class="btn btn-outline-danger btn-sm rounded-pill" onclick="fillCreds('admin@shopsphere.com', 'admin123')">
                                Admin (Admin123)
                            </button>
                        </div>
                    </div>

                    <div class="text-center small text-muted">
                        Don't have an account? 
                        <a href="${pageContext.request.contextPath}/register" class="text-primary fw-semibold text-decoration-none">Create Account</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function fillCreds(email, pass) {
    document.getElementById('loginEmail').value = email;
    document.getElementById('loginPassword').value = pass;
}
</script>

<jsp:include page="fragments/footer.jsp" />
