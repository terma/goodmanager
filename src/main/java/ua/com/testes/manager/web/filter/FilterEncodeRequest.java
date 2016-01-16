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