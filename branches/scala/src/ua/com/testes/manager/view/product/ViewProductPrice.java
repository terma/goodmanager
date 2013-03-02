package ua.com.testes.manager.view.product;


import ua.com.testes.manager.entity.EntityManager;
import ua.com.testes.manager.entity.product.EntityProduct;
import ua.com.testes.manager.entity.product.EntityProductPrice;

import java.util.List;


public class ViewProductPrice {

    public static List<EntityProductPrice> getByProductId(int productId) {

        return EntityManager.list("select price from product_prices as price where price.product.id = :p0", new Object[]{Integer.valueOf(productId)});

    }


    public static EntityProductPrice getLastByProductId(int productId) {

        EntityProduct product = ViewProduct.getById(productId);

        EntityProductPrice lastProductPrice = null;

        for (EntityProductPrice produtPrice : product.prices) {

            if ((lastProductPrice == null) || (lastProductPrice.create.before(produtPrice.create))) {

                lastProductPrice = produtPrice;

            }

        }

        return lastProductPrice;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.view.product.ViewProductPrice
 * JD-Core Version:    0.6.0
 */