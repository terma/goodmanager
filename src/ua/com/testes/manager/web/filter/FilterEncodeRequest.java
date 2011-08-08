package ua.com.testes.manager.web.filter;


import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;


public class FilterEncodeRequest
        implements Filter {

    public void destroy() {

    }


    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;

        httpRequest.setCharacterEncoding("utf-8");

        chain.doFilter(request, response);

    }


    public void init(FilterConfig config)
            throws ServletException {

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.FilterEncodeRequest
 * JD-Core Version:    0.6.0
 */