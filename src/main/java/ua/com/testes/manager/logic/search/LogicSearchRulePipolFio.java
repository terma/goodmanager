package ua.com.testes.manager.logic.search;


import ua.com.testes.manager.entity.EntityFirm;
import ua.com.testes.manager.entity.EntityPipol;
import ua.com.testes.manager.entity.search.EntitySearchRule;
import ua.com.testes.manager.entity.search.EntitySearchRulePipolFio;


final class LogicSearchRulePipolFio
        implements LogicSearchRule {
    private final String fio;


    public LogicSearchRulePipolFio(EntitySearchRule entity) {

        this.fio = ((EntitySearchRulePipolFio) entity).fio.trim().toLowerCase();

    }


    public boolean accept(Object serializable) {

        if ((serializable instanceof EntityFirm)) {

            EntityFirm entity = (EntityFirm) serializable;

            for (EntityPipol pipol : entity.getPipols()) {

                if (pipol.getFio().toLowerCase().contains(this.fio)) {

                    return true;

                }

            }

            return false;

        }
        if ((serializable instanceof EntityPipol)) {

            EntityPipol entity = (EntityPipol) serializable;

            return entity.getFio().toLowerCase().contains(this.fio);

        }

        return false;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.search.LogicSearchRulePipolFio
 * JD-Core Version:    0.6.0
 */