package ua.com.testes.manager.logic.view;

import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.entity.view.EntityFirmSort;
import ua.com.testes.manager.entity.view.EntityView;
import ua.com.testes.manager.entity.view.EntityViewUser;

import java.util.ArrayList;
import java.util.Collections;

public final class LogicView {
    public static boolean isUserCheck(long lookUserId, EntityView view, boolean checkIfEmpty) {
/*  20 */
        if (view.users.isEmpty()) {
/*  21 */
            return checkIfEmpty;
        }
/*  23 */
        for (EntityViewUser viewUser : view.users) {
/*  24 */
            if (viewUser.id.userId == lookUserId) {
/*  25 */
                return true;
            }
        }
/*  28 */
        return false;
    }

    private static void checkSortFirm(EntityView view) {
/*  35 */
        Collections.sort(view.sort.firms, new LogicFirmSortComparator());
/*  36 */
        int order = 0;
/*  37 */
        boolean corruptSortFirm = false;
/*  38 */
        for (EntityFirmSort firmSort : view.sort.firms) {
/*  39 */
            if (firmSort.order != order) {
/*  40 */
                corruptSortFirm = true;
/*  41 */
                break;
            }
/*  43 */
            order++;
        }
/*  45 */
        if (view.sort.firms.size() != EntityFirmSort.Field.values().length) {
/*  46 */
            corruptSortFirm = true;
        }
/*  48 */
        if (!corruptSortFirm) return;
/*  49 */
        view.sort.firms = new ArrayList();
/*  50 */
        for (EntityFirmSort.Field field : EntityFirmSort.Field.values()) {
/*  51 */
            boolean containt = false;
/*  52 */
            for (EntityFirmSort firmSort : view.sort.firms) {
/*  53 */
                if (firmSort.field == field) {
/*  54 */
                    containt = true;
/*  55 */
                    break;
                }
            }
/*  58 */
            if (!containt) {
/*  59 */
                EntityFirmSort firmSort = new EntityFirmSort();
/*  60 */
                firmSort.field = field;
/*  61 */
                firmSort.view = view;
/*  62 */
                view.sort.firms.add(firmSort);
            }
        }
/*  65 */
        order = 0;
/*  66 */
        for (EntityFirmSort firmSort : view.sort.firms) {
/*  67 */
            firmSort.order = order;
/*  68 */
            order++;
/*  69 */
            firmSort.view = view;
        }
    }

    private static EntityView getDefault() {
/*  77 */
        EntityView view = new EntityView();
/*  78 */
        view.sort.firms = new ArrayList();
/*  79 */
        int i = 0;
/*  80 */
        for (EntityFirmSort.Field field : EntityFirmSort.Field.values()) {
/*  81 */
            EntityFirmSort firmSort = new EntityFirmSort();
/*  82 */
            firmSort.field = field;
/*  83 */
            firmSort.order = (i++);
/*  84 */
            firmSort.view = view;
/*  85 */
            view.sort.firms.add(firmSort);
        }
/*  87 */
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