<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Профиль - Чайхона</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }

        .header {
            background: linear-gradient(135deg, #8B4513 0%, #A0522D 100%);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }

        .logo-icon {
            font-size: 2rem;
        }

        .nav {
            display: flex;
            gap: 1.5rem;
        }

        .nav a {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: background-color 0.2s;
        }

        .nav a:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .main {
            min-height: calc(100vh - 200px);
            padding: 2rem 0;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .footer {
            background-color: #333;
            color: white;
            padding: 2rem 0;
            text-align: center;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .profile-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .profile-header {
            background: linear-gradient(135deg, #8B4513 0%, #A0522D 100%);
            color: white;
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }

        .profile-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .info-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #8B4513;
        }

        .btn {
            display: inline-block;
            padding: 0.875rem 1.75rem;
            font-size: 1rem;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: #8B4513;
            color: white;
        }

        .btn-primary:hover {
            background-color: #A0522D;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(139, 69, 19, 0.2);
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-outline {
            background: white;
            color: #8B4513;
            border: 2px solid #8B4513;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .nav {
                flex-wrap: wrap;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Встроенный header -->
    <header class="header">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <span class="logo-icon">🍵</span>
                <span>Чайхона</span>
            </a>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/">Главная</a>
                <a href="${pageContext.request.contextPath}/menu">Меню</a>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/order/cart">Корзина</a>
                        <a href="${pageContext.request.contextPath}/order/history">История</a>
                        <a href="${pageContext.request.contextPath}/profile">Профиль</a>
                        <a href="${pageContext.request.contextPath}/auth/logout">Выйти</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth/login">Вход</a>
                        <a href="${pageContext.request.contextPath}/auth/register">Регистрация</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>

    <main class="main">
        <div class="container profile-container">
            <div class="profile-header">
                <h1>Профиль пользователя</h1>
                <c:if test="${not empty sessionScope.user}">
                    <p>Добро пожаловать, ${sessionScope.user.username}!</p>
                </c:if>
            </div>

            <div class="profile-info">
                <div class="info-card">
                    <h3>Личная информация</h3>
                    <c:if test="${not empty sessionScope.user}">
                        <p><strong>Имя пользователя:</strong> ${sessionScope.user.username}</p>
                        <p><strong>Email:</strong> ${sessionScope.user.email}</p>
                        <p><strong>Дата регистрации:</strong> ${sessionScope.user.createdAt}</p>
                    </c:if>
                </div>

                <div class="info-card">
                    <h3>Действия</h3>
                    <div style="display: flex; flex-direction: column; gap: 10px;">
                        <a href="${pageContext.request.contextPath}/order/history" class="btn btn-primary">
                            История заказов
                        </a>
                        <a href="${pageContext.request.contextPath}/order/cart" class="btn btn-secondary">
                            Корзина
                        </a>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline">
                            Просмотреть меню
                        </a>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger">
                            Выйти
                        </a>
                    </div>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">2</div>
                    <p>Заказов оформлено</p>
                </div>
                <div class="stat-card">
                    <div class="stat-number">5</div>
                    <p>Товаров в истории</p>
                </div>
                <div class="stat-card">
                    <div class="stat-number">✓</div>
                    <p>Активный аккаунт</p>
                </div>
            </div>
        </div>
    </main>

    <!-- Встроенный footer -->
    <footer class="footer">
        <div class="footer-content">
            <p>&copy; 2025 Чайхона. Все права защищены.</p>
            <p>Семестровая работа - Разработка веб-приложений</p>
        </div>
    </footer>
</body>
</html>