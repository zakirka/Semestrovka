<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</main>
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-section">
                <h3>Чайхона</h3>
                <p>Настоящая восточная кухня в центре города</p>
            </div>
            <div class="footer-section">
                <h3>Контакты</h3>
                <p>📞 +7 (999) 123-45-67</p>
                <p>📧 info@chaikhona.ru</p>
                <p>📍 ул. Восточная, д. 15</p>
            </div>
            <div class="footer-section">
                <h3>Часы работы</h3>
                <p>Пн-Пт: 10:00 - 23:00</p>
                <p>Сб-Вс: 11:00 - 00:00</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 Чайхона. Все права защищены.</p>
            <p class="footer-links">
                <a href="${pageContext.request.contextPath}/menu">Меню</a> |
                <a href="${pageContext.request.contextPath}/order/history">Заказы</a> |
                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin">Админ-панель</a> |
                </c:if>
                <a href="${pageContext.request.contextPath}/auth/login">Вход</a>
            </p>
        </div>
    </div>
</footer>

<!-- Основной JS -->
<script src="${pageContext.request.contextPath}/js/main.js?v=${System.currentTimeMillis()}"></script>

<!-- Подключение скрипта страницы -->
<c:if test="${param.script != null}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var script = document.createElement('script');
            script.src = '${pageContext.request.contextPath}/js/${param.script}.js?v=${System.currentTimeMillis()}';
            document.body.appendChild(script);
        });
    </script>
</c:if>
</body>
</html>
