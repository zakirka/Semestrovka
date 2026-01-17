<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<div class="error-page">
    <c:choose>
        <c:when test="${pageContext.errorData.statusCode == 404}">
            <h1>404 - Страница не найдена</h1>
            <p>Запрашиваемая страница не существует.</p>
        </c:when>
        <c:when test="${pageContext.errorData.statusCode == 500}">
            <h1>500 - Ошибка сервера</h1>
            <p>Произошла внутренняя ошибка сервера.</p>
        </c:when>
        <c:when test="${pageContext.errorData.statusCode == 403}">
            <h1>403 - Доступ запрещен</h1>
            <p>У вас нет прав для доступа к этой странице.</p>
        </c:when>
        <c:otherwise>
            <h1>Ошибка ${pageContext.errorData.statusCode}</h1>
            <p>Произошла непредвиденная ошибка.</p>
        </c:otherwise>
    </c:choose>

    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Вернуться на главную</a>
</div>