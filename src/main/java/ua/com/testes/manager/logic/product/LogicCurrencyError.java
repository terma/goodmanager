package ua.com.testes.manager.logic.product;


import java.util.HashSet;
import java.util.Set;


public enum LogicCurrencyError {
       NAME_EMPTY, NAME_NOT_UNIQUE, LABEL_EMPTY, LABEL_NOT_UNIQUE, LABEL_TOO_LONG;


    public static Set<LogicCurrencyError> toSet(LogicCurrencyError[] errorArray) {

        Set errors = new HashSet(errorArray.length);

        for (LogicCurrencyError error : errorArray) {

            errors.add(error);

        }

        return errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicCurrencyError
 * JD-Core Version:    0.6.0
 */