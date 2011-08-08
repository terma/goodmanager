package ua.com.testes.manager.web.filter;


import ua.com.testes.manager.entity.EntityManager;

import javax.servlet.*;
import java.io.IOException;


public final class FilterEntity
        implements Filter {

    public void destroy() {

    }


    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        EntityManager.start();

        try {

            chain.doFilter(request, response);

            EntityManager.finish(true);

        } catch (RuntimeException exception) {

            EntityManager.finish(false);

            throw exception;

        }

    }


    public void init(FilterConfig config)
            throws ServletException {

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.FilterEntity
 * JD-Core Version:    0.6.0
 */