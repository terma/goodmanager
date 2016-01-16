package ua.com.testes.manager.web.tag;


import javax.servlet.jsp.tagext.TagSupport;
import java.io.IOException;


public class TagVersionNumberGet extends TagSupport {

    private void write(String text) {
        try {
            this.pageContext.getOut().print(text);
        } catch (IOException exception) {
            throw new IllegalStateException(exception);
        }

    }

    @Override
    public final int doStartTag() {
        write(this.pageContext.getServletContext().getInitParameter("version"));
        return 1;
    }

}