<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>История заказов - Чайхона</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="../includes/header.jsp">
        <jsp:param name="title" value="История заказов" />
    </jsp:include>

    <main class="main">
        <div class="container">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">Главная</a> &gt;
                <span>История заказов</span>
            </div>

            <h1 class="page-title">История заказов</h1>

            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <div class="orders-empty">
                        <div class="empty-icon">📋</div>
                        <h2>Требуется авторизация</h2>
                        <p>Для просмотра истории заказов необходимо войти в систему.</p>
                        <div class="empty-actions">
                            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary">Войти</a>
                            <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-secondary">Регистрация</a>
                        </div>
                    </div>
                </c:when>

                <c:when test="${empty orders or orders.size() == 0}">
                    <div class="orders-empty">
                        <div class="empty-icon">📋</div>
                        <h2>Заказов нет</h2>
                        <p>Вы еще не сделали ни одного заказа.</p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">Сделать первый заказ</a>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="orders-container">
                        <div class="orders-filter">
                            <div class="filter-options">
                                <button class="filter-btn active" data-status="">Все заказы</button>
                                <button class="filter-btn" data-status="PENDING">Ожидание</button>
                                <button class="filter-btn" data-status="CONFIRMED">Подтверждены</button>
                                <button class="filter-btn" data-status="PREPARING">Готовятся</button>
                                <button class="filter-btn" data-status="READY">Готовы</button>
                                <button class="filter-btn" data-status="COMPLETED">Завершены</button>
                            </div>

                            <div class="search-box">
                                <input type="text" id="order-search" placeholder="Поиск по номеру заказа..."
                                       class="search-input">
                                <button class="search-btn">🔍</button>
                            </div>
                        </div>

                        <div class="orders-list" id="orders-list">
                            <c:forEach var="order" items="${orders}">
                                <div class="order-card" data-status="${order.status}" data-id="${order.id}">
                                    <div class="order-header">
                                        <div class="order-info">
                                            <h3 class="order-number">Заказ #${order.id}</h3>
                                            <div class="order-date">
                                                <!-- Просто выводим дату как строку, без форматирования -->
                                                ${order.createdAt}
                                            </div>
                                        </div>

                                        <div class="order-status status-${order.status.name().toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${order.status == 'PENDING'}">⏳ Ожидание</c:when>
                                                <c:when test="${order.status == 'CONFIRMED'}">✅ Подтвержден</c:when>
                                                <c:when test="${order.status == 'PREPARING'}">👨‍🍳 Готовится</c:when>
                                                <c:when test="${order.status == 'READY'}">🎉 Готов</c:when>
                                                <c:when test="${order.status == 'COMPLETED'}">🏁 Завершен</c:when>
                                                <c:when test="${order.status == 'CANCELLED'}">❌ Отменен</c:when>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="order-items">
                                        <!-- Отображаем все элементы заказа -->
                                        <c:forEach var="orderItem" items="${order.orderItems}">
                                            <div class="order-item">
                                                <span class="item-name">${orderItem.menuItem.name}</span>
                                                <span class="item-quantity">× ${orderItem.quantity}</span>
                                                <span class="item-price">
                                                    <fmt:formatNumber value="${orderItem.unitPrice * orderItem.quantity}"
                                                                      type="currency" currencyCode="RUB" />
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <div class="order-footer">
                                        <div class="order-total">
                                            <span>Итого:</span>
                                            <span class="total-amount">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="RUB" />
                                            </span>
                                        </div>

                                        <div class="order-actions">
                                            <a href="${pageContext.request.contextPath}/order/details?id=${order.id}"
                                               class="btn btn-secondary btn-sm">Подробнее</a>
                                            <c:if test="${order.status == 'PENDING'}">
                                                <button type="button" class="btn btn-danger btn-sm"
                                                        onclick="cancelOrder(${order.id})">
                                                    Отменить
                                                </button>
                                            </c:if>
                                            <c:if test="${order.status == 'READY'}">
                                                <button type="button" class="btn btn-success btn-sm"
                                                        onclick="completeOrder(${order.id})">
                                                    Получен
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>

                                    <c:if test="${not empty order.customerNotes}">
                                        <div class="order-notes">
                                            <strong>Комментарий:</strong> ${order.customerNotes}
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="orders-stats">
                            <div class="stat-card">
                                <h3>Статистика заказов</h3>
                                <div class="stats-grid">
                                    <div class="stat-item">
                                        <span class="stat-label">Всего заказов</span>
                                        <span class="stat-value">${orders.size()}</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-label">На сумму</span>
                                        <span class="stat-value">
                                            <fmt:formatNumber value="${totalOrdersAmount}" type="currency" currencyCode="RUB" />
                                        </span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-label">Активные</span>
                                        <span class="stat-value">
                                            <c:set var="activeCount" value="0" />
                                            <c:forEach var="order" items="${orders}">
                                                <c:if test="${order.status != 'COMPLETED' and order.status != 'CANCELLED'}">
                                                    <c:set var="activeCount" value="${activeCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${activeCount}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="../includes/footer.jsp" />

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        initOrdersFilter();
        initOrderSearch();
    });

    function initOrdersFilter() {
        const filterBtns = document.querySelectorAll('.filter-btn');
        const orderCards = document.querySelectorAll('.order-card');

        filterBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                // Убираем активный класс у всех кнопок
                filterBtns.forEach(b => b.classList.remove('active'));
                // Добавляем активный класс текущей кнопке
                this.classList.add('active');

                const status = this.dataset.status;

                // Фильтруем заказы
                orderCards.forEach(card => {
                    if (status === '' || card.dataset.status === status) {
                        card.style.display = 'block';
                        setTimeout(() => {
                            card.style.opacity = '1';
                            card.style.transform = 'translateY(0)';
                        }, 10);
                    } else {
                        card.style.opacity = '0';
                        card.style.transform = 'translateY(-10px)';
                        setTimeout(() => {
                            card.style.display = 'none';
                        }, 300);
                    }
                });
            });
        });
    }

    function initOrderSearch() {
        const searchInput = document.getElementById('order-search');
        const orderCards = document.querySelectorAll('.order-card');

        if (searchInput) {
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase().trim();

                orderCards.forEach(card => {
                    const orderId = card.dataset.id;
                    const matches = orderId.toString().includes(searchTerm);

                    if (searchTerm === '' || matches) {
                        card.style.display = 'block';
                        setTimeout(() => {
                            card.style.opacity = '1';
                            card.style.transform = 'translateY(0)';
                        }, 10);
                    } else {
                        card.style.opacity = '0';
                        card.style.transform = 'translateY(-10px)';
                        setTimeout(() => {
                            card.style.display = 'none';
                        }, 300);
                    }
                });
            });
        }
    }

    function cancelOrder(orderId) {
        if (!confirm('Вы уверены, что хотите отменить заказ?')) return;

        fetch('${pageContext.request.contextPath}/order/cancel', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: 'orderId=' + orderId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showNotification('Заказ отменен', 'success');
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                showNotification(data.error || 'Ошибка отмены заказа', 'error');
            }
        })
        .catch(error => {
            showNotification('Ошибка соединения', 'error');
        });
    }

    function completeOrder(orderId) {
        fetch('${pageContext.request.contextPath}/order/complete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: 'orderId=' + orderId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showNotification('Заказ отмечен как полученный', 'success');
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                showNotification(data.error || 'Ошибка', 'error');
            }
        })
        .catch(error => {
            showNotification('Ошибка соединения', 'error');
        });
    }

    function showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = 'notification notification-' + type;
        notification.textContent = message;

        // Определяем цвет на основе типа
        let backgroundColor;
        switch(type) {
            case 'success':
                backgroundColor = '#28a745';
                break;
            case 'error':
                backgroundColor = '#dc3545';
                break;
            case 'warning':
                backgroundColor = '#ffc107';
                break;
            default:
                backgroundColor = '#17a2b8';
        }

        notification.style.cssText =
            'position: fixed;' +
            'top: 20px;' +
            'right: 20px;' +
            'z-index: 1000;' +
            'padding: 1rem 1.5rem;' +
            'border-radius: 8px;' +
            'color: white;' +
            'min-width: 300px;' +
            'animation: slideIn 0.3s ease-out;' +
            'background: ' + backgroundColor + ';' +
            'box-shadow: 0 4px 12px rgba(0,0,0,0.15);';

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-in';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

    // Глобальная переменная для контекстного пути
    const contextPath = '${pageContext.request.contextPath}';

    // Анимации
    const style = document.createElement('style');
    style.textContent =
        '@keyframes slideIn {' +
        '    from { transform: translateX(100%); opacity: 0; }' +
        '    to { transform: translateX(0); opacity: 1; }' +
        '}' +
        '@keyframes slideOut {' +
        '    from { transform: translateX(0); opacity: 1; }' +
        '    to { transform: translateX(100%); opacity: 0; }' +
        '}';
    document.head.appendChild(style);
    </script>

    <style>
    /* Breadcrumb */
    .breadcrumb {
        margin-bottom: 1.5rem;
        padding-bottom: 1rem;
        border-bottom: 1px solid #eee;
        font-size: 0.9rem;
    }

    .breadcrumb a {
        color: #8B4513;
        text-decoration: none;
    }

    .breadcrumb a:hover {
        text-decoration: underline;
    }

    .breadcrumb span {
        color: #666;
    }

    /* Page Title */
    .page-title {
        font-size: 2rem;
        color: #333;
        margin-bottom: 2rem;
    }

    /* Empty Orders */
    .orders-empty {
        text-align: center;
        padding: 4rem 2rem;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 15px rgba(0,0,0,0.08);
    }

    .orders-empty .empty-icon {
        font-size: 4rem;
        margin-bottom: 1.5rem;
        opacity: 0.7;
    }

    .orders-empty h2 {
        color: #333;
        margin-bottom: 1rem;
    }

    .orders-empty p {
        color: #666;
        margin-bottom: 2rem;
        max-width: 400px;
        margin-left: auto;
        margin-right: auto;
    }

    .empty-actions {
        display: flex;
        gap: 1rem;
        justify-content: center;
    }

    /* Orders Container */
    .orders-container {
        margin-top: 2rem;
    }

    /* Orders Filter */
    .orders-filter {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        padding: 1.5rem;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }

    .filter-options {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .filter-btn {
        padding: 0.5rem 1rem;
        border: 1px solid #ddd;
        background: white;
        border-radius: 20px;
        cursor: pointer;
        font-size: 0.9rem;
        transition: all 0.2s;
    }

    .filter-btn:hover {
        border-color: #8B4513;
        color: #8B4513;
    }

    .filter-btn.active {
        background: #8B4513;
        color: white;
        border-color: #8B4513;
    }

    .search-box {
        display: flex;
        gap: 0.5rem;
    }

    .search-input {
        padding: 0.5rem 1rem;
        border: 1px solid #ddd;
        border-radius: 20px;
        width: 200px;
        font-size: 0.9rem;
    }

    .search-input:focus {
        outline: none;
        border-color: #8B4513;
        box-shadow: 0 0 0 2px rgba(139, 69, 19, 0.1);
    }

    .search-btn {
        background: #8B4513;
        color: white;
        border: none;
        border-radius: 20px;
        padding: 0.5rem 1rem;
        cursor: pointer;
    }

    /* Orders List */
    .orders-list {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    /* Order Card */
    .order-card {
        background: white;
        border-radius: 12px;
        padding: 1.5rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        border-left: 4px solid #8B4513;
        transition: all 0.3s ease;
    }

    .order-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
        padding-bottom: 1rem;
        border-bottom: 1px solid #eee;
    }

    .order-info h3 {
        margin: 0 0 0.5rem 0;
        color: #333;
    }

    .order-date {
        color: #666;
        font-size: 0.9rem;
    }

    .order-status {
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-size: 0.875rem;
        font-weight: 500;
    }

    .status-pending { background: #fff3cd; color: #856404; }
    .status-confirmed { background: #d1ecf1; color: #0c5460; }
    .status-preparing { background: #cce5ff; color: #004085; }
    .status-ready { background: #d4edda; color: #155724; }
    .status-completed { background: #e2e3e5; color: #383d41; }
    .status-cancelled { background: #f8d7da; color: #721c24; }

    /* Order Items */
    .order-items {
        margin-bottom: 1.5rem;
        max-height: 300px;
        overflow-y: auto;
        padding-right: 10px;
    }

    .order-items::-webkit-scrollbar {
        width: 5px;
    }

    .order-items::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }

    .order-items::-webkit-scrollbar-thumb {
        background: #8B4513;
        border-radius: 10px;
    }

    .order-item {
        display: flex;
        justify-content: space-between;
        padding: 0.5rem 0;
        border-bottom: 1px dashed #eee;
    }

    .order-item:last-child {
        border-bottom: none;
    }

    .item-name {
        flex: 1;
    }

    .item-quantity {
        margin: 0 1rem;
        color: #666;
    }

    .item-price {
        font-weight: 500;
        color: #333;
        min-width: 80px;
        text-align: right;
    }

    .more-items {
        text-align: center;
        color: #666;
        font-size: 0.9rem;
        margin-top: 0.5rem;
        padding-top: 0.5rem;
        border-top: 1px dashed #eee;
    }

    /* Order Footer */
    .order-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 1.5rem;
        padding-top: 1.5rem;
        border-top: 1px solid #eee;
    }

    .order-total {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .order-total span:first-child {
        font-weight: 500;
        color: #666;
    }

    .total-amount {
        font-size: 1.2rem;
        font-weight: bold;
        color: #8B4513;
    }

    .order-actions {
        display: flex;
        gap: 0.5rem;
    }

    .btn-sm {
        padding: 0.5rem 1rem;
        font-size: 0.875rem;
    }

    /* Order Notes */
    .order-notes {
        margin-top: 1rem;
        padding: 1rem;
        background: #f8f9fa;
        border-radius: 8px;
        color: #666;
        font-size: 0.9rem;
        border-left: 3px solid #8B4513;
    }

    /* Orders Stats */
    .orders-stats {
        margin-top: 3rem;
    }

    .stat-card {
        background: white;
        border-radius: 12px;
        padding: 2rem;
        box-shadow: 0 2px 15px rgba(0,0,0,0.08);
    }

    .stat-card h3 {
        margin: 0 0 1.5rem 0;
        color: #333;
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
    }

    .stat-item {
        text-align: center;
        padding: 1.5rem;
        background: #f8f9fa;
        border-radius: 8px;
    }

    .stat-label {
        display: block;
        color: #666;
        font-size: 0.9rem;
        margin-bottom: 0.5rem;
    }

    .stat-value {
        display: block;
        font-size: 1.5rem;
        font-weight: bold;
        color: #8B4513;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .orders-filter {
            flex-direction: column;
            gap: 1rem;
            align-items: stretch;
        }

        .filter-options {
            justify-content: center;
        }

        .search-box {
            justify-content: center;
        }

        .order-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
        }

        .order-footer {
            flex-direction: column;
            gap: 1rem;
            align-items: stretch;
        }

        .order-actions {
            justify-content: center;
        }

        .empty-actions {
            flex-direction: column;
        }

        .empty-actions .btn {
            width: 100%;
        }
    }

    @media (max-width: 480px) {
        .filter-options {
            gap: 0.25rem;
        }

        .filter-btn {
            padding: 0.4rem 0.8rem;
            font-size: 0.8rem;
        }

        .search-input {
            width: 150px;
        }

        .order-item {
            flex-direction: column;
            gap: 0.25rem;
        }

        .item-quantity,
        .item-price {
            margin-left: 1rem;
            text-align: left;
        }
    }
    </style>
</body>
</html>