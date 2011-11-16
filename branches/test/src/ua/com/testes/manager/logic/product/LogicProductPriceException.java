package ua.com.testes.manager.logic.product;


import ua.com.testes.manager.entity.product.EntityProductPrice;

import java.util.Collections;
import java.util.Set;


public class LogicProductPriceException extends Exception {
    private final EntityProductPrice productPrice;
    private final Set<LogicProductPriceError> errors;


    public LogicProductPriceException(EntityProductPrice productPrice, LogicProductPriceError[] errorArray) {

        this.errors = Collections.unmodifiableSet(LogicProductPriceError.toSet(errorArray));

        this.productPrice = productPrice;

    }


    public EntityProductPrice getProductPrice() {

        return this.productPrice;

    }


    public Set<LogicProductPriceError> getErrors() {

        return this.errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicProductPriceException
 * JD-Core Version:    0.6.0
 */