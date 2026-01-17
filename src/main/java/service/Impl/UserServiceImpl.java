package service.Impl;

import dao.UserDAO;
import dao.Impl.UserDAOImpl;
import model.User;
import model.Enums.UserRole;
import service.UserService;
import util.DatabaseUtil;
import util.PasswordHasher;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class UserServiceImpl implements UserService {
    private UserDAO userDAO;
    private Connection connection;

    public UserServiceImpl() {
        try {
            this.connection = DatabaseUtil.getConnection();
            this.userDAO = new UserDAOImpl(connection);
        } catch (SQLException e) {
            throw new RuntimeException("Error initializing UserDAO", e);
        }
    }

    @Override
    public boolean authenticate(String username, String password) {
        Optional<User> userOpt = userDAO.findByUsername(username);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            PasswordHasher passwordHasher = new PasswordHasher();
            return passwordHasher.verifyPassword(password, user.getPasswordHash());
        }
        return false;
    }

    @Override
    public User register(User user, String password) {
        if (!isUsernameAvailable(user.getUsername())) {
            throw new RuntimeException("Пользователь с таким именем уже существует");
        }

        if (!isEmailAvailable(user.getEmail())) {
            throw new RuntimeException("Пользователь с таким email уже существует");
        }

        PasswordHasher passwordHasher = new PasswordHasher();
        user.setPasswordHash(passwordHasher.hashPassword(password));

        if (user.getRole() == null) {
            user.setRole(UserRole.CUSTOMER);
        }
        if (user.getCreatedAt() == null) {
            user.setCreatedAt(LocalDateTime.now());
        }
        user.setActive(true);

        return userDAO.save(user);
    }

    @Override
    public boolean isUsernameAvailable(String username) {
        return !userDAO.existsByUsername(username);
    }

    @Override
    public boolean isEmailAvailable(String email) {
        return !userDAO.existsByEmail(email);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    @Override
    public Optional<User> findById(Long id) {
        return userDAO.findById(id);
    }

    @Override
    public List<User> findAll() {
        return userDAO.findAll();
    }

    @Override
    public User save(User user) {
        return userDAO.save(user);
    }

    @Override
    public void update(User user) {
        userDAO.update(user);
    }

    @Override
    public void delete(Long id) {
        userDAO.delete(id);
    }

    @Override
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            PasswordHasher passwordHasher = new PasswordHasher();

            if (passwordHasher.verifyPassword(oldPassword, user.getPasswordHash())) {
                String newPasswordHash = passwordHasher.hashPassword(newPassword);
                userDAO.updatePassword(userId, newPasswordHash);
            } else {
                throw new RuntimeException("Неверный старый пароль");
            }
        } else {
            throw new RuntimeException("Пользователь не найден");
        }
    }

    @Override
    public List<User> findByRole(UserRole role) {
        return findAll().stream()
                .filter(user -> user.getRole() == role)
                .toList();
    }
}