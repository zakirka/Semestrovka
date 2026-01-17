package servlet;

import dao.Impl.MenuItemDAOImpl;
import dao.Impl.OrderDAOImpl;
import dao.Impl.OrderItemDAOImpl;
import dao.Impl.UserDAOImpl;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Enums.OrderStatus;
import model.Order;
import model.User;
import service.OrderService;
import service.Impl.OrderServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/orders")
public class AdminServlet extends HttpServlet {

    private OrderService orderService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            orderService = new OrderServiceImpl(
                    new OrderDAOImpl(),
                    new OrderItemDAOImpl(),
                    new MenuItemDAOImpl()
            );
            userDAO = new UserDAOImpl();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Order> orders = orderService.findAllOrders();

        Map<Long, User> usersMap = new HashMap<>();
        for (Order order : orders) {
            if (order.getUserId() != null && !usersMap.containsKey(order.getUserId())) {
                userDAO.findById(order.getUserId()).ifPresent(user ->
                        usersMap.put(order.getUserId(), user));
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("usersMap", usersMap);
        request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();

        if ("/update-status".equals(action)) {
            updateOrderStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }


    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String orderIdStr = request.getParameter("orderId");
            String statusStr = request.getParameter("status");

            if (orderIdStr == null || statusStr == null) {
                request.setAttribute("error", "Не указаны параметры заказа или статуса");
                doGet(request, response);
                return;
            }

            Long orderId = Long.parseLong(orderIdStr);
            OrderStatus newStatus = OrderStatus.valueOf(statusStr);

            OrderService orderService = new OrderServiceImpl(
                    new OrderDAOImpl(),
                    new OrderItemDAOImpl(),
                    new MenuItemDAOImpl()
            );

            orderService.updateOrderStatus(orderId, newStatus);

            request.setAttribute("success", "Статус заказа #" + orderId + " обновлен на " + newStatus);

            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Ошибка обновления статуса: " + e.getMessage());
            doGet(request, response);
        }
    }
}
