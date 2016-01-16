package ua.com.testes.manager.logic.product;


import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.product.EntityProductPrice;
import ua.com.testes.manager.view.product.ViewCurrency;
import ua.com.testes.manager.view.product.ViewProduct;


public final class LogicProductPrice {

    public static void add(int productId, int currencyId, float value)
            throws LogicProductPriceException {

        final EntityProductPrice productPrice = new EntityProductPrice();

        productPrice.value = value;

        if (productPrice.value < 0.0F) {

            throw new LogicProductPriceException(productPrice, new LogicProductPriceError[]{LogicProductPriceError.PRICE_INFINITE});

        }

        productPrice.currency = ViewCurrency.getById(currencyId);

        productPrice.product = ViewProduct.getById(productId);

        productPrice.product.prices.add(productPrice);

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public EntityProductPrice execute(javax.persistence.EntityManager manager) {

                ua.com.testes.manager.entity.EntityManager.get().persist(productPrice);

                return productPrice;

            }

        });

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicProductPrice
 * JD-Core Version:    0.6.0
 */