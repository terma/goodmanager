package ua.com.testes.manager.logic.product.rate;


import java.io.Serializable;
import java.util.Date;


public final class LogicRateItem
        implements Serializable {
    private final long date;
    private final float value;
    private final String currency;


    public LogicRateItem(Date date, float value, String currency) {

        if ((currency == null) || (date == null)) {

            throw new NullPointerException();

        }

        this.currency = currency;

        this.date = date.getTime();

        this.value = value;

    }


    public Date getDate() {

        return new Date(this.date);

    }


    public String getCurrency() {

        return this.currency;

    }


    public float getValue() {

        return this.value;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.rate.LogicRateItem
 * JD-Core Version:    0.6.0
 */