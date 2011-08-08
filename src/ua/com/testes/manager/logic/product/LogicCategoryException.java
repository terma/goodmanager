package ua.com.testes.manager.logic.product;


import ua.com.testes.manager.entity.product.EntityCategory;

import java.util.Collections;
import java.util.Set;


public class LogicCategoryException extends Exception {
    private final Set<LogicCategoryError> errors;
    private final EntityCategory category;


    public LogicCategoryException(EntityCategory category, LogicCategoryError[] errorArray) {

        this.errors = Collections.unmodifiableSet(LogicCategoryError.toSet(errorArray));

        this.category = category;

    }


    public EntityCategory getCategory() {

        return this.category;

    }


    public Set<LogicCategoryError> getErrors() {

        return this.errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicCategoryException
 * JD-Core Version:    0.6.0
 */