package service.Impl;

import dao.MenuItemDAO;
import dao.Impl.MenuItemDAOImpl;
import model.MenuItem;
import service.MenuItemService;
import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class MenuItemServiceImpl implements MenuItemService {
    private MenuItemDAO menuItemDAO;
    private Connection connection;

    public MenuItemServiceImpl() {
        try {
            this.connection = DatabaseUtil.getConnection();
            this.menuItemDAO = new MenuItemDAOImpl(connection);
        } catch (SQLException e) {
            throw new RuntimeException("Error initializing MenuItemDAO", e);
        }
    }

    public MenuItemServiceImpl(MenuItemDAO menuItemDAO) {
        this.menuItemDAO = menuItemDAO;
    }

    @Override
    public Optional<MenuItem> findById(Long id) {
        return menuItemDAO.findById(id);
    }

    @Override
    public List<MenuItem> findAll() {
        return menuItemDAO.findAll();
    }

    @Override
    public List<MenuItem> findByCategoryId(Long categoryId) {
        return menuItemDAO.findByCategoryId(categoryId);
    }

    @Override
    public List<MenuItem> findAvailableItems() {
        return menuItemDAO.findAvailableItems();
    }

    @Override
    public List<MenuItem> findPopularItems(int limit) {
        return menuItemDAO.findPopularItems(limit);
    }

    @Override
    public MenuItem save(MenuItem menuItem) {
        if (!validateMenuItem(menuItem)) {
            throw new IllegalArgumentException("Invalid menu item data");
        }
        return menuItemDAO.save(menuItem);
    }

    @Override
    public void update(MenuItem menuItem) {
        if (!validateMenuItem(menuItem)) {
            throw new IllegalArgumentException("Invalid menu item data");
        }
        menuItemDAO.update(menuItem);
    }

    @Override
    public void delete(Long id) {
        menuItemDAO.delete(id);
    }

    @Override
    public void updateAvailability(Long id, boolean available) {
        menuItemDAO.updateAvailability(id, available);
    }

    @Override
    public boolean validateMenuItem(MenuItem menuItem) {
        if (menuItem == null) {
            return false;
        }

        if (menuItem.getName() == null || menuItem.getName().trim().isEmpty()) {
            return false;
        }

        if (menuItem.getDescription() == null || menuItem.getDescription().trim().isEmpty()) {
            return false;
        }

        if (menuItem.getPrice() == null || menuItem.getPrice().doubleValue() <= 0) {
            return false;
        }

        if (menuItem.getCategoryId() == null) {
            return false;
        }

        return true;
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
}