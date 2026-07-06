// Punto de entrada: activa únicamente los componentes presentes en la página actual.
document.addEventListener('DOMContentLoaded', function() {
    initAuthForms();
    initEmployeeNav();
    initPosterFileName();
    initInventoryTemplate();
    initSynopsisInventoryTemplate();
    initHeroPosterSlider();
    initCartRentalTotal();
});

// Recalcula en vivo el precio del carrito según los días escogidos.
function initCartRentalTotal() {
    const daysInput = document.getElementById('rentalDays');
    const totalBox = document.querySelector('[data-daily-total]');
    const daysLabel = document.getElementById('rentalDaysLabel');
    const rentalTotal = document.getElementById('rentalTotal');
    if (!daysInput || !totalBox || !daysLabel || !rentalTotal) return;

    function updateTotal() {
        const days = Math.min(30, Math.max(1, parseInt(daysInput.value, 10) || 1));
        const daily = parseFloat(totalBox.dataset.dailyTotal) || 0;
        daysLabel.textContent = String(days);
        rentalTotal.textContent = (daily * days).toFixed(2);
    }

    daysInput.addEventListener('input', updateTotal);
    updateTotal();
}

// Alterna aleatoriamente los pósteres de la portada sin repetir el actual.
function initHeroPosterSlider() {
    const poster = document.querySelector('[data-hero-poster-slider]');
    if (!poster) return;

    const posters = (poster.dataset.posters || '').split(',').map(function(name) {
        return name.trim();
    }).filter(Boolean);
    if (posters.length < 2) return;

    const base = poster.dataset.posterBase || '';
    const nameLabel = document.querySelector('[data-hero-poster-name]');
    let current = posters.indexOf(poster.src.split('/').pop());

    function showRandomPoster() {
        let next;
        do {
            next = Math.floor(Math.random() * posters.length);
        } while (next === current && posters.length > 1);

        current = next;
        poster.classList.add('is-changing');
        window.setTimeout(function() {
            poster.src = base + posters[current];
            if (nameLabel) nameLabel.textContent = posters[current];
            poster.classList.remove('is-changing');
        }, 250);
    }

    window.setInterval(showRandomPoster, 1500);
}

// Validaciones básicas del lado del navegador para login y registro.
function initAuthForms() {
    const loginForm = document.getElementById('loginForm');
    const registroForm = document.getElementById('registroForm');

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

    if (registroForm) {
        registroForm.addEventListener('submit', function(event) {
            const campos = registroForm.querySelectorAll('input[required]');
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

            if (!validarContrasenas()) {
                event.preventDefault();
            }
        });
    }
}

// Comprueba que la contraseña y su confirmación coincidan.
function validarContrasenas() {
    const pass = document.getElementById('password');
    const confirmPass = document.getElementById('confirmPassword');

    if (!pass || !confirmPass) return true;

    if (pass.value !== confirmPass.value) {
        alert('Error: las contrasenas no coinciden.');
        return false;
    }

    return true;
}

// Marca la sección activa y crea el menú adaptable de las vistas de empleado.
function initEmployeeNav() {
    const nav = document.querySelector('.employee-nav');
    if (!nav) return;

    const links = nav.querySelector('.nav-links');
    const currentPage = window.location.pathname.split('/').pop();

    nav.querySelectorAll('a[href]').forEach(function(link) {
        if (link.getAttribute('href') === currentPage) {
            link.classList.add('active');
        }
    });

    if (!links || nav.querySelector('.employee-menu-toggle')) return;

    const toggle = document.createElement('button');
    toggle.type = 'button';
    toggle.className = 'employee-menu-toggle';
    toggle.setAttribute('aria-label', 'Abrir menu de empleado');
    toggle.setAttribute('aria-expanded', 'false');
    toggle.textContent = 'MENU';
    nav.insertBefore(toggle, links);

    toggle.addEventListener('click', function() {
        const isOpen = nav.classList.toggle('employee-nav-open');
        toggle.setAttribute('aria-expanded', String(isOpen));
    });

    links.addEventListener('click', function(event) {
        if (event.target.closest('a')) {
            nav.classList.remove('employee-nav-open');
            toggle.setAttribute('aria-expanded', 'false');
        }
    });
}

