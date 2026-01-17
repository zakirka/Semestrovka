package service;

import model.MenuItem;
import java.util.List;
import java.util.Optional;

public interface MenuItemService {
    Optional<MenuItem> findById(Long id);
    List<MenuItem> findAll();
    MenuItem save(MenuItem menuItem);
    void update(MenuItem menuItem);
    void delete(Long id);

    List<MenuItem> findByCategoryId(Long categoryId);
    List<MenuItem> findAvailableItems();
    List<MenuItem> findPopularItems(int limit);
    void updateAvailability(Long id, boolean available);

    boolean validateMenuItem(MenuItem menuItem);
}