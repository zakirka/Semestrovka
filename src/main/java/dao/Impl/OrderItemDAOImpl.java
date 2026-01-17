package dao.Impl;

import dao.OrderItemDAO;
import model.OrderItem;
import java.util.List;
import java.util.Optional;
import java.sql.*;
import java.util.ArrayList;
import java.math.BigDecimal;

public class OrderItemDAOImpl implements OrderItemDAO {
    private Connection connection;

    public OrderItemDAOImpl() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            this.connection = DriverManager.getConnection(
                    "jdbc:postgresql://localhost:5432/Samsa",
                    "postgres",
                    "postgres"
            );
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL driver not found", e);
        } catch (SQLException e) {
            throw e;
        }
    }

    @Override
    public Optional<OrderItem> findById(Long id) {
        String sql = "SELECT * FROM order_items WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToOrderItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding order item by id", e);
        }
        return Optional.empty();
    }

    @Override
    public List<OrderItem> findByOrderId(Long orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, orderId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToOrderItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding order items by order id", e);
        }
        return items;
    }

    @Override
    public Optional<OrderItem> findByOrderIdAndMenuItemId(Long orderId, Long menuItemId) {
        String sql = "SELECT * FROM order_items WHERE order_id = ? AND menu_item_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, orderId);
            stmt.setLong(2, menuItemId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToOrderItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding order item", e);
        }
        return Optional.empty();
    }

    @Override
    public OrderItem save(OrderItem orderItem) {
        String sql = "INSERT INTO order_items (order_id, menu_item_id, quantity, unit_price) " +
                "VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, orderItem.getOrderId());
            stmt.setLong(2, orderItem.getMenuItemId());
            stmt.setInt(3, orderItem.getQuantity());
            stmt.setBigDecimal(4, orderItem.getUnitPrice());

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    orderItem.setId(rs.getLong(1));
                }
            }

            return orderItem;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving order item", e);
        }
    }

    @Override
    public void update(OrderItem orderItem) {
        String sql = "UPDATE order_items SET quantity = ?, unit_price = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, orderItem.getQuantity());
            stmt.setBigDecimal(2, orderItem.getUnitPrice());
            stmt.setLong(3, orderItem.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating order item", e);
        }
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM order_items WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting order item", e);
        }
    }

    @Override
    public void deleteByOrderId(Long orderId) {
        String sql = "DELETE FROM order_items WHERE order_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting order items by order id", e);
        }
    }

    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getLong("id"));
        item.setOrderId(rs.getLong("order_id"));
        item.setMenuItemId(rs.getLong("menu_item_id"));
        item.setQuantity(rs.getInt("quantity"));

        BigDecimal unitPrice = rs.getBigDecimal("unit_price");
        item.setUnitPrice(unitPrice);

        return item;
    }
}