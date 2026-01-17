package service;

import model.MenuItem;
import model.Order;
import model.OrderItem;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;

public class CartService {

    public void addItem(HttpSession session, MenuItem menuItem, int quantity) {
        Order order = (Order) session.getAttribute("currentOrder");
        if (order == null) {
            order = new Order();
            order.setOrderItems(new ArrayList<>());
        }

        if (order.getOrderItems() == null) {
            order.setOrderItems(new ArrayList<>());
        }

        boolean found = false;
        for (OrderItem item : order.getOrderItems()) {
            if (item.getMenuItem().getId().equals(menuItem.getId())) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }

        if (!found) {
            OrderItem newItem = new OrderItem();
            newItem.setId(System.currentTimeMillis());
            newItem.setMenuItem(menuItem);
            newItem.setQuantity(quantity);
            newItem.setUnitPrice(menuItem.getPrice());
            order.getOrderItems().add(newItem);
        }

        recalcTotal(order);
        session.setAttribute("currentOrder", order);
    }

    public void updateItemQuantity(HttpSession session, Long itemId, int quantity) {
        Order order = (Order) session.getAttribute("currentOrder");
        if (order != null && order.getOrderItems() != null) {
            for (var item : order.getOrderItems()) {
                if (item.getId().equals(itemId)) {
                    item.setQuantity(quantity);
                    break;
                }
            }
            recalcTotal(order);
            session.setAttribute("currentOrder", order);
        }
    }

    public void removeItem(HttpSession session, Long itemId) {
        Order order = (Order) session.getAttribute("currentOrder");
        if (order != null && order.getOrderItems() != null) {
            order.getOrderItems().removeIf(item -> item.getId().equals(itemId));
            recalcTotal(order);
            session.setAttribute("currentOrder", order);
        }
    }

    public void clearCart(HttpSession session) {
        Order order = (Order) session.getAttribute("currentOrder");
        if (order != null && order.getOrderItems() != null) {
            order.getOrderItems().clear();
            recalcTotal(order);
            session.setAttribute("currentOrder", order);
        }
    }

    private void recalcTotal(Order order) {
        BigDecimal total = BigDecimal.ZERO;
        if (order.getOrderItems() != null) {
            for (var item : order.getOrderItems()) {
                if (item.getUnitPrice() != null && item.getQuantity() != null) {

                    BigDecimal itemTotal = item.getUnitPrice()
                            .multiply(BigDecimal.valueOf(item.getQuantity()));
                    total = total.add(itemTotal);
                }
            }
        }
        order.setTotalAmount(total);
    }
}