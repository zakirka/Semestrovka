package dao;

import model.Category;

import java.util.List;
import java.util.Optional;

public interface CategoryDAO extends BaseDAO<Category> {
    Optional<Category> findById(Long id);

    List<Category> findAll();

    List<Category> findAllWithMenuItemsCount();

    Category save(Category category);

    void update(Category category);

    void delete(Long id);

    boolean existsByName(String name);
}
