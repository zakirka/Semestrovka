<main class="main">
    <div class="container">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">Главная</a> &gt;
            <a href="${pageContext.request.contextPath}/order/history">История заказов</a> &gt;
            <span>Заказ #${order.id}</span>
        </div>

        <div style="background: white; padding: 30px; border-radius: 10px; margin-top: 20px;">
            <h1>Заказ #${order.id}</h1>

            <div style="display: flex; gap: 30px; margin-top: 20px;">
                <div style="flex: 1;">
                    <h3>Основная информация:</h3>
                    <table style="width: 100%;">
                        <tr>
                            <td><strong>Статус:</strong></td>
                            <td>${order.status}</td>
                        </tr>
                        <tr>
                            <td><strong>Дата создания:</strong></td>
                            <td>${order.createdAt}</td>
                        </tr>
                        <tr>
                            <td><strong>Сумма:</strong></td>
                            <td>${order.totalAmount} ₽</td>
                        </tr>
                        <c:if test="${not empty order.customerNotes}">
                        <tr>
                            <td><strong>Комментарий:</strong></td>
                            <td>${order.customerNotes}</td>
                        </tr>
                        </c:if>
                    </table>

                    <h3 style="margin-top: 30px;">Товары:</h3>
                    <c:choose>
                        <c:when test="${not empty order.orderItems and order.orderItems.size() > 0}">
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr style="background: #f5f5f5;">
                                    <th style="padding: 10px; text-align: left;">Название</th>
                                    <th style="padding: 10px; text-align: left;">Цена</th>
                                    <th style="padding: 10px; text-align: left;">Кол-во</th>
                                    <th style="padding: 10px; text-align: left;">Сумма</th>
                                </tr>
                                <c:forEach var="item" items="${order.orderItems}">
                                <tr style="border-bottom: 1px solid #eee;">
                                    <td style="padding: 10px;">
                                        ${item.menuItem != null ? item.menuItem.name : 'Товар #' + item.id}
                                    </td>
                                    <td style="padding: 10px;">${item.unitPrice} ₽</td>
                                    <td style="padding: 10px;">${item.quantity}</td>
                                    <td style="padding: 10px;">${item.unitPrice * item.quantity} ₽</td>
                                </tr>
                                </c:forEach>
                                <tr style="background: #f9f9f9; font-weight: bold;">
                                    <td colspan="3" style="padding: 10px; text-align: right;">Итого:</td>
                                    <td style="padding: 10px;">${order.totalAmount} ₽</td>
                                </tr>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p style="color: #666; font-style: italic;">Товары не найдены</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div style="width: 300px;">
                    <div style="background: #f8f9fa; padding: 20px; border-radius: 8px;">
                        <h3>Действия</h3>
                        <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 15px;">
                            <a href="${pageContext.request.contextPath}/order/history"
                               class="btn btn-secondary"
                               style="display: block; text-align: center; padding: 10px;">
                                ← К истории заказов
                            </a>

                            <c:if test="${order.status == 'PENDING'}">
                                <button onclick="cancelOrder(${order.id})"
                                        class="btn btn-danger"
                                        style="width: 100%; padding: 10px;">
                                    ❌ Отменить заказ
                                </button>
                            </c:if>

                            <c:if test="${order.status == 'READY'}">
                                <button onclick="completeOrder(${order.id})"
                                        class="btn btn-success"
                                        style="width: 100%; padding: 10px;">
                                    ✅ Подтвердить получение
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>