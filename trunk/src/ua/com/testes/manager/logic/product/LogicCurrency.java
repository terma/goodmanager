package ua.com.testes.manager.logic.product;


import ua.com.testes.manager.entity.EntityTransaction;
import ua.com.testes.manager.entity.product.EntityCurrency;
import ua.com.testes.manager.view.product.ViewCurrency;


public final class LogicCurrency {

    public static void add(String name, String label)
            throws LogicCurrencyException {

        final EntityCurrency currency = new EntityCurrency();

        if (name == null) {

            throw new LogicCurrencyException(currency, new LogicCurrencyError[]{LogicCurrencyError.NAME_EMPTY});

        }

        currency.name = name.trim();

        if (currency.name.length() == 0) {

            throw new LogicCurrencyException(currency, new LogicCurrencyError[]{LogicCurrencyError.NAME_EMPTY});

        }

        if (label == null) {

            throw new LogicCurrencyException(currency, new LogicCurrencyError[]{LogicCurrencyError.LABEL_EMPTY});

        }

        currency.label = label.trim();

        if (currency.label.length() == 0) {

            throw new LogicCurrencyException(currency, new LogicCurrencyError[]{LogicCurrencyError.LABEL_EMPTY});

        }

        if (currency.label.length() > 3) {

            throw new LogicCurrencyException(currency, new LogicCurrencyError[]{LogicCurrencyError.LABEL_TOO_LONG});

        }

        if (!ViewCurrency.getByName(currency.name).isEmpty()) {

            throw new LogicCurrencyException(currency, new LogicCurrencyError[]{LogicCurrencyError.NAME_NOT_UNIQUE});

        }

        if (!ViewCurrency.getByLabel(currency.label).isEmpty()) {

            throw new LogicCurrencyException(currency, new LogicCurrencyError[]{LogicCurrencyError.LABEL_NOT_UNIQUE});

        }

        ua.com.testes.manager.entity.EntityManager.execute(new EntityTransaction() {

            public EntityCurrency execute(javax.persistence.EntityManager manager) {

                ua.com.testes.manager.entity.EntityManager.get().persist(currency);

                return currency;

            }

        });

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicCurrency
 * JD-Core Version:    0.6.0
 */