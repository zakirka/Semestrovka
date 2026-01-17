package dao;

import model.OrderItem;
import java.util.List;
import java.util.Optional;

public interface OrderItemDAO {
    Optional<OrderItem> findById(Long id);
    List<OrderItem> findByOrderId(Long orderId);
    Optional<OrderItem> findByOrderIdAndMenuItemId(Long orderId, Long menuItemId);
    OrderItem save(OrderItem orderItem);
    void update(OrderItem orderItem);
    void delete(Long id);
    void deleteByOrderId(Long orderId);
}