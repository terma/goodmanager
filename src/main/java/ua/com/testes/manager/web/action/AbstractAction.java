package ua.com.testes.manager.web.action;


import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;


public abstract class AbstractAction
        implements ActionBean {
    private ActionBeanContext actionBeanContext;


    public void setContext(ActionBeanContext actionBeanContext) {

        this.actionBeanContext = actionBeanContext;

    }


    public ActionBeanContext getContext() {

        return this.actionBeanContext;

    }


    protected int getLoginUserId() {

        return Integer.parseInt((String) getContext().getRequest().getAttribute("userId"));

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.action.AbstractAction
 * JD-Core Version:    0.6.0
 */