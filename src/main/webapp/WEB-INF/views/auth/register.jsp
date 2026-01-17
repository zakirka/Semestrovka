<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Регистрация - Чайхона</title>
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

        .auth-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 60vh;
        }

        .auth-card {
            background: white;
            border-radius: 12px;
            padding: 2.5rem;
            box-shadow: 0 4px 25px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 420px;
            border: 1px solid #eaeaea;
        }

        .auth-logo {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo-icon {
            font-size: 3rem;
            display: block;
            margin-bottom: 0.5rem;
        }

        .auth-logo h2 {
            color: #8B4513;
            margin: 0;
            font-size: 1.8rem;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
        }

        .auth-form {
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 0.875rem;
            font-size: 1rem;
            border: 1px solid #ddd;
            border-radius: 6px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-control:focus {
            border-color: #8B4513;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
            outline: none;
        }

        .form-control:invalid {
            border-color: #dc3545;
        }

        .form-text {
            display: block;
            margin-top: 0.25rem;
            font-size: 0.875rem;
            color: #666;
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

        .btn-block {
            width: 100%;
        }

        .auth-links {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #eee;
        }

        .auth-links p {
            margin-bottom: 0.75rem;
            color: #666;
        }

        .auth-links a {
            color: #8B4513;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .auth-links a:hover {
            color: #A0522D;
            text-decoration: underline;
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

        .field-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
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

            .auth-card {
                padding: 1.5rem;
                margin: 0 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Встроенный header -->
    <header class="header">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <span class="logo-icon">☕</span>
                <span>Чайхона</span>
            </a>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/">Главная</a>
                <a href="${pageContext.request.contextPath}/auth/login">Вход</a>
                <a href="${pageContext.request.contextPath}/auth/register">Регистрация</a>
            </nav>
        </div>
    </header>

    <main class="main">
        <div class="container">
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-logo">
                        <span class="logo-icon">☕</span>
                        <h2>Регистрация в Чайхоне</h2>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert-error">
                            <c:out value="${error}" />
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert-success">
                            <c:out value="${success}" />
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth/register" method="post" class="auth-form" id="register-form">
                        <div class="form-group">
                            <label for="username" class="form-label">Имя пользователя *</label>
                            <input type="text" id="username" name="username" class="form-control"
                                   value="${param.username}" required minlength="3" maxlength="50"
                                   placeholder="Введите имя пользователя">
                            <small class="form-text">От 3 до 50 символов</small>
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email *</label>
                            <input type="email" id="email" name="email" class="form-control"
                                   value="${param.email}" required placeholder="example@domain.com">
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Пароль *</label>
                            <input type="password" id="password" name="password" class="form-control"
                                   required minlength="6" placeholder="Не менее 6 символов">
                            <small class="form-text">Не менее 6 символов</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword" class="form-label">Подтверждение пароля *</label>
                            <input type="password" id="confirmPassword" name="confirmPassword"
                                   class="form-control" required minlength="6" placeholder="Повторите пароль">
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary btn-block">Зарегистрироваться</button>
                        </div>

                        <div class="auth-links">
                            <p>Уже есть аккаунт? <a href="${pageContext.request.contextPath}/auth/login">Войти</a></p>
                            <p><a href="${pageContext.request.contextPath}/">Вернуться на главную</a></p>
                        </div>
                    </form>
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

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('register-form');

        const requiredFields = form.querySelectorAll('input[required]');

        form.addEventListener('submit', function(e) {
            let isValid = true;
            let errorMessage = '';

            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    showFieldError(field.id, 'Это поле обязательно для заполнения');
                    errorMessage = 'Все поля обязательны для заполнения';
                } else {
                    clearFieldError(field.id);
                }
            });

            const emailField = document.getElementById('email');
            if (emailField.value.trim() && !isValidEmail(emailField.value)) {
                isValid = false;
                showFieldError('email', 'Введите корректный email');
                errorMessage = 'Введите корректный email';
            }

            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password && confirmPassword && password !== confirmPassword) {
                isValid = false;
                showFieldError('confirmPassword', 'Пароли не совпадают');
                errorMessage = 'Пароли не совпадают';
            }

            if (password && password.length < 6) {
                isValid = false;
                showFieldError('password', 'Пароль должен содержать минимум 6 символов');
                errorMessage = 'Пароль должен содержать минимум 6 символов';
            }

            if (!isValid) {
                e.preventDefault();
                showNotification(errorMessage || 'Исправьте ошибки в форме', 'warning');
            }
        });

        requiredFields.forEach(field => {
            field.addEventListener('input', function() {
                clearFieldError(this.id);
            });
        });

        const emailField = document.getElementById('email');
        if (emailField) {
            emailField.addEventListener('blur', function() {
                if (this.value.trim() && !isValidEmail(this.value)) {
                    showFieldError('email', 'Введите корректный email');
                } else {
                    clearFieldError('email');
                }
            });
        }

        const passwordField = document.getElementById('password');
        const confirmPasswordField = document.getElementById('confirmPassword');

        if (passwordField && confirmPasswordField) {
            confirmPasswordField.addEventListener('blur', function() {
                if (passwordField.value && this.value && passwordField.value !== this.value) {
                    showFieldError('confirmPassword', 'Пароли не совпадают');
                } else {
                    clearFieldError('confirmPassword');
                }
            });
        }

        function isValidEmail(email) {
            const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return re.test(email);
        }

        function showFieldError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorDiv = document.createElement('div');
            errorDiv.className = 'field-error';
            errorDiv.textContent = message;

            field.parentNode.appendChild(errorDiv);
            field.style.borderColor = '#dc3545';
        }

        function clearFieldError(fieldId) {
            const field = document.getElementById(fieldId);
            const errorDiv = field.parentNode.querySelector('.field-error');
            if (errorDiv) {
                errorDiv.remove();
            }
            field.style.borderColor = '';
        }

        function showNotification(message, type) {
            const oldNotifications = document.querySelectorAll('.notification');
            oldNotifications.forEach(notification => notification.remove());

            const notification = document.createElement('div');
            notification.className = 'notification notification-' + type;
            notification.textContent = message;

            let backgroundColor;
            let textColor = 'white';

            if (type === 'warning') {
                backgroundColor = '#ffc107';
                textColor = '#333';
            } else if (type === 'error') {
                backgroundColor = '#dc3545';
            } else if (type === 'success') {
                backgroundColor = '#28a745';
            } else {
                backgroundColor = '#17a2b8';
            }

            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1000;
                padding: 1rem 1.5rem;
                border-radius: 8px;
                color: ${textColor};
                min-width: 300px;
                animation: slideIn 0.3s ease-out;
                background: ${backgroundColor};
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            `;

            document.body.appendChild(notification);

            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease-in';
                setTimeout(() => notification.remove(), 300);
            }, 5000);
        }
    });
    </script>
</body>
</html>