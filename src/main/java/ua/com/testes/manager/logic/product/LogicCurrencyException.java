package ua.com.testes.manager.logic.product;


import ua.com.testes.manager.entity.product.EntityCurrency;

import java.util.Collections;
import java.util.Set;


public class LogicCurrencyException extends RuntimeException {
    private final Set<LogicCurrencyError> errors;
    private final EntityCurrency currency;


    public LogicCurrencyException(EntityCurrency currency, LogicCurrencyError[] errorArray) {

        this.errors = Collections.unmodifiableSet(LogicCurrencyError.toSet(errorArray));

        this.currency = currency;

    }


    public EntityCurrency getCurrency() {

        return this.currency;

    }


    public Set<LogicCurrencyError> getErrors() {

        return this.errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicCurrencyException
 * JD-Core Version:    0.6.0
 */