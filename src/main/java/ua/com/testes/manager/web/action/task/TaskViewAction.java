package ua.com.testes.manager.web.action.task;


import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;
import ua.com.testes.manager.entity.task.EntityTask;
import ua.com.testes.manager.logic.task.LogicTask;
import ua.com.testes.manager.web.action.AbstractAction;

import java.util.List;


@UrlBinding("/security/task/execute/view.action")
public class TaskViewAction extends AbstractAction {
    public List<EntityTask> tasks;


    public Resolution execute() {

        this.tasks = LogicTask.getForExecute(getLoginUserId());

        return new ForwardResolution("/web-inf/page/security/task/view.jsp");

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.action.task.TaskViewAction
 * JD-Core Version:    0.6.0
 */