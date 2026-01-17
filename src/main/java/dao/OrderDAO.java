package dao;

import model.Order;
import model.Enums.OrderStatus;
import java.util.List;
import java.util.Optional;

public interface OrderDAO {
    Order save(Order order);
    void update(Order order);
    Optional<Order> findById(Long id);
    List<Order> findAll();
    List<Order> findByUserId(Long userId);
    List<Order> findByStatus(OrderStatus status);
    void delete(Long id);
}