package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmDelete;
import ua.com.testes.manager.util.UtilCalendar;

import java.io.Serializable;
import java.util.Date;


final class LogicSearchRuleFirmDelete
        implements LogicSearchRule {
    private final Date start;
    private final Date finish;


    public LogicSearchRuleFirmDelete(EntitySearchRule entity) {

        this.start = ((EntitySearchRuleFirmDelete) entity).start;

        this.finish = ((EntitySearchRuleFirmDelete) entity).finish;

    }


    public boolean accept(Serializable serializable) {

        if ((serializable instanceof EntityFirm)) {

            EntityFirm entity = (EntityFirm) serializable;

            return UtilCalendar.inPeriod(this.start, this.finish, entity.getDelete());

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleFirmDelete
 * JD-Core Version:    0.6.0
 */