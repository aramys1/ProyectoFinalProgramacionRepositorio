// 1. Animación de entrada al cargar la página
window.addEventListener('load', () => {
    document.querySelector('.hero-content').classList.add('fade-in');
});

window.addEventListener('scroll', () => {
    const section = document.querySelector('.content-section');
    const scrollPosition = window.scrollY;

    // A partir de los 200px, aplicamos un gradiente que va del fondo oscuro al claro
    // Esto crea la ilusión de que el color se "aclara" suavemente
    if (scrollPosition > 200) {
        section.style.background = 'linear-gradient(to bottom, #d8a47f, #fce4d6)';
    } else {
        section.style.background = '#d8a47f'; // Vuelve al color original
    }
});