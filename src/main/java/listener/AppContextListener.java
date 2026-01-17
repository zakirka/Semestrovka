package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import dao.OrderDAO;
import dao.OrderItemDAO;
import dao.MenuItemDAO;
import dao.Impl.OrderDAOImpl;
import dao.Impl.OrderItemDAOImpl;
import dao.Impl.MenuItemDAOImpl;
import service.OrderService;
import service.Impl.OrderServiceImpl;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            OrderDAO orderDAO = new OrderDAOImpl();
            OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
            MenuItemDAO menuItemDAO = new MenuItemDAOImpl();

            OrderService orderService = new OrderServiceImpl(orderDAO, orderItemDAO, menuItemDAO);

            sce.getServletContext().setAttribute("orderService", orderService);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}