package ua.com.testes.manager.filter;

import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.page.PageLoginError;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

public final class FilterLogin
        implements Filter {
    public static final long BLOCK_DELAY = 1800000L;
    public static final int BLOCK_COUNT = 3;
    /*  21 */   private static boolean use = true;

    public void destroy() {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
/*  29 */
        if (use) {
/*  30 */
            HttpServletRequest httpRequest = (HttpServletRequest) request;
/*  31 */
            httpRequest.setCharacterEncoding("utf-8");
/*  32 */
            HttpSession session = httpRequest.getSession(true);
/*  33 */
            if (session.getAttribute("userId") == null) {
/*  34 */
                HttpServletResponse httpResponse = (HttpServletResponse) response;
/*  35 */
                String login = httpRequest.getParameter("login");
/*  36 */
                String password = httpRequest.getParameter("password");

/*  38 */
                if ((login != null) && (password != null)) {
/*  39 */
                    List users = ua.com.testes.manager.entity.EntityManager.list("select user from ua.com.testes.manager.entity.user.EntityUser as user where user.login = :p0", new Object[]{login.toLowerCase()});

/*  42 */
                    if (!users.isEmpty()) {
/*  43 */
                        final EntityUser user = (EntityUser) users.get(0);

/*  45 */
                        if (user.getPassword().equals(password)) {
/*  46 */
                            if (user.isBlock()) {
/*  47 */
                                httpRequest.setAttribute("error", PageLoginError.BLOCK);
/*  48 */
                                httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                            } else {
/*  51 */
                                session.setAttribute("userId", user.getId());
/*  52 */
                                String url = (String) session.getAttribute("url");
/*  53 */
                                if (url != null) {
/*  55 */
                                    httpResponse.sendRedirect(url);
                                }
/*  57 */
                                else chain.doFilter(request, response);
                            }
                        } else {
/*  62 */
                            Integer passwordError = (Integer) session.getAttribute("passwordError");
                            Integer localInteger1;
/*  63 */
                            if (passwordError == null) {
/*  64 */
                                passwordError = Integer.valueOf(0);
                            } else {
/*  66 */
                                localInteger1 = passwordError;
                                Integer localInteger2 = passwordError = Integer.valueOf(passwordError.intValue() + 1);
                            }
/*  68 */
                            session.setAttribute("passwordError", passwordError);

/*  70 */
                            if (passwordError.intValue() > 3) {
/*  71 */
                                httpRequest.setAttribute("error", PageLoginError.BLOCK);
/*  72 */
                                ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {
                                    public Object execute(javax.persistence.EntityManager manager) {
/*  75 */
                                        EntityUser userForBlock = (EntityUser) manager.find(EntityUser.class, user.getId());
/*  76 */
                                        userForBlock.setBlock(new Date(System.currentTimeMillis() + 1800000L));
/*  77 */
                                        return null;
                                    }
                                });
                            } else {
/*  82 */
                                httpRequest.setAttribute("error", PageLoginError.NOT_CORRENT);
                            }
/*  84 */
                            httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                        }
                    } else {
/*  87 */
                        httpRequest.setAttribute("error", PageLoginError.NOT_CORRENT);

/*  89 */
                        httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                    }
                } else {
/*  92 */
                    chain.doFilter(request, response);
                }
            } else {
/*  95 */
                chain.doFilter(request, response);
            }
        } else {
/*  99 */
            chain.doFilter(request, response);
        }
    }

    public void init(FilterConfig config) throws ServletException {

        String useString = config.getServletContext().getInitParameter("basicLoginUse");

        use = (useString == null) || ("true".equalsIgnoreCase(useString));
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.filter.FilterLogin
 * JD-Core Version:    0.6.0
 */