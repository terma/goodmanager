package ua.com.testes.manager.logic.view;


import ua.com.testes.manager.entity.view.EntityFirmSort;

import java.util.Comparator;


public final class LogicFirmSortComparator
        implements Comparator<EntityFirmSort> {

    public int compare(EntityFirmSort o1, EntityFirmSort o2) {

        return o1.order - o2.order;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.view.LogicFirmSortComparator
 * JD-Core Version:    0.6.0
 */