package service;

import model.Order;
import model.Enums.OrderStatus;
import java.util.List;
import java.util.Optional;

public interface OrderService {
    Order createOrder();
    Order updateOrderWithUser(Order order);
    void update(Order order);

    Optional<Order> findByIdWithItems(Long id);

    default Optional<Order> findById(Long id) {
        return findByIdWithItems(id);
    }

    List<Order> findByUserId(Long userId);

    void addItem(Long orderId, Long menuItemId, int quantity);
    void updateItemQuantity(Long orderId, Long itemId, int quantity);
    void removeItem(Long orderId, Long itemId);
    void clearCart(Long orderId);
    boolean itemExists(Long orderId, Long itemId);

    void checkoutOrder(Long orderId, String notes);

    List<Order> findAllOrders();
    List<Order> findOrdersByStatus(OrderStatus status);
    void updateOrderStatus(Long orderId, OrderStatus newStatus);
}