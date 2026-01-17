<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Чайхона - <c:out value="${title != null ? title : 'Восточная кухня'}" /></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="logo">
                <h1><a href="${pageContext.request.contextPath}/">Чайхона</a></h1>
            </div>
            <nav class="nav">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/">Главная</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu">Меню</a></li>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li><a href="${pageContext.request.contextPath}/order/cart">Корзина</a></li>
                            <li><a href="${pageContext.request.contextPath}/order/history">Мои заказы</a></li>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li><a href="${pageContext.request.contextPath}/admin">Админ-панель</a></li>
                            </c:if>
                            <li class="user-menu">
                                <span>Привет, <c:out value="${sessionScope.user.username}" /></span>
                                <a href="${pageContext.request.contextPath}/auth/logout">Выйти</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/auth/login">Войти</a></li>
                            <li><a href="${pageContext.request.contextPath}/auth/register">Регистрация</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </nav>
        </div>
    </header>

    <main class="main">
        <div class="container">
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <c:out value="${error}" />
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <c:out value="${success}" />
                </div>
            </c:if>

            <jsp:include page="/WEB-INF/views/${content}" />
        </div>
    </main>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2026 Чайхона. Восточная кухня.</p>
            <p>Телефон: +7 (999) 123-45-67</p>
            <p>Адрес: ул. Восточная, д. 15</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <c:if test="${not empty script}">
        <script src="${pageContext.request.contextPath}/js/${script}.js"></script>
    </c:if>
</body>
</html>