package ua.com.testes.manager.web.action.task;


import net.sourceforge.stripes.action.*;
import net.sourceforge.stripes.validation.ValidateNestedProperties;
import ua.com.testes.manager.entity.task.EntityTask;
import ua.com.testes.manager.logic.task.LogicTask;
import ua.com.testes.manager.web.action.AbstractAction;


@UrlBinding("/security/task/delete.action")
public class TaskDeleteAction extends AbstractAction {


    @ValidateNestedProperties({@net.sourceforge.stripes.validation.Validate(field = "id", required = true)})
    public EntityTask task;


    @DontValidate

    @DefaultHandler
    public Resolution confirm() {

        this.task = LogicTask.get(getLoginUserId(), this.task.id.intValue());

        return new ForwardResolution("/web-inf/page/security/task/deleteconfirm.action");

    }


    public Resolution execute() {

        LogicTask.delete(getLoginUserId(), this.task.id.intValue());

        return new RedirectResolution("/web-inf/page/security/task/view.action");

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.action.task.TaskDeleteAction
 * JD-Core Version:    0.6.0
 */