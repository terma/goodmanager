package ua.com.testes.manager.web.filter.upload;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

public final class UploadRequest extends HttpServletRequestWrapper {
    public static final String UPLOAD_REQUEST_ATTRIBUTE = "UPLOAD_REQUEST_ATTRIBUTE";
       private Upload su = new Upload();

    private static String[] concatArrays(String[] s1, String[] s2) {

        String[] mix = new String[s1.length + s2.length];

        System.arraycopy(s1, 0, mix, 0, s1.length);

        System.arraycopy(s2, 0, mix, s1.length, s2.length);

        return mix;
    }

    public UploadRequest(HttpServletRequest request, HttpServletResponse response, ServletContext context) {

        super(request);

        this.su.setCharset("UTF8");

        this.su.init(new DummyServletConfig(context), request, response);
        try {

            this.su.upload();
        } catch (Exception ex) {

            ex.printStackTrace();
        }

        request.setAttribute("UPLOAD_REQUEST_ATTRIBUTE", this.su.getFiles());
    }

    public final String getParameter(String name) {

        String val = super.getParameter(name);

        if (val != null) return val;

        return this.su.getRequest().getParameter(name);
    }

    public final Map getParameterMap() {

        throw new UnsupportedOperationException();
    }

    public final Enumeration getParameterNames() {

        Set pns = new TreeSet();

        for (Enumeration e = super.getParameterNames(); e.hasMoreElements(); ) {

            System.out.println("Add request parameter!");

            pns.add((String) e.nextElement());
        }

        for (Enumeration e = this.su.getRequest().getParameterNames(); e.hasMoreElements(); ) {

            System.out.println("Add file parameter!");

            pns.add(e.nextElement());
        }

        return new Vector(pns).elements();
    }

    public final String[] getParameterValues(String name) {

        String[] sv = super.getParameterValues(name);

        String[] uv = this.su.getRequest().getParameterValues(name);

        if ((sv == null) && (uv == null))
 return null;

        if (sv == null)
 return uv;

        if (uv == null) {

            return sv;
        }

        return concatArrays(sv, uv);
    }

    public final void upload(Upload su) {

        this.su = su;
    }

    private final class DummyServletConfig
            implements ServletConfig {
        ServletContext ctx;

        DummyServletConfig(ServletContext ctx) {

            this.ctx = ctx;
        }

        public String getServletName() {

            return null;
        }

        public ServletContext getServletContext() {

            return this.ctx;
        }

        public String getInitParameter(String string) {

            return null;
        }

        public Enumeration getInitParameterNames() {

            return null;
        }
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.upload.UploadRequest
 * JD-Core Version:    0.6.0
 */