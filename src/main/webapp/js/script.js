document.addEventListener('DOMContentLoaded', function() {
    const heroContent = document.querySelector('.hero-content');
    const contentSection = document.querySelector('.content-section');
    const loginForm = document.getElementById('loginForm');

    if (heroContent) {
        heroContent.classList.add('fade-in');
    }

    if (contentSection) {
        window.addEventListener('scroll', function() {
            contentSection.style.backgroundColor = window.scrollY > 150 ? '#ffffff' : '#d8a47f';
        });
    }

    if (loginForm) {
        loginForm.addEventListener('submit', function(event) {
            const user = loginForm.querySelector('input[name="usuario"]');
            const pass = loginForm.querySelector('input[name="password"]');

            if (!user.value.trim() || !pass.value.trim()) {
                alert('Error: debes rellenar todos los campos.');
                event.preventDefault();
            }
        });
    }
});
