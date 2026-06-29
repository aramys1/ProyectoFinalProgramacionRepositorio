document.addEventListener('DOMContentLoaded', function() {
    const heroContent = document.querySelector('.hero-content');
    const contentSection = document.querySelector('.content-section');
    const loginForm = document.getElementById('loginForm');
    const registroForm = document.getElementById('registroForm');

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
                return;
            }

            event.preventDefault();
            window.location.href = loginForm.dataset.demoRedirect || 'index.jsp';
        });
    }

    if (registroForm) {
        registroForm.addEventListener('submit', function(event) {
            const campos = registroForm.querySelectorAll('input[required]');
            const pass = registroForm.querySelector('input[name="password"]');
            const confirmPass = registroForm.querySelector('input[name="confirmarPassword"]');
            const numeroTarjeta = registroForm.querySelector('input[name="numeroTarjeta"]');
            let incompleto = false;

            campos.forEach(function(campo) {
                if (!campo.value.trim()) {
                    incompleto = true;
                }
            });

            if (incompleto) {
                alert('Error: debes rellenar todos los campos.');
                event.preventDefault();
                return;
            }

            if (pass.value !== confirmPass.value) {
                alert('Error: las contrasenas no coinciden.');
                event.preventDefault();
                return;
            }

            if (!/^[0-9]{5,6}$/.test(numeroTarjeta.value.trim())) {
                alert('Error: la tarjeta VHS debe tener solo 5 o 6 numeros.');
                event.preventDefault();
                return;
            }

            event.preventDefault();
            window.location.href = registroForm.dataset.demoRedirect || 'index.jsp';
        });
    }
});
