package servlet;

import dao.Impl.MenuItemDAOImpl;
import dao.Impl.OrderDAOImpl;
import dao.Impl.OrderItemDAOImpl;
import dao.MenuItemDAO;
import dao.OrderDAO;
import dao.OrderItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;
import service.OrderService;
import service.Impl.OrderServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.math.BigDecimal;
import java.util.Locale;

@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {
    private OrderService orderService;
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private MenuItemDAO menuItemDAO;

    @Override
    public void init() throws ServletException {
        try {
            this.orderDAO = new OrderDAOImpl();
            this.orderItemDAO = new OrderItemDAOImpl();
            this.menuItemDAO = new MenuItemDAOImpl();

            this.orderService = new OrderServiceImpl(orderDAO, orderItemDAO, menuItemDAO);
        } catch (SQLException e) {
            throw new ServletException("Error initializing database connections", e);
        } catch (Exception e) {
            throw new ServletException("Error initializing OrderServlet", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "/add-item":
                handleAddItem(request, response);
                break;
            case "/update-quantity":
                handleUpdateQuantity(request, response);
                break;
            case "/remove-item":
                handleRemoveItem(request, response);
                break;
            case "/clear":
                handleClearCart(request, response);
                break;
            case "/checkout":
                handleCheckout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "/cart":
                showCartPage(request, response);
                break;
            case "/history":
                showHistoryPage(request, response);
                break;
            case "/confirmation":
                showConfirmationPage(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleAddItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();

        try {
            String itemIdParam = request.getParameter("itemId");
            String quantityParam = request.getParameter("quantity");

            if (itemIdParam == null || itemIdParam.isEmpty()) {
                session.setAttribute("error", "Не указан ID товара");
                response.sendRedirect(getReferer(request));
                return;
            }

            Long itemId = Long.parseLong(itemIdParam);
            int quantity = parseQuantity(quantityParam);

            Order order = getOrCreateCurrentOrder(request);
            System.out.println("DEBUG ADD ITEM: Order ID: " + order.getId());

            User user = (User) session.getAttribute("user");
            if (user != null && order.getUserId() == null) {
                Long userId = getUserIdFromUser(user);
                if (userId != null && userId > 0) {
                    order.setUserId(userId);
                    System.out.println("DEBUG ADD ITEM: Setting user_id to " + userId);

                    try {
                        orderService.update(order);
                        System.out.println("DEBUG ADD ITEM: Order saved with user_id: " + order.getUserId());
                    } catch (Exception e) {
                        System.err.println("ERROR saving order with user_id: " + e.getMessage());
                    }
                }
            }

            orderService.addItem(order.getId(), itemId, quantity);

            updateSessionOrder(request, order);

            session.setAttribute("success", "Товар добавлен в корзину");
            response.sendRedirect(getReferer(request));

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Неверный формат ID товара");
            response.sendRedirect(getReferer(request));
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Ошибка при добавлении товара: " + e.getMessage());
            response.sendRedirect(getReferer(request));
        }
    }

    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        boolean isAjax = isAjaxRequest(request);
        System.out.println("DEBUG update-quantity: isAjax = " + isAjax);



        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String itemIdParam = request.getParameter("itemId");
            String quantityParam = request.getParameter("quantity");

            System.out.println("DEBUG update-quantity: itemId=" + itemIdParam + ", quantity=" + quantityParam);

            if (itemIdParam == null || quantityParam == null) {
                response.getWriter().write("{\"success\": false, \"error\": \"Неверные параметры\"}");
                return;
            }

            Long itemId = Long.parseLong(itemIdParam);
            int quantity = Integer.parseInt(quantityParam);

            Order order = getOrCreateCurrentOrder(request);
            System.out.println("DEBUG update-quantity: Order ID = " + order.getId());

            if (quantity <= 0) {
                orderService.removeItem(order.getId(), itemId);
            } else {
                orderService.updateItemQuantity(order.getId(), itemId, quantity);
            }

            updateSessionOrder(request, order);

            Order updatedOrder = orderService.findById(order.getId()).orElse(order);


            BigDecimal total = updatedOrder.getTotalAmount();

            String json = String.format(Locale.US, "{\"success\": true, \"total\": %.2f}", total.doubleValue());



            System.out.println("DEBUG update-quantity: Returning JSON - " + json);
            System.out.println("DEBUG: JSON length = " + json.length());

            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"error\": \"Неверный формат данных\"}");
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Неизвестная ошибка";
            String errorJson = String.format("{\"success\": false, \"error\": \"%s\"}", errorMsg);
            response.getWriter().write(errorJson);
        }
    }

    private void handleRemoveItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        boolean isAjax = isAjaxRequest(request);

        try {
            String itemIdParam = request.getParameter("itemId");

            if (itemIdParam == null || itemIdParam.isEmpty()) {
                if (isAjax) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"error\": \"Не указан ID товара\"}");
                    return;
                }
                session.setAttribute("error", "Не указан ID товара");
                response.sendRedirect(request.getContextPath() + "/order/cart");
                return;
            }

            Long itemId = Long.parseLong(itemIdParam);
            Order order = getOrCreateCurrentOrder(request);

            orderService.removeItem(order.getId(), itemId);
            updateSessionOrder(request, order);

            session.setAttribute("success", "Товар удален из корзины");

            if (isAjax) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            } else {
                response.sendRedirect(request.getContextPath() + "/order/cart");
            }

        } catch (NumberFormatException e) {
            if (isAjax) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Неверный формат ID товара\"}");
                return;
            }
            session.setAttribute("error", "Неверный формат ID товара");
            response.sendRedirect(request.getContextPath() + "/order/cart");
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
                return;
            }
            session.setAttribute("error", "Ошибка при удалении товара: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/order/cart");
        }
    }

    private void handleClearCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        boolean isAjax = isAjaxRequest(request);

        try {
            Order order = getOrCreateCurrentOrder(request);
            orderService.clearCart(order.getId());
            updateSessionOrder(request, order);

            session.setAttribute("success", "Корзина очищена");

            if (isAjax) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            } else {
                response.sendRedirect(request.getContextPath() + "/order/cart");
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
                return;
            }
            session.setAttribute("error", "Ошибка при очистке корзины: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/order/cart");
        }
    }

    private void handleCheckout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        boolean isAjax = isAjaxRequest(request);

        System.out.println("=== DEBUG CHECKOUT START ===");
        System.out.println("Is AJAX request: " + isAjax);

        try {
            Order order = getOrCreateCurrentOrder(request);

            System.out.println("DEBUG CHECKOUT: Order ID: " + order.getId());
            System.out.println("DEBUG CHECKOUT: Order User ID before: " + order.getUserId());

            if (order == null || order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                System.out.println("ERROR: Cart is empty");
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": false, \"error\": \"Корзина пуста\"}");
                } else {
                    session.setAttribute("error", "Корзина пуста");
                    response.sendRedirect(request.getContextPath() + "/order/cart");
                }
                return;
            }

            User user = (User) session.getAttribute("user");

            if (user == null) {
                System.out.println("ERROR: No user in session");
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": false, \"error\": \"Требуется авторизация\", \"redirect\": \"" +
                            request.getContextPath() + "/auth/login\"}");
                } else {
                    session.setAttribute("error", "Для оформления заказа необходимо войти в систему");
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                }
                return;
            }

            System.out.println("DEBUG CHECKOUT: User from session: " + user);
            System.out.println("DEBUG CHECKOUT: User class: " + user.getClass().getName());

            Long userId = getUserIdFromUser(user);
            System.out.println("DEBUG CHECKOUT: Extracted user ID: " + userId);

            if (userId == null || userId <= 0) {
                System.err.println("ERROR: Invalid user ID: " + userId);
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": false, \"error\": \"Неверный ID пользователя\"}");
                } else {
                    session.setAttribute("error", "Ошибка: неверный ID пользователя");
                    response.sendRedirect(request.getContextPath() + "/order/cart");
                }
                return;
            }

            order.setUserId(userId);
            System.out.println("DEBUG CHECKOUT: Setting order user_id to: " + userId);

            try {
                orderService.update(order);
                System.out.println("DEBUG CHECKOUT: Order saved with user_id: " + order.getUserId());

                // Проверяем, что user_id сохранился
                Order updatedOrder = orderService.findById(order.getId()).orElse(null);
                if (updatedOrder != null) {
                    System.out.println("DEBUG CHECKOUT: Verified order user_id in DB: " + updatedOrder.getUserId());
                }
            } catch (Exception e) {
                System.err.println("ERROR saving order with user_id: " + e.getMessage());
                throw new RuntimeException("Не удалось сохранить заказ с user_id", e);
            }

            String notes = request.getParameter("customerNotes");
            System.out.println("DEBUG CHECKOUT: Customer notes: " + notes);

            orderService.checkoutOrder(order.getId(), notes);
            System.out.println("DEBUG CHECKOUT: Order checked out successfully");

            session.removeAttribute("currentOrder");
            System.out.println("DEBUG CHECKOUT: Removed order from session");

            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String jsonResponse = String.format(
                        "{\"success\": true, \"message\": \"Заказ успешно оформлен\", \"orderId\": %d}",
                        order.getId()
                );
                response.getWriter().write(jsonResponse);
                System.out.println("DEBUG CHECKOUT: Sent JSON response for AJAX");
                System.out.println("=== DEBUG CHECKOUT END (AJAX) ===");
                return;
            }

            session.setAttribute("success", "Заказ успешно оформлен!");
            System.out.println("DEBUG CHECKOUT: Redirecting to confirmation page");
            System.out.println("=== DEBUG CHECKOUT END (REDIRECT) ===");
            response.sendRedirect(request.getContextPath() + "/order/confirmation?id=" + order.getId());

        } catch (Exception e) {
            System.err.println("ERROR in checkout: " + e.getMessage());
            e.printStackTrace();

            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String errorMsg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Неизвестная ошибка";
                response.getWriter().write("{\"success\": false, \"error\": \"" + errorMsg + "\"}");
            } else {
                session.setAttribute("error", "Ошибка при оформлении заказа: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/order/cart");
            }
        }
    }

    private void showCartPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        Order order = (Order) session.getAttribute("currentOrder");
        if (order != null) {
            order = orderService.findById(order.getId()).orElse(order);
            session.setAttribute("currentOrder", order);
        }

        request.getRequestDispatcher("/WEB-INF/views/order/cart.jsp").forward(request, response);
    }

    private void showHistoryPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            System.out.println("DEBUG HISTORY: Looking for orders for user ID: " + user.getId());
            Long userId = getUserIdFromUser(user);
            System.out.println("DEBUG HISTORY: Extracted user ID: " + userId);

            List<Order> orders = orderService.findByUserId(userId);
            System.out.println("DEBUG HISTORY: Found " + orders.size() + " orders");

            for (Order order : orders) {
                System.out.println("DEBUG HISTORY: Order ID: " + order.getId() +
                        ", User ID: " + order.getUserId() +
                        ", Total: " + order.getTotalAmount());
            }

            request.setAttribute("orders", orders);

            double totalOrdersAmount = orders.stream()
                    .mapToDouble(order -> order.getTotalAmount().doubleValue())
                    .sum();
            request.setAttribute("totalOrdersAmount", totalOrdersAmount);

            request.getRequestDispatcher("/WEB-INF/views/order/history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Ошибка при загрузке истории заказов: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/order/history.jsp").forward(request, response);
        }
    }

    private void showConfirmationPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdParam = request.getParameter("id");

        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order/history");
            return;
        }

        try {
            Long orderId = Long.parseLong(orderIdParam);
            Order order = orderService.findById(orderId).orElse(null);

            if (order == null) {
                request.setAttribute("error", "Заказ не найден");
            } else {
                request.setAttribute("order", order);
                System.out.println("DEBUG CONFIRMATION: Showing order ID: " + order.getId() +
                        ", User ID: " + order.getUserId());
            }

            request.getRequestDispatcher("/WEB-INF/views/order/confirmation.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Неверный формат ID заказа");
            request.getRequestDispatcher("/WEB-INF/views/order/confirmation.jsp").forward(request, response);
        }
    }


    private Order getOrCreateCurrentOrder(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("currentOrder");

        if (order == null) {
            System.out.println("DEBUG: Creating new order");
            order = orderService.createOrder();

            // Сразу устанавливаем user_id если пользователь авторизован
            User user = (User) session.getAttribute("user");
            if (user != null) {
                Long userId = getUserIdFromUser(user);
                if (userId != null && userId > 0) {
                    order.setUserId(userId);
                    System.out.println("DEBUG: Set user_id to " + userId + " on order creation");

                    // Сохраняем заказ с user_id сразу
                    try {
                        orderService.update(order);
                        System.out.println("DEBUG: Order created with user_id: " + order.getUserId());
                    } catch (Exception e) {
                        System.err.println("ERROR creating order with user_id: " + e.getMessage());
                    }
                }
            }

            session.setAttribute("currentOrder", order);
        } else {
            System.out.println("DEBUG: Using existing order ID: " + order.getId());
        }

        return order;
    }

    private void updateSessionOrder(HttpServletRequest request, Order order) {
        Order updatedOrder = orderService.findById(order.getId()).orElse(order);
        request.getSession().setAttribute("currentOrder", updatedOrder);
    }

    private int parseQuantity(String quantityParam) {
        try {
            if (quantityParam == null || quantityParam.trim().isEmpty()) {
                return 1;
            }
            int quantity = Integer.parseInt(quantityParam);
            return Math.max(quantity, 1);
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private String getReferer(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        return (referer != null && !referer.isEmpty()) ? referer : request.getContextPath() + "/menu";
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }

    private Long getUserIdFromUser(User user) {
        if (user == null) {
            return null;
        }

        Object idObj = user.getId();
        System.out.println("DEBUG getUserIdFromUser: ID object: " + idObj +
                " (class: " + (idObj != null ? idObj.getClass().getName() : "null") + ")");

        if (idObj instanceof Long) {
            return (Long) idObj;
        } else if (idObj instanceof Integer) {
            return ((Integer) idObj).longValue();
        } else if (idObj != null) {
            try {
                return Long.parseLong(idObj.toString());
            } catch (NumberFormatException e) {
                System.err.println("ERROR parsing user ID: " + idObj);
                return null;
            }
        }

        return null;
    }
}