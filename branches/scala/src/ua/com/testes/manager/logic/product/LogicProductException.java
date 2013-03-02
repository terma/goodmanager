package ua.com.testes.manager.logic.product;


import ua.com.testes.manager.entity.product.EntityProduct;

import java.util.Collections;
import java.util.Set;


public class LogicProductException extends RuntimeException {
    private final EntityProduct product;
    private final Set<LogicProductError> errors;


    public LogicProductException(EntityProduct product, LogicProductError[] errorArray) {

        this.errors = Collections.unmodifiableSet(LogicProductError.toSet(errorArray));

        this.product = product;

    }


    public EntityProduct getProduct() {

        return this.product;

    }


    public Set<LogicProductError> getErrors() {

        return this.errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicProductException
 * JD-Core Version:    0.6.0
 */