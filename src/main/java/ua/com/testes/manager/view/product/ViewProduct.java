package ua.com.testes.manager.view.product;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.product.EntityProduct;

import java.util.List;


public class ViewProduct {

    public static List<EntityProduct> getByName(String name) {

        if (name == null) {

            throw new NullPointerException();

        }

        return EntityManager.list("select product from products as product where product.name = :p0", new Object[]{name});

    }


    public static List<EntityProduct> getByCategoryId(int categoryId) {

        return EntityManager.list("select product from products as product where product.category.id = :p0", new Object[]{Integer.valueOf(categoryId)});

    }


    public static EntityProduct getById(int productId) {

        return (EntityProduct) EntityManager.find(EntityProduct.class, Integer.valueOf(productId));

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.view.product.ViewProduct
 * JD-Core Version:    0.6.0
 */