package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactDelete;
import ua.com.testes.manager.util.UtilCalendar;

import java.io.Serializable;
import java.util.Date;


final class LogicSearchRuleContactDelete
        implements LogicSearchRule {
    private final Date start;
    private final Date finish;


    public LogicSearchRuleContactDelete(EntitySearchRule entity) {

        this.start = ((EntitySearchRuleContactDelete) entity).start;

        this.finish = ((EntitySearchRuleContactDelete) entity).finish;

    }


    public boolean accept(Serializable serializable) {

        if ((serializable instanceof EntityFirm)) {

            EntityFirm entity = (EntityFirm) serializable;

            for (EntityPipol pipol : entity.getPipols()) {

                for (EntityContact contact : pipol.getContacts()) {

                    if (UtilCalendar.inPeriod(this.start, this.finish, contact.getDelete())) {

                        return true;

                    }

                }

            }

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleContactDelete
 * JD-Core Version:    0.6.0
 */