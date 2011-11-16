package ua.com.testes.manager.filter;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.page.PageLoginError;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


public final class FilterLoginCheck
        implements Filter {

    public void destroy() {

    }


    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;

        httpRequest.setCharacterEncoding("utf-8");

        HttpSession session = httpRequest.getSession(true);

        HttpServletResponse httpResponse = (HttpServletResponse) response;

        Integer userId = (Integer) session.getAttribute("userId");

        if (userId != null) {

            EntityUser user = (EntityUser) EntityManager.find(EntityUser.class, userId);

            if (user.isBlock()) {

                httpRequest.setAttribute("error", PageLoginError.BLOCK);

                httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);

            } else {

                chain.doFilter(request, response);

            }

        } else {

            httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);

        }

    }


    public void init(FilterConfig config)
            throws ServletException {

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.filter.FilterLoginCheck
 * JD-Core Version:    0.6.0
 */