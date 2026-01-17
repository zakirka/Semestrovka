package dao;

import model.User;

import java.util.Optional;

public interface UserDAO extends BaseDAO<User> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    void updatePassword(Long userId, String newPasswordHash);

}
