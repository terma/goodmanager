package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRulePipolComposite;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


final class LogicSearchRulePipolComposite
        implements LogicSearchRule {
    private final EntitySearchRulePipolComposite.Type type;
    private final List<LogicSearchRule> rules;


    public LogicSearchRulePipolComposite(EntitySearchRule entity) {

        this.rules = new ArrayList();

        EntitySearchRulePipolComposite composite = (EntitySearchRulePipolComposite) entity;

        for (EntitySearchRule childEntity : composite.rules) {

            LogicSearchRule logicRule = LogicSearchRuleFactory.get(childEntity);

            if (logicRule != null) {

                this.rules.add(logicRule);

            }

        }

        this.type = composite.type;

    }


    public boolean accept(Serializable serializable) {

        if (this.rules.isEmpty()) return true;

        if ((serializable instanceof EntityFirm)) {

            EntityFirm firm = (EntityFirm) serializable;

            for (EntityPipol pipol : firm.getPipols()) {

                if (acceptInternal(pipol)) {

                    return true;

                }

            }

        }

        return false;

    }


    private boolean acceptInternal(EntityPipol pipol) {

        for (LogicSearchRule rule : this.rules) {

            if (this.type == EntitySearchRulePipolComposite.Type.AND) {

                if (!rule.accept(pipol)) return false;

            } else if (rule.accept(pipol)) return true;

        }


        return this.type == EntitySearchRulePipolComposite.Type.AND;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRulePipolComposite
 * JD-Core Version:    0.6.0
 */