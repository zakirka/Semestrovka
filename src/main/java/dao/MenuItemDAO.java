package dao;

import model.MenuItem;
import java.util.List;
import java.util.Optional;

public interface MenuItemDAO {
    Optional<MenuItem> findById(Long id);
    List<MenuItem> findAll();
    List<MenuItem> findByCategoryId(Long categoryId);
    List<MenuItem> findAvailableItems();
    List<MenuItem> findPopularItems(int limit);
    MenuItem save(MenuItem menuItem);
    void update(MenuItem menuItem);
    void delete(Long id);
    void updateAvailability(Long id, boolean available);
}