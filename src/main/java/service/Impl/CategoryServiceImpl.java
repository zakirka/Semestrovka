package service.Impl;



import dao.CategoryDAO;
import dao.Impl.CategoryDAOImpl;
import model.Category;
import service.CategoryService;

import java.util.List;
import java.util.Optional;

public class CategoryServiceImpl implements CategoryService {
    private final CategoryDAO categoryDAO;

    public CategoryServiceImpl() {
        this.categoryDAO = new CategoryDAOImpl(); // Создаем DAO внутри
    }

    public CategoryServiceImpl(CategoryDAO categoryDAO) {
        this.categoryDAO = categoryDAO;
    }

    @Override
    public Optional<Category> findById(Long id) {
        return categoryDAO.findById(id);
    }

    @Override
    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    @Override
    public List<Category> findAllWithMenuItemsCount() {
        return categoryDAO.findAllWithMenuItemsCount();
    }

    @Override
    public Category save(Category category) {
        validateCategory(category);
        return categoryDAO.save(category);
    }

    @Override
    public void update(Category category) {
        validateCategory(category);
        categoryDAO.update(category);
    }

    @Override
    public void delete(Long id) {
        categoryDAO.delete(id);
    }

    @Override
    public boolean isNameAvailable(String name) {
        return !categoryDAO.existsByName(name);
    }

    @Override
    public void validateCategory(Category category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name is required");
        }
        if (category.getName().length() < 2 || category.getName().length() > 50) {
            throw new IllegalArgumentException("Category name must be between 2 and 50 characters");
        }
    }
}