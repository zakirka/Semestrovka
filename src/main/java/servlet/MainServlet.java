package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.MenuItemService;
import service.Impl.MenuItemServiceImpl;

import java.io.IOException;

@WebServlet("")
public class MainServlet extends HttpServlet {
    private MenuItemService menuItemService;

    @Override
    public void init() throws ServletException {
        this.menuItemService = new MenuItemServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            var popularItems = menuItemService.findPopularItems(6);
            request.setAttribute("popularItems", popularItems);

            var availableItems = menuItemService.findAvailableItems();
            request.setAttribute("availableItems", availableItems);


            request.setAttribute("title", "Главная");

            request.getRequestDispatcher("/WEB-INF/views/main.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Ошибка загрузки данных: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}