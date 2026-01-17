package dao.Impl;

import dao.MenuItemDAO;
import model.MenuItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class MenuItemDAOImpl implements MenuItemDAO {
    private final Connection connection;

    public MenuItemDAOImpl(Connection connection) {
        this.connection = connection;
    }

    public MenuItemDAOImpl() throws SQLException {
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
    public Optional<MenuItem> findById(Long id) {
        String sql = "SELECT * FROM menu_items WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSetToMenuItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public List<MenuItem> findAll() {
        String sql = "SELECT * FROM menu_items";
        List<MenuItem> items = new ArrayList<>();
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                items.add(mapResultSetToMenuItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public List<MenuItem> findByCategoryId(Long categoryId) {
        String sql = "SELECT * FROM menu_items WHERE category_id = ?";
        List<MenuItem> items = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(mapResultSetToMenuItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public List<MenuItem> findAvailableItems() {
        String sql = "SELECT * FROM menu_items WHERE available = TRUE";
        List<MenuItem> items = new ArrayList<>();
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                items.add(mapResultSetToMenuItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public List<MenuItem> findPopularItems(int limit) {
        List<MenuItem> items = new ArrayList<>();
        String sql = "SELECT * FROM menu_items WHERE available = true ORDER BY RANDOM() LIMIT ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public MenuItem save(MenuItem menuItem) {
        String sql = "INSERT INTO menu_items(name, description, price, image_url, available, category_id) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, menuItem.getName());
            stmt.setString(2, menuItem.getDescription());
            stmt.setBigDecimal(3, menuItem.getPrice());
            stmt.setString(4, menuItem.getImageUrl());
            stmt.setBoolean(5, menuItem.isAvailable());
            stmt.setLong(6, menuItem.getCategoryId());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating menu item failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    menuItem.setId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating menu item failed, no ID obtained.");
                }
            }
            return menuItem;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error saving menu item: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(MenuItem menuItem) {
        String sql = "UPDATE menu_items SET name = ?, description = ?, price = ?, " +
                "image_url = ?, available = ?, category_id = ? WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, menuItem.getName());
            stmt.setString(2, menuItem.getDescription());
            stmt.setBigDecimal(3, menuItem.getPrice());
            stmt.setString(4, menuItem.getImageUrl());
            stmt.setBoolean(5, menuItem.isAvailable());
            stmt.setLong(6, menuItem.getCategoryId());
            stmt.setLong(7, menuItem.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating menu item: " + e.getMessage(), e);
        }
    }

    @Override
    public void updateAvailability(Long id, boolean available) {
        String sql = "UPDATE menu_items SET available = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, available);
            stmt.setLong(2, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating availability: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM menu_items WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting menu item: " + e.getMessage(), e);
        }
    }

    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private MenuItem mapResultSetToMenuItem(ResultSet rs) throws SQLException {
        MenuItem item = new MenuItem();
        item.setId(rs.getLong("id"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setImageUrl(rs.getString("image_url"));
        item.setAvailable(rs.getBoolean("available"));
        item.setCategoryId(rs.getLong("category_id"));
        return item;
    }

}