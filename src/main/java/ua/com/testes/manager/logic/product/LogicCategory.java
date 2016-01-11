package ua.com.testes.manager.logic.product;


import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.product.EntityCategory;
import ua.com.testes.manager.view.product.ViewCategory;


public final class LogicCategory {

    public static void add(String name)
            throws LogicCategoryException {

        final EntityCategory category = new EntityCategory();

        if (name == null) {

            throw new LogicCategoryException(category, new LogicCategoryError[]{LogicCategoryError.NAME_EMPTY});

        }

        category.name = name.trim();

        if (category.name.length() == 0) {

            throw new LogicCategoryException(category, new LogicCategoryError[]{LogicCategoryError.NAME_EMPTY});

        }

        if (!ViewCategory.getByNameInCategory(category.name, null).isEmpty()) {

            throw new LogicCategoryException(category, new LogicCategoryError[]{LogicCategoryError.NAME_NOT_UNIQUE});

        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public EntityCategory execute(javax.persistence.EntityManager manager) {

                ua.com.testes.manager.entity.EntityManager.get().persist(category);

                return category;

            }

        });

    }


    public static void add(String name, int parentCategoryId) throws LogicCategoryException {

        final EntityCategory category = new EntityCategory();

        if (name == null) {

            throw new LogicCategoryException(category, new LogicCategoryError[]{LogicCategoryError.NAME_EMPTY});

        }

        category.name = name.trim();

        if (category.name.length() == 0) {

            throw new LogicCategoryException(category, new LogicCategoryError[]{LogicCategoryError.NAME_EMPTY});

        }

        if (!ViewCategory.getByNameInCategory(category.name, Integer.valueOf(parentCategoryId)).isEmpty()) {

            throw new LogicCategoryException(category, new LogicCategoryError[]{LogicCategoryError.NAME_NOT_UNIQUE});

        }

        category.parent = ViewCategory.getById(parentCategoryId);

        category.parent.childs.add(category);

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public EntityCategory execute(javax.persistence.EntityManager manager) {

                ua.com.testes.manager.entity.EntityManager.get().persist(category);

                return category;

            }

        });

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicCategory
 * JD-Core Version:    0.6.0
 */