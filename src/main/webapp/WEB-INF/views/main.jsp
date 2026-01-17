<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Главная - Чайхона</title>
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

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 3rem;
        }

        .menu-item-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .menu-item-card:hover {
            transform: translateY(-5px);
        }

        .menu-item-image {
            width: 100%;
            height: 180px;
            background: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 14px;
        }

        .menu-item-content {
            padding: 20px;
        }

        .menu-item-name {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        .menu-item-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 12px;
            line-height: 1.4;
        }

        .menu-item-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .menu-item-price {
            font-size: 1.3rem;
            font-weight: bold;
            color: #8B4513;
        }

        .add-to-cart-btn {
            background: #8B4513;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .add-to-cart-btn:hover {
            background: #a0522d;
        }

        .category-badge {
            display: inline-block;
            background: #f0e6dc;
            color: #8B4513;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8rem;
            margin-bottom: 10px;
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

        .user-greeting {
            text-align: center;
            background: #f0e6dc;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 2rem;
            border-left: 4px solid #8B4513;
        }

        .user-name {
            color: #8B4513;
            font-weight: bold;
        }

        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 3rem;
        }

        .category-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: all 0.3s;
            cursor: pointer;
            border: 2px solid transparent;
        }

        .category-card:hover {
            border-color: #8B4513;
            transform: translateY(-3px);
        }

        .category-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #8B4513;
        }

        .category-name {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .category-count {
            color: #888;
            font-size: 0.9rem;
        }

        footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 1rem 0;
            margin-top: 3rem;
        }

        @media (max-width: 768px) {
            .menu-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }

            .header-content {
                flex-direction: column;
                gap: 10px;
            }

            nav a {
                margin: 0 8px;
            }

            .hero-title {
                font-size: 2rem;
            }

            .hero-subtitle {
                font-size: 1rem;
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
                        <a href="${pageContext.request.contextPath}/profile">Профиль</a>
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
        <!-- Приветствие -->
        <c:if test="${not empty sessionScope.user}">
            <div class="user-greeting">
                Добро пожаловать, <span class="user-name">${sessionScope.user.username}</span>!
            </div>
        </c:if>

        <!-- Герой секция -->
        <section class="hero-section">
            <h1 class="hero-title">Добро пожаловать в Чайхону</h1>
            <p class="hero-subtitle">Насладитесь настоящей восточной кухней в уютной атмосфере. Свежие самсы, ароматные пловы и вкуснейшие шашлыки.</p>
            <a href="${pageContext.request.contextPath}/menu" class="btn">Смотреть меню</a>
        </section>

        <!-- Популярные блюда -->
        <h2 class="section-title">Популярные блюда</h2>
        <div class="menu-grid" id="popular-items">
            <c:forEach var="item" items="${popularItems}">
                <div class="menu-item-card">
                    <div class="menu-item-image">
                        <c:choose>
                            <c:when test="${not empty item.imageUrl}">
                                <img src="${pageContext.request.contextPath}${item.imageUrl}"
                                     alt="${item.name}"
                                     style="width: 100%; height: 100%; object-fit: cover;"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 100%; height: 100%; background: linear-gradient(135deg, #f5deb3 0%, #d2b48c 100%);
                                            display: flex; align-items: center; justify-content: center; color: #8B4513; font-weight: bold;">
                                    ${item.name}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="menu-item-content">
                        <h3 class="menu-item-name">${item.name}</h3>

                        <p class="menu-item-description">
                            <c:choose>
                                <c:when test="${not empty item.description}">
                                    ${item.description}
                                </c:when>
                                <c:otherwise>
                                    Вкусное блюдо восточной кухни
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="menu-item-footer">
                            <span class="menu-item-price">
                                <fmt:formatNumber value="${item.price}" type="currency" currencyCode="RUB"/>
                            </span>

                            <form action="${pageContext.request.contextPath}/order/add-item" method="post" style="margin: 0;">
                                <input type="hidden" name="itemId" value="${item.id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="add-to-cart-btn">
                                    В корзину
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Доступные блюда -->
        <h2 class="section-title">Доступные блюда</h2>
        <div class="menu-grid" id="available-items">
            <c:forEach var="item" items="${availableItems}" begin="0" end="7">
                <div class="menu-item-card">
                    <div class="menu-item-image">
                        <c:choose>
                            <c:when test="${not empty item.imageUrl}">
                                <img src="${pageContext.request.contextPath}${item.imageUrl}"
                                     alt="${item.name}"
                                     style="width: 100%; height: 100%; object-fit: cover;"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 100%; height: 100%; background: linear-gradient(135deg, #f5deb3 0%, #d2b48c 100%);
                                            display: flex; align-items: center; justify-content: center; color: #8B4513; font-weight: bold;">
                                    ${item.name}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="menu-item-content">
                        <h3 class="menu-item-name">${item.name}</h3>

                        <p class="menu-item-description">
                            <c:choose>
                                <c:when test="${not empty item.description}">
                                    ${item.description}
                                </c:when>
                                <c:otherwise>
                                    Вкусное блюдо восточной кухни
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="menu-item-footer">
                            <span class="menu-item-price">
                                <fmt:formatNumber value="${item.price}" type="currency" currencyCode="RUB"/>
                            </span>

                            <form action="${pageContext.request.contextPath}/order/add-item" method="post" style="margin: 0;">
                                <input type="hidden" name="itemId" value="${item.id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="add-to-cart-btn">
                                    В корзину
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Кнопка "Показать всё меню" -->
        <div style="text-align: center; margin: 2rem 0;">
            <a href="${pageContext.request.contextPath}/menu" class="btn" style="background: #8B4513; color: white; border: none;">
                Показать всё меню
            </a>
        </div>

        <!-- Сообщение если нет данных -->
        <c:if test="${empty popularItems and empty availableItems}">
            <div style="text-align: center; padding: 50px 20px;">
                <h2 style="color: #666; margin-bottom: 20px;">Меню временно пусто</h2>
                <p style="color: #888;">Мы обновляем наше меню. Загляните позже!</p>
            </div>
        </c:if>
    </main>

    <footer>
        <div class="container">
            <p>© 2024 Чайхона. Все права защищены.</p>
            <p>Телефон: +7 (XXX) XXX-XX-XX | Адрес: ул. Восточная, д. 15</p>
        </div>
    </footer>

    <script>
    // Анимация карточек при загрузке
    document.addEventListener('DOMContentLoaded', function() {
        const menuItems = document.querySelectorAll('.menu-item-card');

        menuItems.forEach((item, index) => {
            item.style.opacity = '0';
            item.style.transform = 'translateY(20px)';
            item.style.transition = 'opacity 0.5s, transform 0.5s';

            setTimeout(() => {
                item.style.opacity = '1';
                item.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });
    </script>
</body>
</html>