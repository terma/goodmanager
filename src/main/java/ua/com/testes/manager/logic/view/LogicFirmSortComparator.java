package ua.com.testes.manager.logic.view;


import ua.com.testes.manager.entity.view.EntityFirmSort;

import java.util.Comparator;


public final class LogicFirmSortComparator implements Comparator<EntityFirmSort> {

    @Override
    public int compare(EntityFirmSort o1, EntityFirmSort o2) {
        return o1.order - o2.order;
    }

}
