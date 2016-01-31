package ua.com.testes.manager.web.servlet;

import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.web.page.PageLoginError;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

public class LoginResultServlet extends HttpServlet {

    public static final long BLOCK_DELAY = 1800000L;
    public static final int BLOCK_COUNT = 3;
    private static Integer anonymousUserId = null;

    public static Integer getAnonymousUserId() {
        return anonymousUserId;
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        HttpSession session = request.getSession(true);

        String login = request.getParameter("login");
        String password = request.getParameter("password");
        String originalUrl = request.getParameter("originalUrl");

        if (login != null && password != null) {
            List users = ua.com.testes.manager.entity.EntityManager.list(
                    "select user from ua.com.testes.manager.entity.user.EntityUser as user where user.login = :p0",
                    login.toLowerCase());

            if (!users.isEmpty()) {
                final EntityUser user = (EntityUser) users.get(0);

                if (user.getPassword().equals(password)) {
                    if (user.isBlock()) {
                        request.setAttribute("error", PageLoginError.BLOCK);
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                    } else {
                        session.setAttribute("userId", user.getId());
                        response.sendRedirect(originalUrl);
                    }
                } else {
                    Integer passwordError = (Integer) session.getAttribute("passwordError");
                    if (passwordError == null) passwordError = 0;
                    passwordError = passwordError + 1;

                    session.setAttribute("passwordError", passwordError);

                    if (passwordError > 3) {
                        request.setAttribute("error", PageLoginError.BLOCK);

                        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {
                            public Object execute(javax.persistence.EntityManager manager) {
                                EntityUser userForBlock = manager.find(EntityUser.class, user.getId());
                                userForBlock.setBlock(new Date(System.currentTimeMillis() + 1800000L));
                                return null;
                            }
                        });
                    } else {
                        request.setAttribute("error", PageLoginError.NOT_CURRENT);
                    }
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", PageLoginError.NOT_CURRENT);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("/login.jsp");
        }
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        String anonymousUserIdString = config.getServletContext().getInitParameter("anonymoususerid");
        if (anonymousUserIdString != null)
            try {
                anonymousUserId = Integer.parseInt(anonymousUserIdString);
            } catch (NumberFormatException exception) {
            }
    }

}
