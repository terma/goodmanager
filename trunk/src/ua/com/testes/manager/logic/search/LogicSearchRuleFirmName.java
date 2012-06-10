package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmName;


final class LogicSearchRuleFirmName implements LogicSearchRule {

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