package dao;

import java.util.List;
import java.util.Optional;

public interface BaseDAO<T> {
    Optional<T> findById(Long id);
    List<T> findAll();
    T save(T entity);
    void update(T entity);
    void delete(Long id);
}
