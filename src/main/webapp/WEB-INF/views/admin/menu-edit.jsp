<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty menuItem}">Редактирование блюда</c:when>
            <c:otherwise>Добавление блюда</c:otherwise>
        </c:choose> - Админ-панель
    </title>
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
                    <li><a href="${pageContext.request.contextPath}/admin/menu" class="active">Меню</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/categories">Категории</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders">Заказы</a></li>
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
                        <li><a href="${pageContext.request.contextPath}/admin/menu" class="active">Управление меню</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/categories">Категории</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/orders">Заказы</a></li>
                    </ul>
                </aside>

                <div class="admin-content">
                    <h2>
                        <c:choose>
                            <c:when test="${not empty menuItem}">Редактирование блюда</c:when>
                            <c:otherwise>Добавление нового блюда</c:otherwise>
                        </c:choose>
                    </h2>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <c:out value="${error}" />
                        </div>
                    </c:if>

                    <form method="post"
                          action="${pageContext.request.contextPath}/admin/menu/save"
                          class="edit-form"
                          enctype="multipart/form-data">

                        <c:if test="${not empty menuItem}">
                            <input type="hidden" name="id" value="${menuItem.id}">
                        </c:if>

                        <div class="form-group">
                            <label for="name" class="form-label">Название блюда *</label>
                            <input type="text" id="name" name="name" class="form-control"
                                   value="${menuItem.name}" required maxlength="100">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="categoryId" class="form-label">Категория *</label>
                                <select id="categoryId" name="categoryId" class="form-control" required>
                                    <option value="">Выберите категорию</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.id}"
                                                ${menuItem.categoryId == category.id ? 'selected' : ''}>
                                            <c:out value="${category.name}" />
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="price" class="form-label">Цена (руб.) *</label>
                                <input type="number" id="price" name="price" class="form-control"
                                       value="${menuItem.price}"
                                       step="0.01" min="0.01" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="description" class="form-label">Описание</label>
                            <textarea id="description" name="description" class="form-control"
                                      rows="4">${menuItem.description}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="imageUrl" class="form-label">URL изображения</label>
                            <input type="url" id="imageUrl" name="imageUrl" class="form-control"
                                   value="${menuItem.imageUrl}"
                                   placeholder="https://example.com/image.jpg">
                            <small class="form-text">Оставьте пустым для изображения по умолчанию</small>
                        </div>

                        <div class="form-group">
                            <label for="imageFile" class="form-label">Или загрузите изображение</label>
                            <input type="file" id="imageFile" name="imageFile" class="form-control"
                                   accept="image/*">
                        </div>

                        <c:if test="${not empty menuItem}">
                            <div class="form-group">
                                <label class="form-label">Текущее изображение</label>
                                <c:choose>
                                    <c:when test="${not empty menuItem.imageUrl}">
                                        <img src="${menuItem.imageUrl}" alt="${menuItem.name}"
                                             style="max-width: 200px; height: auto; display: block;">
                                    </c:when>
                                    <c:otherwise>
                                        <p>Изображение не задано</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Доступность</label>
                                <div>
                                    <input type="checkbox" id="available" name="available"
                                           ${menuItem.available ? 'checked' : ''}>
                                    <label for="available">Доступно для заказа</label>
                                </div>
                            </div>
                        </c:if>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <c:choose>
                                    <c:when test="${not empty menuItem}">Сохранить изменения</c:when>
                                    <c:otherwise>Добавить блюдо</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/menu" class="btn btn-secondary">Отмена</a>

                            <c:if test="${not empty menuItem}">
                                <a href="${pageContext.request.contextPath}/admin/menu/delete?id=${menuItem.id}"
                                   class="btn btn-danger"
                                   onclick="return confirm('Вы уверены, что хотите удалить это блюдо?')">
                                    Удалить
                                </a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2024 Чайхона. Админ-панель</p>
        </div>
    </footer>

    <script>
    document.getElementById('price').addEventListener('input', function(e) {
        let value = parseFloat(this.value);
        if (isNaN(value) || value <= 0) {
            this.setCustomValidity('Цена должна быть больше 0');
        } else {
            this.setCustomValidity('');
        }
    });

    document.getElementById('name').addEventListener('input', function(e) {
        if (this.value.trim().length < 2) {
            this.setCustomValidity('Название должно содержать минимум 2 символа');
        } else {
            this.setCustomValidity('');
        }
    });
    </script>

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

    .edit-form {
        max-width: 600px;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
    }

    .form-actions {
        display: flex;
        gap: 1rem;
        margin-top: 2rem;
        padding-top: 1rem;
        border-top: 1px solid #dee2e6;
    }

    .form-text {
        display: block;
        margin-top: 0.25rem;
        font-size: 0.875rem;
        color: #6c757d;
    }

    @media (max-width: 768px) {
        .admin-panel {
            grid-template-columns: 1fr;
        }

        .form-row {
            grid-template-columns: 1fr;
        }

        .form-actions {
            flex-direction: column;
        }

        .form-actions .btn {
            width: 100%;
        }
    }
    </style>
</body>
</html>