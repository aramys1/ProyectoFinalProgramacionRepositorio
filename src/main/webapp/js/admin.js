function buscarUsuario() {
    const buscar = document.getElementById('buscarInput').value.toLowerCase().trim();
    const filas = document.querySelectorAll('#tbodyUsuarios tr');

    if (buscar === '') {
        // Sin busqueda: solo mostrar empleados
        filas.forEach(fila => {
            fila.style.display = fila.getAttribute('data-rol') === 'EMPLEADO' ? '' : 'none';
        });
        return;
    }

    // Con busqueda: mostrar todos los que coincidan
    filas.forEach(fila => {
        const nombre = fila.getAttribute('data-nombre');
        const cedula = fila.getAttribute('data-cedula');
        fila.style.display = nombre.includes(buscar) || cedula.includes(buscar) ? '' : 'none';
    });
}

function limpiarBusqueda() {
    document.getElementById('buscarInput').value = '';
    buscarUsuario();
}

function cambiarRol(btn, nuevoRol) {
    const fila = btn.closest('tr');
    const badge = fila.querySelector('.role-badge');

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

function mostrarToast(mensaje, tipo) {
    const toast = document.getElementById('toast');
    toast.textContent = mensaje;
    toast.className = 'toast show ' + tipo;
    setTimeout(() => toast.className = 'toast', 3000);
}