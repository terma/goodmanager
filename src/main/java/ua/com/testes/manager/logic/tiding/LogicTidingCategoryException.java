package ua.com.testes.manager.logic.tiding;


import ua.com.testes.manager.entity.tiding.EntityTidingCategory;

import java.util.Collections;
import java.util.Set;


public class LogicTidingCategoryException extends RuntimeException {
    private final Set<LogicTidingCategoryError> errors;
    private final EntityTidingCategory tidingCategory;


    public LogicTidingCategoryException(EntityTidingCategory tidingCategory, LogicTidingCategoryError[] errorArray) {

        this.errors = Collections.unmodifiableSet(LogicTidingCategoryError.toSet(errorArray));

        this.tidingCategory = tidingCategory;

    }


    public EntityTidingCategory getTidingCategory() {

        return this.tidingCategory;

    }


    public Set<LogicTidingCategoryError> getErrors() {

        return this.errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.tiding.LogicTidingCategoryException
 * JD-Core Version:    0.6.0
 */