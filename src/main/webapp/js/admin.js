document.addEventListener('DOMContentLoaded', function() {
    initAdminPage();
});

function initAdminPage() {
    initDataTables();
    initQuickActions();
    initStatusUpdates();
}

function initDataTables() {
    const tables = document.querySelectorAll('.table-sortable');

    tables.forEach(table => {
        const headers = table.querySelectorAll('th[data-sort]');

        headers.forEach(header => {
            header.style.cursor = 'pointer';
            header.addEventListener('click', function() {
                const sortBy = this.dataset.sort;
                const isAsc = !this.classList.contains('asc');

                headers.forEach(h => {
                    h.classList.remove('asc', 'desc');
                });

                this.classList.add(isAsc ? 'asc' : 'desc');

                sortTable(table, sortBy, isAsc);
            });
        });
    });
}

function sortTable(table, sortBy, ascending) {
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));

    rows.sort((a, b) => {
        const aValue = a.querySelector(`td[data-${sortBy}]`).dataset[sortBy];
        const bValue = b.querySelector(`td[data-${sortBy}]`).dataset[sortBy];

        let comparison = 0;
        if (aValue < bValue) comparison = -1;
        if (aValue > bValue) comparison = 1;

        return ascending ? comparison : -comparison;
    });

    while (tbody.firstChild) {
        tbody.removeChild(tbody.firstChild);
    }

    rows.forEach(row => tbody.appendChild(row));
}

function initQuickActions() {
    const quickEditButtons = document.querySelectorAll('.quick-edit');
    quickEditButtons.forEach(button => {
        button.addEventListener('click', function() {
            const itemId = this.dataset.itemId;
            const itemType = this.dataset.itemType;
            quickEditItem(itemId, itemType);
        });
    });
}

function quickEditItem(itemId, itemType) {
    fetch(`${contextPath}/admin/${itemType}/edit?id=${itemId}`)
        .then(response => response.text())
        .then(html => {
            showModal('Редактирование', html);
        });
}

function initStatusUpdates() {
    const statusSelects = document.querySelectorAll('.order-status-select');
    statusSelects.forEach(select => {
        select.addEventListener('change', function() {
            const orderId = this.dataset.orderId;
            const newStatus = this.value;

            updateOrderStatus(orderId, newStatus, this);
        });
    });
}

function updateOrderStatus(orderId, status, selectElement) {
    const originalStatus = selectElement.dataset.originalStatus;

    fetch(`${contextPath}/admin/orders/update-status`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `orderId=${orderId}&status=${status}`
    })
    .then(response => response.json())
        .then(data => {
            if (data.success) {
                selectElement.dataset.originalStatus = status;
                showNotification('Статус заказа обновлен', 'success');

                updateStatusDisplay(orderId, status);
            } else {
                showNotification('Ошибка обновления статуса', 'error');
                selectElement.value = originalStatus;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            selectElement.value = originalStatus;
            showNotification('Произошла ошибка', 'error');
        });
}

function updateStatusDisplay(orderId, status) {
    const statusElement = document.querySelector(`[data-order-id="${orderId}"] .order-status`);
    if (statusElement) {
        statusElement.textContent = getStatusText(status);
        statusElement.className = `order-status status-${status.toLowerCase()}`;
    }
}

function getStatusText(status) {
    const statusMap = {
        'PENDING': 'Ожидание',
        'CONFIRMED': 'Подтвержден',
        'PREPARING': 'Готовится',
        'READY': 'Готов',
        'COMPLETED': 'Завершен',
        'CANCELLED': 'Отменен'
    };
    return statusMap[status] || status;
}

function showModal(title, content) {
    let modal = document.getElementById('admin-modal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'admin-modal';
        modal.className = 'modal';
        modal.innerHTML = `
            <div class="modal-content">
                <div class="modal-header">
                    <h3>${title}</h3>
                    <span class="close">&times;</span>
                </div>
                <div class="modal-body"></div>
            </div>
        `;
        document.body.appendChild(modal);

        modal.querySelector('.close').addEventListener('click', hideModal);
        modal.addEventListener('click', function(e) {
            if (e.target === modal) hideModal();
        });
    }

    modal.querySelector('.modal-header h3').textContent = title;
    modal.querySelector('.modal-body').innerHTML = content;
    modal.style.display = 'block';

    initModalForm();
}

function hideModal() {
    const modal = document.getElementById('admin-modal');
    if (modal) {
        modal.style.display = 'none';
    }
}

function initModalForm() {
    const form = document.querySelector('#admin-modal form');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            submitModalForm(this);
        });
    }
}

function submitModalForm(form) {
    const formData = new FormData(form);

    fetch(form.action, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showNotification('Изменения сохранены', 'success');
            hideModal();
            setTimeout(() => location.reload(), 1000);
        } else {
            showNotification('Ошибка сохранения: ' + data.error, 'error');
        }
    });
}

const modalStyles = `
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
    }

    .modal-content {
        background-color: white;
        margin: 5% auto;
        padding: 0;
        border-radius: 8px;
        width: 90%;
        max-width: 600px;
        max-height: 80vh;
        overflow-y: auto;
    }

    .modal-header {
        padding: 1rem 1.5rem;
        border-bottom: 1px solid #ddd;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-header h3 {
        margin: 0;
    }

    .close {
        font-size: 1.5rem;
        cursor: pointer;
        color: #aaa;
    }

    .close:hover {
        color: #000;
    }

    .modal-body {
        padding: 1.5rem;
    }

    .status-pending { color: #ffc107; }
    .status-confirmed { color: #17a2b8; }
    .status-preparing { color: #007bff; }
    .status-ready { color: #28a745; }
    .status-completed { color: #6c757d; }
    .status-cancelled { color: #dc3545; }
`;

if (!document.querySelector('#modal-styles')) {
    const styleElement = document.createElement('style');
    styleElement.id = 'modal-styles';
    styleElement.textContent = modalStyles;
    document.head.appendChild(styleElement);
}