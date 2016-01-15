package ua.com.testes.manager.logic.view;

import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.entity.view.EntityFirmSort;
import ua.com.testes.manager.entity.view.EntityView;
import ua.com.testes.manager.entity.view.EntityViewUser;

import java.util.ArrayList;
import java.util.Collections;

public final class LogicView {
    public static boolean isUserCheck(long lookUserId, EntityView view, boolean checkIfEmpty) {

        if (view.users.isEmpty()) {

            return checkIfEmpty;
        }

        for (EntityViewUser viewUser : view.users) {

            if (viewUser.id.userId == lookUserId) {

                return true;
            }
        }

        return false;
    }

    private static void checkSortFirm(EntityView view) {

        Collections.sort(view.sort.firms, new LogicFirmSortComparator());

        int order = 0;

        boolean corruptSortFirm = false;

        for (EntityFirmSort firmSort : view.sort.firms) {

            if (firmSort.order != order) {

                corruptSortFirm = true;

                break;
            }

            order++;
        }

        if (view.sort.firms.size() != EntityFirmSort.Field.values().length) {

            corruptSortFirm = true;
        }

        if (!corruptSortFirm) return;

        view.sort.firms = new ArrayList();

        for (EntityFirmSort.Field field : EntityFirmSort.Field.values()) {

            boolean containt = false;

            for (EntityFirmSort firmSort : view.sort.firms) {

                if (firmSort.field == field) {

                    containt = true;

                    break;
                }
            }

            if (!containt) {

                EntityFirmSort firmSort = new EntityFirmSort();

                firmSort.field = field;

                firmSort.view = view;

                view.sort.firms.add(firmSort);
            }
        }

        order = 0;

        for (EntityFirmSort firmSort : view.sort.firms) {

            firmSort.order = order;

            order++;

            firmSort.view = view;
        }
    }

    private static EntityView getDefault() {

        EntityView view = new EntityView();

        view.sort.firms = new ArrayList();

        int i = 0;

        for (EntityFirmSort.Field field : EntityFirmSort.Field.values()) {

            EntityFirmSort firmSort = new EntityFirmSort();

            firmSort.field = field;

            firmSort.order = (i++);

            firmSort.view = view;

            view.sort.firms.add(firmSort);
        }

        return view;
    }

    public static EntityView get(EntityUser user) {
        if (user == null) {
            throw new NullPointerException("Can't get view by null user!");
        }

        if (user.getDefaultView() != null) {
            checkSortFirm(user.getDefaultView());
            return user.getDefaultView();
        }

        return getDefault();
    }
}