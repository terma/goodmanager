package ua.com.testes.manager.view.tiding;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.tiding.EntityTiding;

import java.util.List;


public final class ViewTiding {

    public static List<EntityTiding> getByCategoryId(int tidingCategoryId) {

        return EntityManager.list("select product from tidings as product where product.category.id = :p0", new Object[]{Integer.valueOf(tidingCategoryId)});

    }


    public static EntityTiding getById(int tidingId) {

        return (EntityTiding) EntityManager.find(EntityTiding.class, Integer.valueOf(tidingId));

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.view.tiding.ViewTiding
 * JD-Core Version:    0.6.0
 */