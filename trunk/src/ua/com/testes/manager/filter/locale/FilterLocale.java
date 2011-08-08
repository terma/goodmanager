package ua.com.testes.manager.filter.locale;


import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;


public final class FilterLocale
        implements Filter {
    public static final String SESSION_PARAMETER = "LOCALE_SESSION_PARAMETER";
    public static final String COOKIE_PARAMETER = "LOCALE_COOKIE_PARAMETER";


    public void destroy() {

    }


    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;


        chain.doFilter(new FilterLocaleRequest(httpRequest), response);

    }


    public void init(FilterConfig config)
            throws ServletException {

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.filter.locale.FilterLocale
 * JD-Core Version:    0.6.0
 */