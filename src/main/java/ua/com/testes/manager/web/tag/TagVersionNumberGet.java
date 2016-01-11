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


    public final int doStartTag() {

        write(this.pageContext.getServletContext().getInitParameter("version"));

        return 1;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.tag.TagVersionNumberGet
 * JD-Core Version:    0.6.0
 */