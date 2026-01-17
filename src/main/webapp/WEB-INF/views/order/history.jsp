<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>История заказов - Чайхона</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }

        body {
            background: #f8f5f0;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            background: #8B4513;
            color: white;
            padding: 1rem 0;
            margin-bottom: 2rem;
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin-left: 1rem;
        }

        nav a:hover {
            text-decoration: underline;
        }

        .page-title {
            text-align: center;
            margin-bottom: 2rem;
            color: #8B4513;
            font-size: 2rem;
        }

        .hero-section {
            background: linear-gradient(rgba(139, 69, 19, 0.8), rgba(139, 69, 19, 0.8)),
                        url('${pageContext.request.contextPath}/images/hero-bg.jpg');
            background-size: cover;
            background-position: center;
            color: white;
            text-align: center;
            padding: 80px 20px;
            border-radius: 10px;
            margin-bottom: 3rem;
        }

        .hero-title {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .hero-subtitle {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: white;
            color: #8B4513;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: all 0.3s;
            border: 2px solid white;
        }

        .btn:hover {
            background: transparent;
            color: white;
        }

        .orders-empty {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .empty-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #8B4513;
        }

        .orders-empty h2 {
            margin-bottom: 15px;
            color: #333;
        }

        .orders-empty p {
            color: #666;
            margin-bottom: 30px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        .empty-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        @media (max-width: 576px) {
            .empty-actions {
                flex-direction: column;
                align-items: center;
            }
        }

        .btn-primary {
            background: #8B4513;
            color: white;
            text-decoration: none;
            padding: 12px 30px;
            border-radius: 5px;
            font-weight: bold;
            transition: background 0.3s;
        }

        .btn-primary:hover {
            background: #a0522d;
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            text-decoration: none;
            padding: 12px 30px;
            border-radius: 5px;
            font-weight: bold;
            transition: background 0.3s;
        }

        .btn-secondary:hover {
            background: #5a6268;
            color: white;
        }

        .orders-filter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        @media (max-width: 768px) {
            .orders-filter {
                flex-direction: column;
                gap: 20px;
            }
        }

        .filter-options {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .filter-btn {
            padding: 8px 16px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s;
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
            gap: 10px;
        }

        .search-input {
            padding: 8px 16px;
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
            padding: 8px 16px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .search-btn:hover {
            background: #a0522d;
        }

        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 30px;
        }

        .order-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            border-left: 4px solid #8B4513;
        }

        .order-card:hover {
            transform: translateY(-3px);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        @media (max-width: 576px) {
            .order-header {
                flex-direction: column;
                gap: 15px;
            }
        }

        .order-info h3 {
            margin: 0 0 8px 0;
            font-size: 1.3rem;
            color: #333;
        }

        .order-date {
            color: #666;
            font-size: 0.9rem;
        }

        .order-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            white-space: nowrap;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-preparing {
            background: #cce5ff;
            color: #004085;
        }

        .status-ready {
            background: #d4edda;
            color: #155724;
        }

        .status-completed {
            background: #e2e3e5;
            color: #383d41;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .order-items {
            margin-bottom: 20px;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed #eee;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-name {
            flex: 1;
            color: #333;
        }

        .item-quantity {
            margin: 0 15px;
            color: #666;
        }

        .item-price {
            font-weight: 500;
            color: #333;
            min-width: 100px;
            text-align: right;
        }

        .more-items {
            text-align: center;
            color: #666;
            font-size: 0.9rem;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px dashed #eee;
        }

        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        @media (max-width: 576px) {
            .order-footer {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
        }

        .order-total {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .order-total span:first-child {
            font-weight: 500;
            color: #666;
        }

        .total-amount {
            font-size: 1.3rem;
            font-weight: bold;
            color: #8B4513;
        }

        .order-actions {
            display: flex;
            gap: 10px;
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 0.85rem;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
        }

        .btn-secondary-sm {
            background: #6c757d;
            color: white;
        }

        .btn-secondary-sm:hover {
            background: #5a6268;
        }

        .btn-danger-sm {
            background: #dc3545;
            color: white;
        }

        .btn-danger-sm:hover {
            background: #c82333;
        }

        .btn-success-sm {
            background: #28a745;
            color: white;
        }

        .btn-success-sm:hover {
            background: #218838;
        }

        .order-notes {
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            color: #666;
            font-size: 0.9rem;
            border-left: 3px solid #8B4513;
        }

        .orders-stats {
            margin-top: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .stat-card h3 {
            margin: 0 0 20px 0;
            color: #333;
            font-size: 1.4rem;
            text-align: center;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-item {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .stat-label {
            display: block;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 10px;
        }

        .stat-value {
            display: block;
            font-size: 1.5rem;
            font-weight: bold;
            color: #8B4513;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            padding: 15px 25px;
            border-radius: 8px;
            color: white;
            min-width: 300px;
            max-width: 400px;
            animation: slideIn 0.3s ease-out;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .notification-success {
            background: #28a745;
        }

        .notification-error {
            background: #dc3545;
        }

        .notification-warning {
            background: #ffc107;
            color: #333;
        }

        .notification-info {
            background: #17a2b8;
        }

        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }

        footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 1rem 0;
            margin-top: 3rem;
        }

        @media (max-width: 768px) {
            .filter-options {
                justify-content: center;
            }

            .search-box {
                width: 100%;
                justify-content: center;
            }

            .search-input {
                width: 100%;
            }

            .order-actions {
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .filter-options {
                gap: 5px;
            }

            .filter-btn {
                padding: 6px 12px;
                font-size: 0.8rem;
            }

            .order-item {
                flex-direction: column;
                gap: 5px;
                text-align: center;
            }

            .item-quantity,
            .item-price {
                margin: 0;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="header-content">
            <div class="logo">🍵 Чайхона</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Главная</a>
                <a href="${pageContext.request.contextPath}/menu">Меню</a>
                <a href="${pageContext.request.contextPath}/order/cart">Корзина</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/order/history" style="font-weight: bold; background: rgba(255,255,255,0.2); padding: 5px 10px; border-radius: 4px;">История заказов</a>
                        <a href="${pageContext.request.contextPath}/auth/logout">Выйти</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth/login">Войти</a>
                        <a href="${pageContext.request.contextPath}/auth/register">Регистрация</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>

    <main class="container">
        <h1 class="page-title">История заказов</h1>

        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <div class="orders-empty">
                    <div class="empty-icon">📋</div>
                    <h2>Требуется авторизация</h2>
                    <p>Для просмотра истории заказов необходимо войти в систему.</p>
                    <div class="empty-actions">
                        <a href="${pageContext.request.contextPath}/auth/login" class="btn-primary">Войти</a>
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn-secondary">Регистрация</a>
                    </div>
                </div>
            </c:when>

            <c:when test="${empty orders or orders.size() == 0}">
                <div class="orders-empty">
                    <div class="empty-icon">📋</div>
                    <h2>Заказов нет</h2>
                    <p>Вы еще не сделали ни одного заказа.</p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn-primary">Сделать первый заказ</a>
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
                                    <c:forEach var="orderItem" items="${order.orderItems}" end="2">
                                        <div class="order-item">
                                            <span class="item-name">${orderItem.menuItem.name}</span>
                                            <span class="item-quantity">× ${orderItem.quantity}</span>
                                            <span class="item-price">
                                                <fmt:formatNumber value="${orderItem.unitPrice * orderItem.quantity}"
                                                                  type="currency" currencyCode="RUB" />
                                            </span>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${order.orderItems.size() > 3}">
                                        <div class="more-items">
                                            и еще ${order.orderItems.size() - 3} товаров
                                        </div>
                                    </c:if>
                                </div>

                                <div class="order-footer">
                                    <div class="order-total">
                                        <span>Итого:</span>
                                        <span class="total-amount">
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="RUB" />
                                        </span>
                                    </div>

                                    <div class="order-actions">

                                        <c:if test="${order.status == 'PENDING'}">
                                            <button type="button" class="btn-sm btn-danger-sm"
                                                    onclick="cancelOrder(${order.id})">
                                                Отменить
                                            </button>
                                        </c:if>
                                        <c:if test="${order.status == 'READY'}">
                                            <button type="button" class="btn-sm btn-success-sm"
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
                                        ${orders.stream().filter(o -> o.status != 'COMPLETED' && o.status != 'CANCELLED').count()}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <footer>
        <div class="container">
            <p>© 2024 Чайхона. Все права защищены.</p>
            <p>Телефон: +7 (XXX) XXX-XX-XX | Адрес: ул. Восточная, д. 15</p>
        </div>
    </footer>

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
                filterBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');

                const status = this.dataset.status;

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

        fetch(`${contextPath}/order/cancel`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `orderId=${orderId}`
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
            console.error('Error:', error);
            showNotification('Ошибка отмены заказа', 'error');
        });
    }

    function completeOrder(orderId) {
        fetch(`${contextPath}/order/complete`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `orderId=${orderId}`
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
            console.error('Error:', error);
            showNotification('Ошибка', 'error');
        });
    }

    function showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;

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

        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            padding: 15px 25px;
            border-radius: 8px;
            color: white;
            min-width: 300px;
            animation: slideIn 0.3s ease-out;
            background: ${backgroundColor};
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        `;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-in';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

    const contextPath = '${pageContext.request.contextPath}';

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
    </script>
</body>
</html>