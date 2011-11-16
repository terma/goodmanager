package ua.com.testes.manager.logic.tiding;


import ua.com.testes.manager.entity.tiding.EntityTiding;
import ua.com.testes.manager.view.tiding.ViewTidingCategory;

import java.util.Date;


public final class LogicTiding {

    public static int add(String name, String description, int tidingCategoryId, Date start, Date finish)
            throws LogicTidingException {

        EntityTiding tiding = new EntityTiding();

        if ((start == null) || (finish == null)) {

            throw new LogicTidingException(tiding, new LogicTidingError[0]);

        }

        if (name == null) {

            throw new LogicTidingException(tiding, new LogicTidingError[]{LogicTidingError.NAME_EMPTY});

        }

        if (description != null) {

            tiding.description = description;

        }

        tiding.name = name.trim();

        if (tiding.name.length() == 0) {

            throw new LogicTidingException(tiding, new LogicTidingError[]{LogicTidingError.NAME_EMPTY});

        }

        tiding.category = ViewTidingCategory.getById(tidingCategoryId);

        tiding.category.tidings.add(tiding);

        ua.com.testes.manager.entity.EntityManager.get().persist(tiding);

        return 0;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.tiding.LogicTiding
 * JD-Core Version:    0.6.0
 */