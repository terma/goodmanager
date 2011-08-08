package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactRepeat;
import ua.com.testes.manager.util.UtilCalendar;

import java.io.Serializable;
import java.util.Date;


final class LogicSearchRuleContactRepeat
        implements LogicSearchRule {
    private final Date start;
    private final Date finish;


    public LogicSearchRuleContactRepeat(EntitySearchRule entity) {

        this.start = ((EntitySearchRuleContactRepeat) entity).start;

        this.finish = ((EntitySearchRuleContactRepeat) entity).finish;

    }


    public boolean accept(Serializable serializable) {

        if ((serializable instanceof EntityContact)) {

            EntityContact entity = (EntityContact) serializable;

            return UtilCalendar.inPeriod(this.start, this.finish, entity.getRepeat());

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleContactRepeat
 * JD-Core Version:    0.6.0
 */