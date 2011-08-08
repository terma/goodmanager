package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRulePipolUser;
import ua.com.testes.manager.entity.search.EntitySearchRulePipolUserItem;

import java.io.Serializable;


final class LogicSearchRulePipolUser
        implements LogicSearchRule {
    private final EntitySearchRulePipolUser entity;


    public LogicSearchRulePipolUser(EntitySearchRule entity) {

        this.entity = ((EntitySearchRulePipolUser) entity);

    }


    public boolean accept(Serializable serializable) {

        EntityPipol pipol;

        if ((serializable instanceof EntityPipol)) {

            pipol = (EntityPipol) serializable;

            for (EntitySearchRulePipolUserItem item : this.entity.items) {

                if (pipol.getUser().getId().equals(Integer.valueOf(item.id.userId))) {

                    return true;

                }

            }

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRulePipolUser
 * JD-Core Version:    0.6.0
 */