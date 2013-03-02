package ua.com.testes.manager.view.search;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.search.EntitySearch;

import java.util.List;


public final class ViewSearch {

    public static List<EntitySearch> getByPark(int userId) {

        return EntityManager.list("select search from searchs as search where search.park = true and search.user.id = :p0", new Object[]{Integer.valueOf(userId)});

    }


    public static List<EntitySearch> getByUse(int userId) {

        return EntityManager.list("select search from searchs as search where search.park = false and search.user.id = :p0", new Object[]{Integer.valueOf(userId)});

    }


    public static EntitySearch getById(int searchId) {

        return (EntitySearch) EntityManager.find(EntitySearch.class, Integer.valueOf(searchId));

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.view.search.ViewSearch
 * JD-Core Version:    0.6.0
 */