package ua.com.testes.manager.web.filter.performance;


import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;


public final class FilterPerformance implements Filter {

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        PerformanceState state = PerformanceManager.start(httpRequest.getRequestURI());
        try {
            chain.doFilter(request, response);
        } finally {
            state.finish();
        }
    }

    @Override
    public void init(FilterConfig config) throws ServletException {
    }

}