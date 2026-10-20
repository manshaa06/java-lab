/**
 * SHOPSPHERE - Interactive Client Logic & Asynchronous Helpers
 * RTU Advanced Java E-Commerce Project
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Auto-dismiss flash alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // 2. Mock Payment Simulation Spinner
    const checkoutForm = document.getElementById('checkoutForm');
    if (checkoutForm) {
        checkoutForm.addEventListener('submit', function (e) {
            const placeBtn = document.getElementById('placeOrderBtn');
            if (placeBtn) {
                placeBtn.disabled = true;
                placeBtn.innerHTML = `
                    <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                    Processing Transaction with Bank Gateway...
                `;
            }
        });
    }

    // 3. Quick Copy Coupon Code Helper
    const copyButtons = document.querySelectorAll('.btn-copy-code');
    copyButtons.forEach(btn => {
        btn.addEventListener('click', function () {
            const code = this.getAttribute('data-code');
            if (code) {
                navigator.clipboard.writeText(code).then(() => {
                    const original = this.innerHTML;
                    this.innerHTML = '<i class="bi bi-check2"></i> Copied!';
                    setTimeout(() => {
                        this.innerHTML = original;
                    }, 2000);
                });
            }
        });
    });

    console.log('[ShopSphere] Interactive JS subsystems initialized.');
});
