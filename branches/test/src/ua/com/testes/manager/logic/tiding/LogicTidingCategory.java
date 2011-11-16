package ua.com.testes.manager.logic.tiding;


import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.tiding.EntityTidingCategory;
import ua.com.testes.manager.view.tiding.ViewTidingCategory;


public final class LogicTidingCategory {

    public static void add(String tidingCategoryName)
            throws LogicTidingCategoryException {

        final EntityTidingCategory tidingCategory = new EntityTidingCategory();

        if (tidingCategoryName == null) {

            throw new LogicTidingCategoryException(tidingCategory, new LogicTidingCategoryError[]{LogicTidingCategoryError.NAME_EMPTY});

        }

        tidingCategory.name = tidingCategoryName.trim();

        if (tidingCategory.name.length() == 0) {

            throw new LogicTidingCategoryException(tidingCategory, new LogicTidingCategoryError[]{LogicTidingCategoryError.NAME_EMPTY});

        }

        if (!ViewTidingCategory.getByName(tidingCategory.name).isEmpty()) {

            throw new LogicTidingCategoryException(tidingCategory, new LogicTidingCategoryError[]{LogicTidingCategoryError.NAME_NOT_UNIQUE});

        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public Object execute(javax.persistence.EntityManager manager) {

                manager.persist(tidingCategory);

                return tidingCategory;

            }

        });

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.tiding.LogicTidingCategory
 * JD-Core Version:    0.6.0
 */