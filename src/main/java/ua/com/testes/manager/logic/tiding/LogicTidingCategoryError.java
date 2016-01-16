package ua.com.testes.manager.logic.tiding;


import java.util.HashSet;
import java.util.Set;


public enum LogicTidingCategoryError {
       NAME_EMPTY, NAME_NOT_UNIQUE;


    public static Set<LogicTidingCategoryError> toSet(LogicTidingCategoryError[] errorArray) {

        Set errors = new HashSet(errorArray.length);

        for (LogicTidingCategoryError error : errorArray) {

            errors.add(error);

        }

        return errors;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.tiding.LogicTidingCategoryError
 * JD-Core Version:    0.6.0
 */