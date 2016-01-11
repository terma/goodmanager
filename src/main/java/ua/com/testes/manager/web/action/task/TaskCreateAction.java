package ua.com.testes.manager.web.action.task;


import net.sourceforge.stripes.action.*;
import net.sourceforge.stripes.validation.Validate;
import ua.com.testes.manager.logic.task.LogicTask;
import ua.com.testes.manager.web.action.AbstractAction;

import java.util.Date;
import java.util.List;


@UrlBinding("/security/task/create.action")
public class TaskCreateAction extends AbstractAction {


    @Validate(required = true, minlength = 1)
    public String name;
    public String description;


    @Validate(required = true)
    public List<Integer> executerIds;
    public List<Date> executorMusts;


    @DontValidate

    @DefaultHandler
    public Resolution show() {

        return new ForwardResolution("/web-inf/page/security/task/add.jsp");

    }


    public Resolution execute() {

        LogicTask.create(getLoginUserId(), this.name, this.description, this.executerIds, this.executorMusts);

        return new RedirectResolution("/web-inf/page/security/task/view.action");

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.action.task.TaskCreateAction
 * JD-Core Version:    0.6.0
 */