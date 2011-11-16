package ua.com.testes.manager.logic.product;


import java.util.HashSet;
import java.util.Set;


public enum LogicCategoryError {
    /*  8 */   NAME_EMPTY, NAME_NOT_UNIQUE;


    public static Set<LogicCategoryError> toSet(LogicCategoryError[] errorArray) {

        Set errors = new HashSet(errorArray.length);

        for (LogicCategoryError error : errorArray) {

            errors.add(error);

        }

        return errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.LogicCategoryError
 * JD-Core Version:    0.6.0
 */