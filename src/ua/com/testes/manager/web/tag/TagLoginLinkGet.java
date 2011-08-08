package ua.com.testes.manager.web.tag;


import javax.servlet.jsp.tagext.TagSupport;
import java.io.IOException;


public class TagLoginLinkGet extends TagSupport {
    private String always;
    private String value;


    private void write(String link) {

        try {

            this.pageContext.getOut().print(link);

        } catch (IOException exception) {

            throw new IllegalStateException(exception);

        }

    }


    private boolean isUseAlways() {

        return "true".equalsIgnoreCase(this.always);

    }


    public final int doStartTag() {
//     if (isUseAlways())
//       write(UtilLoginNtlm.convert(this.value));
//     else {
//       write(UtilLoginNtlm.convertIsForRequest(this.value, (HttpServletRequest)this.pageContext.getRequest()));
//     }

        return 1;

    }


    public String getAlways() {

        return this.always;

    }


    public void setAlways(String always) {

        this.always = always;

    }


    public String getValue() {

        return this.value;

    }


    public void setValue(String value) {

        this.value = value;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.tag.TagLoginLinkGet
 * JD-Core Version:    0.6.0
 */