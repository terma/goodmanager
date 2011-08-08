package ua.com.testes.manager.filter.upload;


import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


public final class UploadFilter extends HttpServlet
        implements Filter {
    private FilterConfig filterConfig = null;


    public final void init(FilterConfig fc) {

        this.filterConfig = fc;

    }


    public final void doFilter(ServletRequest rq, ServletResponse rs, FilterChain fch) throws ServletException, IOException {

        HttpServletResponse httprq = (HttpServletResponse) rs;

        HttpServletRequest httprs = (HttpServletRequest) rq;

        String ct = httprs.getHeader("Content-Type");

        boolean isu = (httprs.getMethod().equalsIgnoreCase("POST")) && (ct != null) && (ct.trim().toLowerCase().startsWith("multipart/form-data".toLowerCase()));


        if (isu) {

            UploadRequest ur = new UploadRequest(httprs, httprq, this.filterConfig.getServletContext());


            fch.doFilter(ur, httprq);

        } else {

            fch.doFilter(httprs, httprq);

        }

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.filter.upload.UploadFilter
 * JD-Core Version:    0.6.0
 */