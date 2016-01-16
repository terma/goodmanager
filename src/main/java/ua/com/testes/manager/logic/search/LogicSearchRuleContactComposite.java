package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityContact;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleContactComposite;

import java.util.ArrayList;
import java.util.List;


final class LogicSearchRuleContactComposite implements LogicSearchRule {

    private final EntitySearchRuleContactComposite.Type type;
    private final List<LogicSearchRule> rules;

    public LogicSearchRuleContactComposite(EntitySearchRule entity) {
        this.rules = new ArrayList<LogicSearchRule>();

        EntitySearchRuleContactComposite composite = (EntitySearchRuleContactComposite) entity;

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

        if ((serializable instanceof EntityPipol)) {

            EntityPipol pipol = (EntityPipol) serializable;

            for (EntityContact contact : pipol.getContacts()) {

                if (acceptInternal(contact)) {

                    return true;

                }

            }

        }

        return false;

    }


    private boolean acceptInternal(Object serializable) {
        for (LogicSearchRule rule : this.rules) {
            if (this.type == EntitySearchRuleContactComposite.Type.AND) {
                if (!rule.accept(serializable)) return false;
            } else if (rule.accept(serializable)) return true;
        }
        return this.type == EntitySearchRuleContactComposite.Type.AND;
    }

}