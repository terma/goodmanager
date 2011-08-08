package ua.com.testes.manager.web.tag;


import javax.servlet.jsp.tagext.TagSupport;
import java.io.IOException;


public final class TagLoginInputGet extends TagSupport {

    private void write(String link) {

        try {

            this.pageContext.getOut().print(link);

        } catch (IOException exception) {

            throw new IllegalStateException(exception);

        }

    }


    public final int doStartTag() {
//     try {
//       if (UtilLoginNtlm.isUseForRequest((HttpServletRequest)this.pageContext.getRequest()))
//         write("<input type=\"hidden\" name=\"loginntlmuse\" value=\"true\">\n");
//     }
//     catch (UnsupportedEncodingException exception) {
//       throw new IllegalArgumentException(exception);
//     }

        return 1;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.tag.TagLoginInputGet
 * JD-Core Version:    0.6.0
 */