package ua.com.testes.manager.view.product;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.product.EntityCurrency;

import java.util.List;


public final class ViewCurrency {

    public static List<EntityCurrency> getAll() {

        return EntityManager.list("select currency from currencys as currency", new Object[0]);

    }


    public static List<EntityCurrency> getByName(String name) {

        return EntityManager.list("select currency from currencys as currency where currency.name = :p0", new Object[]{name});

    }


    public static List<EntityCurrency> getByLabel(String label) {

        return EntityManager.list("select currency from currencys as currency where currency.label = :p0", new Object[]{label});

    }


    public static EntityCurrency getById(int currencyId) {

        return (EntityCurrency) EntityManager.find(EntityCurrency.class, Integer.valueOf(currencyId));

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.view.product.ViewCurrency
 * JD-Core Version:    0.6.0
 */