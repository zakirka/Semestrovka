package service;

import dao.MenuItemDAO;
import dao.Impl.MenuItemDAOImpl;
import model.MenuItem;

import java.sql.SQLException;
import java.util.Optional;

public class MenuService {
    private MenuItemDAO menuItemDAO;

    public MenuService() {
        try {
            this.menuItemDAO = new MenuItemDAOImpl();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize MenuItemDAO", e);
        }
    }

    public MenuService(MenuItemDAO menuItemDAO) {
        this.menuItemDAO = menuItemDAO;
    }

    public MenuItem getMenuItemById(Long id) {
        Optional<MenuItem> itemOpt = menuItemDAO.findById(id);
        return itemOpt.orElse(null);
    }

    public boolean isMenuItemAvailable(Long id) {
        MenuItem item = getMenuItemById(id);
        return item != null && item.isAvailable();
    }
}