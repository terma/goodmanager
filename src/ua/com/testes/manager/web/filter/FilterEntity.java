package ua.com.testes.manager.web.filter;


import ua.com.testes.manager.entity.EntityManager;

import javax.servlet.*;
import java.io.IOException;


public final class FilterEntity implements Filter {

    @Override
    public void destroy() {

    }

    @Override
    public void doFilter(
            final ServletRequest request, final ServletResponse response,
            final FilterChain chain) throws ServletException, IOException {
        EntityManager.start();
        try {
            chain.doFilter(request, response);
        } finally {
            EntityManager.finish();
        }
    }

    @Override
    public void init(final FilterConfig config) throws ServletException {

    }

}