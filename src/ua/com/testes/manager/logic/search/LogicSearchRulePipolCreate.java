package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRulePipolCreate;
import ua.com.testes.manager.util.UtilCalendar;

import java.io.Serializable;
import java.util.Date;


final class LogicSearchRulePipolCreate
        implements LogicSearchRule {
    private final Date start;
    private final Date finish;


    public LogicSearchRulePipolCreate(EntitySearchRule entity) {

        this.start = ((EntitySearchRulePipolCreate) entity).start;

        this.finish = ((EntitySearchRulePipolCreate) entity).finish;

    }


    public boolean accept(Serializable serializable) {

        if ((serializable instanceof EntityPipol)) {

            EntityPipol entity = (EntityPipol) serializable;

            return UtilCalendar.inPeriod(this.start, this.finish, entity.getCreate());

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRulePipolCreate
 * JD-Core Version:    0.6.0
 */