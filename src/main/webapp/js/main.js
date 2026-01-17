document.addEventListener('DOMContentLoaded', () => {
    initAddToCartButtons();
    updateCartCounter();
});

const mainContextPath = window.contextPath || '';

// ==================== Добавление в корзину ====================
function initAddToCartButtons() {
    document.querySelectorAll('.add-to-cart').forEach(button => {
        button.addEventListener('click', function() {
            const itemId = this.dataset.itemId;
            if (!itemId) return;

            addToCart(itemId);
        });
    });
}

function addToCart(itemId) {
    fetch(`${mainContextPath}/order/add-item`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: `itemId=${itemId}&quantity=1`
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        }
        throw new Error('Network response was not ok.');
    })
    .then(data => {
        if (data.success) {
            showNotification('Товар добавлен в корзину!', 'success');
            updateCartCounter();
        } else {
            showNotification('Ошибка: ' + (data.error || 'неизвестная ошибка'), 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Ошибка добавления в корзину', 'error');
    });
}

function updateCartCounter() {
    const counter = document.getElementById('cart-counter');
    if (!counter) return;

    fetch(`${mainContextPath}/order/cart-count`)
        .then(response => response.json())
        .then(data => {
            counter.textContent = data.count || 0;
            counter.style.display = (data.count > 0) ? 'inline' : 'none';
        })
        .catch(error => {
            console.error('Error updating cart counter:', error);
        });
}

// ==================== Уведомления ====================
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;

    let bgColor;
    switch(type) {
        case 'success': bgColor = '#28a745'; break;
        case 'error': bgColor = '#dc3545'; break;
        case 'warning': bgColor = '#ffc107'; break;
        default: bgColor = '#17a2b8';
    }

    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        padding: 12px 20px;
        background: ${bgColor};
        color: white;
        border-radius: 4px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        min-width: 300px;
        max-width: 400px;
        animation: slideIn 0.3s ease-out;
    `;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-in';
        setTimeout(() => notification.remove(), 300);
    }, 4000);
}

const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(style);