// Copia el nombre del archivo seleccionado al campo visible del formulario.
function initPosterFileName() {
    const posterFile = document.getElementById('posterFile');
    const posterNombre = document.getElementById('posterNombre');

    if (posterFile && posterNombre) {
        posterFile.addEventListener('change', function() {
            const file = posterFile.files && posterFile.files[0];
            posterNombre.value = file ? file.name : '';
        });
    }
}

// Controla la apertura de formularios y paneles del inventario.
function initInventoryTemplate() {
    const inventory = document.querySelector('[data-inventory-template]');
    if (!inventory) return;

    const buttons = inventory.querySelectorAll('[data-movie-select]');
    const detail = inventory.querySelector('[data-inventory-detail]');
    const addPanel = inventory.querySelector('[data-add-movie-panel]');
    const addToggles = inventory.querySelectorAll('[data-add-movie-toggle]');

    addToggles.forEach(function(toggle) {
        toggle.addEventListener('click', function() {
            if (!addPanel) return;
            addPanel.hidden = !addPanel.hidden;
            if (detail) {
                detail.hidden = true;
                buttons.forEach(function(item) {
                    item.classList.remove('active');
                });
            }
            if (!addPanel.hidden) {
                addPanel.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    if (!detail || !buttons.length) return;

    detail.hidden = true;

    const fields = {
        title: detail.querySelector('[data-field="title"]'),
        year: detail.querySelector('[data-field="year"]'),
        genre: detail.querySelector('[data-field="genre"]'),
        rating: detail.querySelector('[data-field="rating"]'),
        price: detail.querySelector('[data-field="price"]'),
        total: detail.querySelector('[data-field="total"]'),
        poster: detail.querySelector('[data-field="poster"]'),
        synopsis: detail.querySelector('[data-field="synopsis"]'),
        available: detail.querySelector('[data-count="available"]'),
        rented: detail.querySelector('[data-count="rented"]'),
        damaged: detail.querySelector('[data-count="damaged"]')
    };

    function selectMovie(button, shouldScroll) {
        detail.removeAttribute('hidden');

        buttons.forEach(function(item) {
            item.classList.toggle('active', item === button);
        });

        if (fields.title) fields.title.value = button.dataset.title || '';
        if (fields.year) fields.year.value = button.dataset.year || '';
        if (fields.genre) fields.genre.value = button.dataset.genre || '';
        if (fields.rating) fields.rating.value = button.dataset.rating || '';
        if (fields.price) fields.price.value = button.dataset.price || '';
        if (fields.total) fields.total.value = button.dataset.total || '';
        if (fields.synopsis) fields.synopsis.value = button.dataset.synopsis || '';
        if (fields.available) fields.available.textContent = button.dataset.available || '0';
        if (fields.rented) fields.rented.textContent = button.dataset.rented || '0';
        if (fields.damaged) fields.damaged.textContent = button.dataset.damaged || '0';
        if (fields.poster && button.dataset.poster) {
            fields.poster.src = button.dataset.poster;
            fields.poster.alt = 'Poster de ' + (button.dataset.title || 'pelicula seleccionada');
        }

        if (shouldScroll) {
            detail.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    buttons.forEach(function(button) {
        button.addEventListener('click', function() {
            selectMovie(button, true);
        });
    });

}

// Sincroniza visualmente la insignia de estado de cada copia VHS.
function initSynopsisInventoryTemplate() {
    const statusRows = document.querySelectorAll('[data-copy-status]');
    if (!statusRows.length) return;

    statusRows.forEach(function(row) {
        const select = row.querySelector('select');
        const badge = row.querySelector('.status-badge');
        if (!select || !badge) return;

        select.addEventListener('change', function() {
            badge.textContent = select.value;
            badge.className = 'status-badge ' + (select.value === 'DANADA' ? 'status-danger' : select.value === 'EN USO' ? 'status-warning' : 'status-ok');
        });
    });
}

// Filtra filas de usuario en las tablas antiguas que usan búsqueda en cliente.
function buscarUsuario() {
    const buscarInput = document.getElementById('buscarInput');
    const filas = document.querySelectorAll('#tbodyUsuarios tr');
    if (!buscarInput || !filas.length) return;

    const buscar = buscarInput.value.toLowerCase().trim();

    if (buscar === '') {
        filas.forEach(function(fila) {
            fila.style.display = fila.getAttribute('data-rol') === 'EMPLEADO' ? '' : 'none';
        });
        return;
    }

    filas.forEach(function(fila) {
        const nombre = fila.getAttribute('data-nombre') || '';
        const cedula = fila.getAttribute('data-cedula') || '';
        fila.style.display = nombre.includes(buscar) || cedula.includes(buscar) ? '' : 'none';
    });
}

function limpiarBusqueda() {
    const buscarInput = document.getElementById('buscarInput');
    if (buscarInput) {
        buscarInput.value = '';
        buscarUsuario();
    }
}

// Actualiza visualmente el rol; el guardado real debe validarse también en servidor.
function cambiarRol(btn, nuevoRol) {
    const fila = btn.closest('tr');
    const badge = fila.querySelector('.role-badge');
    if (!fila || !badge) return;

    badge.className = 'role-badge role-' + nuevoRol;
    badge.textContent = nuevoRol;
    fila.setAttribute('data-rol', nuevoRol);

    if (nuevoRol === 'EMPLEADO') {
        btn.className = 'btn-revocar';
        btn.textContent = 'REVOCAR';
        btn.setAttribute('onclick', "cambiarRol(this, 'CLIENTE')");
        mostrarToast('Rol de EMPLEADO otorgado correctamente.', 'success');
    } else {
        btn.className = 'btn-otorgar';
        btn.textContent = 'OTORGAR';
        btn.setAttribute('onclick', "cambiarRol(this, 'EMPLEADO')");
        mostrarToast('Rol revocado. Usuario es ahora CLIENTE.', 'success');
    }
}

// Presenta una notificación temporal de éxito o error.
function mostrarToast(mensaje, tipo) {
    const toast = document.getElementById('toast');
    if (!toast) return;

    toast.textContent = mensaje;
    toast.className = 'toast show ' + tipo;
    setTimeout(function() {
        toast.className = 'toast';
    }, 3000);
}

// Filtra las opciones de película utilizadas por formularios de alquiler.
function filtrarPeliculas() {
    const buscar = (document.getElementById('buscarPelicula')?.value || '').toLowerCase();
    const select = document.getElementById('selectVhs');
    if (!select) return;

    const opciones = select.options;
    for (let i = 1; i < opciones.length; i++) {
        const titulo = opciones[i].getAttribute('data-titulo') || '';
        opciones[i].style.display = titulo.includes(buscar) ? '' : 'none';
    }
    select.value = '';
    const total = document.getElementById('totalCobro');
    if (total) total.textContent = '0.00';
}

// Calcula el importe estimado usando precio por día y duración.
function calcularTotal() {
    const select = document.getElementById('selectVhs');
    const diasInput = document.getElementById('dias');
    const total = document.getElementById('totalCobro');
    if (!select || !diasInput || !total) return;

    const dias = parseInt(diasInput.value, 10) || 0;
    const selected = select.options[select.selectedIndex];
    const precio = parseFloat(selected?.getAttribute('data-precio')) || 0;
    total.textContent = (precio * dias).toFixed(2);
}

// Utilidades genéricas para abrir y cerrar ventanas modales.
function openModal(id) {
    const modal = document.getElementById(id);
    if (modal) modal.style.display = 'block';
}

function closeModal(id) {
    const modal = document.getElementById(id);
    if (modal) modal.style.display = 'none';
}

window.addEventListener('click', function(event) {
    if (event.target.classList && event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
});
