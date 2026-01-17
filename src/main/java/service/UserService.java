package service;

import model.User;
import model.Enums.UserRole;

import java.util.List;
import java.util.Optional;

public interface UserService extends BaseService<User> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    User register(User user, String password);

    boolean authenticate(String username, String password);

    void changePassword(Long userId, String oldPassword, String newPassword);
    List<User> findByRole(UserRole role);
    boolean isUsernameAvailable(String username);
    boolean isEmailAvailable(String email);
}

