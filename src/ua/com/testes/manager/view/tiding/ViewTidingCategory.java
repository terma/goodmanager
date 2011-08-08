package ua.com.testes.manager.view.tiding;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.tiding.EntityTidingCategory;

import java.util.List;


public final class ViewTidingCategory {

    public static List<EntityTidingCategory> getAll() {

        return EntityManager.list("select category from tiding_categorys as category", new Object[0]);

    }


    public static List<EntityTidingCategory> getByName(String tidingCategoryName) {

        if (tidingCategoryName == null) {

            throw new NullPointerException();

        }

        return EntityManager.list("select category from tiding_categorys as category where category.name = :p0", new Object[]{tidingCategoryName});

    }


    public static EntityTidingCategory getById(int tidingCategoryId) {

        return (EntityTidingCategory) EntityManager.find(EntityTidingCategory.class, Integer.valueOf(tidingCategoryId));

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.view.tiding.ViewTidingCategory
 * JD-Core Version:    0.6.0
 */