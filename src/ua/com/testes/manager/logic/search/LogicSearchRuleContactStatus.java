package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactStatus;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactStatusItem;

import java.io.Serializable;
import java.util.Iterator;


final class LogicSearchRuleContactStatus
        implements LogicSearchRule {
    private final EntitySearchRuleContactStatus entity;


    public LogicSearchRuleContactStatus(EntitySearchRule entity) {

        this.entity = ((EntitySearchRuleContactStatus) entity);

    }


    public boolean accept(Serializable serializable) {

        if ((serializable instanceof EntityFirm)) {

            EntityFirm entity = (EntityFirm) serializable;

            for (EntityPipol pipol : entity.getPipols())

                for (Iterator<EntityContact> i = pipol.getContacts().iterator(); i.hasNext(); ) {
                    EntityContact contact = (EntityContact) i.next();

                    for (EntitySearchRuleContactStatusItem item : this.entity.items)

                        if (contact.getStatus().id.equals(Integer.valueOf(item.id.statusId)))
                            return true;

                }

        }

        Iterator i$;

        EntityContact contact;

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleContactStatus
 * JD-Core Version:    0.6.0
 */