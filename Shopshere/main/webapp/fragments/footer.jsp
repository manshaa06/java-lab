<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Footer -->
<footer class="mt-auto bg-dark text-white pt-5 pb-4 border-top border-secondary border-opacity-25">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-lg-4 col-md-6">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <span class="brand-icon-box bg-primary text-white rounded-3 d-inline-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                        <i class="bi bi-gem fs-6"></i>
                    </span>
                    <span class="fs-4 brand-text fw-bold text-white">Shop<span class="text-primary">Sphere</span></span>
                </div>
                <p class="text-secondary small leading-relaxed">
                    ShopSphere is an enterprise-grade E-Commerce management system built adhering strictly to the Rajasthan Technical University (RTU) Advanced Java syllabus.
                </p>
                <div class="d-flex gap-2">
                    <span class="badge bg-secondary-subtle text-light border border-secondary border-opacity-50">Jakarta EE 10</span>
                    <span class="badge bg-secondary-subtle text-light border border-secondary border-opacity-50">Tomcat 11</span>
                    <span class="badge bg-secondary-subtle text-light border border-secondary border-opacity-50">MySQL 8 / MariaDB</span>
                    <span class="badge bg-secondary-subtle text-light border border-secondary border-opacity-50">Java RMI</span>
                </div>
            </div>

            <div class="col-lg-2 col-md-6">
                <h6 class="text-uppercase fw-bold text-white-50 mb-3" style="font-size: 0.8rem; letter-spacing: 1px;">Quick Links</h6>
                <ul class="list-unstyled text-secondary small mb-0 d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none hover-white">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/products" class="text-secondary text-decoration-none hover-white">Product Catalog</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart" class="text-secondary text-decoration-none hover-white">Shopping Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders" class="text-secondary text-decoration-none hover-white">Order Tracking</a></li>
                    <li><a href="${pageContext.request.contextPath}/syllabus-demo" class="text-warning text-decoration-none">Syllabus Demo Lab</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-bold text-white-50 mb-3" style="font-size: 0.8rem; letter-spacing: 1px;">RTU Syllabus Topics</h6>
                <ul class="list-unstyled text-secondary small mb-0 d-flex flex-column gap-2">
                    <li><i class="bi bi-check2 text-success me-1"></i> Servlets, Lifecycle &amp; Filters</li>
                    <li><i class="bi bi-check2 text-success me-1"></i> JSP, EL, JSTL, Tag Files &amp; TLD</li>
                    <li><i class="bi bi-check2 text-success me-1"></i> JDBC Transactions &amp; DAOs</li>
                    <li><i class="bi bi-check2 text-success me-1"></i> Java Sockets &amp; Serialization</li>
                    <li><i class="bi bi-check2 text-success me-1"></i> RMI Registry &amp; Remote Service</li>
                    <li><i class="bi bi-check2 text-success me-1"></i> Swing Desktop Administration</li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-bold text-white-50 mb-3" style="font-size: 0.8rem; letter-spacing: 1px;">Distributed Architecture</h6>
                <div class="bg-black bg-opacity-40 p-3 rounded-3 border border-secondary border-opacity-25 small font-monospace">
                    <div class="d-flex justify-content-between mb-1">
                        <span class="text-secondary">Web Container:</span>
                        <span class="text-success fw-bold">Tomcat 11 (:8080)</span>
                    </div>
                    <div class="d-flex justify-content-between mb-1">
                        <span class="text-secondary">RMI Registry:</span>
                        <span class="text-info fw-bold">rmi://localhost:1099</span>
                    </div>
                    <div class="d-flex justify-content-between mb-1">
                        <span class="text-secondary">Socket Server:</span>
                        <span class="text-warning fw-bold">tcp://localhost:8888</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-secondary">Database:</span>
                        <span class="text-success fw-bold">MySQL (:3306)</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="pt-4 mt-4 border-top border-secondary border-opacity-25 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2 small text-secondary">
            <div>&copy; 2026 <strong>ShopSphere</strong>. Developed for RTU Advanced Java Practical Examination.</div>
            <div class="d-flex gap-3">
                <a href="${pageContext.request.contextPath}/admin-login" class="text-secondary text-decoration-none"><i class="bi bi-shield-lock me-1"></i> Admin Portal</a>
                <span>&bull;</span>
                <a href="${pageContext.request.contextPath}/syllabus-demo" class="text-secondary text-decoration-none"><i class="bi bi-file-earmark-code me-1"></i> Viva Demonstration</a>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5.3 Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JavaScript Application Logic -->
<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
