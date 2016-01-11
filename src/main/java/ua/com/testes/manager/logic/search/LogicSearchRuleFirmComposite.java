package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmComposite;

import java.util.ArrayList;
import java.util.List;


final class LogicSearchRuleFirmComposite
        implements LogicSearchRule {
    private final EntitySearchRuleFirmComposite.Type type;
    private final List<LogicSearchRule> rules;


    public LogicSearchRuleFirmComposite(EntitySearchRule entity) {

        this.rules = new ArrayList();

        EntitySearchRuleFirmComposite composite = (EntitySearchRuleFirmComposite) entity;

        for (EntitySearchRule childEntity : composite.rules) {

            LogicSearchRule logicRule = LogicSearchRuleFactory.get(childEntity);

            if (logicRule != null) {

                this.rules.add(logicRule);

            }

        }

        this.type = composite.type;

    }


    public boolean accept(Object serializable) {

        if (this.rules.isEmpty()) return true;

        for (LogicSearchRule rule : this.rules) {

            if (this.type == EntitySearchRuleFirmComposite.Type.AND) {

                if (!rule.accept(serializable)) return false;

            } else if (rule.accept(serializable)) return true;

        }


        return this.type == EntitySearchRuleFirmComposite.Type.AND;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleFirmComposite
 * JD-Core Version:    0.6.0
 */