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

public final class FilterLogin
        implements Filter {
    public static final long BLOCK_DELAY = 1800000L;
    public static final int BLOCK_COUNT = 3;
    /*  21 */   private static Integer anonymousUserId = null;
    /*  22 */   private static boolean use = true;

    public static Integer getAnonymousUserId() {
/*  25 */
        return anonymousUserId;
    }

    public void destroy() {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
/*  34 */
        if (use) {
/*  35 */
            HttpServletRequest httpRequest = (HttpServletRequest) request;
/*  36 */
            httpRequest.setCharacterEncoding("utf-8");
/*  37 */
            HttpSession session = httpRequest.getSession(true);
/*  38 */
            if (session.getAttribute("userId") == null) {
/*  39 */
                HttpServletResponse httpResponse = (HttpServletResponse) response;
/*  40 */
                String login = httpRequest.getParameter("login");
/*  41 */
                String password = httpRequest.getParameter("password");

/*  43 */
                if ((login != null) && (password != null)) {
/*  44 */
                    List users = ua.com.testes.manager.entity.EntityManager.list("select user from ua.com.testes.manager.entity.user.EntityUser as user where user.login = :p0", new Object[]{login.toLowerCase()});

/*  47 */
                    if (!users.isEmpty()) {
/*  48 */
                        final EntityUser user = (EntityUser) users.get(0);

/*  50 */
                        if (user.getPassword().equals(password)) {
/*  51 */
                            if (user.isBlock()) {
/*  52 */
                                httpRequest.setAttribute("error", PageLoginError.BLOCK);
/*  53 */
                                httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                            } else {
/*  56 */
                                session.setAttribute("userId", user.getId());
/*  57 */
                                chain.doFilter(request, response);
                            }
                        } else {
/*  61 */
                            Integer passwordError = (Integer) session.getAttribute("passwordError");
                            Integer localInteger1;
/*  62 */
                            if (passwordError == null) {
/*  63 */
                                passwordError = Integer.valueOf(0);
                            } else {
/*  65 */
                                localInteger1 = passwordError;
                                Integer localInteger2 = passwordError = Integer.valueOf(passwordError.intValue() + 1);
                            }
/*  67 */
                            session.setAttribute("passwordError", passwordError);

/*  69 */
                            if (passwordError.intValue() > 3) {
/*  70 */
                                httpRequest.setAttribute("error", PageLoginError.BLOCK);
/*  71 */
                                ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {
                                    public Object execute(javax.persistence.EntityManager manager) {
/*  74 */
                                        EntityUser userForBlock = (EntityUser) manager.find(EntityUser.class, user.getId());
/*  75 */
                                        userForBlock.setBlock(new Date(System.currentTimeMillis() + 1800000L));
/*  76 */
                                        return null;
                                    }
                                });
                            } else {
/*  81 */
                                httpRequest.setAttribute("error", PageLoginError.NOT_CORRENT);
                            }
/*  83 */
                            httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                        }
                    } else {
/*  86 */
                        httpRequest.setAttribute("error", PageLoginError.NOT_CORRENT);

/*  88 */
                        httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                    }
                } else {
/*  91 */
                    chain.doFilter(request, response);
                }
            } else {
/*  94 */
                chain.doFilter(request, response);
            }
        } else {
/*  98 */
            chain.doFilter(request, response);
        }
    }

    public void init(FilterConfig config) throws ServletException {

        String useString = config.getServletContext().getInitParameter("basicLoginUse");

        use = (useString == null) || ("true".equalsIgnoreCase(useString));

        String anonymousUserIdString = config.getServletContext().getInitParameter("anonymoususerid");

        if (anonymousUserIdString != null)
            try {

                anonymousUserId = Integer.valueOf(Integer.parseInt(anonymousUserIdString));
            } catch (NumberFormatException exception) {
            }
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.FilterLogin
 * JD-Core Version:    0.6.0
 */