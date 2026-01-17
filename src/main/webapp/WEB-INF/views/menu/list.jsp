<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Меню - Чайхона</title>
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

        .category-filter {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .category-btn {
            padding: 8px 16px;
            background: white;
            border: 2px solid #8B4513;
            border-radius: 20px;
            color: #8B4513;
            cursor: pointer;
            transition: all 0.3s;
        }

        .category-btn:hover,
        .category-btn.active {
            background: #8B4513;
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
                <a href="${pageContext.request.contextPath}/profile">Профиль</a>
            </nav>
        </div>
    </header>

    <main class="container">
        <h1 class="page-title">Наше меню</h1>

        <!-- Сообщение об ошибке -->
        <c:if test="${not empty sessionScope.error}">
            <div style="background: #f8d7da; color: #721c24; padding: 15px; margin: 15px 0; border-radius: 5px;">
                ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Фильтры по категориям -->
        <div class="category-filter">
            <button class="category-btn active" data-category="all">Все</button>
            <c:forEach var="category" items="${categories}">
                <button class="category-btn" data-category="${category.id}">
                    ${category.name}
                </button>
            </c:forEach>
        </div>

        <!-- Сетка блюд -->
        <div class="menu-grid" id="menu-items">
            <c:forEach var="item" items="${menuItems}">
                <div class="menu-item-card" data-category="${item.categoryId}">
                    <div class="menu-item-image">
                        <c:choose>
                            <c:when test="${not empty item.imageURL}">
                                <!-- Используем imageURL из модели -->
                                <img src="${pageContext.request.contextPath}${item.imageURL}"
                                     alt="${item.name}"
                                     style="width: 100%; height: 100%; object-fit: cover;"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'">
                            </c:when>
                            <c:otherwise>
                                <!-- Если изображения нет, показываем заглушку с названием -->
                                <div style="width: 100%; height: 100%; background: linear-gradient(135deg, #f5deb3 0%, #d2b48c 100%);
                                            display: flex; align-items: center; justify-content: center; color: #8B4513; font-weight: bold;">
                                    ${item.name}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>


                    <div class="menu-item-content">
                        <span class="category-badge">
                            <c:choose>
                                <c:when test="${not empty item.category}">
                                    ${item.category.name}
                                </c:when>
                                <c:when test="${not empty item.categoryId}">
                                    <!-- Найдем название категории из списка categories -->
                                    <c:forEach var="cat" items="${categories}">
                                        <c:if test="${cat.id == item.categoryId}">
                                            ${cat.name}
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    Без категории
                                </c:otherwise>
                            </c:choose>
                        </span>

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

        <!-- Если меню пустое -->
        <c:if test="${empty menuItems}">
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
    // Фильтрация по категориям
    document.addEventListener('DOMContentLoaded', function() {
        const filterButtons = document.querySelectorAll('.category-btn');
        const menuItems = document.querySelectorAll('.menu-item-card');

        filterButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Убираем активный класс у всех кнопок
                filterButtons.forEach(btn => btn.classList.remove('active'));
                // Добавляем активный класс текущей кнопке
                this.classList.add('active');

                const category = this.dataset.category;

                // Показываем/скрываем блюда
                menuItems.forEach(item => {
                    if (category === 'all' || item.dataset.category === category) {
                        item.style.display = 'block';
                        setTimeout(() => {
                            item.style.opacity = '1';
                            item.style.transform = 'scale(1)';
                        }, 10);
                    } else {
                        item.style.opacity = '0';
                        item.style.transform = 'scale(0.8)';
                        setTimeout(() => {
                            item.style.display = 'none';
                        }, 300);
                    }
                });
            });
        });

        // Простая анимация при загрузке
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