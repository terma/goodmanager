package ua.com.testes.manager.view.product;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.product.EntityCategory;

import java.util.List;


public class ViewCategory {

    public static List<EntityCategory> getAll() {

        return EntityManager.list("select category from categorys as category", new Object[0]);

    }


    public static List<EntityCategory> getRoot() {

        return EntityManager.list("select category from categorys as category where category.parent = null", new Object[0]);

    }


    public static List<EntityCategory> getChild(int categoryId) {

        return ((EntityCategory) EntityManager.find(EntityCategory.class, Integer.valueOf(categoryId))).childs;

    }


    public static List<EntityCategory> getByName(String name) {

        if (name == null) {

            throw new NullPointerException();

        }

        return EntityManager.list("select category from categorys as category where category.name = :p0", new Object[]{name});

    }


    public static List<EntityCategory> getByNameInCategory(String name, Integer categoryId) {

        if (name == null) {

            throw new NullPointerException();

        }

        if (categoryId == null) {

            return EntityManager.list("select category from categorys as category where category.name = :p0 and category.parent = null", new Object[]{name});

        }


        return EntityManager.list("select category from categorys as category where category.name = :p0 and category.parent.id = :p1", new Object[]{name, categoryId});

    }


    public static EntityCategory getById(int categoryId) {

        return (EntityCategory) EntityManager.find(EntityCategory.class, Integer.valueOf(categoryId));

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.view.product.ViewCategory
 * JD-Core Version:    0.6.0
 */