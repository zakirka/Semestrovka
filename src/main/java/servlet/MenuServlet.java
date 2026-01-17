package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.MenuItemService;
import service.CategoryService;
import service.Impl.MenuItemServiceImpl;
import service.Impl.CategoryServiceImpl;

import java.io.IOException;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    private MenuItemService menuItemService;
    private CategoryService categoryService;
    @Override
    public void init() throws ServletException {
        this.menuItemService = new MenuItemServiceImpl();
        this.categoryService = new CategoryServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            var menuItems = menuItemService.findAll();
            var categories = categoryService.findAll();

            request.setAttribute("menuItems", menuItems);
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/WEB-INF/views/menu/list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Ошибка загрузки меню: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}