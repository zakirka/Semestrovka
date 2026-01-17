package service;

import model.Category;
import service.BaseService;

import java.util.List;
import java.util.Optional;

public interface CategoryService extends BaseService<Category> {
    List<Category> findAllWithMenuItemsCount();
    boolean isNameAvailable(String name);
    void validateCategory(Category category);
}