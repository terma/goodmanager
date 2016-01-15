package ua.com.testes.manager.web.filter;

import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.web.page.PageLoginError;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

public final class FilterLogin implements Filter {

    public static final long BLOCK_DELAY = 1800000L;
    public static final int BLOCK_COUNT = 3;
    private static Integer anonymousUserId = null;
    private static boolean use = true;

    public static Integer getAnonymousUserId() {
        return anonymousUserId;
    }

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
        if (use) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            httpRequest.setCharacterEncoding("utf-8");
            HttpSession session = httpRequest.getSession(true);

            if (session.getAttribute("userId") == null) {
                HttpServletResponse httpResponse = (HttpServletResponse) response;
                String login = httpRequest.getParameter("login");
                String password = httpRequest.getParameter("password");

                if ((login != null) && (password != null)) {
                    List users = ua.com.testes.manager.entity.EntityManager.list("select user from ua.com.testes.manager.entity.user.EntityUser as user where user.login = :p0", new Object[]{login.toLowerCase()});

                    if (!users.isEmpty()) {
                        final EntityUser user = (EntityUser) users.get(0);

                        if (user.getPassword().equals(password)) {
                            if (user.isBlock()) {
                                httpRequest.setAttribute("error", PageLoginError.BLOCK);
                                httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                            } else {
                                session.setAttribute("userId", user.getId());
                                chain.doFilter(request, response);
                            }
                        } else {
                            Integer passwordError = (Integer) session.getAttribute("passwordError");
                            Integer localInteger1;

                            if (passwordError == null) {
                                passwordError = Integer.valueOf(0);
                            } else {
                                localInteger1 = passwordError;
                                Integer localInteger2 = passwordError = passwordError.intValue() + 1;
                            }

                            session.setAttribute("passwordError", passwordError);

                            if (passwordError.intValue() > 3) {
                                httpRequest.setAttribute("error", PageLoginError.BLOCK);

                                ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {
                                    public Object execute(javax.persistence.EntityManager manager) {
                                        EntityUser userForBlock = manager.find(EntityUser.class, user.getId());
                                        userForBlock.setBlock(new Date(System.currentTimeMillis() + 1800000L));
                                        return null;
                                    }
                                });
                            } else {
                                httpRequest.setAttribute("error", PageLoginError.NOT_CORRENT);
                            }
                            httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                        }
                    } else {
                        httpRequest.setAttribute("error", PageLoginError.NOT_CORRENT);
                        httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                    }
                } else {
                    chain.doFilter(request, response);
                }
            } else {
                chain.doFilter(request, response);
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    public void init(FilterConfig config) throws ServletException {
        String useString = config.getServletContext().getInitParameter("basicLoginUse");
        use = (useString == null) || ("true".equalsIgnoreCase(useString));
        String anonymousUserIdString = config.getServletContext().getInitParameter("anonymoususerid");
        if (anonymousUserIdString != null)
            try {
                anonymousUserId = Integer.parseInt(anonymousUserIdString);
            } catch (NumberFormatException exception) {
            }
    }
}