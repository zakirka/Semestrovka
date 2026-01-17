package filter;

import model.User;
import model.Enums.UserRole;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/auth/login",
            "/auth/register",
            "/css/",
            "/js/",
            "/images/",
            "/menu"
    );

    private static final List<String> ADMIN_PATHS = Arrays.asList(
            "/admin"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (!isLoggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login");
            return;
        }

        if (isAdminPath(path)) {
            User user = (User) session.getAttribute("user");


            System.out.println("DEBUG AuthFilter: Checking admin access for user: " + user.getUsername());
            System.out.println("DEBUG AuthFilter: User role: " + user.getRole());
            System.out.println("DEBUG AuthFilter: Required role: ADMIN");
            System.out.println("DEBUG AuthFilter: Is admin? " + (user.getRole() == UserRole.ADMIN));

            if (user.getRole() != UserRole.ADMIN) {
                System.out.println("DEBUG AuthFilter: Access denied - user is not ADMIN");
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return PUBLIC_PATHS.stream().anyMatch(path::startsWith);
    }

    private boolean isAdminPath(String path) {
        return ADMIN_PATHS.stream().anyMatch(path::startsWith);
    }

    @Override
    public void destroy() {
    }
}