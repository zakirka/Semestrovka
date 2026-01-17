package servlet;

import model.MenuItem;
import service.CartService;
import service.MenuService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {

    private CartService cartService = new CartService();
    private MenuService menuService = new MenuService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();
        HttpSession session = request.getSession();

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            switch (path) {
                case "/add":
                    Long menuItemId = Long.parseLong(request.getParameter("itemId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    MenuItem menuItem = menuService.getMenuItemById(menuItemId);

                    if (menuItem == null) {
                        out.print("{\"success\":false,\"error\":\"Item not found\"}");
                        break;
                    }

                    cartService.addItem(session, menuItem, quantity);
                    out.print("{\"success\":true}");
                    break;

                case "/update-quantity":
                    Long itemId = Long.parseLong(request.getParameter("itemId"));
                    int newQuantity = Integer.parseInt(request.getParameter("quantity"));
                    cartService.updateItemQuantity(session, itemId, newQuantity);
                    out.print("{\"success\":true}");
                    break;

                case "/remove":
                    Long removeId = Long.parseLong(request.getParameter("itemId"));
                    cartService.removeItem(session, removeId);
                    out.print("{\"success\":true}");
                    break;

                case "/clear":
                    cartService.clearCart(session);
                    out.print("{\"success\":true}");
                    break;

                default:
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"success\":false,\"error\":\"Unknown action\"}");
                    break;
            }
        } catch (Exception e) {
            out.print("{\"success\":false,\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
