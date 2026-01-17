package dao.Impl;

import dao.OrderDAO;
import model.Order;
import model.Enums.OrderStatus;
import model.OrderItem;

import java.util.List;
import java.util.Optional;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.math.BigDecimal;

public class OrderDAOImpl implements OrderDAO {
    private Connection connection;

    public OrderDAOImpl() throws SQLException {
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
    public Order save(Order order) {
        String sql = "INSERT INTO orders (user_id, status, total_amount, customer_notes, created_at) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (order.getUserId() != null) {
                stmt.setLong(1, order.getUserId());
            } else {
                stmt.setNull(1, Types.BIGINT);
            }

            stmt.setString(2, order.getStatus().name());
            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setString(4, order.getCustomerNotes());
            stmt.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    order.setId(rs.getLong(1));
                }
            }

            return order;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving order: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Order order) {
        String sql = "UPDATE orders SET user_id = ?, status = ?, total_amount = ?, " +
                "customer_notes = ?, updated_at = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            if (order.getUserId() != null) {
                stmt.setLong(1, order.getUserId());
            } else {
                stmt.setNull(1, Types.BIGINT);
            }

            stmt.setString(2, order.getStatus().toString());
            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setString(4, order.getCustomerNotes());
            stmt.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(6, order.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating order", e);
        }
    }

    @Override
    public Optional<Order> findById(Long id) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding order by id", e);
        }
        return Optional.empty();
    }

    @Override
    public List<Order> findByUserId(Long userId) {
        System.out.println("DEBUG OrderDAO.findByUserId: Executing query for user: " + userId);

        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    Order order = mapResultSetToOrder(rs);
                    System.out.println("DEBUG OrderDAO.findByUserId: Found order ID: " + order.getId() +
                            ", Status: " + order.getStatus() +
                            ", User ID in DB: " + rs.getLong("user_id"));
                    orders.add(order);
                }
                System.out.println("DEBUG OrderDAO.findByUserId: Total orders found: " + count);
            }
        } catch (SQLException e) {
            System.err.println("ERROR in OrderDAO.findByUserId: " + e.getMessage());
            throw new RuntimeException("Error finding orders by user id", e);
        }
        return orders;
    }

    private List<OrderItem> findOrderItemsByOrderId(Long orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT oi.*, mi.name as menu_item_name " +
                "FROM order_items oi " +
                "LEFT JOIN menu_items mi ON oi.menu_item_id = mi.id " +
                "WHERE oi.order_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, orderId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setId(rs.getLong("id"));
                    orderItem.setOrderId(rs.getLong("order_id"));
                    orderItem.setMenuItemId(rs.getLong("menu_item_id"));
                    orderItem.setQuantity(rs.getInt("quantity"));
                    orderItem.setUnitPrice(rs.getBigDecimal("price"));

                    orderItems.add(orderItem);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding order items by order id", e);
        }
        return orderItems;
    }

    @Override
    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all orders", e);
        }
        return orders;
    }

    @Override
    public List<Order> findByStatus(OrderStatus status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding orders by status", e);
        }
        return orders;
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM orders WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting order", e);
        }
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong("id"));
        order.setUserId(rs.getLong("user_id"));
        order.setStatus(OrderStatus.valueOf(rs.getString("status")));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCustomerNotes(rs.getString("customer_notes"));
        order.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            order.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return order;
    }
}