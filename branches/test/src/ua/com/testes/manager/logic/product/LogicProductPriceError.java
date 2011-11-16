package ua.com.testes.manager.logic.product;


import java.util.HashSet;
import java.util.Set;


public enum LogicProductPriceError {
    /*  8 */   CURRENTCY_NOT_SELECT, PRODUCT_NOT_SELECT, PRICE_INFINITE;


    public static Set<LogicProductPriceError> toSet(LogicProductPriceError[] errorArray) {

        Set errors = new HashSet(errorArray.length);

        for (LogicProductPriceError error : errorArray) {

            errors.add(error);

        }

        return errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicProductPriceError
 * JD-Core Version:    0.6.0
 */