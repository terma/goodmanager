package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRulePipolOther;

import java.io.Serializable;


final class LogicSearchRulePipolOther
        implements LogicSearchRule {
    private final String text;


    public LogicSearchRulePipolOther(EntitySearchRule entity) {

        this.text = ((EntitySearchRulePipolOther) entity).text.trim().toLowerCase();

    }


    public boolean accept(Serializable serializable) {

        if ((serializable instanceof EntityPipol)) {

            EntityPipol entity = (EntityPipol) serializable;

            if (entity.getEmail().toLowerCase().contains(this.text)) {

                return true;

            }

            if (entity.getDescription().toLowerCase().contains(this.text)) {

                return true;

            }

            if (entity.getTelephon().toLowerCase().contains(this.text)) {

                return true;

            }

            if (entity.getRang().toLowerCase().contains(this.text)) {

                return true;

            }

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRulePipolOther
 * JD-Core Version:    0.6.0
 */