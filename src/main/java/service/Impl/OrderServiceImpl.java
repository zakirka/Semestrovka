package service.Impl;

import model.Order;
import model.OrderItem;
import model.MenuItem;
import model.Enums.OrderStatus;
import dao.OrderDAO;
import dao.OrderItemDAO;
import dao.MenuItemDAO;
import service.OrderService;
import java.util.List;
import java.util.Optional;
import java.math.BigDecimal;
import java.math.RoundingMode;

public class OrderServiceImpl implements OrderService {

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private MenuItemDAO menuItemDAO;

    public OrderServiceImpl(OrderDAO orderDAO, OrderItemDAO orderItemDAO, MenuItemDAO menuItemDAO) {
        this.orderDAO = orderDAO;
        this.orderItemDAO = orderItemDAO;
        this.menuItemDAO = menuItemDAO;
    }

    @Override
    public Optional<Order> findByIdWithItems(Long id) {
        Optional<Order> orderOpt = orderDAO.findById(id);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();

            List<OrderItem> orderItems = orderItemDAO.findByOrderId(id);

            for (OrderItem orderItem : orderItems) {
                MenuItem menuItem = menuItemDAO.findById(orderItem.getMenuItemId()).orElse(null);
                orderItem.setMenuItem(menuItem);
            }

            order.setOrderItems(orderItems);
            return Optional.of(order);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Order> findById(Long id) {
        return findByIdWithItems(id);
    }

    @Override
    public Order createOrder() {
        Order order = new Order();
        order.setStatus(OrderStatus.PENDING);
        order.setTotalAmount(BigDecimal.ZERO);
        return orderDAO.save(order);
    }

    @Override
    public List<Order> findByUserId(Long userId) {
        System.out.println("DEBUG OrderService.findByUserId: Looking for orders for user ID: " + userId);

        List<Order> orders = orderDAO.findByUserId(userId);
        System.out.println("DEBUG OrderService.findByUserId: Found " + orders.size() + " orders");

        for (Order order : orders) {
            System.out.println("DEBUG OrderService.findByUserId: Order ID = " + order.getId() +
                    ", User ID = " + order.getUserId() +
                    ", Total = " + order.getTotalAmount());

            List<OrderItem> orderItems = orderItemDAO.findByOrderId(order.getId());

            for (OrderItem orderItem : orderItems) {
                MenuItem menuItem = menuItemDAO.findById(orderItem.getMenuItemId()).orElse(null);
                orderItem.setMenuItem(menuItem); // ЗАГРУЖАЕМ MenuItem
            }

            order.setOrderItems(orderItems);
            System.out.println("DEBUG OrderService.findByUserId: Loaded " + orderItems.size() +
                    " items for order " + order.getId());
        }

        return orders;
    }

    @Override
    public void addItem(Long orderId, Long menuItemId, int quantity) {
        Optional<OrderItem> existingItem = orderItemDAO.findByOrderIdAndMenuItemId(orderId, menuItemId);

        if (existingItem.isPresent()) {
            OrderItem item = existingItem.get();
            item.setQuantity(item.getQuantity() + quantity);
            orderItemDAO.update(item);
        } else {
            Optional<MenuItem> menuItemOpt = menuItemDAO.findById(menuItemId);
            if (menuItemOpt.isPresent()) {
                MenuItem menuItem = menuItemOpt.get();
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setMenuItemId(menuItemId);
                orderItem.setMenuItem(menuItem);
                orderItem.setQuantity(quantity);
                orderItem.setUnitPrice(menuItem.getPrice());

                orderItemDAO.save(orderItem);
            }
        }

        updateOrderTotal(orderId);
    }

    @Override
    public void updateItemQuantity(Long orderId, Long itemId, int quantity) {
        Optional<OrderItem> orderItemOpt = orderItemDAO.findById(itemId);
        if (orderItemOpt.isPresent()) {
            OrderItem orderItem = orderItemOpt.get();
            orderItem.setQuantity(quantity);
            orderItemDAO.update(orderItem);
            updateOrderTotal(orderId);
        }
    }

    @Override
    public void removeItem(Long orderId, Long itemId) {
        orderItemDAO.delete(itemId);
        updateOrderTotal(orderId);
    }

    @Override
    public void clearCart(Long orderId) {
        orderItemDAO.deleteByOrderId(orderId);

        Optional<Order> orderOpt = orderDAO.findById(orderId);
        orderOpt.ifPresent(order -> {
            order.setTotalAmount(BigDecimal.ZERO);
            orderDAO.update(order);
        });
    }

    @Override
    public boolean itemExists(Long orderId, Long itemId) {
        return orderItemDAO.findById(itemId)
                .map(item -> item.getOrderId().equals(orderId))
                .orElse(false);
    }

    @Override
    public void checkoutOrder(Long orderId, String notes) {
        try {
            Order order = orderDAO.findById(orderId)
                    .orElseThrow(() -> new RuntimeException("Order not found"));

            if (order.getUserId() == null) {
                throw new RuntimeException("Order must have a user_id to checkout");
            }

            order.setStatus(OrderStatus.PENDING);
            order.setCustomerNotes(notes);
            orderDAO.update(order);

        } catch (Exception e) {
            throw new RuntimeException("Error checking out order: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Order> findAllOrders() {
        return orderDAO.findAll();
    }

    @Override
    public List<Order> findOrdersByStatus(OrderStatus status) {
        return orderDAO.findByStatus(status);
    }

    @Override
    public void updateOrderStatus(Long orderId, OrderStatus newStatus) {
        Optional<Order> orderOpt = orderDAO.findById(orderId);
        orderOpt.ifPresent(order -> {
            order.setStatus(newStatus);
            orderDAO.update(order);
        });
    }

    @Override
    public void update(Order order) {
        System.out.println("DEBUG OrderService.update: Order ID: " + order.getId() +
                ", User ID: " + order.getUserId());
        orderDAO.update(order);
    }

    @Override
    public Order updateOrderWithUser(Order order) {
        orderDAO.update(order);
        return order;
    }

    private void updateOrderTotal(Long orderId) {
        Optional<Order> orderOpt = orderDAO.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            List<OrderItem> items = orderItemDAO.findByOrderId(orderId);

            BigDecimal total = BigDecimal.ZERO;
            for (OrderItem item : items) {
                if (item.getUnitPrice() != null && item.getQuantity() != null) {
                    BigDecimal itemTotal = item.getUnitPrice()
                            .multiply(BigDecimal.valueOf(item.getQuantity()));
                    total = total.add(itemTotal);
                }
            }

            total = total.setScale(2, RoundingMode.HALF_UP);
            order.setTotalAmount(total);
            orderDAO.update(order);
        }
    }
}