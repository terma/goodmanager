package ua.com.testes.manager.web.filter.upload;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

public final class UploadRequest extends HttpServletRequestWrapper {
    public static final String UPLOAD_REQUEST_ATTRIBUTE = "UPLOAD_REQUEST_ATTRIBUTE";
    /*  27 */   private Upload su = new Upload();

    private static String[] concatArrays(String[] s1, String[] s2) {
/*  21 */
        String[] mix = new String[s1.length + s2.length];
/*  22 */
        System.arraycopy(s1, 0, mix, 0, s1.length);
/*  23 */
        System.arraycopy(s2, 0, mix, s1.length, s2.length);
/*  24 */
        return mix;
    }

    public UploadRequest(HttpServletRequest request, HttpServletResponse response, ServletContext context) {
/*  30 */
        super(request);
/*  31 */
        this.su.setCharset("UTF8");
/*  32 */
        this.su.init(new DummyServletConfig(context), request, response);
        try {
/*  34 */
            this.su.upload();
        } catch (Exception ex) {
/*  36 */
            ex.printStackTrace();
        }
/*  38 */
        request.setAttribute("UPLOAD_REQUEST_ATTRIBUTE", this.su.getFiles());
    }

    public final String getParameter(String name) {
/*  42 */
        String val = super.getParameter(name);
/*  43 */
        if (val != null) return val;
/*  44 */
        return this.su.getRequest().getParameter(name);
    }

    public final Map getParameterMap() {
/*  48 */
        throw new UnsupportedOperationException();
    }

    public final Enumeration getParameterNames() {
/*  57 */
        Set pns = new TreeSet();
/*  58 */
        for (Enumeration e = super.getParameterNames(); e.hasMoreElements(); ) {
/*  59 */
            System.out.println("Add request parameter!");
/*  60 */
            pns.add((String) e.nextElement());
        }
/*  62 */
        for (Enumeration e = this.su.getRequest().getParameterNames(); e.hasMoreElements(); ) {
/*  63 */
            System.out.println("Add file parameter!");
/*  64 */
            pns.add(e.nextElement());
        }
/*  66 */
        return new Vector(pns).elements();
    }

    public final String[] getParameterValues(String name) {
/*  70 */
        String[] sv = super.getParameterValues(name);
/*  71 */
        String[] uv = this.su.getRequest().getParameterValues(name);
/*  72 */
        if ((sv == null) && (uv == null))
/*  73 */ return null;
/*  74 */
        if (sv == null)
/*  75 */ return uv;
/*  76 */
        if (uv == null) {
/*  77 */
            return sv;
        }
/*  79 */
        return concatArrays(sv, uv);
    }

    public final void upload(Upload su) {

        this.su = su;
    }

    private final class DummyServletConfig
            implements ServletConfig {
        ServletContext ctx;

        DummyServletConfig(ServletContext ctx) {
/*  86 */
            this.ctx = ctx;
        }

        public String getServletName() {
/*  90 */
            return null;
        }

        public ServletContext getServletContext() {
/*  94 */
            return this.ctx;
        }

        public String getInitParameter(String string) {
/*  98 */
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