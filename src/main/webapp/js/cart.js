document.addEventListener('DOMContentLoaded', () => {
    initCartPage();
});

const cartContextPath = window.contextPath || '';

let isProcessing = false;

function initCartPage() {
    initQuantityControls();

    initRemoveButtons();

    initClearCart();

    initCheckout();
}

function initQuantityControls() {
    document.querySelectorAll('.quantity-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            if (isProcessing) return;

            const input = this.closest('.quantity-controls').querySelector('.quantity-input');
            if (!input) return;

            const itemId = input.dataset.itemId;
            let value = parseInt(input.value) || 1;

            if (this.classList.contains('increase')) {
                value++;
            } else if (this.classList.contains('decrease')) {
                value = Math.max(1, value - 1);
            }

            input.value = value;
            updateQuantity(itemId, value);
        });
    });

    document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('change', function() {
            if (isProcessing) return;

            const itemId = this.dataset.itemId;
            let value = parseInt(this.value) || 1;
            value = Math.max(1, Math.min(99, value));

            this.value = value;
            updateQuantity(itemId, value);
        });
    });
}

function updateQuantity(itemId, quantity) {
    fetch(`${contextPath}/order/update-quantity`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `itemId=${itemId}&quantity=${quantity}`
    })
    .then(response => {
        return response.text().then(text => {
            console.log('Raw response:', text);
            console.log('Content-Type:', response.headers.get('content-type'));

            try {
                return JSON.parse(text);
            } catch (e) {
                console.error('JSON parse error:', e);
                console.error('Invalid JSON text:', text);
                throw new Error('Invalid JSON response: ' + text.substring(0, 100));
            }
        });
    })
    .then(data => {
        if (data.success) {
            updateCartDisplay(data);
        } else {
            showNotification(data.error || 'Ошибка', 'error');
        }
    })
    .catch(error => {
        console.error('Fetch error:', error);
        showNotification('Ошибка сети: ' + error.message, 'error');
    });
}

function initRemoveButtons() {
    document.querySelectorAll('.btn-remove').forEach(btn => {
        btn.addEventListener('click', function() {
            const itemId = this.dataset.itemId;
            if (!itemId || !confirm('Удалить товар из корзины?')) return;

            fetch(`${cartContextPath}/order/remove-item`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: `itemId=${itemId}`
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Network response was not ok.');
            })
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Ошибка удаления товара');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Ошибка удаления товара');
            });
        });
    });
}

function initClearCart() {
    const clearBtn = document.getElementById('clear-cart-btn');
    if (!clearBtn) return;

    clearBtn.addEventListener('click', () => {
        if (!confirm('Очистить всю корзину?')) return;

        fetch(`${cartContextPath}/order/clear`, {
            method: 'POST',
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            }
            throw new Error('Network response was not ok.');
        })
        .then(data => {
            if (data.success) {
                location.reload();
            } else {
                alert('Ошибка очистки корзины');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Ошибка очистки корзины');
        });
    });
}

function initCheckout() {
    const checkoutBtn = document.getElementById('checkout-btn');
    if (!checkoutBtn) return;

    checkoutBtn.addEventListener('click', () => {
        const notes = document.getElementById('customer-notes')?.value || '';

        checkoutBtn.disabled = true;
        const originalText = checkoutBtn.textContent;
        checkoutBtn.textContent = 'Оформление...';

        fetch(`${cartContextPath}/order/checkout`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `customerNotes=${encodeURIComponent(notes)}`
        })
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response URL:', response.url);

            const contentType = response.headers.get('content-type');
            console.log('Content-Type:', contentType);

            if (!contentType || !contentType.includes('application/json')) {
                return response.text().then(text => {
                    console.log('Response text (first 500 chars):', text.substring(0, 500));

                    if (text.includes('Ошибка') || text.includes('error')) {
                        const errorMatch = text.match(/Ошибка[^<]*|error[^<]*/i);
                        throw new Error(errorMatch ? errorMatch[0] : 'Неверный формат ответа от сервера');
                    }

                    throw new Error('Сервер вернул HTML вместо JSON. Проверьте настройки сервера.');
                });
            }

            return response.json();
        })
        .then(data => {
            console.log('Parsed data:', data);

            if (data.success) {
                alert('Заказ успешно оформлен! Перенаправляем на историю заказов...');

                setTimeout(() => {
                    window.location.href = `${cartContextPath}/order/history`;
                }, 1000);
            } else {
                alert('Ошибка оформления заказа: ' + (data.error || 'неизвестная ошибка'));
                checkoutBtn.disabled = false;
                checkoutBtn.textContent = originalText;
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);

            let errorMessage = 'Ошибка оформления заказа: ';

            if (error.message.includes('Сервер вернул HTML')) {
                errorMessage += 'Сервер вернул HTML страницу вместо JSON. ';
                errorMessage += 'Это может быть из-за: 1) Отсутствия заголовка X-Requested-With, 2) Ошибки сервера, 3) Перенаправления.';
            } else if (error.message.includes('Ошибка:')) {
                errorMessage += error.message;
            } else {
                errorMessage += error.message || 'Неизвестная ошибка';
            }

            alert(errorMessage);
            checkoutBtn.disabled = false;
            checkoutBtn.textContent = originalText;
        });
    });
}