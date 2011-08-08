package ua.com.testes.manager.logic.product.rate;


import ua.com.testes.manager.entity.user.EntityUser;
import ua.com.testes.manager.logic.view.LogicView;

import java.util.Collections;
import java.util.List;


public final class LogicRate {
    private static boolean use = false;
    private static LogicRateGetter getter = new LogicRateGetterFromUah();
    private static LogicRateCache cache = new LogicRateCache();
    private static final Object synchronizateObject = new Object();


    public static boolean isUse(EntityUser user) {

        if (user == null) {

            throw new NullPointerException("Can't get use rate by null user!");

        }

        if (user.getId() == null) {

            throw new NullPointerException("Can't get use rate by new user!");

        }

        return (use) && (LogicView.get(user).showRate);

    }


    public static void setUse(boolean use) {

        use = use;

    }


    public static void reset() {

        synchronized (synchronizateObject) {

            cache.put(null);

        }

    }


    public static List<LogicRateItem> get() {

        if (!use) {

            throw new IllegalStateException("Can't get becose rate not use!");

        }

        synchronized (synchronizateObject) {

            List rates = cache.get();

            if (rates == null) {

                rates = getter.get();

                if (rates != null) {

                    rates = Collections.unmodifiableList(rates);

                    cache.put(rates);

                }

            }

            return rates;

        }

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.rate.LogicRate
 * JD-Core Version:    0.6.0
 */