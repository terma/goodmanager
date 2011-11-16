package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmName;


final class LogicSearchRuleFirmName
        implements LogicSearchRule {
    private final String name;


    public LogicSearchRuleFirmName(EntitySearchRule entity) {

        this.name = ((EntitySearchRuleFirmName) entity).name.trim().toLowerCase();

    }


    public boolean accept(Object serializable) {

        if ((serializable instanceof EntityFirm)) {

            EntityFirm entity = (EntityFirm) serializable;

            return entity.getName().toLowerCase().contains(this.name);

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleFirmName
 * JD-Core Version:    0.6.0
 */