package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Enums.UserRole;

import java.io.IOException;

public abstract class BaseServlet extends HttpServlet {

    protected void forwardToJsp(String jspPath, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/" + jspPath).forward(request, response);
    }

    protected void redirectTo(String path, HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + path);
    }

    protected boolean isUserLoggedIn(HttpServletRequest request) {
        return request.getSession().getAttribute("user") != null;
    }

    protected boolean isUserAdmin(HttpServletRequest request) {
        Object user = request.getSession().getAttribute("user");
        return user != null && ((model.User) user).getRole() == UserRole.ADMIN;
    }

    protected Long getCurrentUserId(HttpServletRequest request) {
        Object user = request.getSession().getAttribute("user");
        return user != null ? ((model.User) user).getId() : null;
    }
}