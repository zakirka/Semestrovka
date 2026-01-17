<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar">
    <div class="container">
        <div class="navbar-brand">
            <a href="${pageContext.request.contextPath}/" class="navbar-logo">
                <span class="logo-icon">☕</span>
                <span class="logo-text">Чайхона</span>
            </a>
            <button class="navbar-toggle" id="navbar-toggle">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>

        <div class="navbar-menu" id="navbar-menu">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/" class="nav-link ${requestScope['javax.servlet.forward.request_uri'] == '/' ? 'active' : ''}">
                        Главная
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/menu" class="nav-link ${requestScope['javax.servlet.forward.request_uri'].contains('/menu') ? 'active' : ''}">
                        Меню
                    </a>
                </li>

                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/order/cart" class="nav-link ${requestScope['javax.servlet.forward.request_uri'].contains('/order/cart') ? 'active' : ''}">
                            Корзина
                            <c:if test="${sessionScope.cartCount != null && sessionScope.cartCount > 0}">
                                <span class="cart-badge">${sessionScope.cartCount}</span>
                            </c:if>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/order/history" class="nav-link ${requestScope['javax.servlet.forward.request_uri'].contains('/order/history') ? 'active' : ''}">
                            Мои заказы
                        </a>
                    </li>

                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <li class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle">
                                Админ-панель
                            </a>
                            <div class="dropdown-menu">
                                <a href="${pageContext.request.contextPath}/admin" class="dropdown-item">Дашборд</a>
                                <a href="${pageContext.request.contextPath}/admin/menu" class="dropdown-item">Меню</a>
                                <a href="${pageContext.request.contextPath}/admin/categories" class="dropdown-item">Категории</a>
                                <a href="${pageContext.request.contextPath}/admin/orders" class="dropdown-item">Заказы</a>
                            </div>
                        </li>
                    </c:if>
                </c:if>
            </ul>

            <ul class="navbar-nav navbar-nav-right">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle user-profile">
                                <span class="user-avatar">${sessionScope.user.username.charAt(0)}</span>
                                <span class="user-name">${sessionScope.user.username}</span>
                            </a>
                            <div class="dropdown-menu dropdown-menu-right">
                                <div class="dropdown-header">
                                    <strong>${sessionScope.user.username}</strong>
                                    <small>${sessionScope.user.email}</small>
                                </div>
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/order/history" class="dropdown-item">
                                    <i>📋</i> Мои заказы
                                </a>
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin" class="dropdown-item">
                                        <i>⚙️</i> Админ-панель
                                    </a>
                                </c:if>
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/auth/logout" class="dropdown-item">
                                    <i>🚪</i> Выйти
                                </a>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/auth/login" class="nav-link ${requestScope['javax.servlet.forward.request_uri'].contains('/auth/login') ? 'active' : ''}">
                                Войти
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-primary nav-btn">
                                Регистрация
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<style>
.navbar {
    background: linear-gradient(135deg, #8B4513, #A0522D);
    color: white;
    padding: 1rem 0;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    position: relative;
    z-index: 1000;
}

.navbar .container {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.navbar-brand {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
}

.navbar-logo {
    display: flex;
    align-items: center;
    color: white;
    text-decoration: none;
    font-size: 1.5rem;
    font-weight: bold;
}

.logo-icon {
    font-size: 2rem;
    margin-right: 0.5rem;
}

.logo-text {
    font-family: 'Georgia', serif;
}

.navbar-toggle {
    display: none;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0.5rem;
}

.navbar-toggle span {
    display: block;
    width: 25px;
    height: 3px;
    background: white;
    margin: 4px 0;
    border-radius: 2px;
    transition: all 0.3s;
}

.navbar-menu {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex: 1;
}

.navbar-nav {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
    gap: 1rem;
}

.navbar-nav-right {
    margin-left: auto;
    gap: 1rem;
}

.nav-item {
    position: relative;
}

.nav-link {
    color: white;
    text-decoration: none;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    transition: background-color 0.3s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.nav-link:hover {
    background-color: rgba(255,255,255,0.2);
}

.nav-link.active {
    background-color: rgba(255,255,255,0.3);
    font-weight: bold;
}

.dropdown {
    position: relative;
}

.dropdown-toggle {
    cursor: pointer;
}

.dropdown-toggle::after {
    content: '▼';
    font-size: 0.8em;
    margin-left: 0.5rem;
}

.dropdown-menu {
    position: absolute;
    top: 100%;
    left: 0;
    background: white;
    min-width: 200px;
    border-radius: 8px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    padding: 0.5rem 0;
    display: none;
    z-index: 1001;
}

.dropdown-menu-right {
    left: auto;
    right: 0;
}

.dropdown:hover .dropdown-menu {
    display: block;
}

.dropdown-header {
    padding: 0.75rem 1rem;
    background: #f8f9fa;
    border-bottom: 1px solid #dee2e6;
}

.dropdown-header strong {
    display: block;
    color: #333;
}

.dropdown-header small {
    color: #6c757d;
    font-size: 0.875rem;
}

.dropdown-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.75rem 1rem;
    color: #333;
    text-decoration: none;
    transition: background-color 0.3s;
}

.dropdown-item:hover {
    background-color: #f8f9fa;
    color: #8B4513;
}

.dropdown-item i {
    font-style: normal;
    width: 1.5rem;
    text-align: center;
}

.dropdown-divider {
    height: 1px;
    background: #dee2e6;
    margin: 0.5rem 0;
}

.user-profile {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.user-avatar {
    width: 32px;
    height: 32px;
    background: rgba(255,255,255,0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    font-size: 0.9rem;
}

.user-name {
    max-width: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.cart-badge {
    background: #ff4757;
    color: white;
    font-size: 0.75rem;
    padding: 0.1rem 0.4rem;
    border-radius: 10px;
    margin-left: 0.25rem;
    vertical-align: super;
}

.nav-btn {
    padding: 0.5rem 1.5rem !important;
    margin: 0 !important;
}

@media (max-width: 992px) {
    .navbar-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: #8B4513;
        flex-direction: column;
        padding: 1rem;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        border-top: 1px solid rgba(255,255,255,0.1);
    }

    .navbar-menu.active {
        display: flex;
    }

    .navbar-toggle {
        display: block;
    }

    .navbar-toggle.active span:nth-child(1) {
        transform: rotate(45deg) translate(5px, 5px);
    }

    .navbar-toggle.active span:nth-child(2) {
        opacity: 0;
    }

    .navbar-toggle.active span:nth-child(3) {
        transform: rotate(-45deg) translate(7px, -6px);
    }

    .navbar-nav {
        flex-direction: column;
        width: 100%;
        gap: 0.5rem;
    }

    .navbar-nav-right {
        flex-direction: column;
        width: 100%;
        margin-left: 0;
        margin-top: 1rem;
        padding-top: 1rem;
        border-top: 1px solid rgba(255,255,255,0.1);
    }

    .dropdown-menu {
        position: static;
        box-shadow: none;
        background: rgba(0,0,0,0.1);
        margin-top: 0.5rem;
        display: none;
    }

    .dropdown:hover .dropdown-menu {
        display: block;
    }

    .dropdown-item {
        color: white;
        padding-left: 2rem;
    }

    .dropdown-item:hover {
        background: rgba(255,255,255,0.1);
    }

    .dropdown-header {
        background: rgba(0,0,0,0.2);
        color: white;
    }

    .dropdown-divider {
        background: rgba(255,255,255,0.1);
    }
}

@media (prefers-color-scheme: dark) {
    .navbar {
        background: linear-gradient(135deg, #5D4037, #795548);
    }

    .dropdown-menu {
        background: #2c2c2c;
        border: 1px solid #444;
    }

    .dropdown-item {
        color: #ddd;
    }

    .dropdown-item:hover {
        background: #3c3c3c;
    }

    .dropdown-header {
        background: #222;
        color: #ddd;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const toggleButton = document.getElementById('navbar-toggle');
    const navbarMenu = document.getElementById('navbar-menu');

    if (toggleButton && navbarMenu) {
        toggleButton.addEventListener('click', function() {
            this.classList.toggle('active');
            navbarMenu.classList.toggle('active');
        });

        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!navbarMenu.contains(event.target) && !toggleButton.contains(event.target)) {
                toggleButton.classList.remove('active');
                navbarMenu.classList.remove('active');
            }
        });

        // Close dropdowns on mobile when clicking item
        if (window.innerWidth <= 992) {
            const dropdownItems = document.querySelectorAll('.dropdown-item');
            dropdownItems.forEach(item => {
                item.addEventListener('click', function() {
                    toggleButton.classList.remove('active');
                    navbarMenu.classList.remove('active');
                });
            });
        }
    }

    // Highlight current page
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-link');

    navLinks.forEach(link => {
        const linkPath = link.getAttribute('href');
        if (linkPath && currentPath.includes(linkPath.replace(/^.*\/\/[^\/]+/, ''))) {
            link.classList.add('active');
        }
    });

    // Update cart count if available
    function updateCartCount() {
        const cartBadge = document.querySelector('.cart-badge');
        if (cartBadge) {
            // You can implement AJAX call here to get cart count
            // For now, we'll keep the server-side value
        }
    }

    updateCartCount();
});
</script>