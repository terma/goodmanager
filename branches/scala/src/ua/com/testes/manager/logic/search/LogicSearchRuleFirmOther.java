package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmOther;


final class LogicSearchRuleFirmOther
        implements LogicSearchRule {
    private final String text;


    public LogicSearchRuleFirmOther(EntitySearchRule entity) {

        this.text = ((EntitySearchRuleFirmOther) entity).text.trim().toLowerCase();

    }


    public boolean accept(Object serializable) {

        if ((serializable instanceof EntityFirm)) {

            EntityFirm entity = (EntityFirm) serializable;

            if (entity.getAddress().toLowerCase().contains(this.text)) {

                return true;

            }

            if (entity.getEmail().toLowerCase().contains(this.text)) {

                return true;

            }

            if (entity.getSite().toLowerCase().contains(this.text)) {

                return true;

            }

            if (entity.getTelephon().toLowerCase().contains(this.text)) {

                return true;

            }

            if (entity.getFax().toLowerCase().contains(this.text)) {

                return true;

            }

            if (entity.getDescription().toLowerCase().contains(this.text)) {

                return true;

            }

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleFirmOther
 * JD-Core Version:    0.6.0
 */