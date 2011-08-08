package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmSection;
import ua.com.testes.manager.entity.search.EntitySearchRuleFirmSectionItem;

import java.io.Serializable;


final class LogicSearchRuleFirmSection
        implements LogicSearchRule {
    private final EntitySearchRuleFirmSection entity;


    public LogicSearchRuleFirmSection(EntitySearchRule entity) {

        this.entity = ((EntitySearchRuleFirmSection) entity);

    }


    public boolean accept(Serializable serializable) {

        EntityFirm entity;

        if ((serializable instanceof EntityFirm)) {

            entity = (EntityFirm) serializable;

            for (EntitySearchRuleFirmSectionItem item : this.entity.items) {

                if (entity.getSection().getId().intValue() == item.id.sectionId) {

                    return true;

                }

            }

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRuleFirmSection
 * JD-Core Version:    0.6.0
 */