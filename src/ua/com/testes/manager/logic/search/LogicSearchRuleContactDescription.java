package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactDescription;

import java.io.Serializable;


final class LogicSearchRuleContactDescription
        implements LogicSearchRule {
    private final String description;


    public LogicSearchRuleContactDescription(EntitySearchRule entity) {

        this.description = ((EntitySearchRuleContactDescription) entity).description.trim().toLowerCase();

    }


    public boolean accept(Serializable serializable) {

        if ((serializable instanceof EntityContact)) {

            EntityContact entity = (EntityContact) serializable;

            return entity.getDescription().toLowerCase().contains(this.description);

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleContactDescription
 * JD-Core Version:    0.6.0
 */