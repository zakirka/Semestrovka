<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<section class="hero">
    <h2>Добро пожаловать в Чайхону!</h2>
    <p>Насладитесь настоящей восточной кухней в уютной атмосфере</p>
    <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">Посмотреть меню</a>
</section>

<section class="featured-categories">
    <h3>Категории</h3>
    <div class="categories-grid">
        <c:forEach var="category" items="${categories}">
            <div class="category-card">
                <c:if test="${not empty category.imageUrl}">
                    <img src="${category.imageUrl}" alt="${category.name}">
                </c:if>
                <h4>${category.name}</h4>
                <p>${category.description}</p>
                <a href="${pageContext.request.contextPath}/menu/category?id=${category.id}" class="btn btn-secondary">Смотреть</a>
            </div>
        </c:forEach>
    </div>
</section>

<section class="popular-items">
    <h3>Популярные блюда</h3>
    <div class="items-grid">
        <c:forEach var="item" items="${popularItems}">
            <div class="item-card">
                <c:if test="${not empty item.imageUrl}">
                    <img src="${item.imageUrl}" alt="${item.name}">
                </c:if>
                <h4>${item.name}</h4>
                <p class="price"><fmt:formatNumber value="${item.price}" type="currency" currencyCode="RUB" /></p>
                <p class="description">${item.description}</p>
                <c:if test="${not empty sessionScope.user}">
                    <button class="btn btn-primary add-to-cart" data-item-id="${item.id}">В корзину</button>
                </c:if>
            </div>
        </c:forEach>
    </div>
</section>