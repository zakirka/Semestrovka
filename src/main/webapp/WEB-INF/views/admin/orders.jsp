<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Управление заказами - Админ-панель</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="logo">
                <h1><a href="${pageContext.request.contextPath}/admin">Админ-панель</a></h1>
            </div>
            <nav class="nav">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/">Главная сайта</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin">Дашборд</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/menu">Меню</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/categories">Категории</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders" class="active">Заказы</a></li>
                    <li class="user-menu">
                        <span>Админ: <c:out value="${sessionScope.user.username}" /></span>
                        <a href="${pageContext.request.contextPath}/auth/logout">Выйти</a>
                    </li>
                </ul>
            </nav>
        </div>
    </header>

    <main class="main">
        <div class="container">
            <div class="admin-panel">
                <aside class="admin-sidebar">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/admin">Дашборд</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/menu">Управление меню</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/categories">Категории</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/orders" class="active">Заказы</a></li>
                    </ul>
                </aside>

                <div class="admin-content">
                    <h2>Управление заказами</h2>

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

                    <div class="orders-management">
                        <div class="admin-toolbar">
                            <form method="get" action="${pageContext.request.contextPath}/admin/orders" class="filter-form">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="status" class="form-label">Фильтр по статусу:</label>
                                        <select name="status" id="status" class="form-control" onchange="this.form.submit()">
                                            <option value="">Все статусы</option>
                                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Ожидание</option>
                                            <option value="CONFIRMED" ${param.status == 'CONFIRMED' ? 'selected' : ''}>Подтвержден</option>
                                            <option value="PREPARING" ${param.status == 'PREPARING' ? 'selected' : ''}>Готовится</option>
                                            <option value="READY" ${param.status == 'READY' ? 'selected' : ''}>Готов</option>
                                            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Завершен</option>
                                            <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Отменен</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="user" class="form-label">Поиск по пользователю:</label>
                                        <input type="text" name="search" id="user" class="form-control"
                                               placeholder="Имя или email" value="${param.search}">
                                    </div>

                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">Применить</button>
                                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">Сбросить</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <c:choose>
                            <c:when test="${not empty orders and orders.size() > 0}">
                                <div class="table-responsive">
                                    <table class="table table-sortable">
                                        <thead>
                                            <tr>
                                                <th data-sort="id">ID</th>
                                                <th data-sort="user">Пользователь</th>
                                                <th data-sort="date">Дата</th>
                                                <th data-sort="total">Сумма</th>
                                                <th data-sort="status">Статус</th>
                                                <th>Действия</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${orders}">
                                                <tr>
                                                    <td data-id="${order.id}">#${order.id}</td>
                                                    <td data-user="${order.userId}">
                                                        Пользователь #${order.userId}
                                                    </td>
                                                    <td data-date="${order.createdAt}">
                                                        ${order.createdAt}
                                                    </td>
                                                    <td data-total="${order.totalAmount}">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="RUB" />
                                                    </td>
                                                    <td>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status"
                                                              class="status-form" style="display: inline;">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <select name="status" class="order-status-select form-control-sm"
                                                                    data-order-id="${order.id}"
                                                                    data-original-status="${order.status}"
                                                                    onchange="this.form.submit()">
                                                                <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Ожидание</option>
                                                                <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>Подтвержден</option>
                                                                <option value="PREPARING" ${order.status == 'PREPARING' ? 'selected' : ''}>Готовится</option>
                                                                <option value="READY" ${order.status == 'READY' ? 'selected' : ''}>Готов</option>
                                                                <option value="COMPLETED" ${order.status == 'COMPLETED' ? 'selected' : ''}>Завершен</option>
                                                                <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Отменен</option>
                                                            </select>
                                                        </form>
                                                        <span class="status-badge status-${order.status.name().toLowerCase()}">
                                                            <c:choose>
                                                                <c:when test="${order.status == 'PENDING'}">⏳ Ожидание</c:when>
                                                                <c:when test="${order.status == 'CONFIRMED'}">✅ Подтвержден</c:when>
                                                                <c:when test="${order.status == 'PREPARING'}">👨‍🍳 Готовится</c:when>
                                                                <c:when test="${order.status == 'READY'}">🎉 Готов</c:when>
                                                                <c:when test="${order.status == 'COMPLETED'}">🏁 Завершен</c:when>
                                                                <c:when test="${order.status == 'CANCELLED'}">❌ Отменен</c:when>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/order/details?id=${order.id}"
                                                           class="btn btn-secondary btn-sm">Просмотр</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="orders-stats">
                                    <h3>Статистика</h3>
                                    <div class="stats-grid">
                                        <div class="stat-card">
                                            <h4>Всего заказов</h4>
                                            <p class="stat-number">${orders.size()}</p>
                                        </div>
                                        <div class="stat-card">
                                            <h4>На сумму</h4>
                                            <p class="stat-number">
                                                <fmt:formatNumber value="${orders.stream().map(o -> o.totalAmount).reduce(0, (a, b) -> a + b)}"
                                                                  type="currency" currencyCode="RUB" />
                                            </p>
                                        </div>
                                        <div class="stat-card">
                                            <h4>В ожидании</h4>
                                            <p class="stat-number">
                                                ${orders.stream().filter(o -> o.status == 'PENDING').count()}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <h3>Заказов не найдено</h3>
                                    <p>Пока нет заказов, соответствующих вашим критериям фильтрации.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2024 Чайхона. Админ-панель</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>

    <style>
    .admin-panel {
        display: grid;
        grid-template-columns: 250px 1fr;
        gap: 2rem;
        margin-top: 2rem;
    }

    .admin-sidebar {
        background: white;
        border-radius: 8px;
        padding: 1.5rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        height: fit-content;
    }

    .admin-sidebar ul {
        list-style: none;
        padding: 0;
    }

    .admin-sidebar li {
        margin-bottom: 0.5rem;
    }

    .admin-sidebar a {
        display: block;
        padding: 0.75rem 1rem;
        color: #333;
        text-decoration: none;
        border-radius: 4px;
        transition: all 0.3s;
    }

    .admin-sidebar a:hover,
    .admin-sidebar a.active {
        background: #8B4513;
        color: white;
    }

    .admin-content {
        background: white;
        border-radius: 8px;
        padding: 2rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .admin-toolbar {
        background: #f8f9fa;
        padding: 1rem;
        border-radius: 8px;
        margin-bottom: 2rem;
    }

    .form-row {
        display: flex;
        gap: 1rem;
        align-items: flex-end;
    }

    .form-row .form-group {
        flex: 1;
        margin-bottom: 0;
    }

    .status-badge {
        display: inline-block;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-size: 0.875rem;
        margin-left: 0.5rem;
    }

    .status-pending { background: #fff3cd; color: #856404; }
    .status-confirmed { background: #d1ecf1; color: #0c5460; }
    .status-preparing { background: #cce5ff; color: #004085; }
    .status-ready { background: #d4edda; color: #155724; }
    .status-completed { background: #e2e3e5; color: #383d41; }
    .status-cancelled { background: #f8d7da; color: #721c24; }

    .btn-sm {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }

    .orders-stats {
        margin-top: 2rem;
        padding-top: 2rem;
        border-top: 1px solid #dee2e6;
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
    }

    .stat-card {
        background: #f8f9fa;
        padding: 1rem;
        border-radius: 8px;
        text-align: center;
    }

    .stat-number {
        font-size: 2rem;
        font-weight: bold;
        color: #8B4513;
        margin: 0.5rem 0;
    }

    .empty-state {
        text-align: center;
        padding: 3rem;
        color: #6c757d;
    }

    @media (max-width: 768px) {
        .admin-panel {
            grid-template-columns: 1fr;
        }

        .form-row {
            flex-direction: column;
        }
    }
    </style>
</body>
</html>