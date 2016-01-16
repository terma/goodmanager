package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmUser;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmUserItem;


final class LogicSearchRuleFirmUser
        implements LogicSearchRule {
    private final EntitySearchRuleFirmUser entity;


    public LogicSearchRuleFirmUser(EntitySearchRule entity) {

        this.entity = ((EntitySearchRuleFirmUser) entity);

    }


    public boolean accept(Object serializable) {

        EntityFirm entity;

        if ((serializable instanceof EntityFirm)) {

            entity = (EntityFirm) serializable;

            for (EntitySearchRuleFirmUserItem item : this.entity.items) {

                if (entity.getUser().getId().equals(Integer.valueOf(item.id.userId))) {

                    return true;

                }

            }

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleFirmUser
 * JD-Core Version:    0.6.0
 */