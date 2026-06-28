// 1. Animación de entrada al cargar la página
window.addEventListener('load', () => {
    document.querySelector('.hero-content').classList.add('fade-in');
});

window.addEventListener('scroll', () => {
    const section = document.querySelector('.content-section');
    if (window.scrollY > 150) {
        section.style.backgroundColor = '#ffffff';
    } else {
        // Vuelve al color original si subes
        section.style.backgroundColor = '#d8a47f'; 
    }
});