package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactUser;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactUserItem;

import java.io.Serializable;


final class LogicSearchRuleContactUser
        implements LogicSearchRule {
    private final EntitySearchRuleContactUser entity;


    public LogicSearchRuleContactUser(EntitySearchRule entity) {

        this.entity = ((EntitySearchRuleContactUser) entity);

    }


    public boolean accept(Serializable serializable) {

        EntityContact contact;

        if ((serializable instanceof EntityContact)) {

            contact = (EntityContact) serializable;

            for (EntitySearchRuleContactUserItem item : this.entity.items) {

                if (contact.getUser().getId().equals(Integer.valueOf(item.id.userId))) {

                    return true;

                }

            }

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleContactUser
 * JD-Core Version:    0.6.0
 */