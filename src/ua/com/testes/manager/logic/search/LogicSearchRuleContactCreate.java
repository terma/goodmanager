package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactCreate;
import ua.com.testes.manager.util.UtilCalendar;

import java.util.Date;


final class LogicSearchRuleContactCreate
        implements LogicSearchRule {
    private final Date start;
    private final Date finish;


    public LogicSearchRuleContactCreate(EntitySearchRule entity) {

        this.start = ((EntitySearchRuleContactCreate) entity).start;

        this.finish = ((EntitySearchRuleContactCreate) entity).finish;

    }


    public boolean accept(Object serializable) {

        if ((serializable instanceof EntityContact)) {

            EntityContact entity = (EntityContact) serializable;

            return UtilCalendar.inPeriod(this.start, this.finish, entity.create);

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleContactCreate
 * JD-Core Version:    0.6.0
 */