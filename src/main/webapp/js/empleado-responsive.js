document.addEventListener('DOMContentLoaded', () => {
    const nav = document.querySelector('.employee-nav');
    if (!nav) return;

    const links = nav.querySelector('.nav-links');
    const currentPage = window.location.pathname.split('/').pop();

    nav.querySelectorAll('a[href]').forEach((link) => {
        if (link.getAttribute('href') === currentPage) {
            link.classList.add('active');
        }
    });

    const toggle = document.createElement('button');
    toggle.type = 'button';
    toggle.className = 'employee-menu-toggle';
    toggle.setAttribute('aria-label', 'Abrir menu de empleado');
    toggle.setAttribute('aria-expanded', 'false');
    toggle.textContent = 'MENU';
    nav.insertBefore(toggle, links);

    toggle.addEventListener('click', () => {
        const isOpen = nav.classList.toggle('employee-nav-open');
        toggle.setAttribute('aria-expanded', String(isOpen));
    });

    links.addEventListener('click', (event) => {
        if (event.target.closest('a')) {
            nav.classList.remove('employee-nav-open');
            toggle.setAttribute('aria-expanded', 'false');
        }
    });

    const posterFile = document.getElementById('posterFile');
    const posterNombre = document.getElementById('posterNombre');
    if (posterFile && posterNombre) {
        posterFile.addEventListener('change', () => {
            const file = posterFile.files && posterFile.files[0];
            posterNombre.value = file ? file.name : '';
        });
    }
});
