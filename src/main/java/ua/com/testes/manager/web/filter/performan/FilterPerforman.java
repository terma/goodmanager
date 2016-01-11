package ua.com.testes.manager.web.filter.performan;


import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;


public final class FilterPerforman
        implements Filter {

    public void destroy() {

    }


    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;

        PerformanState state = PerformanManager.start(httpRequest.getRequestURI());

        try {

            chain.doFilter(request, response);

        } finally {

            state.finish();

        }

    }


    public void init(FilterConfig config)
            throws ServletException {

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.performan.FilterPerforman
 * JD-Core Version:    0.6.0
 */