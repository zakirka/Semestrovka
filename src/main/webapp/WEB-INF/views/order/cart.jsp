<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Корзина - Чайхона</title>
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

        .cart-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 30px;
            margin-bottom: 3rem;
        }

        @media (max-width: 768px) {
            .cart-grid {
                grid-template-columns: 1fr;
            }
        }

        .cart-item-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }

        .cart-item-card:hover {
            transform: translateY(-3px);
        }

        .cart-item-content {
            display: grid;
            grid-template-columns: 120px 1fr auto;
            gap: 20px;
            padding: 20px;
            align-items: center;
        }

        @media (max-width: 576px) {
            .cart-item-content {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }

        .cart-item-image {
            width: 120px;
            height: 120px;
            border-radius: 8px;
            overflow: hidden;
            background: #eee;
        }

        .cart-item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .cart-item-image-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #f5deb3 0%, #d2b48c 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #8B4513;
            font-weight: bold;
            font-size: 12px;
            text-align: center;
            padding: 10px;
        }

        .cart-item-info {
            flex: 1;
        }

        .cart-item-name {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        .cart-item-name a {
            color: #333;
            text-decoration: none;
        }

        .cart-item-name a:hover {
            color: #8B4513;
        }

        .cart-item-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 12px;
            line-height: 1.4;
        }

        .cart-item-price {
            font-size: 1.3rem;
            font-weight: bold;
            color: #8B4513;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .quantity-btn {
            width: 36px;
            height: 36px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .quantity-btn:hover {
            background: #f8f9fa;
            border-color: #8B4513;
        }

        .quantity-input {
            width: 60px;
            height: 36px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }

        .quantity-input:focus {
            outline: none;
            border-color: #8B4513;
            box-shadow: 0 0 0 2px rgba(139, 69, 19, 0.1);
        }

        .btn-remove {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background 0.3s;
        }

        .btn-remove:hover {
            background: #c82333;
        }

        .cart-item-total {
            text-align: right;
            min-width: 120px;
        }

        .cart-item-total-price {
            font-size: 1.4rem;
            font-weight: bold;
            color: #333;
        }

        .summary-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 20px;
        }

        @media (max-width: 768px) {
            .summary-card {
                position: static;
            }
        }

        .summary-title {
            font-size: 1.4rem;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
            text-align: center;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .summary-row.total {
            font-weight: bold;
            font-size: 1.2rem;
            color: #333;
            border-bottom: none;
        }

        .summary-divider {
            height: 1px;
            background: #eee;
            margin: 20px 0;
        }

        .summary-notes {
            margin-top: 25px;
        }

        .summary-notes h4 {
            margin-bottom: 12px;
            color: #333;
        }

        .notes-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 0.95rem;
            resize: vertical;
            min-height: 100px;
            margin-bottom: 20px;
        }

        .notes-input:focus {
            outline: none;
            border-color: #8B4513;
            box-shadow: 0 0 0 2px rgba(139, 69, 19, 0.1);
        }

        .btn-checkout {
            width: 100%;
            padding: 15px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
            margin-bottom: 20px;
        }

        .btn-checkout:hover {
            background: #218838;
        }

        .summary-info {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .summary-info p {
            margin-bottom: 8px;
        }

        .cart-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            transition: background 0.3s;
        }

        .btn-secondary:hover {
            background: #5a6268;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .cart-empty {
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

        .cart-empty h2 {
            margin-bottom: 15px;
            color: #333;
        }

        .cart-empty p {
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

        .section-title {
            text-align: center;
            color: #8B4513;
            font-size: 1.8rem;
            margin: 3rem 0 1.5rem;
            position: relative;
        }

        .section-title:after {
            content: '';
            display: block;
            width: 50px;
            height: 3px;
            background: #8B4513;
            margin: 10px auto;
        }

        footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 1rem 0;
            margin-top: 3rem;
        }

        @media (max-width: 768px) {
            .cart-grid {
                grid-template-columns: 1fr;
            }

            .cart-item-content {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .cart-item-image {
                margin: 0 auto;
            }

            .cart-item-total {
                text-align: center;
            }

            .cart-actions {
                flex-direction: column;
                gap: 15px;
            }

            .cart-actions .btn {
                width: 100%;
                text-align: center;
            }
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
                        <a href="${pageContext.request.contextPath}/order/history">История заказов</a>
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
        <h1 class="page-title">Корзина</h1>

        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <div class="cart-empty">
                    <div class="empty-icon">🛒</div>
                    <h2>Требуется авторизация</h2>
                    <p>Для просмотра корзины необходимо войти в систему.</p>
                    <div class="empty-actions">
                        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary">Войти</a>
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-secondary">Регистрация</a>
                    </div>
                </div>
            </c:when>

            <c:when test="${empty currentOrder or empty currentOrder.orderItems or currentOrder.orderItems.size() == 0}">
                <div class="cart-empty">
                    <div class="empty-icon">🛒</div>
                    <h2>Корзина пуста</h2>
                    <p>Добавьте товары из меню, чтобы сделать заказ.</p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">Перейти в меню</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="cart-grid">
                    <div class="cart-items-section">
                        <div class="section-title">
                            Товары в корзине
                            <span style="font-size: 1rem; color: #666; margin-left: 10px;">
                                (${currentOrder.orderItems.size()} товара)
                            </span>
                        </div>

                        <div class="cart-items" id="cart-items">
                            <c:forEach var="orderItem" items="${currentOrder.orderItems}">
                                <div class="cart-item-card" data-item-id="${orderItem.id}">
                                    <div class="cart-item-content">
                                        <div class="cart-item-image">
                                            <c:choose>
                                                <c:when test="${not empty orderItem.menuItem.imageURL}">
                                                    <img src="${pageContext.request.contextPath}${orderItem.menuItem.imageURL}"
                                                         alt="${orderItem.menuItem.name}"
                                                         onerror="showPlaceholder(this, '${orderItem.menuItem.name}')">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="cart-item-image-placeholder">
                                                        ${orderItem.menuItem.name}
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="cart-item-info">
                                            <h3 class="cart-item-name">
                                                <a href="${pageContext.request.contextPath}/menu/item?id=${orderItem.menuItem.id}">
                                                    ${orderItem.menuItem.name}
                                                </a>
                                            </h3>
                                            <p class="cart-item-description">
                                                ${orderItem.menuItem.description}
                                            </p>
                                            <div class="cart-item-price">
                                                <fmt:formatNumber value="${orderItem.unitPrice}" type="currency" currencyCode="RUB" />
                                            </div>
                                        </div>

                                        <div class="cart-item-controls">
                                            <div class="quantity-controls">
                                                <button type="button" class="quantity-btn decrease"
                                                        data-item-id="${orderItem.id}">
                                                    -
                                                </button>
                                                <input type="number" class="quantity-input"
                                                       value="${orderItem.quantity}" min="1" max="99"
                                                       data-item-id="${orderItem.id}">
                                                <button type="button" class="quantity-btn increase"
                                                        data-item-id="${orderItem.id}">
                                                    +
                                                </button>
                                            </div>
                                            <button type="button" class="btn-remove"
                                                    data-item-id="${orderItem.id}">
                                                Удалить
                                            </button>
                                        </div>

                                        <div class="cart-item-total">
                                            <div class="cart-item-total-price">
                                                <fmt:formatNumber value="${orderItem.unitPrice * orderItem.quantity}"
                                                                  type="currency" currencyCode="RUB" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="cart-actions">
                            <a href="${pageContext.request.contextPath}/menu" class="btn-secondary">
                                ← Продолжить покупки
                            </a>
                            <button type="button" class="btn-danger" id="clear-cart-btn">
                                Очистить корзину
                            </button>
                        </div>
                    </div>

                    <div class="summary-section">
                        <div class="summary-card">
                            <h3 class="summary-title">Итоги заказа</h3>

                            <div class="summary-row">
                                <span>Товары (${currentOrder.orderItems.size()} шт.)</span>
                                <span id="subtotal">
                                    <fmt:formatNumber value="${currentOrder.totalAmount}" type="currency" currencyCode="RUB" />
                                </span>
                            </div>

                            <div class="summary-row">
                                <span>Доставка</span>
                                <span>Бесплатно</span>
                            </div>

                            <div class="summary-divider"></div>

                            <div class="summary-row total">
                                <span>Итого к оплате</span>
                                <span id="total-amount">
                                    <fmt:formatNumber value="${currentOrder.totalAmount}" type="currency" currencyCode="RUB" />
                                </span>
                            </div>

                            <div class="summary-notes">
                                <h4>Комментарии к заказу</h4>
                                <textarea id="customer-notes" class="notes-input"
                                          placeholder="Укажите пожелания по заказу, аллергии, время доставки и т.д.">${currentOrder.customerNotes}</textarea>
                            </div>

                            <button type="button" class="btn-checkout" id="checkout-btn">
                                Оформить заказ
                            </button>

                            <div class="summary-info">
                                <p>📞 Для вопросов: +7 (999) 123-45-67</p>
                                <p>⏰ Время доставки: 45-60 минут</p>
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
        window.contextPath = '${pageContext.request.contextPath}';

        // Утилита для placeholder изображений
        function showPlaceholder(img, itemName) {
            const parent = img.parentElement;
            parent.innerHTML = `
                <div class="cart-item-image-placeholder">
                    ${itemName}
                </div>
            `;
        }
    </script>
    <script src="${pageContext.request.contextPath}/js/cart.js"></script>
</body>
</html>