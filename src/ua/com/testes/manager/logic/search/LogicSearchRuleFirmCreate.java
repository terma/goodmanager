package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmCreate;
import ua.com.testes.manager.util.UtilCalendar;

import java.util.Date;


final class LogicSearchRuleFirmCreate
        implements LogicSearchRule {
    private final Date start;
    private final Date finish;


    public LogicSearchRuleFirmCreate(EntitySearchRule entity) {

        this.start = ((EntitySearchRuleFirmCreate) entity).start;

        this.finish = ((EntitySearchRuleFirmCreate) entity).finish;

    }


    public boolean accept(Object serializable) {

        if ((serializable instanceof EntityFirm)) {

            EntityFirm entity = (EntityFirm) serializable;

            return UtilCalendar.inPeriod(this.start, this.finish, entity.getCreate());

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleFirmCreate
 * JD-Core Version:    0.6.0
 */