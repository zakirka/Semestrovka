<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${menuItem.name} - Чайхона</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="../includes/header.jsp">
        <jsp:param name="title" value="${menuItem.name}" />
    </jsp:include>

    <main class="main">
        <div class="container">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">Главная</a> &gt;
                <a href="${pageContext.request.contextPath}/menu">Меню</a> &gt;
                <c:if test="${not empty menuItem.category}">
                    <a href="${pageContext.request.contextPath}/menu?category=${menuItem.category.id}">
                        ${menuItem.category.name}
                    </a> &gt;
                </c:if>
                <span>${menuItem.name}</span>
            </div>

            <div class="product-detail">
                <div class="product-gallery">
                    <div class="main-image">
                        <c:choose>
                            <c:when test="${not empty menuItem.imageURL}">
                                <img src="${pageContext.request.contextPath}${menuItem.imageURL}"
                                     alt="${menuItem.name}"
                                     id="main-image"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 100%; height: 400px; background: linear-gradient(135deg, #f5deb3 0%, #d2b48c 100%);
                                            display: flex; align-items: center; justify-content: center; border-radius: 12px;">
                                    <span style="font-size: 2rem; color: #8B4513; font-weight: bold;">${menuItem.name}</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="product-info">
                    <h1 class="product-title">${menuItem.name}</h1>

                    <div class="product-meta">
                        <span class="product-category">
                            <c:if test="${not empty menuItem.category}">
                                Категория: ${menuItem.category.name}
                            </c:if>
                        </span>
                        <span class="product-status ${menuItem.available ? 'available' : 'unavailable'}">
                            ${menuItem.available ? '✓ В наличии' : '✗ Нет в наличии'}
                        </span>
                    </div>

                    <div class="product-price">
                        <span class="price">
                            <fmt:formatNumber value="${menuItem.price}" type="currency" currencyCode="RUB" />
                        </span>
                    </div>

                    <div class="product-description">
                        <h3>Описание</h3>
                        <p>${not empty menuItem.description ? menuItem.description : 'Описание отсутствует.'}</p>
                    </div>

                    <c:if test="${menuItem.available and not empty sessionScope.user}">
                        <div class="product-actions">
                            <form action="${pageContext.request.contextPath}/order/add-item" method="post" class="add-to-cart-form">
                                <input type="hidden" name="menuItemId" value="${menuItem.id}">

                                <div class="quantity-selector">
                                    <label for="quantity">Количество:</label>
                                    <div class="quantity-controls">
                                        <button type="button" class="quantity-btn decrease">-</button>
                                        <input type="number" id="quantity" name="quantity" value="1" min="1" max="10" class="quantity-input">
                                        <button type="button" class="quantity-btn increase">+</button>
                                    </div>
                                </div>

                                <div class="action-buttons">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <span class="btn-icon">🛒</span>
                                        Добавить в корзину
                                    </button>

                                    <button type="button" class="btn btn-secondary btn-lg" onclick="addToCartWithQuantity(${menuItem.id})">
                                        Быстрый заказ
                                    </button>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <c:if test="${empty sessionScope.user}">
                        <div class="login-prompt">
                            <p>Чтобы добавить товар в корзину, необходимо <a href="${pageContext.request.contextPath}/auth/login">войти</a> в систему.</p>
                        </div>
                    </c:if>

                    <div class="product-extra">
                        <div class="nutrition-info">
                            <h3>Пищевая ценность (приблизительно)</h3>
                            <ul>
                                <li>Калории: 250-450 ккал</li>
                                <li>Белки: 15-25 г</li>
                                <li>Жиры: 10-20 г</li>
                                <li>Углеводы: 20-40 г</li>
                            </ul>
                            <p class="note">*Значения могут отличаться в зависимости от конкретного приготовления</p>
                        </div>

                        <div class="preparation-time">
                            <h3>Время приготовления</h3>
                            <p>⏱️ 15-30 минут</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="related-products">
                <h2>Похожие блюда</h2>
                <div class="related-grid">
                    <c:forEach var="relatedItem" items="${relatedItems}" end="3">
                        <div class="related-card">
                            <a href="${pageContext.request.contextPath}/menu/item?id=${relatedItem.id}">
                                <img src="${not empty relatedItem.imageUrl ? relatedItem.imageUrl : '/images/default-food.jpg'}"
                                     alt="${relatedItem.name}">
                                <h4>${relatedItem.name}</h4>
                                <p class="price"><fmt:formatNumber value="${relatedItem.price}" type="currency" currencyCode="RUB" /></p>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../includes/footer.jsp" />

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Quantity controls
        const quantityInput = document.querySelector('.quantity-input');
        const decreaseBtn = document.querySelector('.quantity-btn.decrease');
        const increaseBtn = document.querySelector('.quantity-btn.increase');

        if (decreaseBtn && increaseBtn && quantityInput) {
            decreaseBtn.addEventListener('click', function() {
                let value = parseInt(quantityInput.value);
                if (value > 1) {
                    quantityInput.value = value - 1;
                }
            });

            increaseBtn.addEventListener('click', function() {
                let value = parseInt(quantityInput.value);
                if (value < 10) {
                    quantityInput.value = value + 1;
                }
            });

            quantityInput.addEventListener('change', function() {
                let value = parseInt(this.value);
                if (isNaN(value) || value < 1) {
                    this.value = 1;
                } else if (value > 10) {
                    this.value = 10;
                }
            });
        }

        // Add to cart form submission
        const addToCartForm = document.querySelector('.add-to-cart-form');
        if (addToCartForm) {
            addToCartForm.addEventListener('submit', function(e) {
                e.preventDefault();

                const formData = new FormData(this);
                const quantity = formData.get('quantity');
                const menuItemId = formData.get('menuItemId');

                // AJAX request
                fetch('${pageContext.request.contextPath}/order/add-item?ajax=true', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `menuItemId=${menuItemId}&quantity=${quantity}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('Товар добавлен в корзину!', 'success');
                        // Update cart counter
                        updateCartCounter();
                    } else {
                        showNotification('Ошибка: ' + data.error, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Произошла ошибка', 'error');
                });
            });
        }
    });

    function addToCartWithQuantity(itemId) {
        const quantity = document.getElementById('quantity').value;
        fetch('${pageContext.request.contextPath}/order/add-item?ajax=true', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `menuItemId=${itemId}&quantity=${quantity}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showNotification('Товар добавлен в корзину! Переходим к оформлению...', 'success');
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/order/cart';
                }, 1500);
            } else {
                showNotification('Ошибка: ' + data.error, 'error');
            }
        });
    }

    function updateCartCounter() {
        fetch('${pageContext.request.contextPath}/order/cart-count')
            .then(response => response.json())
            .then(data => {
                const cartBadge = document.querySelector('.cart-badge');
                if (cartBadge) {
                    cartBadge.textContent = data.count;
                    cartBadge.style.display = data.count > 0 ? 'inline' : 'none';
                }
            });
    }

    function showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;

        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            color: white;
            min-width: 300px;
            animation: slideIn 0.3s ease-out;
        `;

        if (type == 'success') {
            notification.style.background = '#28a745';
        } else if (type === 'error') {
            notification.style.background = '#dc3545';
        } else {
            notification.style.background = '#17a2b8';
        }

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-in';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }
    </script>

    <style>
    .breadcrumb {
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 1px solid #eee;
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

    .product-detail {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 3rem;
        margin-bottom: 3rem;
    }

    .product-gallery {
        position: relative;
    }

    .main-image img {
        width: 100%;
        height: 400px;
        object-fit: cover;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }

    .product-info {
        padding: 1rem;
    }

    .product-title {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        color: #333;
    }

    .product-meta {
        display: flex;
        gap: 2rem;
        margin-bottom: 1.5rem;
        color: #666;
    }

    .product-status.available {
        color: #28a745;
        font-weight: bold;
    }

    .product-status.unavailable {
        color: #dc3545;
        font-weight: bold;
    }

    .product-price {
        margin-bottom: 2rem;
    }

    .product-price .price {
        font-size: 2rem;
        font-weight: bold;
        color: #8B4513;
    }

    .product-description {
        margin-bottom: 2rem;
        line-height: 1.6;
    }

    .product-description h3 {
        margin-bottom: 1rem;
        color: #333;
    }

    .quantity-selector {
        margin-bottom: 2rem;
    }

    .quantity-selector label {
        display: block;
        margin-bottom: 0.5rem;
        font-weight: bold;
    }

    .quantity-controls {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        max-width: 150px;
    }

    .quantity-btn {
        width: 40px;
        height: 40px;
        border: 1px solid #ddd;
        background: white;
        border-radius: 4px;
        cursor: pointer;
        font-size: 1.2rem;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .quantity-btn:hover {
        background: #f8f9fa;
    }

    .quantity-input {
        width: 60px;
        height: 40px;
        text-align: center;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 1rem;
    }

    .action-buttons {
        display: flex;
        gap: 1rem;
        margin-bottom: 2rem;
    }

    .btn-lg {
        padding: 1rem 2rem;
        font-size: 1.1rem;
    }

    .btn-icon {
        margin-right: 0.5rem;
    }

    .login-prompt {
        background: #f8f9fa;
        padding: 1.5rem;
        border-radius: 8px;
        margin-bottom: 2rem;
        border-left: 4px solid #8B4513;
    }

    .login-prompt a {
        color: #8B4513;
        font-weight: bold;
        text-decoration: none;
    }

    .login-prompt a:hover {
        text-decoration: underline;
    }

    .product-extra {
        background: #f8f9fa;
        padding: 2rem;
        border-radius: 12px;
        margin-top: 2rem;
    }

    .nutrition-info h3,
    .preparation-time h3 {
        margin-bottom: 1rem;
        color: #333;
    }

    .nutrition-info ul {
        list-style: none;
        padding: 0;
        margin-bottom: 1rem;
    }

    .nutrition-info li {
        padding: 0.5rem 0;
        border-bottom: 1px solid #eee;
    }

    .note {
        font-size: 0.875rem;
        color: #666;
        font-style: italic;
    }

    .related-products {
        margin-top: 4rem;
        padding-top: 3rem;
        border-top: 1px solid #eee;
    }

    .related-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 2rem;
        margin-top: 2rem;
    }

    .related-card {
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        transition: transform 0.3s;
    }

    .related-card:hover {
        transform: translateY(-5px);
    }

    .related-card img {
        width: 100%;
        height: 200px;
        object-fit: cover;
    }

    .related-card h4 {
        padding: 1rem;
        margin: 0;
        color: #333;
    }

    .related-card .price {
        padding: 0 1rem 1rem;
        color: #28a745;
        font-weight: bold;
    }

    .related-card a {
        text-decoration: none;
        color: inherit;
        display: block;
    }

    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }

    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }

    @media (max-width: 768px) {
        .product-detail {
            grid-template-columns: 1fr;
            gap: 2rem;
        }

        .product-title {
            font-size: 2rem;
        }

        .action-buttons {
            flex-direction: column;
        }

        .btn-lg {
            width: 100%;
        }

        .main-image img {
            height: 300px;
        }

        .related-grid {
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        }
    }

    @media (max-width: 480px) {
        .product-meta {
            flex-direction: column;
            gap: 0.5rem;
        }

        .related-grid {
            grid-template-columns: 1fr;
        }
    }
    </style>
</body>
</html>